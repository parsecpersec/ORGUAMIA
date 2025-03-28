library(shinydashboard)
library(shinycssloaders)
library(shiny)
library(ggplot2)
library(reactable)
library(bslib)

meta = read.csv('data/metadata.csv')
n_set = nrow(meta)
n_sample = sum(meta$N)
n_cell = sum(meta$N_Cell)
copyright = 'Copyright © 2024 OMDM'
footer_style = 'bottom:0;
font-size:100%;
color:white;
padding:15px;
position:fixed'

shinyUI(
  dashboardPage(
    skin='blue',
    dashboardHeader(title='ORGUAMIA'),
    dashboardSidebar(
      sidebarMenu(
        menuItem('Home', tabName = 'home', icon = icon('house')),
        menuItem('Browse diseases', tabName = 'browse', icon = icon('folder-open')),
        menuItem('Search datasets', tabName = 'search', icon = icon('magnifying-glass')),
        menuItem('How to use', tabName = 'help', icon = icon('circle-question')),
        menuItem('About us', tabName = 'info', icon = icon('circle-info')),
        tags$footer(copyright, style=footer_style)
      )
    ),
    
    dashboardBody(
      tags$head(tags$style(HTML('* {font-family: "Arial"}
                                h2 {font-family: "Arial"}
                                h4 {font-family: "Arial"}
                                .content {background-color:#FFFFFF}
                                .content-wrapper {background-color:#FFFFFF}
                                .skin-blue .main-header .logo {background-color:#2D89C8}
                                .skin-blue .main-header .logo:hover {background-color:#2D89C8}
                                .skin-blue .main-header .navbar {background-color:#2D89C8}'))),
      tabItems(
        tabItem(
          tabName = 'home',
          h2('Welcome to ORGUAMIA Database'),
          h4('ORGUAMIA is short for "oral-gut axis mucosal immune atlas". 
          The database provides a comprehesive mucosal immune cell and gene data from the
          digestive tract at single-cell level, facilitating research into the 
          landscape of mucosal immune within these crucial organs and systems.'),
          # div(img(src='img.png')),
          p(''),
          fluidRow(column(width=4,
                          withSpinner(plotOutput('plot1'), color='#605CA8', type=8)),
                   column(width=4,
                          withSpinner(plotOutput('plot2'), color='#3D9970', type=8)),
                   column(width=4,
                          withSpinner(plotOutput('plot3'), color='#3C8DBC', type=8))
          ),
          p(''),
          tags$head(tags$style(HTML('.small-box .icon-large {right: 20px; bottom: 0px}'))),
          fluidRow(
            valueBox(value=n_set, subtitle='Datasets',
                     icon=icon(name='laptop-medical'),
                     color='purple'),
            valueBox(value=n_sample, subtitle='Samples',
                     icon=icon(name='flask'),
                     color='olive'),
            valueBox(value=n_cell, subtitle='Cells',
                     icon=icon(name='disease'),
                     color='light-blue'),
          ),
        ),
        
        tabItem(tabName = 'browse',
                withSpinner(reactableOutput('table_merged'), color='#2D89C8', type=8)),
        
        tabItem(tabName = 'search',
                withSpinner(reactableOutput('table'), color='#2D89C8', type=8)),
        
        tabItem(tabName = 'help',
                h3('Working in Progress...')),
        
        tabItem(tabName = 'info',
                h3('About Our Site'),
                h5('Contact: email@example.com'),
                p(''),
                h5('Related paper: '),
                p(''),
                # h3('Privacy Policy'),
                # h5('txt'),
                # p(''),
                h3('Acknowledgements'),
                h5(tags$a(href='https://shiny.posit.co', 'Shiny'), ', ',
                   tags$a(href='https://github.com/SGDDNB/ShinyCell', 'ShinyCell'), ', ',
                   tags$a(href='https://github.com/sqjin/CellChatShiny', 
                          'CellChatShiny'), ', ',
                   tags$a(href='https://github.com/elliefewings/monocle3_shiny', 
                          'monocle3_shiny'), ', ',
                   tags$a(href='https://github.com/guokai8/scGSVA',
                          'scGSVA')
                   )
                
                
                )
        
      ),
    ),
    
  )
)
