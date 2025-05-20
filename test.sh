#!/bin/bash

youtube_url="$1"
effect_rate="${2:-0.66}" # Pass this rate to the ffmpeg command

downloaded_filename=$(youtube-dl --get-filename -f 'bestaudio[ext=m4a]' "$youtube_url")

if [ -z "$downloaded_filename" ]; then
  echo "Error: Could not determine the output filename from youtube-dl. Please check the URL."
  return 1
fi

echo "Predicted download filename: $downloaded_filename"

# Step 2: Download the audio using the predicted filename.
# The -o option ensures youtube-dl saves the file with this exact name.
echo "Downloading audio..."
youtube-dl -f 'bestaudio[ext=m4a]' -o "$downloaded_filename" "$youtube_url"

# Check if the download was successful
if [ ! -f "$downloaded_filename" ]; then
  echo "Error: Audio download failed. File '$downloaded_filename' not found."
  return 1
fi

echo "Audio downloaded successfully: $downloaded_filename"

# Step 3: Apply the vaporwave effect with ffmpeg and pipe directly to ffplay.
# -i "$downloaded_filename": Input file
# -af "asetrate=...": Audio filter for vaporwave effect
# -f wav -: Output format as WAV to stdout (pipe)
# | ffplay -i -: Pipe stdout to ffplay, which reads from stdin
echo "Applying vaporwave effect and playing with ffplay..."
ffmpeg -hide_banner -loglevel error -i "$downloaded_filename" -af "asetrate=44100*${effect_rate},aresample=44100" -f wav - | ffplay -hide_banner -loglevel error -i -

# Step 4: Clean up the downloaded temporary file.
echo "Cleaning up temporary file: $downloaded_filename"
rm "$downloaded_filename"

echo "Process complete for $youtube_url."
