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
  
  autoInvalidate <- reactiveTimer(15000)

  x1<-0
  progress1 <- reactive({
    print(paste("antes de empezar x1 vale: ",x1,sep=""))
    autoInvalidate()
    if(x1==0){
      
      y<-indicador_unzip()
      x1<<-y
      print(paste("Dentro del if, x1 vale: ",x1,sep=""))
      print(x1)
      
    }else{
      print(paste("Sin leer el archivo, x1 vale: ",x1,sep=""))
      print(x1)
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
  
  # x10<-0
  # progress10 <- reactive({
  #   print(paste("antes de empezar x10 vale: ",x10,sep=""))
  #   autoInvalidate()
  #   if(x10==0){
  #     
  #     y<-indicador_analisisubicaciones_fin(x10)
  #     x10<<-y
  #     print(paste("Dentro del if, x10 vale: ",x10,sep=""))
  #     print(x10)
  #     
  #   }else{
  #     print(paste("Sin leer el archivo, x10 vale: ",x10,sep=""))
  #     print(x10)
  #   }
  # })
  
  x11<-0
  progress11 <- reactive({
    print(paste("antes de empezar x11 vale: ",x11,sep=""))
    autoInvalidate()
    if(x11==0){
      
      y<-indicador_analisismails_fin(x11)
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
      
      y<-indicador_recomendaciones_fin(x12)
      x12<<-y
      print(paste("Dentro del if, x12 vale: ",x12,sep=""))
      print(x12)
      
    }else{
      print(paste("Sin leer el archivo, x12 vale: ",x12,sep=""))
      print(x12)
    }
  })
  
  descargado<-0
  # imprimemapa<-'cosa.html'
  mapa<-reactive({
    
      autoInvalidate()
      while(x12==1 & descargado==0){
        print("calculando nombre de mapa")
        temp<-tempfile()
        download.file("https://s3-us-west-2.amazonaws.com/dpaequipo10/resultado/mapapormientras.html",temp)
        system(paste("mv ",temp," mapa.html",sep=""))
        print(imprimemapa)
        descargado<<-1
        imprimemapa<<-dibujandomapa(x12)
      }
      imprimemapa
    
  })
    
    # print(paste("antes de empezar x12 vale en mapa: ",x12,sep=""))
    # if(imprimemapa==0){
    #   autoInvalidate()
    #   if(descargado==0 & x12==1){
    #   print("calculando nombre de mapa")
    #   imprimemapa<<-dibujandomapa(x12)
    #   descargado<<-1
    #   print(descargado)
    #   print(imprimemapa)
    # }else{
    #   # print(paste("no ejecuta ni ptm"))
    #   # print(descargado)
    #   imprimemapa
    
    # }
  

  all<-reactive({progress1()+progress5()+progress8()+
      progress11()+progress12()})
  
  # Same as above, but with fill=TRUE
  output$progressBox1 <- renderInfoBox({
    infoBox(
      "Progress", paste0((100*progress1()), "%"), icon = icon("list"),
      color = "purple", fill = TRUE
    )
  })
  
  output$progressBox5 <- renderInfoBox({
    infoBox(
      "Progress", paste0((100*progress5()), "%"), icon = icon("list"),
      color = "blue", fill = TRUE
    )
  })
  
  output$progressBox8 <- renderInfoBox({
    infoBox(
      "Progress", paste0((100*progress8()), "%"), icon = icon("list"),
      color = "red", fill = TRUE
    )
  })
  
  output$progressBox11 <- renderInfoBox({
    infoBox(
      "Progress", paste0((100*progress11()), "%"), icon = icon("list"),
      color = "green", fill = TRUE
    )
  })
  
  output$progressBox12 <- renderInfoBox({
    infoBox(
      "Progress", paste0((100*progress12()), "%"), icon = icon("list"),
      color = "fuchsia", fill = TRUE
    )
  })
  
  output$progressBoxtodo <- renderInfoBox({
    infoBox(
      "Getting Ready...", paste0((100*(all())/5), "%"), icon = icon("grav"),
      color = "black", fill = TRUE
    )
  })
  
  output$mymap <- renderUI({
    
    tags$iframe(
      srcdoc = paste(readLines(mapa()), collapse = '\n'),
      width = "100%",
      height = "600px")
  })
  
  # print(paste("valor de descargado: ",descargado,sep=""))
  # if(descargado==0){
  #   print("descargando html")
  #   observe({
  #     temp<-tempfile()
  #     download.file("https://s3-us-west-2.amazonaws.com/dpaequipo10/resultado/cosa.html",temp)
  #     system(paste("mv ",temp," cosa.html",sep=""))
  #     system("ls /tmp/")
  #   })
  #   descargado<<-1
  # }else {print("no se vuelve a cargar ni verga")}
  
  # output$progressBox10 <- renderInfoBox({
  #   infoBox(
  #     "Progress", paste0((100*progress10()), "%"), icon = icon("list"),
  #     color = "yellow", fill = TRUE
  #   )
  # })
  

  
  # x2<-0
  # progress2 <- reactive({
  #   print(paste("antes de empezar x2 vale: ",x2,sep=""))
  #   autoInvalidate()
  #   if(x2==0){
  #     
  #     y<-indicador_agruparbusquedas()
  #     x2<<-y
  #     print(paste("Dentro del if, x2 vale: ",x2,sep=""))
  #     print(x2)
  #     
  #   }else{
  #     print(paste("Sin leer el archivo, x2 vale: ",x2,sep=""))
  #     print(x2)
  #   }
  # })
  # 
  # x3<-0
  # progress3 <- reactive({
  #   print(paste("antes de empezar x3 vale: ",x3,sep=""))
  #   autoInvalidate()
  #   if(x3==0){
  #     
  #     y<-indicador_uptodasbusquedas(x3)
  #     x3<<-y
  #     print(paste("Dentro del if, x3 vale: ",x3,sep=""))
  #     print(x3)
  #     
  #   }else{
  #     print(paste("Sin leer el archivo, x3 vale: ",x3,sep=""))
  #     print(x3)
  #   }
  # })
  # 
  # x4<-0
  # progress4 <- reactive({
  #   print(paste("antes de empezar x4 vale: ",x4,sep=""))
  #   autoInvalidate()
  #   if(x4==0){
  #     
  #     y<-indicador_uptodasubicaciones(x4)
  #     x4<<-y
  #     print(paste("Dentro del if, x4 vale: ",x4,sep=""))
  #     print(x4)
  #     
  #   }else{
  #     print(paste("Sin leer el archivo, x4 vale: ",x4,sep=""))
  #     print(x4)
  #   }
  # })
  
  
  # x6<-0
  # progress6 <- reactive({
  #   print(paste("antes de empezar x6 vale: ",x6,sep=""))
  #   autoInvalidate()
  #   if(x6==0){
  #     
  #     y<-indicador_preprocbusquedas_fin(x6)
  #     x6<<-y
  #     print(paste("Dentro del if, x6 vale: ",x6,sep=""))
  #     print(x6)
  #     
  #   }else{
  #     print(paste("Sin leer el archivo, x6 vale: ",x6,sep=""))
  #     print(x6)
  #   }
  # })
  # 
  # x7<-0
  # progress7 <- reactive({
  #   print(paste("antes de empezar x7 vale: ",x7,sep=""))
  #   autoInvalidate()
  #   if(x7==0){
  #     
  #     y<-indicador_preprocubicaciones_fin(x7)
  #     x7<<-y
  #     print(paste("Dentro del if, x7 vale: ",x7,sep=""))
  #     print(x7)
  #     
  #   }else{
  #     print(paste("Sin leer el archivo, x7 vale: ",x7,sep=""))
  #     print(x7)
  #   }
  # })
  

  
  # x9<-0
  # progress9 <- reactive({
  #   print(paste("antes de empezar x9 vale: ",x9,sep=""))
  #   autoInvalidate()
  #   if(x9==0){
  #     
  #     y<-indicador_analisisbusquedas_fin(x9)
  #     x9<<-y
  #     print(paste("Dentro del if, x9 vale: ",x9,sep=""))
  #     print(x9)
  #     
  #   }else{
  #     print(paste("Sin leer el archivo, x9 vale: ",x9,sep=""))
  #     print(x9)
  #   }
  # })

  # output$progressBox2 <- renderInfoBox({
  #   infoBox(
  #     "Progress", paste0((100*progress2()), "%"), icon = icon("list"),
  #     color = "purple", fill = TRUE
  #   )
  # })
  # 
  # output$progressBox3 <- renderInfoBox({
  #   infoBox(
  #     "Progress", paste0((100*progress3()), "%"), icon = icon("list"),
  #     color = "purple", fill = TRUE
  #   )
  # })
  # 
  # output$progressBox4 <- renderInfoBox({
  #   infoBox(
  #     "Progress", paste0((100*progress4()), "%"), icon = icon("list"),
  #     color = "purple", fill = TRUE
  #   )
  # })
  
  # output$progressBox6 <- renderInfoBox({
  #   infoBox(
  #     "Progress", paste0((100*progress6()), "%"), icon = icon("list"),
  #     color = "purple", fill = TRUE
  #   )
  # })
  # 
  # output$progressBox7 <- renderInfoBox({
  #   infoBox(
  #     "Progress", paste0((100*progress7()), "%"), icon = icon("list"),
  #     color = "purple", fill = TRUE
  #   )
  # })
  
  # output$progressBox9 <- renderInfoBox({
  #   infoBox(
  #     "Progress", paste0((100*progress9()), "%"), icon = icon("list"),
  #     color = "purple", fill = TRUE
  #   )
  # })
  
})
