<h1 align="center">
  <br>
  <img src="https://em-content.zobj.net/source/apple/391/sun-with-face_1f31e.png" width="80" alt="GMT">
  <br>
  Good Morning Terminal
  <br>
</h1>

<p align="center">
  <strong>터미널을 열면 맞이하는 "홈 화면"</strong>
</p>

<p align="center">
  <a href="#설치">설치</a> •
  <a href="#기능">기능</a> •
  <a href="#명령어">명령어</a> •
  <a href="#설정">설정</a> •
  <a href="#다국어-지원">다국어</a> •
  <a href="#기여하기">기여하기</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-0.1.0-blue?style=flat-square" alt="Version">
  <img src="https://img.shields.io/badge/shell-bash%20%7C%20zsh-green?style=flat-square" alt="Shell">
  <img src="https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/license-MIT-orange?style=flat-square" alt="License">
  <img src="https://img.shields.io/badge/startup-%3C%20100ms-brightgreen?style=flat-square" alt="Performance">
</p>

<p align="center">
  <a href="README.md">English</a>
</p>

---

```
 ┌────────────────────────────────────────────────────┐
 │  ☀ 좋은 아침이에요, kyoungmin!                       │
 │  4월 6일 일요일 · 오전 9:23                           │
 │  서울 18°C 맑음                                      │
 └────────────────────────────────────────────────────┘

 📂 최근 프로젝트
  [1] ~/projects/my-app           3시간 전
  [2] ~/projects/blog              어제
  [3] ~/work/api-server            3일 전

  번호 입력으로 바로 이동 → gmt go 1

 ⚙ 시스템
  git 2.43.0    node 20.11.0    python 3.12.2
  branch: main  ✓ clean         npm 10.2.4

 📋 오늘의 목표: API 엔드포인트 완성하기

  [ ] 로그인 페이지 디자인
  [✓] DB 스키마 설계
  [ ] README 작성

  gmt add "할 일"  ·  gmt done 1  ·  gmt goal "목표"

 📊 활동 (12주)
  Mon  ░░▓▓░░▓▓▓░░░▓▓░░▓▓▓▓░░▓░░░▓▓▓░▓▓░░▓▓▓░░▓▓░░▓▓▓▓
  Wed  ░▓▓░░▓▓▓░░░░▓▓▓░▓▓▓░░░▓▓░░▓▓▓░░▓▓▓░▓▓▓░░▓▓▓░▓▓▓▓
  Fri  ░░▓░░░▓▓░░░░░▓▓░░▓▓░░░░▓░░░▓▓░░░▓▓░░▓▓░░░▓░░░▓▓░
  ·····················································today
```

## 왜 만들었나요?

바이브코딩(Cursor, Claude Code 등)이 유행하면서 터미널을 처음 접하는 사람들이 늘고 있습니다. 하지만 기본 터미널은 빈 프롬프트만 덩그러니 보여줘서 낯설고 차가운 느낌이죠.

**Good Morning Terminal**은 터미널을 열 때마다 자동 실행되는 쉘 스크립트 대시보드입니다. 시간에 맞는 인사말, 오늘 할 일, 최근 프로젝트 바로가기, 시스템 상태, 활동 로그를 한눈에 보여줍니다.

> 외부 의존성 없음. 프레임워크 없음. 순수 쉘 스크립트. 100ms 이내.

## 기능

