#!/usr/bin/env bash
# ko.sh — 한국어 언어팩

# ── greeting ──
L_GREETING_MORNING="좋은 아침이에요"
L_GREETING_AFTERNOON="좋은 오후예요"
L_GREETING_EVENING="좋은 저녁이에요"
L_GREETING_NIGHT="아직 안 주무셨네요"

# ── date ──
L_WEEKDAYS=("일" "월" "화" "수" "목" "금" "토")
L_DATE_FMT="%m월 %d일 {weekday}요일"
L_DATE_SEP="·"
L_TIME_AM="오전"
L_TIME_PM="오후"

# ── weather ──
L_WEATHER_LOADING="날씨 불러오는 중..."
L_WEATHER_UNAVAILABLE="날씨 정보 없음"

# ── todos ──
L_TODO_TITLE="할 일"
L_TODO_GOAL="오늘의 목표"
L_TODO_EMPTY="아직 할 일이 없어요!"
L_TODO_HINT='gm add "첫 번째 할 일" 로 추가해보세요'
L_TODO_DONE_TOGGLE="완료 처리했어요"
L_TODO_UNDONE_TOGGLE="미완료로 되돌렸어요"
L_TODO_REMOVED="삭제했어요"
L_TODO_CLEARED="완료된 항목을 모두 삭제했어요"
L_TODO_ADDED="추가했어요"
L_TODO_GOAL_SET="오늘의 목표를 설정했어요"
L_TODO_GOAL_EMPTY="아직 오늘의 목표가 없어요"
L_TODO_CMD_HINT="gm add \"할 일\"  ·  gm done 1  ·  gm goal \"목표\""

# ── projects ──
L_PROJ_TITLE="최근 프로젝트"
L_PROJ_EMPTY="아직 방문한 프로젝트가 없어요"
L_PROJ_HINT="git 프로젝트 폴더로 cd 하면 자동으로 기록돼요"
L_PROJ_GO_HINT="번호 입력으로 바로 이동 → gm go 1"
L_PROJ_NOT_FOUND="프로젝트를 찾을 수 없어요"

# ── relative time ──
L_TIME_JUST_NOW="방금 전"
L_TIME_MINUTES_AGO="%d분 전"
L_TIME_HOURS_AGO="%d시간 전"
L_TIME_DAYS_AGO="%d일 전"
L_TIME_WEEKS_AGO="%d주 전"
L_TIME_YESTERDAY="어제"

# ── sysinfo ──
L_SYS_TITLE="시스템"
L_SYS_BRANCH="브랜치"
L_SYS_CLEAN="깨끗함"
L_SYS_DIRTY="변경사항 있음"

# ── activity ──
L_ACTIVITY_TITLE="활동"
L_ACTIVITY_WEEKS="%d주"
L_ACTIVITY_STREAK="연속"
L_ACTIVITY_DAYS="일째"
L_ACTIVITY_TODAY="오늘"
L_ACTIVITY_EMPTY="아직 활동 기록이 없어요"
L_ACTIVITY_HINT="터미널을 사용하면 자동으로 기록돼요"

# ── onboarding ──
L_ONBOARD_WELCOME="반가워요! Good Morning Terminal을 설정할게요."
L_ONBOARD_NAME_ASK="터미널에서 어떤 이름으로 불러드릴까요?"
L_ONBOARD_NAME_DEFAULT="(Enter를 누르면 '%s' 사용)"
L_ONBOARD_WEATHER_ASK="날씨를 보여드릴까요?"
L_ONBOARD_WEATHER_CITY="어느 도시의 날씨를 보여드릴까요?"
L_ONBOARD_DONE="설정이 끝났어요!"
L_ONBOARD_DONE_DESC="터미널을 열 때마다 이 화면이 반겨줄 거예요."
L_ONBOARD_TIP="언제든 gm config 로 설정을 바꿀 수 있어요."
L_ONBOARD_LANG_ASK="어떤 언어를 사용할까요?"

# ── help ──
L_HELP_HEADER="사용법"
L_HELP_COMMANDS=(
  "gm               홈 화면 보기"
  "gm add \"할 일\"  할 일 추가"
  "gm done 1       완료 처리 (토글)"
  "gm rm 1         삭제"
  "gm goal \"목표\"  오늘의 목표 설정"
  "gm go 1         프로젝트로 이동"
  "gm config       설정 편집"
  "gm help         이 도움말"
)

# ── tips ──
L_TIPS_TITLE="팁"
L_TIPS=(
  "cd - 를 입력하면 이전 디렉토리로 돌아가요"
  "Tab 키로 파일/폴더 이름을 자동완성할 수 있어요"
  "Ctrl+R 을 누르면 명령어 히스토리를 검색할 수 있어요"
  "mkdir -p a/b/c 로 중첩 폴더를 한번에 만들 수 있어요"
  "!! 를 입력하면 마지막 명령어를 다시 실행해요"
  "Ctrl+A 는 줄 맨 앞으로, Ctrl+E 는 줄 맨 뒤로 이동해요"
  "ls -la 로 숨김 파일까지 자세히 볼 수 있어요"
  "cat file1 file2 > merged 로 파일을 합칠 수 있어요"
  "&& 로 명령어를 연결해요: git add . && git commit"
  "Ctrl+C 로 실행 중인 명령어를 취소할 수 있어요"
  "Ctrl+L 로 터미널 화면을 깨끗하게 지울 수 있어요"
  "history 를 입력하면 최근 명령어를 볼 수 있어요"
  "pwd 로 현재 디렉토리 경로를 확인할 수 있어요"
  "mv 로 파일 이름을 바꿀 수 있어요: mv old.txt new.txt"
  "위쪽 화살표로 이전 명령어를 불러올 수 있어요"
)

# ── errors ──
L_ERR_UNKNOWN_CMD="알 수 없는 명령이에요. gm help 를 입력해보세요."
L_ERR_NO_ARG="내용을 입력해주세요."
L_ERR_INVALID_NUM="올바른 번호를 입력해주세요."
