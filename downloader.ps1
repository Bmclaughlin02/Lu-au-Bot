$video = $args[0]

yt-dlp -o 'audio.mp3' -f worstaudio --no-check-certificate --verbose --ffmpeg-location 'ffmpeg-2023-04-17-git-65e537b833-essentials_build\bin\ffmpeg.exe' $video