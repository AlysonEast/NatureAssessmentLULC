# NatureAssessmentLULC

Land-use / land-cover (LULC) change analysis pipeline for the United by Nature conservation initiative. This project processes national land-cover raster datasets to quantify how land cover in the U.S. (including Hawaii) has shifted over time — tracking transitions like forest loss, cropland expansion, and urban development.

## What it does

The pipeline runs in two stages:

1. **Raster processing (GRASS GIS)** — Imports NLCD and LCMAP raster tiles, reclassifies change/disturbance layers, and generates tabular area reports (in square miles/kilometers) summarizing land-cover class transitions between time periods.
2. **Analysis & visualization (R)** — Reads the generated reports, cleans and recodes land-cover categories into readable labels (Developed, Cropland, Grass/Shrub, Forest, Water, Wetland, Barren), and produces:
   - **Sankey diagrams** showing how land cover flows from one class to another over time
   - **Bar charts** showing area changed by year and change type

## Datasets covered

| Script | Data source | Coverage | Period |
|---|---|---|---|
| `NLCD.sh` / `NLCD.R` | [NLCD](https://www.mrlc.gov/data) (National Land Cover Database) | CONUS | 2001–2021 |
| `LCMAP.sh` / `LCMAP.R` | [LCMAP](https://www.usgs.gov/special-topics/lcmap) (Land Change Monitoring, Assessment, and Projection) | CONUS | 1985–2021 |
| `LCMAP.sh` / `LCMAP_HI.R` | LCMAP | Hawaii | 2000–2020 |

## Repository contents

```
NatureAssessmentLULC/
├── NLCD.sh                              # GRASS GIS: import + reclass NLCD rasters, generate change reports
├── NLCD.R                               # R: visualize NLCD change (bar charts, Sankey diagram)
├── LCMAP.sh                              # GRASS GIS: import + reclass LCMAP rasters (CONUS + HI), generate reports
├── LCMAP.R                               # R: visualize LCMAP CONUS change (Sankey diagram)
├── LCMAP_HI.R                            # R: visualize LCMAP Hawaii change (Sankey diagram)
├── NLCD_Date_ChangeIndex_report.tsv      # Raw GRASS r.report output: NLCD change by date/index
├── LCMAP_1985to2021_report.tsv           # Raw GRASS r.report output: LCMAP land cover 1985 vs 2021
├── LCMAPChanged_1985to2021_report.tsv    # Raw GRASS r.report output: LCMAP change areas 1985–2021
└── LCMAP_HI_2000to2020_report.tsv        # Raw GRASS r.report output: LCMAP Hawaii 2000 vs 2020
```

## Requirements

- [GRASS GIS](https://grass.osgeo.org/) (tested with GRASS 8) with a configured location/mapset
- R with the following packages: `networkD3`, `dplyr`, `ggplot2`, `ggpubr`, `tidyverse`
- Source raster tiles from [MRLC](https://www.mrlc.gov/data) (NLCD) and [USGS LCMAP](https://www.usgs.gov/special-topics/lcmap)

## Data sources & attribution

This project uses publicly available land-cover data from:

- **NLCD (National Land Cover Database)** — U.S. Geological Survey and Multi-Resolution Land Characteristics (MRLC) Consortium. https://www.mrlc.gov/data
- **LCMAP (Land Change Monitoring, Assessment, and Projection)** — U.S. Geological Survey. https://www.usgs.gov/special-topics/lcmap

Please consult the USGS/MRLC data usage policies for citation requirements when reusing outputs derived from these datasets.

## About

Part of the [The National Assessment by the Nature Record](https://naturerecord.org/) initiative for Chapter 8: Status, Trends, and Future Projections of Terrestrial Ecosystems in the US.
