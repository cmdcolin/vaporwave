# vaporwaver

Some bash aliases/functions/scripts to slow down sounds, sort of like vaporwave

## Pre-requisites

1. Get yt-dlp
2. Get ffmpeg

## Usage

Make this into a bash alias in your .bashrc or .zshrc like this

```bash

function vp() {
  youtube_url="$1"
  effect_rate="${2:-0.66}" # Default effect rate if not provided

  yt-dlp -f 'bestaudio[ext=m4a]' -o - "$youtube_url" |
    ffplay -hide_banner -loglevel error -i pipe:0 -af "asetrate=44100*${effect_rate},aresample=44100"
}
```

Then run

```bash
vp 'https://www.youtube.com/watch?v=WNcFERh0KEE'
```

The above command pipes from YouTube straight to ffplay to your headphones

## FAQ

### What if I want to save the file

You can also split this up into multiple commands to make this write to disk

e.g.

```bash


alias yda="youtube-dl -f 'bestaudio[ext=m4a]' "
function vaporwave() {
  ffmpeg -i "$1" -af "asetrate=44100*${2:-0.66},aresample=44100" "$(basename $1 .m4a).vaporwave${2:-0.66}.m4a"
}

```

Then you can run

```bash
yda 'https://www.youtube.com/watch?v=WNcFERh0KEE'
vaporwave outputted_file.mp4
```
