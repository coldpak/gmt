# Good Morning Terminal (GMT) - 프로젝트 아키텍처 문서

> 이 문서는 프로젝트를 처음 접하는 개발자가 전체 구조를 파악하고 바로 작업할 수 있도록 작성되었습니다.

---

## 1. 프로젝트 개요

**Good Morning Terminal (GMT)** 은 터미널을 열 때마다 개인화된 대시보드를 보여주는 경량 셸 스크립트 프레임워크입니다.

- **버전**: 0.1.0
- **라이선스**: MIT
- **지원 환경**: macOS / Linux (bash 3.2+, zsh 5.0+)
- **시작 시간**: < 100ms (캐시 기반 설계)
- **외부 의존성**: 없음 (curl, python3은 선택적)

### 주요 기능

| 기능 | 설명 |
|------|------|
| 시간별 인사 | 시간대에 따른 이모지와 인사말 (아침/오후/저녁/밤) |
| 날씨 | wttr.in API를 통한 실시간 날씨 (캐시 + 백그라운드 갱신) |
| 최근 프로젝트 | `cd`로 방문한 git 프로젝트 자동 추적, `gm go N`으로 즉시 이동 |
| 할 일 관리 | 태스크 추가/완료/삭제, 일일 목표 설정 |
| 활동 추적 | 연속 사용일 스트릭 카운터 (🔥) |
| 시스템 정보 | git, node, python 버전 + 현재 git 브랜치 상태 |
| 오늘의 팁 | 매일 바뀌는 터미널 사용 팁 (15개 로테이션) |
| 다국어 지원 | 한국어/영어 내장, 확장 가능한 i18n 구조 |

---

## 2. 디렉토리 구조

```
gmt/
├── gmt.sh                  # 메인 진입점 (셸 rc에서 source)
├── config.sh               # 사용자 설정 파일 (온보딩에서 자동 생성)
├── install.sh              # 설치 스크립트
│
├── modules/                # 기능 모듈 (7개)
│   ├── onboarding.sh       # 첫 실행 설정 마법사
│   ├── greeting.sh         # 시간별 인사 + 날씨
│   ├── projects.sh         # Git 프로젝트 추적 & 빠른 이동
│   ├── sysinfo.sh          # 도구 버전 + git 상태
│   ├── todos.sh            # 할 일 관리 + 일일 목표
│   ├── activity.sh         # 활동 스트릭 카운터
│   └── tips.sh             # 오늘의 터미널 팁
│
├── lib/                    # 유틸리티 라이브러리 (4개)
│   ├── colors.sh           # ANSI 색상 상수
│   ├── layout.sh           # 박스 그리기, CJK 너비 계산
│   ├── cache.sh            # TTL 기반 파일 캐시
│   └── compat.sh           # 크로스 플랫폼 래퍼 (macOS/Linux)
│
├── lang/                   # 언어 팩
│   ├── en.sh               # 영어
│   └── ko.sh               # 한국어
│
├── data/                   # 사용자 데이터 (자동 생성, gitignore됨)
│   ├── .initialized        # 온보딩 완료 플래그
│   ├── projects.log        # 프로젝트 방문 기록
│   ├── todos.txt           # 할 일 목록
│   ├── goal.txt            # 오늘의 목표
│   └── activity.log        # 활동 기록
│
├── cache/                  # 캐시 데이터 (자동 생성, gitignore됨)
│   ├── weather.txt         # 날씨 캐시 (TTL: 1800초)
│   ├── versions.txt        # 도구 버전 캐시 (일별 갱신)
│   └── recent_projects.txt # 중복 제거된 프로젝트 목록
│
├── README.md               # 영문 README
├── README.ko.md            # 한국어 README
├── CONTRIBUTING.md          # 기여 가이드
└── LICENSE                 # MIT 라이선스
```

---

## 3. 코드 실행 흐름

### 3.1 시작 순서

```
사용자가 터미널 열기
  └─> ~/.zshrc (또는 ~/.bashrc) 실행
      └─> source ~/.gmt/gmt.sh
          ├─> 1. 라이브러리 로드 (lib/colors, layout, cache, compat)
          ├─> 2. config.sh 로드 (사용자 설정)
          ├─> 3. data/, cache/ 디렉토리 생성
          ├─> 4. 언어 팩 로드 (자동 감지 또는 수동 설정)
          ├─> 5. 모든 모듈 파일 source
          ├─> 6. 셸 훅 등록 (디렉토리 추적)
          └─> 7. 초기화 확인
              ├─> 첫 실행: 온보딩 마법사 표시
              └─> 이후: 홈 화면 렌더링
```

### 3.2 홈 화면 렌더링 (`_gmt_render_home`)

