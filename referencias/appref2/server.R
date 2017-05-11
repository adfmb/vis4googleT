library(shiny)
library(jsonlite)
library(httr)

library(ggplot2)
# Create fake data
DF <- data.frame( Age = rnorm(50, 45, 20), Weight= runif(50, 50 , 200), Circumference =  runif(50, 30 , 100) )  

# Define server logic for random distribution application
shinyServer(function(input, output) {
  
  output$plot <- renderPlot({
  DF$X <- DF[, which(names(DF) == input$X)]
  DF$Y <- DF[, which(names(DF) == input$Y)]   
  ggplot(DF, aes( x= X, y= Y)) + geom_point() + labs(list(x = input$X, y = input$Y))
} )
  
})