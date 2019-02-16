#!/usr/bin/zsh
# Credits: https://github.com/benvan/sandboxd

# holds all hook descriptions in "cmd:hook" format
sandbox_hooks=()

# deletes all hooks associated with cmd
sandbox_delete_hooks() {
  local cmd=$1
  for i in "${sandbox_hooks[@]}";
  do
    if [[ $i == "${cmd}:"* ]]; then
      local hook=$(echo $i | sed "s/.*://")
      unset -f "$hook"
    fi
  done
}

# prepares environment and removes hooks
sandbox() {
  local cmd=$1
  if [[ "$(type $cmd | grep -o function)" = "function" ]]; then
    (>&2 echo "Lazy-loading $cmd for the first time...")
    sandbox_delete_hooks $cmd
    sandbox_init_$cmd
  else
    (>&2 echo "sandbox '$cmd' not found.\nIs 'sandbox_init_$cmd() { ... }' defined and 'sandbox_hook $cmd $cmd' called?")
    return 1
  fi
}

sandbox_hook() {
  local cmd=$1
  local hook=$2

  sandbox_hooks+=("${cmd}:${hook}")

  eval "$hook(){ sandbox $cmd; $hook \$@ }"
}


# RVM configuration
sandbox_init_rvm() {
  if [ -f /usr/share/rvm/scripts/rvm ]; then
     source /usr/share/rvm/scripts/rvm
  fi
}
sandbox_hook rvm rvm
sandbox_hook rvm eyaml
sandbox_hook rvm ruby
