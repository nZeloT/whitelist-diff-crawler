#!/bin/bash

cd /c/users/d062430/git/web-crawler
mkdir old
rm -r new
mkdir new
report="report_$(date +'%d-%m-%Y').txt"
rm $report
touch "$report"
count=0
while read line; do
  echo "Curling ... $line"
  url=$(echo $line | cut -d'|' -f 2)
  name=$(echo -n $url | md5sum | cut -d' ' -f 1)
  curl -s -o "new/$name" "$url"

  echo "Diffing to old version ... "
  diff -q "old/$name" "new/$name" | grep 'differ$'
  if [[ $? -eq 0 ]];
  then
	echo "Found difference!"
	echo "$line" >> $report
  fi
done <diffcheck.txt
echo "Done diffing. Deleting old, moving new"
rm -r old
echo "Finished. Find result in $report"
mv new old
notepad $report

