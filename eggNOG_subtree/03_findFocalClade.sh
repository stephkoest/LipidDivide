#!/bin/bash
INTREE=$1
INFASTA=$2
FOCALNODE=$3
MINSUPP=0.7
MINTAX=200
MAXTAX=400
INDIR=$(dirname $INTREE)
OUTBASE=${INDIR}/$(basename $INTREE .tre)
FOCALTREE=${OUTBASE}.focalclade.tre
FOCALTXT=${OUTBASE}.focalclade.txt
FOCALFAA=${INDIR}/$(basename $INFASTA .faa).focal.faa
FOCALOUTFAA=${INDIR}/$(basename $FOCALFAA .faa).out.faa
OUTGROUPTXT=${OUTBASE}.focaloutgroup.txt
FOCALPARAS=${OUTBASE}.focalclade.parameters.txt
LEAFN=0
i=0

INTREEROOT=${OUTBASE}.root.tre
gotree reroot midpoint -i $INTREE -o $INTREEROOT

INTREE=$INTREEROOT

while [ "${LEAFN}" -le "${MAXTAX}" ]
do
	i=$(expr $i + 1)
	LEAFN=$(nw_clade -c $i $INTREE $FOCALNODE | nw_stats - | grep leaves | awk '{print $2}')
	SUPPORT=$(nw_clade -c $i $INTREE $FOCALNODE | nw_labels -r -)
	echo "$i levels down: $LEAFN leaves and $SUPPORT support for basal split"
	if [ "${LEAFN}" -ge "${MINTAX}" ] && [ "${LEAFN}" -le "${MAXTAX}" ] && (( $(echo "${SUPPORT} > ${MINSUPP}" | bc -l) ))
	then
		nw_clade -c $i $INTREE $FOCALNODE > $FOCALTREE
		nw_clade -c $(expr $i - 1) $INTREE $FOCALNODE | nw_labels -I - > $FOCALTXT
		grep -vwFf $FOCALTXT <(nw_clade -c $i $INTREE $FOCALNODE | nw_labels -I -) > $OUTGROUPTXT
		echo -e "MINTAX: ${MINTAX}\nMAXTAX: ${MAXTAX}\nMINSUPP: ${MINSUPP}" > $FOCALPARAS
		echo
		echo "Solution found:"
		echo "Tree written to ${FOCALTREE}"
		echo "clade labels written to ${FOCALTXT}"
		echo "outgroup written to ${OUTGROUPTXT}"
		echo "parameters written to ${FOCALPARAS}"
		python bin/fastaGrep.py $FOCALTXT $INFASTA > $FOCALFAA
		echo "focal sequences written to $FOCALFAA"
		python bin/fastaGrep.py <(cat $FOCALTXT $OUTGROUPTXT) $INFASTA > $FOCALOUTFAA
		echo "focal and outgroup sequences written to $FOCALOUTFAA"
		echo "bye"
		break
	fi
	if [ "${LEAFN}" -gt "${MAXTAX}" ]
	then
		echo "No solution with current settings. Change support (MINSUPP) or number of min (MINTAX) or max (MAXTAX) target taxa"
	fi
done
