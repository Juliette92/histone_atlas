#Setting up environment
#Install packages first before loading

library(readxl)
library(pals)
library(pheatmap)
library(ComplexHeatmap)
library(dplyr)

###############################
#Prepare the data for plotting
###############################

#Read data from Excel sheet 2, convert to dataframe
data_for_heatmap <- as.data.frame(read_excel("210629_Heatmap_calculations_all_cell_lines_H3_H4.xlsx", col_names = T, sheet = 2))

#Convert the column Simplified_annotation from character to vector, this preserves the plotting order as it was in the Excel file
data_for_heatmap$Simplified_annotation <- factor(data_for_heatmap$Simplified_annotation, levels=unique(data_for_heatmap$Simplified_annotation))

#Summarize rows by summing up all values if the column Simplified_annotation is the same
data_for_heatmap <- data_for_heatmap %>% group_by(Simplified_annotation) %>% summarise(across(everything(), list(sum)))

#Convert back to dataframe
data_for_heatmap <- as.data.frame(data_for_heatmap)

#Adjust column names to remove the trailing "_1" added when summarizing the data
colnames(data_for_heatmap) <- sub("_1", "", colnames(data_for_heatmap))

#Use the first column (Simplified_annotation) as rownames of data frame
rownames(data_for_heatmap) <- data_for_heatmap[,1]

#Remove the first column from the dataframe, only numeric values (values to plot) remain
data_for_heatmap <- data_for_heatmap[,-1]




###############################
#Plot heatmap
###############################

#option cluster_rows=F: no dendrogram on rows
png("heatmap_histones.png", height=1200, width=800)
Heatmap(data_for_heatmap,cluster_rows = F,column_dend_height = unit(30, "mm") )
dev.off()



