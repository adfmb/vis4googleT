shinyUI(fluidPage(
  titlePanel("Shiny Viz!"),
  
  fluidRow( class= "R1",
            tabsetPanel(type= "pills",
                        
            ####################################
            ############ PANEL 1 ###############
            ####################################
                        tabPanel("Controls",
                                 fluidRow(column(4, offset=1, selectInput("X", label="x var", 
                                                                          choices = list("Age" = "Age", "Weight" = "Weight", "Circumference" = "Circumference"),
                                                                          multiple=F) ),
                                          column(4,selectInput("Y", label="y var", 
                                                               choices = list("Age" = "Age", "Weight" = "Weight", "Circumference" = "Circumference"),
                                                               multiple=F))) ,
                                 fluidRow(column(5, offset=1, plotOutput("plot", height = "400px") ),
                                          column(5, class= "R2C2", helpText("This is an exemple") ) ) ),
            
            ####################################
            ############ PANEL 2 ###############
            ####################################
                        tabPanel("output_at_some_point",
                                 div(style = "height:800px; background-color: yellow;", "This is an example")))  
            
  ), tags$head(tags$style(".R2C2{height:250px; background-color: red;}
                      .R1{background-color: lightgray;}"))
)
)



