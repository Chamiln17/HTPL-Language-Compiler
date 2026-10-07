#!/bin/sh
# Compile every examples/*.htpl and tests/programs/*.htpl with htplc and diff stdout
# against the .expected file next to it. Usage: sh tests/run.sh ./htplc
htplc=$1
fails=0
total=0
for prog in examples/*.htpl tests/programs/*.htpl; do
  total=$((total + 1))
  if "$htplc" < "$prog" | diff -u "${prog%.htpl}.expected" - > /tmp/htpl-diff.$$; then
    echo "ok   $prog"
  else
    echo "FAIL $prog"; cat /tmp/htpl-diff.$$; fails=$((fails + 1))
  fi
done
rm -f /tmp/htpl-diff.$$
echo "$total programs, $fails failures"
[ "$fails" -eq 0 ]
