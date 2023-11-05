#!/usr/bin/bash

if ! [ -x $(command -v fzf) ]; then
  echo "󱧖 -> fzf not found (run: yay -S fzf)" | lolcat
  exit
fi

if ! [ -x $(command -v zellij) ]; then
  echo "󱧖 -> zellij not found (run: yay -S zellij)" | lolcat
  exit
fi

if [ -x $(command -v lolcat) ]; then
  echo "󱧖 -> zellij not found (run: yay -S lolcat)" | lolcat
  exit
fi

EXCLUDE_DIRS=(
  ".*"
  "node_modules"
  "public"
  "prisma"
  "src"
  "Downloads"
  "yay"
  "Pictures"
  "Documents"
  "go"
  "lua*"
  "IdeaProjects"
  "neovim"
  "HyprV4"
)

if [ $# == 0 ]; then
  if [ $(zellij ls | wc -l) == 0 ]; then
    zellij --session default
  else
    session=$(zellij ls | fzf --prompt="󱊄 Select a session: " --height=15% --color --pointer=" " --min-height=5 --layout=reverse --border)
    if [[ $session ]]; then
      zellij a $session
    else
      echo "󰂭  No session selected!"
    fi
  fi
elif [ $# == 1 ]; then
  echo "󰂭  invalid command: fzj $1 [value]"
else
  FIND_COMMAND="find $HOME -type d"

  for dir in "${EXCLUDE_DIRS[@]}"; do
    FIND_COMMAND+=" -name '$dir' -prune -o"
  done

  FIND_COMMAND+=" -type d -print"

  SELECTED_PATH=$(eval "$FIND_COMMAND" | fzf --prompt="󰥨 Search dir: " --height=40% --min-height=5 --pointer=" " --layout=reverse --border --preview "ls -la --color {}")

  if [ $SELECTED_PATH ]; then
    cd $SELECTED_PATH
    
    if [ $1 == "-t" ]; then
      zellij action new-tab -n $2
    elif [ $1 == "-s" ]; then
      zellij --session $2
    elif [ $1 == "-f"]; then
      #  TODO: Select a file with fzf to edit on a pane in zellij
      
      # zellij action edit $file
      echo "todo"
    else
      echo "something" | lolcat
    fi
  else
    echo "󰂭  No path selected!" | lolcat
  fi
fi
