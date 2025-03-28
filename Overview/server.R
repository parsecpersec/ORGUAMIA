library(shinydashboard)
library(shinycssloaders)
library(shiny)
library(ggplot2)
library(reactable)

dat1 = read.csv('../index/data/metadata.csv')
dat2 = read.csv('../index/data/Merged.csv')
GEO_id = 'GSE116130-B'
Merged_id = 'Proj-1'
GEO_prefix = 'https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc='

shinyServer(function(input, output, session) {
  
  observe({
    URLvars = session$clientData$url_search
    ID = sub('^.*ID=', '\\1', URLvars)
    if(grepl('Proj-', ID)) {updateTabsetPanel(session, 'choose_datasets', 'Merged')}
  })
  
  output$selectbox = renderUI({
    URLvars = session$clientData$url_search
    ID = sub('^.*ID=', '\\1', URLvars)
    
    selectInput('sets', label=h3('Dataset Info'),
                choices=dat1$Dataset_ID, multiple=F,
                selected=ifelse(ID=='', GEO_id, ID))
  })
  output$info = renderUI({
    ID = input$sets
    
    card(p(paste0('Organ: ', dat1$Organ[dat1$Dataset_ID==ID])),
         p(paste0('Disease: ', dat1$Status[dat1$Dataset_ID==ID])),
         p('Original Site: ', tags$a(href=paste0(GEO_prefix,
                                                 ID),
                                     ID)),
         p(''),
         p('View Cell Atlas: ',
           tags$a(href=paste0('../shinyCell/', ID, '/a1_cell/'), target='_blank', 
                  "All Cells")),
         # p('View Cell Atlas: ',
         #   tags$a(href=paste0('../shinyCell/', ID, '/a2_myeloid/'), target='_blank', 
         #          "Myeloid Cells")),
         # p('View Cell Atlas: ',
         #   tags$a(href=paste0('../shinyCell/', ID, '/a3_macro/'), target='_blank', 
         #          "Macrophages")),
         # p('View Cell Atlas: ',
         #   tags$a(href=paste0('../shinyCell/', ID, '/a4_trem1/'), target='_blank', 
         #          "TREM1+ Macrophages"))
         p('View Cell Communication: ',
           tags$a(href='../CellChat', target='_blank',
                  "CellChat")),
         p('View Trajectory: ',
           tags$a(href='../Monocle', target='_blank',
                  "Pseudotime")),
         p('View GSVA: ',
           tags$a(href='../GSVA', target='_blank',
                  "GSVA"))
        )
  })
  observe({
    ID = input$sets
    output$sample = renderReactable(
      reactable(
        read.csv(paste0('./data/pheno/', substr(ID, 1, 9), '.csv')),
        defaultColDef = colDef(
          align = 'center',
          headerStyle = list(background='#2D89C8',
                             color='white')
        ),
        bordered = T,
        highlight = T,
        searchable = T,
        filterable = F,
        defaultPageSize = 10,
        pageSizeOptions = c(10,20,30,40,50),
        showPageSizeOptions = T,
        paginationType = 'jump',
        wrap = F,
        resizable = T,
        fullWidth = T
      )
    )
    
  })
  
  
  output$selectbox_merged = renderUI({
    URLvars = session$clientData$url_search
    updateTabItems(session, 'panels', 'Merged')
    ID = sub('^.*ID=', '\\1', URLvars)
    
    selectInput('sets_merged', label=h3('Dataset Info'),
                choices=dat2$Project, multiple=F,
                selected=ifelse(ID=='', Merged_id, ID))
  })
  
  output$info_merged = renderUI({
    ID = input$sets_merged
    
    card(p(paste0('Organ: ', dat2$Organ[dat2$Project==ID])),
         p(paste0('Disease: ', dat2$Disease[dat2$Project==ID])),
         # p('Original Site: ', tags$a(href=paste0(GEO_prefix,
         #                                         ID),
         #                             ID)),
         p(''),
         p('View Cell Atlas: ',
           tags$a(href=paste0('../shinyCell/', ID, '/a1_cell/'), target='_blank', 
                  "All Cells")),
         p('View Cell Atlas: ',
           tags$a(href=paste0('../shinyCell/', ID, '/a2_myeloid/'), target='_blank', 
                  "Myeloid Cells")),
         p('View Cell Atlas: ',
           tags$a(href=paste0('../shinyCell/', ID, '/a3_macro/'), target='_blank', 
                  "Macrophages")),
         p('View Cell Atlas: ',
           tags$a(href=paste0('../shinyCell/', ID, '/a4_trem1/'), target='_blank', 
                  "TREM1+ Macrophages")),
         p('View Cell Communication: ',
           tags$a(href=paste0('../cellchat?ID=', ID), target='_blank',
                  "CellChat")),
         p('View Trajectory: ',
           tags$a(href='./', target='_blank',
                  "Pseudotime")),
         p('View GSVA: ',
           tags$a(href='./', target='_blank',
                  "GSVA")))
  })
  
  observe({
    ID = input$sets_merged
    output$sample_merged = renderReactable(
      reactable(
        read.csv(paste0('./data/pheno_merged/', gsub('-','',ID), '.csv')),
        defaultColDef = colDef(
          align = 'center',
          headerStyle = list(background='#2D89C8',
                             color='white')
        ),
        bordered = T,
        highlight = T,
        searchable = T,
        filterable = F,
        defaultPageSize = 10,
        pageSizeOptions = c(10,20,30,40,50),
        showPageSizeOptions = T,
        paginationType = 'jump',
        wrap = F,
        resizable = T,
        fullWidth = T
      )
    )
    
  })
  
  
})