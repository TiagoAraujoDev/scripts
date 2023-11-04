#!/usr/bin/bash

EXCLUDE_DIRS=(
  ".*"
  "node_modules"
  "public"
  "prisma"
  "src"
  "Downloads"
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

PREFIX="/home/tma/"

if [ $SELECTED_PATH ]; then
  cd $SELECTED_PATH
  if [ $1 == "-t" ]; then
    zellij action new-tab -n fzf_tab --layout ~/.config/zellij/zdir.kdl
  elif [ $1 == "-p" ]; then
    zellij action new-pane -n fzf_pane -h
  else
    zellij --session fzf_session
  fi
else
  echo "❌ No path selected!"
fi

echo $SELECTED_PATH
echo "~/${SELECTED_PATH#$PREFIX}"
