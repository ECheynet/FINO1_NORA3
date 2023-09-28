# Dataset for NEWA and NORA3 Wind Atlas Analysis at FINO1
[![View Dataset for NEWA and NORA3 Wind Atlas Analysis at FINO1 on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://se.mathworks.com/matlabcentral/fileexchange/135877-dataset-for-newa-and-nora3-wind-atlas-analysis-at-fino1)
[![DOI](https://zenodo.org/badge/686340152.svg)](https://zenodo.org/badge/latestdoi/686340152)


## Summary
This repository hosts the Matlab code to reproduce primary figures from the research article titled "A One-Year Comparison of New Wind Atlases over the North Sea"[1]. The paper focuses on a comparative analysis of the New European Wind Atlas (NEWA) and the Norwegian hindcast archive (NORA3) database with in-situ measurements. Both NORA3 and NEWA have emerged as potential tools for wind energy applications. The analysis relies on data recorded in 2009 at the FINO1 platform in the North Sea. The repository's code helps to visualize the findings and emphasises the differences between NEWA and NORA3, supplemented by an additional dataset from ERA5.

## Repository Structure
- **functions**: A directory containing essential functions utilized within `Documentation.mlx`.
- **data_Cheynet2022.mat**: Hosts post-processed  data from NORA3, NEWA, ERA5 and measurements from the FINO1 offshore mast.
- **SST_FINO1_2009.mat**: Contains post-processed SST data derived from remote sensing measurements and buoys (BSH)
- **Documentation.mlx**: A Matlab LiveScript that details data usage and facilitates the recreation of some paper figures[1].

> **Note**: This is the preliminary version of this repository, and some bugs might still persist. Feedback and issue reporting are encouraged. Note that the time in the dataset is also provided as datenum for those who want to use the dataset in Python

## Figures from the Paper [1]
1. **Figure 2**: Hourly mean wind speed at 51 m (left) and 101 m (right) estimated by NORA3 and NEWA versus the measurements from the FINO1 platform. Each data point stands for one hour, spanning from 2009-01-01 to 2009-12-31.
2. **Figure 3**: Distributions of mean wind speed at 100 m asl in 2009, contrasting data from FINO1 platform, NORA3, NEWA, and ERA5.
3. **Figure 4**: Probability density function of the mean wind direction at 62 m asl (left) and 91 m asl (right) during 2009 at FINO1, compared against data from NEWA and NORA3. The inclusion of ERA5 data serves as a reference.
4. **Figure 5**: Absolute air temperature comparisons at 101 m asl on the FINO1 platform against NORA3 and NEWA datasets.
5. **Figure 6**: Probability density function of the Brunt-Väisälä frequency, derived from the potential air temperature at approximately 100 m asl and the sea-surface temperature.

## References
[1] Cheynet, E., Solbrekke, I. M., Diezel, J. M., & Reuder, J. (2022, November). A one-year comparison of new wind atlases over the North Sea. In Journal of Physics: Conference Series (Vol. 2362, No. 1, p. 012009). IOP Publishing.

## Feedback & Contributions
Should you encounter bugs, wish to suggest enhancements, or contribute, please create an issue or submit a pull request. You can also comment directly on Matlab File Exchange.

