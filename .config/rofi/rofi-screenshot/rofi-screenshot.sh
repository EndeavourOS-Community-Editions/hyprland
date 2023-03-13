#!/usr/bin/env bash

## rofi-screenshot
## Author: ceuk @ github
## Licence: WTFPL
## Usage:
##    show the menu with rofi-screenshot
##    stop recording with rofi-screenshot -s

# Screenshot directory
screenshot_directory="${ROFI_SCREENSHOT_DIR:-$HOME/Pictures/Screenshots}"

# set ffmpeg defaults
ffmpeg() {
    command ffmpeg -hide_banner -loglevel error -nostdin "$@"
}

video_to_gif() {
    ffmpeg -i "$1" -vf palettegen -f image2 -c:v png - |
    ffmpeg -i "$1" -i - -filter_complex paletteuse "$2"
}

countdown() {
  notify-send --app-name="screenshot" "Screenshot" "Recording in 3" -t 1000
  sleep 1
  notify-send --app-name="screenshot" "Screenshot" "Recording in 2" -t 1000
  sleep 1
  notify-send --app-name="screenshot" "Screenshot" "Recording in 1" -t 1000
  sleep 1
}

crtc() {
  notify-send --app-name="screenshot" "Screenshot" "Select a region to capture"
  ffcast -q "$(slop -n -f '-g %g ')" png /tmp/screenshot_clip.png
  xclip -selection clipboard -t image/png /tmp/screenshot_clip.png
  rm /tmp/screenshot_clip.png
  notify-send --app-name="screenshot" "Screenshot" "Region copied to Clipboard"
}

crtf() {
  notify-send --app-name="screenshot" "Screenshot" "Select a region to capture"
  dt=$(date '+%d-%m-%Y %H:%M:%S')
  ffcast -q "$(slop -n -f '-g %g ')" png "$screenshot_directory/$dt.png"
  notify-send --app-name="screenshot" "Screenshot" "Region saved to ${screenshot_directory//${HOME}/~}"
}

cstc() {
  ffcast -q png /tmp/screenshot_clip.png
  xclip -selection clipboard -t image/png /tmp/screenshot_clip.png
  rm /tmp/screenshot_clip.png
  notify-send --app-name="screenshot" "Screenshot" "Screenshot copied to Clipboard"
}

cstf() {
  dt=$(date '+%d-%m-%Y %H:%M:%S')
  ffcast -q png "$screenshot_directory/$dt.png"
  notify-send --app-name="screenshot" "Screenshot" "Saved to ${screenshot_directory//${HOME}/~}"
}

rgrtf() {
  notify-send --app-name="screenshot" "Screenshot" "Select a region to record"
  dt=$(date '+%d-%m-%Y %H:%M:%S')
  ffcast -q "$(slop -n -f '-g %g ' && countdown)" rec /tmp/screenshot_gif.mp4
  notify-send --app-name="screenshot" "Screenshot" "Converting to gif… (can take a while)"
  video_to_gif /tmp/screenshot_gif.mp4 "$screenshot_directory/$dt.gif"
  rm /tmp/screenshot_gif.mp4
  notify-send --app-name="screenshot" "Screenshot" "Saved to ${screenshot_directory//${HOME}/~}"
}

rgstf() {
  countdown
  dt=$(date '+%d-%m-%Y %H:%M:%S')
  ffcast -q rec /tmp/screenshot_gif.mp4
  notify-send --app-name="screenshot" "Screenshot" "Converting to gif… (can take a while)"
  video_to_gif /tmp/screenshot_gif.mp4 "$screenshot_directory/$dt.gif"
  rm /tmp/screenshot_gif.mp4
  notify-send --app-name="screenshot" "Screenshot" "Saved to ${screenshot_directory//${HOME}/~}"
}

rvrtf() {
  notify-send --app-name="screenshot" "Screenshot" "Select a region to record"
  dt=$(date '+%d-%m-%Y %H:%M:%S')
  ffcast -q "$(slop -n -f '-g %g ' && countdown)" rec "$screenshot_directory/$dt.mp4"
  notify-send --app-name="screenshot" "Screenshot" "Saved to ${screenshot_directory//${HOME}/~}"
}

rvstf() {
  countdown
  dt=$(date '+%d-%m-%Y %H:%M:%S')
  ffcast -q rec "$screenshot_directory/$dt.mp4"
  notify-send --app-name="screenshot" "Screenshot" "Saved to ${screenshot_directory//${HOME}/~}"
}

get_options() {
  echo "  Region  File"
  echo "  Screen  File"
  echo "  Region  File (GIF)"
  echo "  Screen  File (GIF)"
  echo "  Region  File (MP4)"
  echo "  Screen  File (MP4)"
}

main() {
  if [[ $1 == '--help' ]] || [[ $1 = '-h' ]]
  then
    echo ### rofi-screenshot
    echo "USAGE: rofi-screenshot [OPTION] <argument>"
    echo "(no option)"
    echo "    show the screenshot menu"
    echo "-s, --stop"
    echo "    stop recording"
    echo "-h, --help"
    echo "    this screen"
    echo "-d, --directory <directory>"
    echo "    set the screenshot directory"
    exit 1
  fi

  if [[ $1 = '--stop' ]] || [[ $1 = '-s' ]]
  then
    pkill -fxn '(/\S+)*ffmpeg\s.*\sx11grab\s.*'
    exit 1
  fi

  if [[ $1 = '--directory' ]] || [[ $1 = '-d' ]]
  then
    if [[ ! -d $2 ]]
    then
      echo "Directory does not exist!"
      exit 1
    fi
    screenshot_directory="$2"
  fi


  # Get choice from rofi
  choice=$( (get_options) | rofi -dmenu -i -fuzzy -p "Screenshot" )

  # If user has not picked anything, exit
  if [[ -z "${choice// }" ]]; then
      exit 1
  fi

  # run the selected command
  case $choice in
    '  Region  Clip')
      crtc
      ;;
    '  Region  File')
      crtf
      ;;
    '  Screen  Clip')
      cstc
      ;;
    '  Screen  File')
      cstf
      ;;
    '  Region  File (GIF)')
      rgrtf
      ;;
    '  Screen  File (GIF)')
      rgstf
      ;;
    '  Region  File (MP4)')
      rvrtf
      ;;
    '  Screen  File (MP4)')
      rvstf
      ;;
  esac

  # done
  set -e
}

main "$@" &

exit 0