- **시간대별 인사말** — 아침/오후/저녁 인사 + [wttr.in](https://wttr.in) 날씨
- **최근 프로젝트** — `cd` 할 때마다 git 프로젝트 자동 추적, `gmt go 1`로 바로 이동
- **할 일 관리** — `gmt add "할 일"`로 간단한 태스크 관리
- **오늘의 목표** — `gmt goal "목표"`로 설정 (자정에 자동 만료)
- **시스템 정보** — git, node, python 버전 + 현재 브랜치 상태
- **활동 히트맵** — GitHub 잔디밭 스타일의 터미널 활동 기록
- **다국어 지원** — 한국어, English 기본 제공. 커뮤니티 번역 환영!
- **빠른 속도** — ~100ms 로딩. 캐시 기반 설계, 서브쉘 최소화

## 요구사항

- **쉘**: bash 3.2+ 또는 zsh 5.0+
- **OS**: macOS 또는 Linux
- **선택**: `curl` (날씨 기능에 필요)

그 외 외부 의존성 없음. 순수 쉘 스크립트입니다.

## 설치

### 한 줄 설치

```bash
git clone https://github.com/coldpak/gmt.git ~/.gmt && bash ~/.gmt/install.sh
```

### 수동 설치

```bash
git clone https://github.com/coldpak/gmt.git ~/.gmt
echo 'source ~/.gmt/gmt.sh' >> ~/.zshrc   # bash라면 ~/.bashrc
source ~/.zshrc
```

첫 실행 시 온보딩 위저드가 자동으로 시작됩니다.

## 명령어

| 명령어 | 설명 |
|--------|------|
| `gmt` | 홈 화면 보기 |
| `gmt add "할 일"` | 할 일 추가 |
| `gmt done <N>` | 완료/미완료 토글 |
| `gmt rm <N>` | 할 일 삭제 |
| `gmt goal "목표"` | 오늘의 목표 설정 |
| `gmt go <N>` | 최근 프로젝트로 이동 |
| `gmt list` | 할 일 목록만 표시 |
| `gmt clear` | 완료된 항목 일괄 삭제 |
| `gmt config` | 설정 파일 편집 |
| `gmt setup` | 온보딩 다시 실행 |
| `gmt help` | 도움말 |
| `gmt version` | 버전 표시 |

## 설정

`~/.gmt/config.sh`를 직접 편집하거나 `gmt config` 명령어를 사용하세요.

```bash
GMT_USERNAME=""              # 비어있으면 $USER 사용
GMT_LANG="auto"              # auto | ko | en | ja | zh
GMT_WEATHER_ENABLED=true     # 날씨 표시 여부
GMT_WEATHER_CITY="Seoul"     # 도시명 (wttr.in 기준)
GMT_WEATHER_CACHE_TTL=1800   # 날씨 캐시 TTL (초)
GMT_MODULES="greeting projects sysinfo todos activity"
GMT_PROJECTS_COUNT=5         # 표시할 최근 프로젝트 수
GMT_ACTIVITY_WEEKS=12        # 잔디밭 표시 주 수
```

### 모듈 순서 변경

`GMT_MODULES` 값을 수정해서 표시 순서를 바꾸거나 특정 모듈을 숨길 수 있습니다:

```bash
# 할 일을 먼저 보고 싶다면
GMT_MODULES="todos greeting projects"

# 시스템 정보 숨기기
GMT_MODULES="greeting projects todos activity"
```

## 다국어 지원

| 언어 | 파일 | 상태 |
|------|------|------|
| English | `lang/en.sh` | 기본 제공 |
| 한국어 | `lang/ko.sh` | 기본 제공 |
| 日本語 | `lang/ja.sh` | 커뮤니티 |
| 中文 | `lang/zh.sh` | 커뮤니티 |

### 새 언어 추가하기

1. `lang/en.sh`를 복사하여 `lang/{code}.sh` 생성
2. 모든 `L_` 변수를 번역
3. PR 제출!

```bash
cp ~/.gmt/lang/en.sh ~/.gmt/lang/fr.sh
# fr.sh를 열어 번역하세요
```

모든 사용자 노출 문자열은 `L_` 변수로 관리됩니다. 명령어(`gmt add` 등)는 번역하지 않습니다.

## 프로젝트 구조

```
~/.gmt/
├── gmt.sh              # 메인 엔트리포인트 (쉘 rc에서 source)
├── config.sh           # 사용자 설정
├── install.sh          # 설치 스크립트
├── modules/
│   ├── onboarding.sh   # 첫 실행 온보딩
│   ├── greeting.sh     # 인사말 + 시간 + 날씨
│   ├── projects.sh     # 최근 프로젝트 & 빠른 이동
│   ├── sysinfo.sh      # 시스템 정보 (git, node, python)
│   ├── todos.sh        # 할 일 / 오늘의 목표
│   └── activity.sh     # 활동 히트맵
├── lang/
│   ├── ko.sh           # 한국어
│   └── en.sh           # 영어
├── lib/
│   ├── colors.sh       # ANSI 색상 유틸리티
│   ├── layout.sh       # 박스 그리기 & 정렬
│   ├── cache.sh        # TTL 기반 파일 캐시
│   └── compat.sh       # 크로스 플랫폼 래퍼
├── data/               # 사용자 데이터 (자동 생성)
│   ├── todos.txt
│   ├── goal.txt
│   ├── activity.log
│   └── projects.log
└── cache/              # 캐시 데이터 (자동 생성)
```

## 성능

터미널 시작 시 **체감 속도 100ms 이내**를 목표로 설계되었습니다.

- 모든 외부 호출(날씨 API, 버전 체크)은 캐시 사용
- 캐시 미스 시 백그라운드에서 갱신 — 렌더링을 블로킹하지 않음
- 서브쉘/파이프 최소화, bash 빌트인 우선 사용
- 잔디밭 렌더링 결과 캐시 (activity.log 변경 시에만 재생성)

## 크로스 플랫폼

macOS와 Linux 모두 지원합니다. BSD/GNU 차이는 `lib/compat.sh`에서 자동 처리합니다.

| 기능 | macOS | Linux |
|------|-------|-------|
| 파일 수정시간 | `stat -f %m` | `stat -c %Y` |
| sed in-place | `sed -i ''` | `sed -i` |
| 파일 역순 읽기 | `tail -r` | `tac` |

## 삭제

```bash
# 쉘 rc에서 source 줄 제거
# zsh:
sed -i '' '/gmt\.sh/d' ~/.zshrc

# bash:
sed -i '/gmt\.sh/d' ~/.bashrc

# GMT 디렉토리 삭제
rm -rf ~/.gmt
```

## 기여하기

기여를 환영합니다! 자세한 내용은 [CONTRIBUTING.md](CONTRIBUTING.md)를 참고하세요.

- **언어 추가** — `lang/en.sh`를 번역해주세요
- **새 모듈** — `modules/your_module.sh`에 `_gmt_yourmodule_render` 함수를 만들어주세요
- **버그 리포트** — OS, 쉘 버전, `gmt version` 출력과 함께 이슈를 열어주세요
- **아이디어** — 기능 제안은 Issues에서 환영합니다

### 개발 환경

```bash
# 테스트용으로 별도 디렉토리에 클론 (~/.gmt 말고)
git clone https://github.com/coldpak/gmt.git ~/gmt-dev
cd ~/gmt-dev

# 실제 설치에 영향 없이 테스트
GMT_DIR="$(pwd)" bash -c 'source gmt.sh'
```

## 영감

- [wtfutil/wtf](https://github.com/wtfutil/wtf) — 터미널 대시보드 (Go)
- [dylanaraps/neofetch](https://github.com/dylanaraps/neofetch) — 시스템 정보 도구
- GitHub 잔디밭

## 라이선스

[MIT](LICENSE) © 2026 Good Morning Terminal Contributors

---

<p align="center">
  쉘 스크립트와 모닝커피로 만들었습니다.<br>
  <sub>GMT가 마음에 드셨다면 별을 눌러주세요!</sub>
</p>
