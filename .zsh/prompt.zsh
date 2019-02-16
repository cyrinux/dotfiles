typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=white,bold'

export SPACESHIP_PROMPT_ORDER=(
  time
  user
  dir
  host
  git_branch
  git_status
  # kubecontext
  docker
  tox
  ruby
  venv
  exec_time
  line_sep
  jobs
  char
)

export SPACESHIP_CHAR_SYMBOL="❯ "
export SPACESHIP_JOBS_SYMBOL="»"
export SPACESHIP_TIME_SHOW=true
export SPACESHIP_USER_PREFIX="as "
export SPACESHIP_USER_SHOW="needed"
export SPACESHIP_DIR_TRUNC_PREFIX=".../"
export SPACESHIP_DIR_TRUNC_REPO=false
export TIPZ_TEXT='💡 '
export SPACESHIP_TOX_COLOR_OK="green"
export SPACESHIP_TOX_COLOR_FAIL="red"
#export SPACESHIP_TOX_SYMBOL_OK=" "
export SPACESHIP_RUBY_COLOR="white"
export SPACESHIP_KUBECONTEXT_COLOR_GROUPS=(
  red -prod-
)
