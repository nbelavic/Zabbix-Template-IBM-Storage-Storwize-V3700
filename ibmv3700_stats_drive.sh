#!/bin/bash

. /usr/lib/zabbix/externalscripts/ibmv3700_discovery.sh

STORWIZEADDR=$(echo $1)
SLOTID=$(echo $2)

#START CHAR SLOT ID
SCS=$(cat  ${REPODIR}/${STORWIZEADDR}.drive.repo | grep -aob 'lot_id' | \grep -oE '^[0-9]+')
#END CHAR SLOT ID
ECS=$(($SCS + 7))


IFS=' '

status () {
	LINE=$(cat ${REPODIR}/${STORWIZEADDR}.drive.repo | cut -c4-10,${SCS}-${ECS} | grep -w ${SLOTID})
	STATUS=$(echo ${LINE}| awk '{ print $1 }')
	echo ${STATUS}
}

use () {
	LINE=$(cat ${REPODIR}/${STORWIZEADDR}.drive.repo | cut -c33-39,${SCS}-${ECS} | grep -w ${SLOTID})
        USE=$(echo ${LINE}| awk '{ print $1 }')
        echo ${USE}
}

type () {
	LINE=$(cat ${REPODIR}/${STORWIZEADDR}.drive.repo | cut -c40-49,${SCS}-${ECS} | grep -w ${SLOTID})
        TYPE=$(echo ${LINE}| awk '{ print $1 }')
	echo ${TYPE}
}

mdisk_name  () {
        LINE=$(cat ${REPODIR}/${STORWIZEADDR}.drive.repo | cut -c68-78,${SCS}-${ECS} | grep -w ${SLOTID})
	if [ $(echo ${LINE} | grep -o " " | wc -l) -gt 0  ] ; then
	        MDISK_NAME=$(echo ${LINE}| awk '{ print $1 }')
	fi
	echo ${MDISK_NAME}
}

enclosure_id () {
	LINE=$(cat ${REPODIR}/${STORWIZEADDR}.drive.repo | cut -c89-101,${SCS}-${ECS} | awk -v SLOTID=${SLOTID} '{if ($2==SLOTID){print $0}}')
	ENCLOUSURE_ID=$(echo ${LINE}| awk '{ print $1 }')
	echo ${ENCLOUSURE_ID}
}

$3
