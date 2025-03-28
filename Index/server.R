library(shinydashboard)
library(shiny)
library(ggplot2)
library(reactable)
# addResourcePath(prefix = 'shinyCell', directoryPath = '/media/dell/fa619c3b-8515-415a-8a1c-3caa41b2c5cd/XH/PJK/sc-database/shinyCell/')

options(scipen = 999)
cols = c('#34D622', '#58A3E4', '#F6D209', '#EE6798', '#A597FF')
levs = c('Mouth', 'Esophagus', 'Stomach', 'Gut', 'Anus')

shinyServer(function(input, output, session) {
  observe({
    x <- input$Dataset_ID
    output$table <- renderReactable({
      reactable(
        read.csv('data/metadata.csv'),
        defaultColDef = colDef(
          align = 'center',
          headerStyle = list(background='#2D89C8',
                             color='white')
        ),
        columns = list(
          Link = colDef(cell = function(x) {
            url = paste0('../overview?ID=', gsub('View: ', '', x))
            htmltools::tags$a(href=as.character(url),
                              target='_blank',
                              as.character(substr(x, 1, 4)))
          }),
          GEO_ID = colDef(name = 'GEO ID'),
          Dataset_ID = colDef(name = 'Dataset ID'),
          N = colDef(name = 'Included samples'),
          Status = colDef(name = 'Disease type'),
          Source = colDef(name = 'Sample origin'),
          N_Cell = colDef(show = F),
          N_Set = colDef(show = F),
          Note_invis = colDef(show = F)
        ),
        bordered = T,
        highlight = T,
        searchable = T,
        filterable = F,
        defaultPageSize = 10,
        pageSizeOptions = c(10,20,30,40,50),
        showPageSizeOptions = T,
        paginationType = 'jump',
      )
    })
    output$table_merged <- renderReactable({
      reactable(
        read.csv('data/Merged.csv'),
        defaultColDef = colDef(
          align = 'center',
          headerStyle = list(background='#2D89C8',
                             color='white')
        ),
        columns = list(
          Link = colDef(cell = function(x) {
            url = paste0('../overview?ID=', gsub('View: ', '', x))
            htmltools::tags$a(href=as.character(url),
                              target='_blank',
                              as.character(substr(x, 1, 4)))
          }),
          N_Sets = colDef(name = 'Included datasets'),
          N_Samples = colDef(name = 'Included samples')
        ),
        bordered = T,
        highlight = T,
        searchable = T,
        filterable = F,
        defaultPageSize = 10,
        pageSizeOptions = c(10),
        showPageSizeOptions = T,
        paginationType = 'jump',
      )
    })
    output$plot1 <- renderCachedPlot({
      ggplot(
        aggregate(read.csv('data/metadata.csv')$GEO_ID,
                  by=list(read.csv('data/metadata.csv')$Organ),
                  FUN=length),
        aes(x=Group.1, y=x, color=Group.1, fill=Group.1)) + 
        geom_point(size=3.5, shape=21, stroke=1.5) +
        geom_segment(aes(x=Group.1, xend=Group.1, y=0, yend=x),
                     size=1.5) +
        ylab('Datasets') + xlab('') +
        theme_classic() +
        theme(plot.background = element_rect(fill='white', color='transparent'),
              panel.background = element_rect(fill='white'),
              legend.background = element_rect(fill='white'),
              panel.grid = element_blank(),
              text = element_text(family = 'arial'),
              axis.text.x = element_text(angle = 45, hjust = 1),
              legend.position = 'none') +
        scale_color_manual(values = cols) +
        scale_fill_manual(values = cols) +
        scale_x_discrete(limits=levs)
    }, res = 120, bg='white', execOnResize = T,
    cacheKeyExpr = {})
    output$plot2 <- renderCachedPlot({
      ggplot(
        aggregate(read.csv('data/metadata.csv')$N,
                  by=list(read.csv('data/metadata.csv')$Organ),
                  FUN=sum),
        aes(x=Group.1, y=x, color=Group.1, fill=Group.1)) + 
        geom_point(size=3.5, shape=21, stroke=1.5) +
        geom_segment(aes(x=Group.1, xend=Group.1, y=0, yend=x),
                     size=1.5) +
        ylab('Samples') + xlab('') +
        theme_classic() +
        theme(plot.background = element_rect(fill='white', color='transparent'),
              panel.background = element_rect(fill='white'),
              legend.background = element_rect(fill='white'),
              panel.grid = element_blank(),
              text = element_text(family = 'arial'),
              axis.text.x = element_text(angle = 45, hjust = 1),
              legend.position = 'none') +
        scale_color_manual(values = cols) +
        scale_fill_manual(values = cols) +
        scale_x_discrete(limits=levs)
    }, res = 120, bg='white', execOnResize = T,
    cacheKeyExpr = {})
    output$plot3 <- renderCachedPlot({
      ggplot(
        aggregate(read.csv('data/metadata.csv')$N_Cell,
                  by=list(read.csv('data/metadata.csv')$Organ),
                  FUN=sum),
        aes(x=Group.1, y=x, color=Group.1, fill=Group.1)) + 
        geom_point(size=3.5, shape=21, stroke=1.5) +
        geom_segment(aes(x=Group.1, xend=Group.1, y=0, yend=x),
                     size=1.5) +
        ylab('Cells') + xlab('') +
        theme_classic() +
        theme(plot.background = element_rect(fill='white', color='transparent'),
              panel.background = element_rect(fill='white'),
              legend.background = element_rect(fill='white'),
              panel.grid = element_blank(),
              text = element_text(family = 'arial'),
              axis.text.x = element_text(angle = 45, hjust = 1),
              legend.position = 'none') +
        scale_color_manual(values = cols) +
        scale_fill_manual(values = cols) +
        scale_x_discrete(limits=levs) +
        scale_y_continuous(labels=scales::comma)
    }, res = 120, bg='white', execOnResize = T,
    cacheKeyExpr = {})
  })
})