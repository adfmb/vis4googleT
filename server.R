# require(shiny)
library(shiny)
library(shinydashboard)
options(shiny.maxRequestSize=500*1024^2) 



# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  
  mvzip<-eventReactive(input$file1,{
    system(paste("mv ",print(input$file1$datapath)," /tmp/todo_googlet.zip",sep=""))
    system("./tasks/unzip_mv.sh")
    system("python tasks/agrupar_busquedas.py")
    system("python tasks/ups/up_todos_mails.py")
    system("python tasks/ups/up_todas_ubicaciones.py")
    system("python tasks/ups/up_todas_busquedas.py")
  })
  
  observe({ mvzip() })
  
  autoInvalidate <- reactiveTimer(2000)

  x1<-0
  progress1 <- reactive({
    print(paste("antes de empezar x1 vale: ",x1,sep=""))
    autoInvalidate()
    if(x1==0){
      
      y<-indicador_unzip(x1)
      x1<<-y
      print(paste("Dentro del if, x1 vale: ",x1,sep=""))
      print(x1)
      
    }else{
      print(paste("Sin leer el archivo, x1 vale: ",x1,sep=""))
      print(x1)
    }
  })
  
  x2<-0
  progress2 <- reactive({
    print(paste("antes de empezar x2 vale: ",x2,sep=""))
    autoInvalidate()
    if(x2==0){
      
      y<-indicador_agruparbusquedas(x2)
      x2<<-y
      print(paste("Dentro del if, x2 vale: ",x2,sep=""))
      print(x2)
      
    }else{
      print(paste("Sin leer el archivo, x2 vale: ",x2,sep=""))
      print(x2)
    }
  })
  
  x3<-0
  progress3 <- reactive({
    print(paste("antes de empezar x3 vale: ",x3,sep=""))
    autoInvalidate()
    if(x3==0){
      
      y<-indicador_uptodasbusquedas(x3)
      x3<<-y
      print(paste("Dentro del if, x3 vale: ",x3,sep=""))
      print(x3)
      
    }else{
      print(paste("Sin leer el archivo, x3 vale: ",x3,sep=""))
      print(x3)
    }
  })
  
  x4<-0
  progress4 <- reactive({
    print(paste("antes de empezar x4 vale: ",x4,sep=""))
    autoInvalidate()
    if(x4==0){
      
      y<-indicador_uptodasubicaciones(x4)
      x4<<-y
      print(paste("Dentro del if, x4 vale: ",x4,sep=""))
      print(x4)
      
    }else{
      print(paste("Sin leer el archivo, x4 vale: ",x4,sep=""))
      print(x4)
    }
  })
  
  x5<-0
  progress5 <- reactive({
    print(paste("antes de empezar x5 vale: ",x5,sep=""))
    autoInvalidate()
    if(x5==0){
      
      y<-indicador_uptodosmails(x5)
      x5<<-y
      print(paste("Dentro del if, x5 vale: ",x5,sep=""))
      print(x5)
      
    }else{
      print(paste("Sin leer el archivo, x1 vale: ",x1,sep=""))
      print(x1)
    }
  })
  
  x6<-0
  progress6 <- reactive({
    print(paste("antes de empezar x6 vale: ",x6,sep=""))
    autoInvalidate()
    if(x6==0){
      
      y<-indicador_preprocbusquedas_fin(x6)
      x6<<-y
      print(paste("Dentro del if, x6 vale: ",x6,sep=""))
      print(x6)
      
    }else{
      print(paste("Sin leer el archivo, x6 vale: ",x6,sep=""))
      print(x6)
    }
  })
  
  x7<-0
  progress7 <- reactive({
    print(paste("antes de empezar x7 vale: ",x7,sep=""))
    autoInvalidate()
    if(x7==0){
      
      y<-indicador_preprocubicaciones_fin(x7)
      x7<<-y
      print(paste("Dentro del if, x7 vale: ",x7,sep=""))
      print(x7)
      
    }else{
      print(paste("Sin leer el archivo, x7 vale: ",x7,sep=""))
      print(x7)
    }
  })
  
  x8<-0
  progress8 <- reactive({
    print(paste("antes de empezar x8 vale: ",x8,sep=""))
    autoInvalidate()
    if(x8==0){
      
      y<-indicador_preprocmails_fin(x8)
      x8<<-y
      print(paste("Dentro del if, x8 vale: ",x8,sep=""))
      print(x8)
      
    }else{
      print(paste("Sin leer el archivo, x8 vale: ",x8,sep=""))
      print(x8)
    }
  })
  
  x9<-0
  progress9 <- reactive({
    print(paste("antes de empezar x9 vale: ",x9,sep=""))
    autoInvalidate()
    if(x9==0){
      
      y<-indicador_analisisbusquedas_fin(x9)
      x9<<-y
      print(paste("Dentro del if, x9 vale: ",x9,sep=""))
      print(x9)
      
    }else{
      print(paste("Sin leer el archivo, x9 vale: ",x9,sep=""))
      print(x9)
    }
  })
  
  x10<-0
  progress10 <- reactive({
    print(paste("antes de empezar x10 vale: ",x10,sep=""))
    autoInvalidate()
    if(x10==0){
      
      y<-indicador_analisisubicaciones_fin(x10)
      x10<<-y
      print(paste("Dentro del if, x10 vale: ",x10,sep=""))
      print(x10)
      
    }else{
      print(paste("Sin leer el archivo, x10 vale: ",x10,sep=""))
      print(x10)
    }
  })
  
  x11<-0
  progress11 <- reactive({
    print(paste("antes de empezar x11 vale: ",x11,sep=""))
    autoInvalidate()
    if(x11==0){
      
      y<-indicador_agruparbusquedas(x11)
      x11<<-y
      print(paste("Dentro del if, x11 vale: ",x11,sep=""))
      print(x11)
      
    }else{
      print(paste("Sin leer el archivo, x11 vale: ",x11,sep=""))
      print(x11)
    }
  })
  
  x12<-0
  progress12 <- reactive({
    print(paste("antes de empezar x12 vale: ",x12,sep=""))
    autoInvalidate()
    if(x12==0){
      
      y<-indicador_agruparbusquedas(x12)
      x12<<-y
      print(paste("Dentro del if, x12 vale: ",x12,sep=""))
      print(x12)
      
    }else{
      print(paste("Sin leer el archivo, x12 vale: ",x12,sep=""))
      print(x12)
    }
  })
  
  x13<-0
  progress13 <- reactive({
    print(paste("antes de empezar x13 vale: ",x13,sep=""))
    autoInvalidate()
    if(x13==0){
      
      y<-indicador_agruparbusquedas(x13)
      x13<<-y
      print(paste("Dentro del if, x13 vale: ",x13,sep=""))
      print(x13)
      
    }else{
      print(paste("Sin leer el archivo, x13 vale: ",x13,sep=""))
      print(x13)
    }
  })
  
  # Same as above, but with fill=TRUE
  output$progressBox2 <- renderInfoBox({
    infoBox(
      "Progress", paste0((100*progress())/8, "%"), icon = icon("list"),
      color = "purple", fill = TRUE
    )
  })
  # output$approvalBox2 <- renderInfoBox({
  #   infoBox(
  #     "Approval", "80%", icon = icon("thumbs-up", lib = "glyphicon"),
  #     color = "yellow", fill = TRUE
  #   )
  # })
  
})
