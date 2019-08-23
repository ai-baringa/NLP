# The following code can be used to group text 
# where there are spelling errors or different naming conventions
# e.g "Kelly Gosen" vs. "Kelly Lee Goosen"
# user inputs a vector with spelling errors in the form of a csv file
# Cleaned vector results are written to csv (alongside original vector and match similarity)
###################################################################################

# Declare Working Directory, csv file and which column to find text strings
working_directory = "Z:/_Phase 2/04_Data/Partnership Data"
dataframe = "Partnership Data Partner and IDv02.csv"
col_index = 1

# Precision parameter: 
# the smaller the more similar the text strings need to be to be grouped
precision_select = 4
###################################################################################

# System Requirements
install.packages("sjmisc")
install.packages("stringdist")
install.packages("stringr")

library(sjmisc)
library(stringdist)
library(stringr)
###################################################################################

# Set working directory and source in data
setwd(working_directory)
df = read.csv(dataframe, header = T)
unique_partners = unique(df[,col_index])
###################################################################################

# Function to group strings in a vector
newstring = group_str(unique_partners, precision = precision_select, strict = FALSE,
                      trim.whitespace = TRUE, remove.empty = FALSE, verbose = FALSE)

# Extract group names
group_header = c()
for (i in 1:length(newstring)){
  group_header[i] = word(newstring[[i]],1,sep = ",")
}
group_header_Df = data.frame(Partnership = group_header)
###################################################################################

# Write to csv
Grouped_Partners = cbind(unique_partners, group_header_Df)
colnames(Grouped_Partners) = c("Original Partners", "Grouped Partners")
coln_df = colnames(df) 
full_partner_map = merge(df, Grouped_Partners, by.x = coln_df[1], by.y = "Original Partners", all.x = TRUE)

write.csv(Grouped_Partners, file = "Grouped Partnership Datav01_Precision4.csv")
###################################################################################

