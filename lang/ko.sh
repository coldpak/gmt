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
L_TODO_HINT='gmt add "첫 번째 할 일" 로 추가해보세요'
L_TODO_DONE_TOGGLE="완료 처리했어요"
L_TODO_UNDONE_TOGGLE="미완료로 되돌렸어요"
L_TODO_REMOVED="삭제했어요"
L_TODO_CLEARED="완료된 항목을 모두 삭제했어요"
L_TODO_ADDED="추가했어요"
L_TODO_GOAL_SET="오늘의 목표를 설정했어요"
L_TODO_GOAL_EMPTY="아직 오늘의 목표가 없어요"
L_TODO_CMD_HINT="gmt add \"할 일\"  ·  gmt done 1  ·  gmt goal \"목표\""

# ── projects ──
L_PROJ_TITLE="최근 프로젝트"
L_PROJ_EMPTY="아직 방문한 프로젝트가 없어요"
L_PROJ_HINT="git 프로젝트 폴더로 cd 하면 자동으로 기록돼요"
L_PROJ_GO_HINT="번호 입력으로 바로 이동 → gmt go 1"
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
L_ONBOARD_TIP="언제든 gmt config 로 설정을 바꿀 수 있어요."
L_ONBOARD_LANG_ASK="어떤 언어를 사용할까요?"

# ── help ──
L_HELP_HEADER="사용법"
L_HELP_COMMANDS=(
  "gmt              홈 화면 보기"
  "gmt add \"할 일\"  할 일 추가"
  "gmt done 1       완료 처리 (토글)"
  "gmt rm 1         삭제"
  "gmt goal \"목표\"  오늘의 목표 설정"
  "gmt go 1         프로젝트로 이동"
  "gmt config       설정 편집"
  "gmt help         이 도움말"
)

# ── errors ──
L_ERR_UNKNOWN_CMD="알 수 없는 명령이에요. gmt help 를 입력해보세요."
L_ERR_NO_ARG="내용을 입력해주세요."
L_ERR_INVALID_NUM="올바른 번호를 입력해주세요."
