#!/bin/bash

cd /c/users/d062430/git/web-crawler
mkdir old
rm -r new
mkdir new
report="report_$(date +'%d-%m-%Y').txt"
rm $report
touch "$report"
count=0
found="NODIFF"
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
	found="DIFF"
  fi
done <diffcheck.txt
echo "Done diffing. Deleting old, moving new"
rm -r old
echo "Finished. Find result in $report"

echo "Preparing Mail ..."
echo $found | grep "NODIFF$"
if [[ $? -eq 0 ]]
then
  echo "No difference mail ..."
  mail="No Updates found."
else
  echo "Diff mail ..."
  mail="Updates found on:<br><ul>"
  while read line; do
    name=$(echo $line | cut -d'|' -f 1)
    url=$(echo $line | cut -d'|' -f 2)
    mail="$mail<li><a href='$url'>$name</a></li>"
  done <$report
  mail="$mail</ul>"
  echo $mail
fi
echo "Sending mail ..."
java -cp ".;./javax.mail.jar;./javax.activation.jar" MessageSend "[$found] $(date +'%d-%m-%Y')" "$mail"
mv new old
