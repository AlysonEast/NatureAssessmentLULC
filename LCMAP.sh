#!/bin/bash                                                                     
READDATA=0
RECLASS=1
REPORTS=1

export GISRC=/home/aly/.grassrc8.data

g.mapset mapset=UNB_NLCD

if [ $READDATA -eq 1 ]
then
	r.in.gdal input=../NLCD/LCMAP/LCMAP_CU_1985_V13_LCPRI.tif output=LCMAP_CU_1985_V13_LCPRI --o
	r.in.gdal input=../NLCD/LCMAP/LCMAP_CU_2021_V13_LCPRI.tif output=LCMAP_CU_2021_V13_LCPRI --o
	r.in.gdal input=../NLCD/LCMAP/LCMAP_CU_2021_V13_SCLAST.tif output=LCMAP_CU_2021_V13_SCLAST --o

fi

if [ $RECLASS -eq 1 ]
then
	r.reclass input=LCMAP_CU_2021_V13_SCLAST output=LCMAP_Changed_1985_2021 rules=../NLCD/LCMAP/Dist_Reclass.txt

fi

if [ $REPORTS -eq 1 ]
then
	#r.mask NLCD_Changed_2001_2021 --o
	r.report map=LCMAP_CU_1985_V13_LCPRI,LCMAP_CU_2021_V13_LCPRI -h -n -a units=kilometers output=LCMAP_1985to2021_report
	awk 'BEGIN { FS="|"; } {print $2"	"$3"	"$5}' LCMAP_1985to2021_report >LCMAP_1985to2021_report.tsv

	r.mask LCMAP_Changed_1985_2021 --o
	r.report map=LCMAP_CU_1985_V13_LCPRI,LCMAP_CU_2021_V13_LCPRI -h -n -a units=kilometers output=LCMAPChanged_1985to2021_report
	awk 'BEGIN { FS="|"; } {print $2"	"$3"	"$5}' LCMAPChanged_1985to2021_report >LCMAPChanged_1985to2021_report.tsv

fi
