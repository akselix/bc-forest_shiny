# 2015-06-04
# Shiny app for showing US 2010 consensus info
# ui.R

# Set common options and libraries
library(datasets)
library(ggplot2)
library(dplyr)
options(scipen = 999)

# Read in file
bc_df <- read.csv('data/disturbances_and_reforestation.csv', stringsAsFactors = F)

# Transform data
bc <- tbl_df(bc_df)
bc <- bc %>%
    mutate(Hectares = ifelse(bc$Category == 'Disturbances', bc$Hectares * -1, bc$Hectares)) %>%
    arrange(Fiscal_Year)

# Change column data types
bc$Fiscal_Year <- as.integer(substr(bc$Fiscal_Year, 1,4))

# Texts for the UI

sideBarText <- "You can use the slider to select a range of fiscal years for the plot."
mainText <- "In the above graph the forest balance of British Columbia is shown with yearly re- and de -forestation sums. Explanation of the data can be found from: from http://catalogue.data.gov.bc.ca/dataset/trends-in-forest-disturbances-and-reforestation"

# ui.R

shinyUI(fluidPage(
    titlePanel("British Columbia Forest Balance"),
    
    sidebarLayout(
        sidebarPanel(
            helpText(sideBarText),
           
            sliderInput('slifi', 
                    label = 'Fiscal Year(s)',
                    min = min(bc$Fiscal_Year), max = max(bc$Fiscal_Year), 
                    value = c(min(bc$Fiscal_Year), max = max(bc$Fiscal_Year)),
                    sep = '',
                    round = T,
                    step = 1
                    )
        ),
        
        mainPanel(plotOutput('yearPlot'),
                  p(mainText))
        )
    )
)