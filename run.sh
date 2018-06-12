#!/bin/bash
#This script will give the list of all video files and its size using df command.
VIDEO_LIST_FILE='video-list.data'
RESULT_FILE='video-results.csv'
FILE_PATH=''

while getopts ":p:" opt; do
  case $opt in
    p)
      FILE_PATH=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ ! -d "$FILE_PATH" ]; then
 echo -e "wrong path: $FILE_PATH does not exists"
 exit 1
fi
>$RESULT_FILE
echo -e "script starts at $(date)"
echo -e "scanning $FILE_PATH ..."
echo -e "extracting video list..."
find $FILE_PATH -type f -exec file -N -i -- {} + | sed -n 's!: video/[^:]*$!!p' > $VIDEO_LIST_FILE
echo -e "evaluating video disk usage..."
while read file; do
      du -k "$file" >> $RESULT_FILE
done <$VIDEO_LIST_FILE

rm $VIDEO_LIST_FILE
echo -e "script ends. check results in $RESULT_FILE"
echo -e "script ends at $(date)"