`GMT_MODULES` 설정에 정의된 순서대로 각 모듈의 `_gmt_<module>_render()` 함수를 호출합니다.

```
기본 순서: greeting → projects → sysinfo → todos → activity → tips
```

각 모듈은 독립적이며, `config.sh`에서 순서를 변경하거나 특정 모듈을 제거할 수 있습니다.

### 3.3 디렉토리 추적 훅

```
사용자가 cd 명령 실행
  └─> 셸 훅 트리거 (_gmt_track_directory)
      ├─> 현재 디렉토리에 .git/ 존재?
      │   ├─> YES: 타임스탬프|경로를 projects.log에 기록
      │   └─> NO: 무시
      └─> activity.log 업데이트 (오늘 날짜|횟수)
```

---

## 4. 핵심 파일 상세

### 4.1 `gmt.sh` — 메인 진입점

**역할**: 전체 시스템 초기화, 홈 화면 렌더링, CLI 명령 라우팅

**주요 함수**:
- `_gmt_render_home()` — 홈 화면 렌더링 (모듈 순회)
- `gm()` — CLI 명령 핸들러 (아래 명령 표 참조)
- `_gmt_track_directory()` — 셸 훅에서 호출, 디렉토리 추적
- `_gmt_help()` — 도움말 출력

### 4.2 `config.sh` — 사용자 설정

```bash
GMT_USERNAME="이름"               # 표시 이름
GMT_LANG="ko"                     # 언어: auto | ko | en | ja | zh
GMT_WEATHER_ENABLED=false         # 날씨 기능 활성화
GMT_WEATHER_CITY="Seoul"          # 날씨 도시
GMT_WEATHER_CACHE_TTL=1800        # 날씨 캐시 유효 시간 (초)
GMT_MODULES="greeting projects sysinfo todos activity tips"  # 활성 모듈 및 순서
GMT_PROJECTS_COUNT=5              # 최근 프로젝트 표시 수
GMT_ACTIVITY_WEEKS=12             # 활동 그래프 주 수
```

---

## 5. 모듈 상세

### 5.1 Greeting (`modules/greeting.sh`)

- 시간대별 인사: 오전(☀), 오후(⛅), 저녁(🌙), 밤(🌃)
- 날짜 포맷팅 (로컬라이즈, CJK 인식)
- wttr.in API로 날씨 가져오기 (캐시 + 백그라운드 갱신)
- **렌더 함수**: `_gmt_greeting_render()`

### 5.2 Projects (`modules/projects.sh`)

- `cd`로 방문한 모든 git 프로젝트 자동 기록
- 최근 순으로 정렬, 중복 제거
- 상대 시간 표시 (예: "3시간 전")
- **렌더 함수**: `_gmt_projects_render()`
- **이동 함수**: `_gmt_project_go(N)` — N번 프로젝트로 cd

### 5.3 System Info (`modules/sysinfo.sh`)

- git, node, python, npm 버전 수집
- 현재 git 브랜치 + 상태 (✓ clean / ✗ dirty)
- 일별 캐시, 백그라운드 갱신
- **렌더 함수**: `_gmt_sysinfo_render()`

### 5.4 To-Dos (`modules/todos.sh`)

- **데이터 파일**: `data/todos.txt` (상태|타임스탬프|내용)
- **목표 파일**: `data/goal.txt` (날짜|내용, 자정에 자동 만료)
- **주요 함수**:
  - `_gmt_todo_add(text)` — 태스크 추가
  - `_gmt_todo_toggle(N)` — 완료/미완료 토글
  - `_gmt_todo_remove(N)` — 삭제
  - `_gmt_todo_goal(text)` — 일일 목표 설정
  - `_gmt_todo_clear()` — 완료된 항목 일괄 삭제
  - `_gmt_todos_render()` — 렌더링

### 5.5 Activity (`modules/activity.sh`)

- 연속 사용일(스트릭) 계산
- `data/activity.log` (날짜|일별 호출 횟수)
- 스트릭 레벨: 🔥(1-2일), 🔥🔥(3-6일), 🔥🔥🔥(7일+)
- **렌더 함수**: `_gmt_activity_render()`

### 5.6 Tips (`modules/tips.sh`)

- 언어별 15개 터미널 팁 로테이션
- 선택 로직: `연중_일수 % 팁_수`
- 하루에 하나씩 새로운 팁
- **렌더 함수**: `_gmt_tips_render()`

### 5.7 Onboarding (`modules/onboarding.sh`)

- 화살표 키 / vim 키(j/k) 지원 대화형 UI
- 4단계: 언어 선택 → 이름 입력 → 날씨 설정 → 설정 저장
- 완료 시 `data/.initialized` 파일 생성
- **진입 함수**: `_gmt_onboarding()`

