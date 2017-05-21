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
    system("python tasks/ups/up_todas_ubicaciones.py")
    system("python tasks/ups/up_todas_busquedas.py")
    system("./tasks/ups/up_archivos_mails.sh")
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
  

  getmap<-function(){
    print("calculando nombre de mapa")
    temp<-tempfile()
    download.file("https://s3-us-west-2.amazonaws.com/dpaequipo10/resultado/mapa.html",temp)
    system(paste("mv ",temp," mapa.html",sep=""))
    # print(imprimemapa)
    descargado<<-1
    imprimemapa<-includeHTML("mapa.html")
    # }
    
    return(tags$iframe(
      srcdoc = imprimemapa,#paste(readLines(imprimemapa,warn=FALSE), collapse = '\n'), #mapa()
      width = "100%",
      height = "600px"))
  }
  # imprimemapa<-'cosa.html'
  
  printmapa<-tags$iframe(
    srcdoc = includeHTML("cosa1.html"),#paste(readLines(imprimemapa,warn=FALSE), collapse = '\n'), #mapa()
    width = "100%",
    height = "600px")
  
  descargado<-0 
mapa<-reactive({
      
      autoInvalidate()
      if(x12==1 & descargado==0){
        
        descargado<-1
        printmapa<<-getmap()
        printmapa
        
      }else{
        printmapa
        }

    
  })
    
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
    mapa()#getmap()
    # tags$iframe(
    #   srcdoc = paste(readLines(getmap()), collapse = '\n'), #mapa()
    #   width = "100%",
    #   height = "600px")
  })
  
  output$plot<-renderPlot({
    
    colnames(date_counts_querys) <- c("Dia","Freq")
    date_counts_querys$Tipo <- 'Queries'
    
    nrow(date_counts_mails)
    colnames(date_counts_mails) <- c("Dia","Freq")
    date_counts_mails$Tipo <- 'Mails'
    
    date_counts <- rbind(date_counts_querys, date_counts_mails)
    
    date_counts$Dia <- as.Date(date_counts$Dia)
    date_counts$Year <- format(date_counts$Dia, "%Y")
    date_counts$Month <- format(date_counts$Dia, "%b")
    date_counts$Day <- format(date_counts$Dia, "%d")
    date_counts$MonthDay <- format(date_counts$Dia, "%d-%b")
    #date_counts <- date_counts_mails[date_counts$Year>=2014,]
    
    ggplot(data = date_counts,
           mapping = aes(x = date_counts$Dia, y = date_counts$Freq,  shape = Tipo, colour = Tipo)) + 
      geom_line() +  xlab("") + ylab("Frecuencia")
    
  })
  
})
