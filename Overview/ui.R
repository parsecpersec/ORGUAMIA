library(shinydashboard)
library(shinycssloaders)
library(shiny)
library(ggplot2)
library(reactable)
library(bslib)

GEO_prefix = 'https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc='
GEO_id = 'GSE164241'
dat1 = read.csv('../index/data/metadata.csv')
dat2 = read.csv('../index/data/Merged.csv')
copyright = 'Copyright © 2024 OMDM'

shinyUI(page_navbar(
  title='ORGUAMIA',
  bg='#2D89C8',
  id='choose_datasets',
  inverse=T,
  #underline=T,
  tags$head(tags$style(HTML('* {font-family: "Arial"};'))),
  nav_panel(title = 'Separate',
            withSpinner(htmlOutput('selectbox'), color='#2D89C8', type=8),
            withSpinner(reactableOutput('sample'), color='#2D89C8', type=8),
            withSpinner(htmlOutput('info'), color='#2D89C8', type=8)
            ),
  nav_panel(title = 'Merged',
            withSpinner(htmlOutput('selectbox_merged'), color='#2D89C8', type=8),
            withSpinner(reactableOutput('sample_merged'), color='#2D89C8', type=8),
            withSpinner(htmlOutput('info_merged'), color='#2D89C8', type=8)),
  nav_spacer(),
))