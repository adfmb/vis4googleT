shinyUI(fluidPage(
  
  tags$head(tags$style(HTML("
    .shiny-text-output {
      background-color:#fff;
    }
  "))),
  
  #strong("Autómata: Cálculo de probabilidades de que cierto estado del proceso suceda")
  h1("Autómata: ",span("Cálculo de probabilidades de que un insaculado llegue a cierto estado del proceso en la primera y segunda etapa", style = "font-weight: 300"), 
     style = "font-family: 'Source Sans Pro';
        color: #fff; text-align: center;
background-image: url('texturebg.png');
     padding: 20px"),
  
  br(),
  
  fluidRow(
    column(8, offset = 3,
           img(src="logo_ine.png", height = 200, width = 550)
    )
  ),
  
  br(),
  
  fluidRow(
    
    column(4,
           wellPanel(
             #img(src="logo_ine.png", height = 70, width = 200),
             h1(strong(textOutput("entidad"))),
             br(),
             br(),
             #i<-paste("<b>",textOutput("prob_calcu"),"</b>"),
             HTML(paste(h2(em("Probabilidad de ")), h2(strong(textOutput("prob_calcu"))))),
             #img(src="ine.png", height = 110, width = 250),
             br()
           )),

column(4,
       wellPanel(
             h4(strong(span(textOutput("urbana"),style="color:red"))),
             h5(textOutput("texto_decision_urbana")),
             h4(strong(span(textOutput("no_urbana"),style="color:red"))),
             h5(textOutput("texto_decision_no_urbana")),
             br(),
             br(),
             br(),
             br(),
             br(),
             helpText("Información de referencia: "),
             span(strong("Los datos utilizados fueron generados por medio de simulaciones 
para proteger la naturaleza e integridad de los datos reales del PE 2014-2015"), style = "color:blue")
             
#              p("Current Value:", style = "color:#888888;"), 
#              verbatimTextOutput("action"),
#              a("See Code", class = "btn btn-primary btn-md", 
#                href = "https://gallery.shinyapps.io/068-widget-action-button/")
           )),

column(4,
       wellPanel(
#          selectInput("Entidad", label = "Selecciona alguna de las entidades", 
#                      choices = unique(fuente2()$NOMBRE_ESTADO), selected = 1),
#          
         uiOutput("nombres_entidades"),
         
         selectInput("Calcula_proba", label = "Selecciona el estado al que se le calculará la probabilidad de que el insaculado caiga en él", 
                     choices = list("Visitado"=1, "Ciudadanos con revisita pendiente"=2, 
                                    "Revisitas para notificacion"=3,
                                    "Notificado"=4,"Rechazos"=5, 
                                    "Ciudadano que no fue posible notificar"=6,
                                    "Ciudadano notificado no apto"=7,
                                    "Revisitas para capacitar"=8,
                                    "Capacitado"=9,
                                    "Rechazo durante la capacitación no capacitado"=10,
                                    "No fue posible capacitar"=11,
                                    "Rechazo durante la capacitacion capacitados"=12,
                                    "Ciudadanos capacitados no aptos"=13,
                                    "Ciudadanos aptos"=14,
                                    "Funcionario designado"=15, "Sustituido"=16,
                                    "Con nombramiento entregado"=17,
                                    "Tuvo alguna capacitación"=18,"La capacitación fue grupal"=19,
                                    "Asistió a Simulacros"=20,
                                    "Propietario"=21,"Asistencia"=22),
                                     selected = 22),
         
         
         sliderInput("Umbral",label="Umbral de recomendación",
                     min=0,max=1,value=.5,step=.01)
         
       ))

),

fluidRow(
    
    column(2,
           wellPanel(
             
             selectInput("Visitado", label = "Visitado", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 1),
             
             br(),
             
             selectInput("Revisita_pendiente", label = "Ciudadanos con revisita pendiente", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             
             br(),
             
             selectInput("Revisita_notificar", label = "Revisitas para notificacion", 
                         choices = c("",0:10,100), selected = ""),
             
             br(),
             
             selectInput("Notificado", label = "Notificado", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             
             br(),
             
             selectInput("Rechazos", label = "Rechazos", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             
             
             
            
             
             br()
             
           )),
    
    column(2,
           wellPanel(
             
      
             selectInput("Ciudadano_no_notificar", label = "Ciudadano que no fue posible notificar", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             
             selectInput("Ciudadano_notificado_no_apto", label = "Ciudadano notificado no apto", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             br(),
             
             selectInput("Revisitas_capacitar", label = "Revisitas para capacitar", 
                         choices = c("",0:10,100), selected = ""),
             
             br(),
             
             selectInput("Capacitado", label = "Capacitado", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             
             selectInput("Rechazo_capacitacion_no_capacitado", label = "Rechazo durante la capacitación no capacitado", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2)
             
             
            
             
           )),
    
    column(3,
           wellPanel(
             
             
             selectInput("No_posible_capacitar", label = "No fue posible capacitar", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             br(),
             
             
             selectInput("Rechazo_capacitacion_capacitados", label = "Rechazo durante la capacitación capacitados", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             br(),
             
             selectInput("Ciudadanos_no_aptos", label = "Ciudadanos capacitados no aptos", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             
             
             br(),
             #                   selectInput("Lista_reserva", label = "Lista de reserva", 
             #                               choices = c(1,0), selected = 1),
             
             selectInput("Ciudadanos_aptos", label = "Ciudadanos aptos", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             
             br(),
             
             #                   selectInput("Suplentes", label = "Suplentes", 
             #                               choices = c(1,0), selected = 0),
             #                   
             selectInput("Sustituido", label = "Sustituido", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             
             
             
             
             br(),
             br()
             
           )),
    
# ),
# 
# fluidRow(
  

    column(3,
           wellPanel(
             
          
             
             selectInput("Con_nombramiento_entregado", label = "Con nombramiento entregado", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             br(),
             br(),
             br(),
             
             selectInput("Tuvo_alguna_capacitacion", label = "Tuvo alguna capacitación", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             
             br(),
             br(),
             br(),
             
             selectInput("La_capacitacion_fue_grupal", label = "La capacitación fue grupal", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             
             br(),
             br(),
             br(),
             
             selectInput("Asistio_a_Simulacros", label = "Asistió a Simulacros", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             
             
             
            
             br(),
             br()
             
           )),
    
    column(2,
           wellPanel(
             
             
             selectInput("Funcionario_designado", label = "Funcionario designado", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             
             br(),
             br(),
             br(),
             br(),
             br(),
             
             selectInput("Propietario", label = "Propietario", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),

             br(),
             br(),
             br(),
             br(),
             br(),
            
             selectInput("Exito", label = "Asistencia", 
                         choices = list("Sí"=1,"No"=0,"Sin distinción"=2), selected = 2),
             
             
             
             
            
             br(),
             br(),
             br(),
             br()
           )) 
  ),

fluidRow(
  column(9, offset = 2,
         img(src="diagrama.png", height = 300, width = 850)
  ),
  
  br()
)
                  #                   helpText("Informacion de referencia:
                  # Datos del Sistema del Proceso Electoral 2014-2015"),
))