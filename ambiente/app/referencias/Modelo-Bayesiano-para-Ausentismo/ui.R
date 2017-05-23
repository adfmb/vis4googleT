shinyUI(fluidPage(
  titlePanel("Modelo de Alarmas para posibles Casillas con Ausentismo"),
  
  sidebarLayout(position = "right",
                sidebarPanel(
                  helpText("Información de referencia:
                           Los datos utilizados fueron generados por medio de simulaciones 
                           para proteger la naturaleza e integridad de los datos reales del PE 14-15"),
                  
                  selectInput("var", 
                              label = "Escoge la variable de interes",
                              choices = c("Proporcion de Casillas con Ausentismo", 
                                          "Cantidad de Casillas con Ausentismo",
                                          "Cantidad de Casillas"),
                              selected = "Proporcion de Casillas con Ausentismo"),
                  
                  radioButtons("radio", label = "Tipo de Analisis a visualizar",
                               choices = list("Descriptivo" = 1, "Inferencial" = 2), 
                               selected = 1),
                  selectInput("Entidad", label = "Selecciona Nacional o alguna de las entidades", 
                              choices = c("NACIONAL", "OAXACA", "QUINTANA ROO","SINALOA","TAMAULIPAS","CHIHUAHUA","DISTRITO FEDERAL"), selected = "NACIONAL"),
                  
                  
                  radioButtons("liga", label = "Tipo de Liga a utilizar",
                               choices = list("Gibbs con liga Logit" = 1, "Gibbs con liga Probit" = 2,"MH con liga logit"= 3), 
                               selected = 1),
                  
                  radioButtons("TipoElec", label = "Tipo de Eleccion",
                               choices = list("Concurrente" = 1, "Federal" = 0), 
                               selected = 1),
                  
                  sliderInput("Proporcion",label="Proporcion de datos a entrenar",
                              min=.01,max=1,value=.02),
                  
                  sliderInput("IteracionesMH",label="Iteraciones",
                              min=5000,max=50000,value=5000,step=100),
                  
                  sliderInput("CalentamientoJags",label="Calentamiento",
                              min=100,max=5000,value=1000,step=100),
                  
                  checkboxGroupInput("checkGroup", label = "Seleccionar Variables explicativas", 
                                     choices = c("% Sustituciones"="Porcentaje_Sustituciones", 
                                                 "% Rechazos"="porc_Rechazos","% NE"= "porc_NE",
                                                 "% Aptos"="porc_Aptos","Casillas x CAE"="Casillas_x_CAE_escaladas",
                                                 "Casilla A"="A1","Casilla B"="B1","Casilla C"="C1","Casilla Rural"="Rural1",
                                                 "Casilla Urbana"="Urbana1", "Casilla Mixta"="Mixta1",
                                                 "% Mujeres"="porc_m_mesas","% Hombres"="porc_h_mesas",
                                                 "% sin esolaridad"="porc_sin_e_mesas","% con primaria"="porc_prim_mesas",
                                                 "% con secundaria"="porc_sec_mesas","% con bachillerato"="porc_bach_mesas",
                                                 "% con licenciatura"="porc_lic_mesas","Edad promedio de funcionarios (escalada por entidad)"="edad_promedio_escalada_X_edo",
                                                 "Rango de edades de los funcionarios (escalada por entidad)"="edad_rango_escalada_X_edo",
                                                 "Edad promedio de funcionarios (escalada nacional)"="edad_promedio_escalada_Nacional",
                                                 "Rango de edades de los funcionarios (escalada nacional)"="edad_rango_escalada_Nacional"),
                                     selected = "Porcentaje_Sustituciones"),
                  
                  sliderInput("umbral",label="Umbral para etiquetar ausentismo",
                              min=.01,max=1,value=.02),
                  
                  submitButton("Refresh",icon("bar-chart-o")),
                  
                  downloadButton('downloadData1', 'Tabla de casillas'),
                  
                  downloadButton('downloadData2', 'Pesos de las variables'),
                  
                  downloadButton('downloadData3', 'Datos de entrenamiento'),
                  
                  downloadButton('downloadData4', 'Datos de prueba'),
                  
                  downloadButton('downloadData5', 'Umbrales para variables')
                  
                  
                  
                  
                  ),
                
                mainPanel(
                  tabsetPanel(id="inTabset", 
                              tabPanel("Descriptivo",value="panel1",plotOutput("map")),
                                       #submitButton("Refresh",icon("bar-chart-o"))),
                              tabPanel("Inferencial",value="panel2",plotOutput("plot1"),
                                       verbatimTextOutput("sumario"),
                                       #tableOutput("tabla_resumen"),
                                       #tableOutput("tabla_resumen_2_1"),
                                       tableOutput("tabla_resumen_2_2"),
                                       tableOutput("comparativa"),
                                       plotOutput("plot2"),
                                       tableOutput("mat_conf"),
                                       tableOutput("umbrales_1_2"),
                                       #submitButton("Refresh",icon("bar-chart-o")),
                                       dataTableOutput("tabla_final_casillas_ordenadas"))
                   #           submitButton("Refresh",icon("bar-chart-o"))
                  )
                )
  )
))