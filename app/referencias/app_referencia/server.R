# setwd("~/Google Drive/alfredo/PE_2014-2015/Capacitacion_2014-2015/2016/2017/archivos_para_automata")
# fuente2<-read.csv("tabla_gigante2.csv",header=TRUE)
## fuente2<-read.csv("tabla_gigante.csv",header=TRUE)
# # urbana<-read.csv("urbana.csv",header = TRUE)
# no_urbana<-read.csv("no_urbana.csv",header = TRUE)

library("RCurl") 

funcion_fuente2<-function(){

  read.table(textConnection(getURL(
  #"https://s3-us-west-2.amazonaws.com/adfmb/tabla_gigante2.csv"
    "https://s3-us-west-2.amazonaws.com/datos-simulados-para-apps/tabla_datos_simulados.csv"
)), sep=",", header=TRUE)

  }

#
library(Rcpp)
library(maps)
library(mapproj)
library(ggplot2)
library(shiny)
library(psych)
library(caret)
library(bnclassify)
library(klaR)
library(rocc)

shinyServer(function(input, output,session) {
  
  opciones<-c("Visitado", "Ciudadanos con revisita pendiente", 
                 "Revisitas para notificación",
                 "Notificado","Rechazos", 
                 "Ciudadano que no fue posible notificar",
                 "Ciudadano notificado no apto",
                 "Revisitas para capacitar",
                 "Capacitado",
                 "Rechazo durante la capacitación no capacitado",
                 "No fue posible capacitar",
                 "Rechazo durante la capacitación capacitados",
                 "Ciudadanos capacitados no aptos",
                 "Ciudadanos aptos",
                 "Funcionario designado", "Sustituido", "Con nombramiento entregado",
                 "Tuvo alguna capacitación", "La capacitación fue grupal",
                 "Asistió a Simulacros",
                  "Propietario","Asistencia")
  
  fuente2<-reactive({funcion_fuente2()})
  
  lista_entidades<-reactive({
    
    unique(as.character(fuente2()$NOMBRE_ESTADO))
    
  })
  
  output$nombres_entidades<-renderUI({
    
    selectInput("Entidad","Entidad",choices=lista_entidades())
    
  })
  
  
  tabla_entidad <- reactive({
  
    subset(fuente2(),NOMBRE_ESTADO==input$Entidad)
    #tabla_entidad<-subset(fuente2,NOMBRE_ESTADO=="AGUASCALIENTES")
  })
  
  subs<-reactive({
  
    #Visitado<-1
    if(input$Visitado<2){
    
    sub_u<-subset(tabla_entidad(),Visitado==input$Visitado & tipo_seccion_deoe=="URBANA")
    #sub_u<-subset(tabla_entidad,Visitado==Visitado & tipo_seccion_deoe=="URBANA")
    
    sub_nu<-subset(tabla_entidad(),Visitado==input$Visitado & tipo_seccion_deoe=="NO URBANA")
    #sub_nu<-subset(tabla_entidad,Visitado==Visitado & tipo_seccion_deoe=="NO URBANA")
    
    }else{
      sub_u<-subset(tabla_entidad(),tipo_seccion_deoe=="URBANA")
      sub_nu<-subset(tabla_entidad(),tipo_seccion_deoe=="NO URBANA")
    }
    
    if(input$Revisita_pendiente<2){
      sub_u<-subset(sub_u,Ciudadanos.con.revisita.pendiente==input$Revisita_pendiente)
      sub_nu<-subset(sub_nu,Ciudadanos.con.revisita.pendiente==input$Revisita_pendiente)
    }

    if(input$Revisita_notificar!=""){
      sub_u<-subset(sub_u,Revisitas.para.notificacion==input$Revisita_notificar)
      sub_nu<-subset(sub_nu,Revisitas.para.notificacion==input$Revisita_notificar)
    }
    
    if(input$Notificado<2){
      sub_u<-subset(sub_u,Notificado==input$Notificado)
      sub_nu<-subset(sub_nu,Notificado==input$Notificado)
    }
    
    if(input$Rechazos<2){
      sub_u<-subset(sub_u,Rechazos==input$Rechazos)
      sub_nu<-subset(sub_nu,Rechazos==input$Rechazos)
    }
    
    if(input$Ciudadano_no_notificar<2){
      sub_u<-subset(sub_u,Ciudadanos.que.NO.fue.posible.notificar==input$Ciudadano_no_notificar)
      sub_nu<-subset(sub_nu,Ciudadanos.que.NO.fue.posible.notificar==input$Ciudadano_no_notificar)
    }
    
    if(input$Ciudadano_notificado_no_apto<2){
      sub_u<-subset(sub_u,Ciudadanos.que.NO.fue.posible.notificar==input$Ciudadano_notificado_no_apto)
      sub_nu<-subset(sub_nu,Ciudadanos.que.NO.fue.posible.notificar==input$Ciudadano_notificado_no_apto)
    }
    
    if(input$Revisitas_capacitar!=""){
      sub_u<-subset(sub_u,Revisita.para.capacitacion==input$Revisitas_capacitar)
      sub_nu<-subset(sub_nu,Revisita.para.capacitacion==input$Revisitas_capacitar)
    }
    
    if(input$Capacitado<2){
      sub_u<-subset(sub_u,Capacitado==input$Capacitado)
      sub_nu<-subset(sub_nu,Capacitado==input$Capacitado)
    }
    
    if(input$Rechazo_capacitacion_no_capacitado<2){
      sub_u<-subset(sub_u,Rechazos.durante.la.capacitacion.No.capacitados==input$Revisita_capacitacion_no_capacitado)
      sub_nu<-subset(sub_nu,Rechazos.durante.la.capacitacion.No.capacitados==input$Revisita_capacitacion_no_capacitado)
    }
    
    if(input$No_posible_capacitar<2){
      sub_u<-subset(sub_u,No.fue.posible.capacitar==input$No_posible_capacitar)
      sub_nu<-subset(sub_nu,No.fue.posible.capacitar==input$No_posible_capacitar)
    }
    
    if(input$Rechazo_capacitacion_capacitados<2){
      sub_u<-subset(sub_u,Rechazos.durante.la.capacitacion.capacitados==input$Revisita_capacitacion_capacitados)
      sub_nu<-subset(sub_nu,Rechazos.durante.la.capacitacion.capacitados==input$Revisita_capacitacion_capacitados)
    }
    
    if(input$Ciudadanos_no_aptos<2){
      sub_u<-subset(sub_u,Ciudadanos.capacitados.NO.aptos==input$Ciudadanos_no_aptos)
      sub_nu<-subset(sub_nu,Ciudadanos.capacitados.NO.aptos==input$Ciudadanos_no_aptos)
    }
    
    if(input$Ciudadanos_aptos<2){
      sub_u<-subset(sub_u,Ciudadanos.aptos==input$Ciudadanos_aptos)
      sub_nu<-subset(sub_nu,Ciudadanos.aptos==input$Ciudadanos_aptos)
    }
    
    if(input$Funcionario_designado<2){
      sub_u<-subset(sub_u,Funcionario.designado==input$Funcionario_designado)
      sub_nu<-subset(sub_nu,Funcionario.designado==input$Funcionario_designado)
    }
    
    if(input$Sustituido<2){
      sub_u<-subset(sub_u,sustituido==input$Sustituido)
      sub_nu<-subset(sub_nu,sustituido==input$Sustituido)
    }
    
    if(input$Con_nombramiento_entregado<2){
      sub_u<-subset(sub_u,funcionario.con.nombramiento.entregado==input$Con_nombramiento_entregado)
      sub_nu<-subset(sub_nu,funcionario.con.nombramiento.entregado==input$Con_nombramiento_entregado)
    }
    
    if(input$Tuvo_alguna_capacitacion<2){
      sub_u<-subset(sub_u,Capacitado.1==input$Tuvo_alguna_capacitacion)
      sub_nu<-subset(sub_nu,Capacitado.1==input$Tuvo_alguna_capacitacion)
    }

    if(input$La_capacitacion_fue_grupal<2){
      sub_u<-subset(sub_u,Capacitacion.grupal==input$La_capacitacion_fue_grupal)
      sub_nu<-subset(sub_nu,Capacitacion.grupal==input$La_capacitacion_fue_grupal)
    }
    
    if(input$Asistio_a_Simulacros<2){
      sub_u<-subset(sub_u,asistencia.a.simulacros==input$Asistio_a_Simulacros)
      sub_nu<-subset(sub_nu,asistencia.a.simulacros==input$Asistio_a_Simulacros)
    }
    
    if(input$Propietario<2){
      sub_u<-subset(sub_u,Propietario==input$Propietario)
      sub_nu<-subset(sub_nu,Propietario==input$Propietario)
    }
    
    if(input$Exito<2){
      sub_u<-subset(sub_u,Exito==input$Exito)
      sub_nu<-subset(sub_nu,Exito==input$Exito)
    }
    
    list("u"=sub_u,"nu"=sub_nu)
    # subs<-list("u"=sub_u,"nu"=sub_nu)  
})
  
#   Revisita_pendiente
#   Revisita_notificar
#   Notificado
#   Rechazos
#   Ciudadano_no_notificar
#   Ciudadano_notificado_no_apto
#   Revisitas_capacitar
#   Capacitado
#   Revisita_capacitacion_no_capacitado
#   No_posible_capacitar
#   Revisita_capacitacion_capacitados
#   Ciudadanos_no_aptos
#   Ciudadanos_aptos
#   Funcionario_designado
#   Propietario
#   Exito
  
 
        CalculoProbabilidades <- reactive({
          
          
          sub_urbana<-subs()$u
          # sub_urbana<-subs$u
          # sub_urbana<-subset(fuente2,NOMBRE_ESTADO=="AGUASCALIENTES" & tipo_seccion_deoe=="URBANA")
          if(nrow(sub_urbana)>0){
          
            # Calcula_proba<-17
            numerador_u<-length(sub_urbana[[as.numeric(input$Calcula_proba)+2]][which(sub_urbana[[as.numeric(input$Calcula_proba)+2]]>0)])
            # numerador_u<-length(sub_urbana[[Calcula_proba+2]][which(sub_urbana[[Calcula_proba+2]]>0)])
            
            univ_u<-nrow(sub_urbana)
            proba_U<-numerador_u/univ_u
#             numerador_u<-length(sub_urbana[[17+2]][which(sub_urbana[[17+2]]>0)])
#             sub_ur_ex<-subset(sub_urbana,Exito==1)
#              
          }else{proba_U<-"No Aplica"}
          
          
          
          sub_no_urbana<-subs()$nu
          # sub_no_urbana<-subs$nu
          if(nrow(sub_no_urbana)>0){
            
            numerador_nu<-length(sub_no_urbana[[as.numeric(as.character(input$Calcula_proba))+2]][which(sub_no_urbana[[as.numeric(as.character(input$Calcula_proba))+2]]>0)])
            # numerador_nu<-length(sub_no_urbana[[Calcula_proba+2]][which(sub_no_urbana[[Calcula_proba+2]]>0)])
            univ_nu<-nrow(sub_no_urbana)
            proba_NU<-numerador_nu/univ_nu
            #             numerador_u<-length(sub_no_urbana[[17+2]][which(sub_no_urbana[[17+2]]>0)])
            #             sub_ur_ex<-subset(sub_no_urbana,Exito==1)
            #              
          }else{proba_NU<-"No Aplica"}
          
          
          
          list("U"=proba_U,"NU"=proba_NU,"sub_urbana"=sub_urbana)    
  
#             probas<-list(U=runif(1),NU=runif(1))
#             probas
    
  })
        

  
        output$entidad <-  renderText({
            paste(input$Entidad)
        })
        
#         output$lista_entidades <-  renderText({
#           unique(fuente2()$NOMBRE_ESTADO)
#         })
        

        output$prob_calcu <-  renderText({
          
              #paste("Probabilidad de ",opciones[as.numeric(input$Calcula_proba)]," en casillas:")
              paste(opciones[as.numeric(input$Calcula_proba)])
            # paste("Probabilidad de ",names(tabla_entidad())[as.numeric(input$Calcula_proba) + 2]," en casillas:")
        })
        
#         output$tabla_resumen<-renderTable({
#   
#           head(CalculoProbabilidades()$sub_urbana,10)
#   
#         })
        
        output$urbana <-  renderText({
          if(CalculoProbabilidades()$U=="No Aplica"){
            paste("- Urbanas -> No Aplica")
          }else{
            paste("- Urbanas -> ",round(CalculoProbabilidades()$U,4)*100,"%",sep="")
          }
        })

        output$no_urbana <-  renderText({
          if(CalculoProbabilidades()$NU=="No Aplica"){
            paste("- No urbanas -> No Aplica")
          }else{
            paste("- No urbanas -> ",round(CalculoProbabilidades()$NU,4)*100,"%",sep="")
          }
        })
        
        
        output$texto_decision_urbana <- renderText({
          
          if(CalculoProbabilidades()$U=="No Aplica"){
            paste(" ")
          }else if(CalculoProbabilidades()$U>=input$Umbral){
            
            paste("Continuar con el insaculado")
            
          }else{paste("No continuar con el insaculado")}
          
        })
#         
#         
        output$texto_decision_no_urbana <- renderText({
          
          if(CalculoProbabilidades()$NU=="No Aplica"){
            paste(" ")
          }else if(CalculoProbabilidades()$NU>=input$Umbral){
            
            paste("Continuar con el insaculado")
            
          }else{paste("No continuar con el insaculado")}
          
        })
        
        
    }
  )


