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

FIND_COMMAND="find $HOME -type d"

for dir in "${EXCLUDE_DIRS[@]}"; do
  FIND_COMMAND+=" -name '$dir' -prune -o"
done

FIND_COMMAND+=" -type d -print"

SELECTED_PATH=$(eval "$FIND_COMMAND" | fzf)

if [ $SELECTED_PATH ] && [ $2 ]; then
  cd $SELECTED_PATH
  if [ $1 == "-t" ]; then
    zellij action new-tab -n $2 --layout ~/.config/zellij/zdir.kdl
  elif [ $1 == "-s" ]; then
    zellij --session $2
  else
    zellij --session default
  fi
else
  echo "❌ No path selected!"
fi
