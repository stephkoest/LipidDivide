#!/bin/bash
LINE=$1
ANNOF=$2
ID=$(echo $LINE | cut -d"#" -f3)
COG=$(grep -w $ID $ANNOF | awk -F"\t" '{print $2}' | sed 's/|.*//')
echo $LINE | awk -v COG=$COG -F"#" '{print $1"|"$2"#"$3"#"$4"#"COG}'