---

## 6. 라이브러리 상세

### 6.1 `lib/colors.sh`

ANSI 색상 상수 정의:

| 변수 | 용도 |
|------|------|
| `C_BOLD`, `C_DIM`, `C_RESET` | 텍스트 스타일 |
| `C_WHITE`, `C_GRAY`, `C_GREEN`, `C_YELLOW`, `C_BLUE`, `C_CYAN`, `C_RED`, `C_MAGENTA` | 기본 색상 |
| `COLOR_NONE` ~ `COLOR_MAX` | 256색 히트맵 (활동 그래프용) |
| `supports_256_color()` | 터미널 256색 지원 확인 |

### 6.2 `lib/layout.sh`

박스 그리기 및 정렬 유틸리티:

| 함수 | 설명 |
|------|------|
| `_gmt_term_width()` | 터미널 너비 조회 (렌더 중 캐시) |
| `_gmt_display_width(str)` | CJK 더블 너비 문자/이모지 고려한 표시 너비 |
| `draw_line()` | `─` 문자로 수평선 그리기 |
| `draw_box(lines)` | `┌─┐│└┘` 테두리 박스 그리기 |
| `section_header(icon, title)` | 섹션 제목 출력 |
| `padded(text)` | 들여쓰기 텍스트 출력 |
| `visible_len(str)` | ANSI 코드 제외한 문자열 길이 |

### 6.3 `lib/cache.sh`

TTL 기반 파일 캐시:

| 함수 | 설명 |
|------|------|
| `cache_get(key, ttl)` | 캐시 읽기 (만료 시 1 반환) |
| `cache_set(key, value)` | 캐시 쓰기 |
| `cache_refresh_bg(key, cmd)` | 백그라운드에서 명령 실행 후 캐시 저장 (논블로킹) |

### 6.4 `lib/compat.sh`

크로스 플랫폼 호환성:

| 함수 | 설명 |
|------|------|
| `_gmt_detect_os()` | OS 감지 ("macos" / "linux") |
| `_gmt_stat_mtime(file)` | 파일 수정 시간 (BSD vs GNU stat) |
| `_gmt_sed_inplace(expr, file)` | 인플레이스 sed (macOS `-i ''` vs Linux `-i`) |
| `_gmt_now()` | 유닉스 타임스탬프 |
| `_gmt_format_date()` | 로컬라이즈된 날짜/시간 포맷 |

---

## 7. CLI 명령어 레퍼런스

`gm` 함수가 모든 CLI 명령을 라우팅합니다.

| 명령 | 설명 | 예시 |
|------|------|------|
| `gm` 또는 `gm home` | 홈 화면 표시 | `gm` |
| `gm add "내용"` | 할 일 추가 | `gm add "로그인 페이지 디자인"` |
| `gm done N` | N번 태스크 완료/미완료 토글 | `gm done 1` |
| `gm rm N` | N번 태스크 삭제 | `gm rm 2` |
| `gm goal "내용"` | 오늘의 목표 설정 | `gm goal "v0.2.0 출시"` |
| `gm go N` | N번 프로젝트로 이동 | `gm go 3` |
| `gm list` | 할 일만 표시 | `gm list` |
| `gm clear` | 완료된 태스크 일괄 삭제 | `gm clear` |
| `gm setup` | 온보딩 마법사 재실행 | `gm setup` |
| `gm config` | 설정 파일 편집기에서 열기 | `gm config` |
| `gm help` | 도움말 표시 | `gm help` |
| `gm version` | 버전 출력 | `gm version` |

---

## 8. 데이터 파일 형식

### `data/projects.log`
```
타임스탬프|절대경로
1712501234|/Users/user/projects/my-app
1712501235|/Users/user/projects/blog
```

### `data/todos.txt`
```
상태|타임스탬프|내용
0|1712501000|로그인 페이지 디자인        # 0 = 미완료
1|1712500900|데이터베이스 스키마 완성     # 1 = 완료
```

### `data/goal.txt`
```
날짜|내용
2026-04-07|v0.2.0 출시
```

### `data/activity.log`
```
날짜|호출횟수
2026-04-06|5
2026-04-07|12
```

---

## 9. 다국어(i18n) 시스템

### 언어 파일 구조

모든 사용자 대면 문자열은 `L_` 접두사를 가집니다:

