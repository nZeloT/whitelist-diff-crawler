#!/bin/bash

mkdir old
rm -r new
mkdir new
report="report_$(date +'%d-%m-%Y').txt"
touch "$report"
count=0
while read line; do
  echo "Curling ... $line"
  name=$(echo -n $line | md5sum | cut -d' ' -f 1)
  curl -s -o "new/$name" "$line"

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
mv new old
echo "Finished. Find result in $report"
