#!/bin/bash


# Поиск всех PID
find /proc -maxdepth 1 -type d | awk -F "/" '{print $3}' | sed '/[a-z]/d' | sed '/./!d' > pid_list

echo "UID PID STATE NAME COMMAND" >> psax_clone

while read cr_pid; do
    a=$(grep Uid /proc/$cr_pid/status 2> /dev/null | awk '{print $2}') 
    b=$cr_pid
    c=$(grep State /proc/$cr_pid/status 2> /dev/null | awk '{print $2}')
    d=$(grep Name /proc/$cr_pid/status 2> /dev/null | awk '{print $2}')
    e=$(readlink /proc/$cr_pid/exe) 
    if [ -z $a ] && [ -z $c ] && [ -z $d ]; then
        continue;
    else
        echo "$a" "$b" "$c" "$d" "$e" >> psax_clone
    fi
done < pid_list

cat psax_clone | column -t

rm -r pid_list psax_clone
