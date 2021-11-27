#!/bin/bash

recycle_dir='/work1/lixeira'
lastaccess_maxdays=30 #Validade dos arquivos em dias

find $recycle_dir -atime +$lastaccess_maxdays -type f -delete
find $recycle_dir -type d ! -path $recycle_dir -empty -delete
