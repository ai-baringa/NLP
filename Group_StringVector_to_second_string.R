# This script takes in two vectors (or columns) from 2 seperate xlsx files. 
# Vector 1: contains strings with spelling errors
# Vector 2: contains the ideal strings with which you want to group Vector 1 into
# And returns a csv VLOOKUP table
# Simply alter the user inputs and the rest is done for you

# User Inputs:
list_with_errors_xlsx = "Site_Messy_Partners_v0.1.xlsx"
list_concise_xlsx = "Distinct_Partner_List_v0.1.xlsx"
working_directory = "Z:/_Phase 2/04_Data/Partnership Data/Useable Excel Docs"

# System Requirements:
install.packages("fuzzyjoin"); install.packages("dplyr"); install.packages("readxl");install.packages("data.table");
library(fuzzyjoin); library(dplyr); library(readxl); library(data.table)

# Set Working Directory and Read in two files as dataframes:
setwd(working_directory)
full_partner = as.data.frame(readxl::read_xlsx(list_with_errors_xlsx))
concise_partner = as.data.frame(readxl::read_xlsx(list_concise_xlsx))

# Only need to work with unique partners (approx 20000)
full_unique_partners = as.data.frame( unique(full_partner$CUSTOMER_NAME))
colnames(full_unique_partners) = "CUSTOMER_NAME"
full_unique_partners$CUSTOMER_NAME = as.character(full_unique_partners$CUSTOMER_NAME)

# Fuzzy join merge concise and partner list
groupd_df = stringdist_join(full_unique_partners, concise_partner, 
                            by = c( "CUSTOMER_NAME"="Distinct_Partners_IncludesAdded" ),
                            mode = "left",
                            ignore_case = TRUE, 
                            method = "jw", 
                            max_dist = 99, 
                            distance_col = "dist") %>%
  group_by(CUSTOMER_NAME) %>%
  top_n(1, -dist)

groupd_df$match = ifelse(groupd_df$dist < 0.2, groupd_df$Distinct_Partners_IncludesAdded, "No match") 
