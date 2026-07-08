#!/bin/bash                                                                     
READDATA=0
RECLASS=1
REPORTS=0

export GISRC=/home/aly/.grassrc8.data

g.mapset mapset=UNB_NLCD

if [ $READDATA -eq 1 ]
then
	r.in.gdal input=../LandCover/conus_lulc_boolean/conus_lulc_1650.tif output=conus_lulc_1650 --o
	r.in.gdal input=../LandCover/conus_lulc_boolean/conus_lulc_1850.tif output=conus_lulc_1850 --o
	r.in.gdal input=../LandCover/conus_lulc_boolean/conus_lulc_1900.tif output=conus_lulc_1900 --o
	r.in.gdal input=../LandCover/conus_lulc_boolean/conus_lulc_1985.tif output=conus_lulc_1985 --o
	r.in.gdal input=../LandCover/conus_lulc_boolean/conus_lulc_2020.tif output=conus_lulc_2020 --o

fi

if [ $RECLASS -eq 1 ]
then
	r.reclass input=conus_lulc_1850 output=conus_lulc_1850_reclassMatchLCMAP rules=../LandCover/lulc_boolean_reclass.txt --o
	r.out.gdal input=conus_lulc_1850_reclassMatchLCMAP  output=conus_lulc_1850_reclassMatchLCMAP.tif format=GTiff --o

fi

if [ $REPORTS -eq 1 ]
then
	r.mask -r
	r.report map=conus_lulc_1650,conus_lulc_2020 -h -n -a units=miles output=hindcastLULC_1650to2020_report --overwrite
	awk 'BEGIN { FS="|"; } {print $2"	"$3"	"$5}' hindcastLULC_1650to2020_report>hindcastLULC_1650to2020_report.tsv
fi

