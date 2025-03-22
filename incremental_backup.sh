#!/bin/bash
NOW=$(date +%Y%m%d%H%M)
MNOW=$(date +%Y%m)

SRC_DIR="/home/ivan"
DST_DIR="/tmp/backup/"
LOG_FILE="$DST_DIR/${MNOW}/backup-${NOW}.log"

DOW=`date +%a`              # Day of the week e.g. Mon
DOM=`date +%d`              # Date of the Month e.g. 27
DM=`date +%d%b`             # Date and Month e.g. 27Sep

if [[ ! -d ${DST_DIR}${MNOW} ]]
  then
    mkdir -p ${DST_DIR}${MNOW}
  else
    echo &>/dev/null
fi

echo "Создание резервной копии в $DST_DIR..." | tee -a "$LOG_FILE"

tar -v -z --create --file ${DST_DIR}${MNOW}/${NOW}.tar.gz --listed-incremental=${DST_DIR}${MNOW}/${MNOW}.snar $SRC_DIR &>> $LOG_FILE 2>&1

echo "Резервная копия завершена." | tee -a "$LOG_FILE"

find $SRC_DIR -type f -exec md5sum {} + > "${DST_DIR}${MNOW}/md5sum.txt"

if md5sum -c ${DST_DIR}${MNOW}/md5sum.txt  &>> $LOG_FILE 2>&1; then
        echo "Проверка целостности прошла успешно." | tee -a "$LOG_FILE"
    else
        echo "Ошибка проверки целостности!" | tee -a "$LOG_FILE"
        exit 1
    fi
