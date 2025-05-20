#!/bin/bash

youtube_url="$1"
effect_rate="${2:-0.66}" # Default effect rate if not provided

youtube-dl -f 'bestaudio[ext=m4a]' -o - "$youtube_url" |
  ffmpeg -hide_banner -loglevel error -i pipe:0 -af "asetrate=44100*${effect_rate},aresample=44100" -f wav - |
  ffplay -hide_banner -loglevel error -i -
