#!/bin/sh
x=$(psql -U postgres -d 'download' -c "SELECT task_id,destination,filename,status FROM download_queue where status=5 OR status=8 " -P format=unaligned -R "|")
echo $x
OLD_IFS=$IFS
IFS="|"
set -- $x
IFS=$OLD_IFS
echo $5
if [ "$5" != "(0 rows)" ]; then
  if find '/volume1/'$6'/'$7 -iname '*.mkv' -o -iname '*.mp4' 1> /dev/null 2>&1 ; then
    echo "?!"
    for i in $( find '/volume1/'$6'/'$7 -iname '*.mkv' -o -iname '*.mp4'); do
      echo $i;
      j=$(echo $i | sed -e "s/mp4/T.mp4/g; s/mkv/T.mp4/g");
      echo $j;
      /volume1/@appstore/FFmpegWithDTS/bin/ffmpeg -i "$i" -c:v copy -c:a libfaac "$j";
    done;
  fi
fi
