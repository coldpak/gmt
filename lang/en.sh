#!/usr/bin/env bash
# en.sh — English language pack

# ── greeting ──
L_GREETING_MORNING="Good morning"
L_GREETING_AFTERNOON="Good afternoon"
L_GREETING_EVENING="Good evening"
L_GREETING_NIGHT="Burning the midnight oil"

# ── date ──
L_WEEKDAYS=("Sun" "Mon" "Tue" "Wed" "Thu" "Fri" "Sat")
L_DATE_FMT="{weekday}, %m/%d"
L_DATE_SEP="·"
L_TIME_AM="AM"
L_TIME_PM="PM"

# ── weather ──
L_WEATHER_LOADING="Loading weather..."
L_WEATHER_UNAVAILABLE="Weather unavailable"

# ── todos ──
L_TODO_TITLE="To-Do"
L_TODO_GOAL="Today's Goal"
L_TODO_EMPTY="No tasks yet!"
L_TODO_HINT='Try: gmt add "your first task"'
L_TODO_DONE_TOGGLE="Marked as done"
L_TODO_UNDONE_TOGGLE="Marked as not done"
L_TODO_REMOVED="Removed"
L_TODO_CLEARED="Cleared all completed tasks"
L_TODO_ADDED="Added"
L_TODO_GOAL_SET="Goal set for today"
L_TODO_GOAL_EMPTY="No goal set for today"
L_TODO_CMD_HINT="gmt add \"task\"  ·  gmt done 1  ·  gmt goal \"goal\""

# ── projects ──
L_PROJ_TITLE="Recent Projects"
L_PROJ_EMPTY="No projects visited yet"
L_PROJ_HINT="cd into a git project folder to start tracking"
L_PROJ_GO_HINT="Jump to a project → gmt go 1"
L_PROJ_NOT_FOUND="Project not found"

# ── relative time ──
L_TIME_JUST_NOW="just now"
L_TIME_MINUTES_AGO="%d min ago"
L_TIME_HOURS_AGO="%dh ago"
L_TIME_DAYS_AGO="%dd ago"
L_TIME_WEEKS_AGO="%dw ago"
L_TIME_YESTERDAY="yesterday"

# ── sysinfo ──
L_SYS_TITLE="System"
L_SYS_BRANCH="branch"
L_SYS_CLEAN="clean"
L_SYS_DIRTY="dirty"

# ── activity ──
L_ACTIVITY_TITLE="Activity"
L_ACTIVITY_WEEKS="%d weeks"
L_ACTIVITY_STREAK="streak"
L_ACTIVITY_DAYS=" days"
L_ACTIVITY_TODAY="today:"
L_ACTIVITY_EMPTY="No activity recorded yet"
L_ACTIVITY_HINT="Activity is tracked automatically as you use the terminal"

# ── onboarding ──
L_ONBOARD_WELCOME="Welcome! Let's set up Good Morning Terminal."
L_ONBOARD_NAME_ASK="What name should the terminal call you?"
L_ONBOARD_NAME_DEFAULT="(Press Enter to use '%s')"
L_ONBOARD_WEATHER_ASK="Show weather?"
L_ONBOARD_WEATHER_CITY="Which city's weather?"
L_ONBOARD_DONE="All set!"
L_ONBOARD_DONE_DESC="This screen will greet you every time you open a terminal."
L_ONBOARD_TIP="You can change settings anytime with gmt config."
L_ONBOARD_LANG_ASK="Which language would you like?"

# ── help ──
L_HELP_HEADER="Usage"
L_HELP_COMMANDS=(
  "gmt              Show home screen"
  "gmt add \"task\"   Add a task"
  "gmt done 1       Toggle completion"
  "gmt rm 1         Remove a task"
  "gmt goal \"goal\"  Set today's goal"
  "gmt go 1         Jump to project"
  "gmt config       Edit settings"
  "gmt help         Show this help"
)

# ── tips ──
L_TIPS_TITLE="Tip"
L_TIPS=(
  "cd - takes you back to the previous directory"
  "Use Tab to autocomplete file and directory names"
  "Press Ctrl+R to search your command history"
  "mkdir -p path/to/dir creates nested directories at once"
  "Use !! to repeat the last command"
  "Ctrl+A moves to the start of the line, Ctrl+E to the end"
  "ls -la shows hidden files with details"
  "cat file1 file2 > combined merges files together"
  "Use && to chain commands: git add . && git commit"
  "Ctrl+C cancels a running command"
  "Ctrl+L clears the terminal (same as running clear)"
  "history shows your recent commands"
  "pwd shows your current directory"
  "mv can rename files: mv old.txt new.txt"
  "Use up arrow to cycle through previous commands"
)

# ── errors ──
L_ERR_UNKNOWN_CMD="Unknown command. Try: gmt help"
L_ERR_NO_ARG="Please provide content."
L_ERR_INVALID_NUM="Please enter a valid number."
