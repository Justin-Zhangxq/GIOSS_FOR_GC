# GIOSS-based Survival Calculator in Aged Gastric Cancer

## Project Description

This project develops and validates a machine learning model to predict 5-year overall survival in elderly gastric cancer patients after curative surgery. The model incorporates a novel GC-Integrated Oxidative Stress Score (GIOSS) along with clinical and pathological factors.

## Availability of Data and Materials

Data will be accessible beginning with the publication of the article. Data can be requested by contacting Huang CM, who had full access to all the data in the study and takes responsibility for the integrity and accuracy of the data analysis. Requests for data sharing will be handled in accordance with the data access and sharing policy of Fujian Medical University Union Hospital. Researchers interested in accessing the data should email Huang CM at anelzxq@126.com with a detailed proposal of their intended use. Access will be granted upon approval of the proposal and the signing of a data access agreement.

## Software Information

- **Project name**: GIOSS-based Survival Calculator in Aged Gastric Cancer
- **Project home page**: https://fmuuh.shinyapps.io/GIOSS-based_Survival_Calculator_in_Aged_GC/
- **Operating system(s)**: Platform independent
- **Programming language**: R
- **R version**: R version 4.4.1 (2024-06-14 ucrt)
- **Other requirements**: 
  - tidymodels (version 1.2.0)
  - ggplot2 (version 3.5.1)
  - dplyr (version 1.1.4)
  - survival (version 3.7-0)
  - xgboost (version 1.7.8.1)
- **License**: MIT License
- **Any restrictions to use by non-academics**: This project is not permitted for non-academic use.

## Installation

To set up the environment and install the required packages, run the following commands in R:

```r
install.packages(c("tidymodels", "ggplot2", "dplyr", "survival", "xgboost"))
```

## Usage

1. Clone this repository to your local machine.
2. Ensure you have R installed (version 4.4.1 or later).
3. Install the required packages as described in the Installation section.
4. Run the main script (main_analysis.R) to reproduce the analysis.
5. To use the web-based calculator, visit https://fmuuh.shinyapps.io/GIOSS-based_Survival_Calculator_in_Aged_GC/

For detailed instructions on using the code or interpreting results, please refer to the comments within the R scripts.

## Citation

If you use this model or data in your research, please cite:

Zhang XQ, Huang ZN, Wu J, et al. Development and validation of a prognostic prediction model for elderly gastric cancer patients based on oxidative stress biochemical markers. 

## Contact

For questions or collaboration requests, please contact:

Chang-Ming Huang, MD, FACS
Department of Gastric Surgery, Fujian Medical University Union Hospital
No.29 Xinquan Road, Fuzhou, 350001, Fujian Province, China
Email: angelzxq@126.com

## Acknowledgments

This study was supported by the Joint Funds for the Innovation of Science and Technology, Fujian Province (No. 2023Y9208), the Natural Science Foundation of Fujian Province (No. 2023J01674), and the Construction Funds for "High-level Hospitals and Clinical Specialties" of Fujian Province (No. [2021]76).
