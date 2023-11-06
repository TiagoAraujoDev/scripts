#!/usr/bin/bash

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

EXCLUDE_FILES=(
  ".git"
  ".next"
  "build"
  "node_modules"
)

dependencies=(
  fzf
  zellij
  lolcat
)

for dep in "${dependencies[@]}"; do
  if ! pacman -Qq $dep &> /dev/null; then
    echo "󱧖 -> $dep not found (run: yay -S $dep)"
    exit
  fi
done

if [ $1 == "--help" ]; then
  echo "  fzj is a shell script to give extra power to zellij

  usage:
    fzj -> open a zellij session with default name or list all section for selection 
    fzj [option] [valeu]

    options:
      -t    create new tab in zellij with the given name[value]
      -s    create new session with a given name[value]
      -f    create a edit pane to the selected file

    --help  show this message
"
  exit 0
fi

get_dir() {
  FIND_COMMAND="find $HOME -type d"
  for dir in "${EXCLUDE_DIRS[@]}"; do
    FIND_COMMAND+=" -name '$dir' -prune -o"
  done
  FIND_COMMAND+=" -type d -print"
  SELECTED_PATH=$(eval "$FIND_COMMAND" | fzf --prompt="󰥨 Search dir: " --height=40% --min-height=5 --pointer=" " --layout=reverse --border --preview "ls -la --color {}")
  echo $SELECTED_PATH
}

get_file() {
  FIND_COMMAND="find -type d"
  for dir in "${EXCLUDE_FILES[@]}"; do
    FIND_COMMAND+=" -name '$dir' -prune -o"
  done
  FIND_COMMAND+=" -type f -print"
  FILE=$(eval "$FIND_COMMAND" | fzf --prompt="󰈞 Search file: " --height=40% --min-height=5 --pointer=" " --layout=reverse --border --preview "bat {}")
  echo $FILE
}

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
  if [ $1 == "-f" ]; then
    file=$(get_file)
    
    if [ $file ]; then
      zellij action edit $file
    else
      echo "󰂭  No file selected!"
    fi
  else
    echo "󰂭  invalid command: fzj $1 [value]"
  fi
else
  if [ $1 == "-t" ]; then
    path=$(get_dir)

    cd $path
    
    if [ $path ]; then
      zellij action new-tab -n $2 -l ~/.config/zellij/fzj_tab.kdl -c $path
    else
      echo "󰂭  No path selected!"
    fi
  elif [ $1 == "-s" ]; then
    path=$(get_dir)

    cd $path
    if [ $path ]; then
      zellij --session $2
    else
      echo "󰂭  No path selected!"
    fi
  else
    echo "󰂭  Invalid option!"
  fi
fi