| 카테고리 | 변수 패턴 | 예시 |
|----------|-----------|------|
| 인사 | `L_GREETING_*` | `L_GREETING_MORNING`, `L_GREETING_AFTERNOON` |
| 날짜/시간 | `L_WEEKDAYS[]`, `L_DATE_SEP`, `L_TIME_*` | `L_WEEKDAYS=("일" "월" "화" ...)` |
| 할 일 | `L_TODO_*` | `L_TODO_EMPTY`, `L_TODO_ADDED` |
| 프로젝트 | `L_PROJ_*` | `L_PROJ_HEADER`, `L_PROJ_EMPTY` |
| 활동 | `L_ACTIVITY_*` | `L_ACTIVITY_STREAK` |
| 팁 | `L_TIPS[]` | 15개 팁 배열 |
| 에러 | `L_ERR_*` | `L_ERR_NO_TASK` |
| 온보딩 | `L_ONBOARD_*` | `L_ONBOARD_WELCOME` |

### 새 언어 추가 방법

1. `lang/en.sh`를 `lang/{언어코드}.sh`로 복사
2. 모든 `L_` 변수 번역
3. PR 제출

---

## 10. 설치 및 개발 환경 설정

### 일반 사용자 설치

```bash
git clone https://github.com/coldpak/gmt.git ~/.gmt && bash ~/.gmt/install.sh
```

### 개발자 설정

```bash
# 1. 저장소 클론
git clone https://github.com/coldpak/gmt.git
cd gmt

# 2. 심볼릭 링크로 개발 환경 설정 (선택)
ln -sf $(pwd)/gmt.sh ~/.gmt/gmt.sh

# 3. 셸 rc 파일에 추가 (아직 없다면)
echo 'source ~/.gmt/gmt.sh' >> ~/.zshrc

# 4. 새 터미널 열기 또는
source gmt.sh
```

### 설치 스크립트가 하는 일 (`install.sh`)

1. 저장소를 `~/.gmt`로 복사 (기존 `config.sh` 보존)
2. `data/`, `cache/` 디렉토리 생성
3. 셸 감지 (zsh/bash) 후 rc 파일에 source 라인 추가

---

## 11. 아키텍처 설계 원칙

| 원칙 | 설명 |
|------|------|
| **순수 셸** | 외부 런타임 의존성 없음. curl(날씨), python3(CJK 너비)은 선택적 |
| **모듈러** | 각 기능은 독립 모듈. `_gmt_<name>_render()` 함수 하나로 구성 |
| **논블로킹** | 캐시 미스 시 백그라운드 갱신. 시작 시간 절대 차단하지 않음 |
| **크로스 플랫폼** | BSD/GNU 차이를 `lib/compat.sh`로 추상화 |
| **성능 우선** | 터미널 너비 캐싱, 최소 서브셸, bash 내장 명령 선호 |
| **확장 가능** | 새 모듈 = 함수 1개 + 언어 문자열. 플러그인 방식 |
| **Git 중심** | `.git/` 디렉토리만 추적. 중복 제거 + 최신순 정렬 |

---

## 12. 새 모듈 추가 가이드

### 1단계: 모듈 파일 생성

`modules/mymodule.sh`:

```bash
#!/usr/bin/env bash

_gmt_mymodule_render() {
    section_header "🎯" "${L_MYMOD_HEADER}"
    padded "내용을 여기에 렌더링"
    echo ""
}
```

### 2단계: 언어 문자열 추가

`lang/ko.sh`와 `lang/en.sh`에 추가:

```bash
L_MYMOD_HEADER="내 모듈"  # ko.sh
L_MYMOD_HEADER="My Module"  # en.sh
```

### 3단계: 설정에 등록

`config.sh`의 `GMT_MODULES`에 추가:

```bash
GMT_MODULES="greeting projects sysinfo todos activity tips mymodule"
```

모듈 파일은 `gmt.sh`가 자동으로 `modules/` 디렉토리에서 source합니다.

---

## 13. 알려진 제약 / 주의사항

- **oh-my-zsh 충돌**: `gm`이 oh-my-zsh에서 alias로 사용될 수 있음 → `gmt.sh`에서 `unalias gm` 처리
- **bash 3.2 제한**: macOS 기본 bash는 3.2로, 연관 배열 미지원. 인덱스 배열만 사용
- **CJK 너비 계산**: Python3 없으면 단순 문자 수로 폴백 (박스 그리기 시 어긋날 수 있음)
- **날씨 API**: wttr.in은 비공식 무료 API로, 레이트 리밋 또는 다운타임 가능

---

## 14. Git 커밋 히스토리

| 커밋 | 메시지 |
|------|--------|
| `05b6769` | feat: initial release of Good Morning Terminal v0.1.0 |
| `de16813` | fix: zsh compatibility and UI redesign |
| `99fc2bb` | feat: add daily tips module and update README |
| `79584d1` | refactor: rename command from gmt to gm |
| `f49cde0` | fix: unalias gm before defining function (oh-my-zsh conflict) |
