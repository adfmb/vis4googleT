library(shiny)

# Define UI for random distribution application 
shinyUI(fluidPage(theme = "background.css",
  
  # # Application title
  # titlePanel("Shiny + Flask + Postgresql"),
  # 
  # mainPanel(tableOutput("tbl_completa"),
  #             tableOutput("renglon_i"))
  
  
  tags$head(tags$style(HTML("
    .shiny-text-output {
                            background-color:#fff;
                            }
                            "))),
  
  #strong("Autómata: Cálculo de probabilidades de que cierto estado del proceso suceda")
  h1("Go Google Yourself",#,span("Cálculo de probabilidades de que un insaculado llegue a cierto estado del proceso en la primera y segunda etapa", style = "font-weight: 300"), 
     style = "font-family: 'Source Sans Pro';
     color: #fff; text-align: center;
     background-image: url('texturebg.png');
     padding: 20px"),
  
  br(),
  fluidRow( class= "R1",
            tabsetPanel(type= "pills",
                        
                    ####################################
                    ############ PANEL 1 ###############
                    ####################################
                    tabPanel("INPUT",
  
                        fluidRow(
                          # column(8, offset = 3,
                          #        img(src="logo-map-maker.png", height = 300, width = 550)
                          # )
                        ),

                        br()
                    ),
                    
                    ####################################
                    ############ PANEL 2 ###############
                    ####################################
                    tabPanel("output_at_some_point",
                             div(style = "height:800px; background-color: yellow;", "This is an example")))
  )
  
  )
)


