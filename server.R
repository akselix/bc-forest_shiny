# server.R
# 2015-06-06
# Shiny app for British Columbia Forest Balance

# Set common options and libraries
library(datasets)
library(ggplot2)
library(dplyr)
options(scipen = 999)

# Setting up the data

# Description of data:
# http://catalogue.data.gov.bc.ca/dataset/trends-in-forest-disturbances-and-reforestation
# Original dataset can be loaded from:
# http://pub.data.gov.bc.ca/datasets/179624/disturbances_and_reforestation.csv

# Read in file
bc_df <- read.csv('data/disturbances_and_reforestation.csv', stringsAsFactors = F)

# Transform data
bc <- tbl_df(bc_df)
bc <- bc %>%
    mutate(Hectares = ifelse(bc$Category == 'Disturbances', bc$Hectares * -1, bc$Hectares)) %>%
    arrange(Fiscal_Year)

# Change column data types
bc$Fiscal_Year <- as.integer(substr(bc$Fiscal_Year, 1,4))

# Set up Shiny Server
shinyServer(
    function(input, output) {
        
# Select data from wanted years based on slider input
        bcSelected <- reactive({
                        filter(bc, Fiscal_Year >= min(input$slifi) & Fiscal_Year <= max(input$slifi))
        })
# Create the plot       
        output$yearPlot <- renderPlot({
            ggplot(data = bcSelected(), aes(x = Fiscal_Year, weight = Hectares)) +
            geom_bar(stat = 'bin', binwidth = 0.5, fill = 'darkgreen') +
            theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
            labs(x = 'Fiscal Years', y = 'Hectares')
        })
    }
)
    