## Only run examples in interactive R sessions
if (interactive()) {
  
  ui <- fluidPage(
    sliderInput("n", "Number of observations", 2, 1000, 500),
    verbatimTextOutput("plot")
  )
  
  server <- function(input, output) {
    
    # Anything that calls autoInvalidate will automatically invalidate
    # every 2 seconds.
    autoInvalidate <- reactiveTimer(2000)
    
    output$plot <- renderPrint({
      autoInvalidate()
      numtareas<-read.csv(file = "numtareas.csv",header=T)
      numtareas$numtareas
    })
    
    
    # funnumtareas<-reactive({
    #   numtareas<-read.csv(file = "numtareas.csv",header=T)
    #   numtareas$numtareas
    #   })
    
    
    
    # observe({
    #   # Invalidate and re-execute this reactive expression every time the
    #   # timer fires.
    #   autoInvalidate()
    #   
    #   # Do something each time this is invalidated.
    #   # The isolate() makes this observer _not_ get invalidated and re-executed
    #   # when input$n changes.
    #   print(paste("The value of input$n is", isolate(input$n)))
    # })
    
    # Generate a new histogram each time the timer fires, but not when
    # input$n changes.
    # output$plot <- renderPrint({
    #   autoInvalidate()
    #   numtareas<-read.csv(file = "numtareas.csv",header=T)
    #   numtareas$numtareas
    # })
  }
  
  shinyApp(ui, server)
}