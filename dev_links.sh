#!/usr/bin/bash

OPTION1="http://localhost:8080"
OPTION2="http://localhost:3000"

OPTIONS="$OPTION1\n$OPTION2"

OPTION_SELECTED=$(echo -e $OPTIONS | wofi -c ~/.config/HyprV/wofi/config-select -s ~/.config/HyprV/wofi/style/select.css -dmenu 2> /dev/null)

if [ $OPTION_SELECTED ]; then
  brave --app=$OPTION_SELECTED 2> /dev/null
else
  echo "No option selected!"
fi
