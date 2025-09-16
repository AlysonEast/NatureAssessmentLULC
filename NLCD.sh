#!/bin/bash                                                                     
READDATA=0
RECLASS=0
ALLCELLS=0
REPORTS=1

export GISRC=/home/aly/.grassrc8.data

g.mapset mapset=UNB_NLCD

if [ $READDATA -eq 1 ]
then
	r.in.gdal input=../NLCD/nlcd_01_21_land_cover_change_first_disturbance_date_20230630/nlcd_01_21_land_cover_change_first_disturbance_date_20230630.tif output=nlcd_01_21_land_cover_change_first_disturbance_date_20230630 --o
	r.in.gdal input=../NLCD/nlcd_2001_2021_land_cover_change_index_l48_20230630/nlcd_2001_2021_land_cover_change_index_l48_20230630.tif output=nlcd_2001_2021_land_cover_change_index_l48_20230630 --o
	r.in.gdal input=../NLCD/nlcd_2021_land_cover_science_product_l48_20230630/nlcd_2021_land_cover_science_product_l48_20230630.tif output=nlcd_2021_land_cover_science_product_l48_20230630.tif --o
	r.in.gdal input=../NLCD/nlcd_forest_disturbance_date_1984_2021_20230630/nlcd_forest_disturbance_date_1984_2021_20230630.tif output=nlcd_forest_disturbance_date_1984_2021_20230630 --o
	r.in.gdal input=../NLCD/nlcd_2001_land_cover_l48_20210604/nlcd_2001_land_cover_l48_20210604.tif output=nlcd_2001_land_cover_l48_20210604 --o

fi

if [ $RECLASS -eq 1 ]
then
	r.reclass input=nlcd_2001_2021_land_cover_change_index_l48_20230630 output=NLCD_Changed_2001_2021 rules=../NLCD/Dist_Reclass.txt
	r.reclass input=nlcd_forest_disturbance_date_1984_2021_20230630 output=NLCD_Forest_1984_2021 rules=../NLCD/Forest_Reclass.txt
fi

if [ $ALLCELLS -eq 1 ]
then
	r.mask NLCD_Changed_2001_2021 --o
	r.stats -1gn input=nlcd_01_21_land_cover_change_first_disturbance_date_20230630,nlcd_2001_2021_land_cover_change_index_l48_20230630,nlcd_2021_land_cover_science_product_l48_20230630.tif>NLCD_Changed_01_21
	
	r.mask NLCD_Forest_1984_2021 --o
	r.stats -1gn input=nlcd_forest_disturbance_date_1984_2021_20230630,nlcd_2021_land_cover_science_product_l48_20230630.tif>NLCD_Changed_forest
fi


if [ $REPORTS -eq 1 ]
then
	r.mask NLCD_Changed_2001_2021 --o
	r.report map=nlcd_2001_2021_land_cover_change_index_l48_20230630,nlcd_01_21_land_cover_change_first_disturbance_date_20230630 -h -n -a units=kilometers output=NLCD_Date_ChangeIndex_report
	awk 'BEGIN { FS="|"; } {print $2","$3","$5}' NLCD_Date_ChangeIndex_report >NLCD_Date_CHangeIndex.csv


	r.report map=nlcd_2001_land_cover_l48_20210604,nlcd_2021_land_cover_science_product_l48_20230630 -h -n -a units=kilometers output=NLCD_2001_2021_Changed


fi
