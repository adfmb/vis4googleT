
# install.packages("Rcpp")
# install.packages("maps")
# install.packages("mapproj")
# install.packages("ggplot2")
# install.packages("shiny")
# install.packages("R2jags")
# install.packages("rjags")
# install.packages("psych")
# install.packages("caret")
# install.packages("bnclassify")
# install.packages("klaR")
# install.packages("rocc")
# install.packages("RCurl")

library(Rcpp)
library(maps)
library(mapproj)
library(ggplot2)
library(shiny)
library(R2jags)
library(rjags)
library(psych)
library(caret)
library(bnclassify)
library(klaR)
library(rocc)
library("RCurl") 

plot_proporcion_Ausentismo<-function(){
  
  read.table(textConnection(getURL(
    "https://s3-us-west-2.amazonaws.com/datos-simulados-para-apps/datos_simulados_para_proporcionAus.csv"
  )), sep=",", header=TRUE)
  
}

plot_cantidad_Ausentismo<-function(){
  
  read.table(textConnection(getURL(
    "https://s3-us-west-2.amazonaws.com/datos-simulados-para-apps/datos_simulados_para_cantidadAus.csv"
  )), sep=",", header=TRUE)
  
}

plot_cantidad_Casillas<-function(){
  
  read.table(textConnection(getURL(
    "https://s3-us-west-2.amazonaws.com/datos-simulados-para-apps/datos_simulados_para_cantidadC.csv"
  )), sep=",", header=TRUE)
  
}

tabla<-function(){
  
  read.table(textConnection(getURL(
    "https://s3-us-west-2.amazonaws.com/datos-simulados-para-apps/datos_simulados_para_modelo_bayesiano.csv"
  )), sep=",", header=TRUE)
  
}

modelo_binomial_logit<-function(){
  
  for(i in 1:n){
    y[i]~dbin(pi[i],1)
    #Funcion Liga
    logit(pi[i])<-alpha+x[i,]%*%beta
    
  }
  #A priori's
  
  alpha~dnorm(0,.001)
  for(i in 1:var_expl){
    
    beta[i]~dnorm(0,.001)
    
  }
  #Estimaciones de Ys conocidas con
  #La posterior que genera Jags
  for(i in 1:n){
    
    yest[i]~dbin(pi[i],1)
    
  }
  
}
#Binomial con liga probit
modelo_binomial_probit<-function(){
  
  for(i in 1:n){
    y[i]~dbin(pi[i],1)
    #Funcion Liga
    probit(pi[i])<-alpha+x[i,]%*%beta
    
  }
  #A priori's
  
  alpha~dnorm(0,.001)
  for(i in 1:var_expl){
    
    beta[i]~dnorm(0,.001)
    
  }
  #Estimaciones de Ys conocidas con
  #La posterior que genera Jags
  for(i in 1:n){
    
    yest[i]~dbin(pi[i],1)
    
  }
  
}

preparar_datos<-function(tabla_datos,Entidad="NACIONAL",Concurrente=1,proporcion_entrena,
                         vector_variables,iteraciones_jags,calentamiento_jags, modelo_jags1){
  #tabla_datos<-tabla
  #Dejar solo la entidad que vamos a analizar
  if(Entidad=="NACIONAL"){
    tabla_entrena1<-subset(subset(tabla_datos,Concurrente1==Concurrente),select=c("Ausentismo2",vector_variables))
    indicador_nacional<-1
    tabla_resultados1<-subset(subset(tabla_datos,Concurrente1==Concurrente),select=c(vector_variables,"Ausentismo2",
    "Llave.Casilla","NOMBRE_ESTADO.x","iD_ESTADO.x","ID_DISTRITO.x","SECCION","ID_CASILLA","TIPO_CASILLA","EXT_CONTIGUA"))
  }else{
    tabla_entrena1<-subset(subset(tabla_datos,NOMBRE_ESTADO.x==Entidad,select=c("Ausentismo2",vector_variables)))
    indicador_nacional<-0
    Concurrente<-unique(tabla_datos$Concurrente1[which(tabla_datos$NOMBRE_ESTADO.x==Entidad)])
    tabla_resultados1<-subset(subset(tabla_datos,NOMBRE_ESTADO.x==Entidad,select=c(vector_variables,"Ausentismo2",
    "Llave.Casilla","NOMBRE_ESTADO.x","iD_ESTADO.x","ID_DISTRITO.x","SECCION","ID_CASILLA","TIPO_CASILLA","EXT_CONTIGUA")))
  }
  
  
  inTraining <- createDataPartition(tabla_entrena1$Ausentismo2, p = proporcion_entrena, list = FALSE)
  tabla_entrena2 <- tabla_entrena1[ inTraining,]
  n<-nrow(tabla_entrena2)
  var_expl<-ncol(tabla_entrena2)-1
  
  #-Defining data-
  data<-list("n"=n,"var_expl"=var_expl,"y"=tabla_entrena2$Ausentismo2)
  for(i in 1:var_expl){
    #i<-1
    data[[i+3]]<-as.array(tabla_entrena2[,i+1])
    
  }
  
  for( j in 1:var_expl){
    #j<-1
    names(data)[j+3]<-sprintf("x%i",j)
    
  }
  
  x<-matrix(nrow=n,ncol=var_expl)
  for( j in 1:var_expl){
    
    x[,j]<-data[[j+3]]
    
  }
  
  
  
  data2<-list("n"=n,"var_expl"=var_expl,"y"=tabla_entrena2$Ausentismo2,"x"=x)
  #-Defining inits-
  inits<-function(){list(alpha=0,beta=c(rep(0,var_expl)),yest=rep(0,n))}
  
  #-Selecting parameters to monitor-
  parameters<-c("alpha","beta","yest")
  
  if(modelo_jags1==1){
    modelo<-jags(data2,inits,
                 parameters,
                 model.file=modelo_binomial_logit,
                 n.iter=iteraciones_jags,
                 n.chains=1,n.burnin=calentamiento_jags)
    nombre_modelo = "el modelo binomial con liga logit"
  }else{
    modelo<-jags(data2,inits,
                 parameters,
                 model.file=modelo_binomial_probit,
                 n.iter=iteraciones_jags,
                 n.chains=1,n.burnin=calentamiento_jags)
    nombre_modelo = "el modelo binomial con liga probit"
    
  }
  modelo.summary<-modelo$BUGSoutput$summary
  head(modelo.summary)
  
  modelo.dic<-modelo$BUGSoutput$DIC
  e1<-data.frame(DIC=modelo.dic)
  e1
  
  if(Concurrente==0){tipo_elec="Federal"}else{tipo_elec="Concurrente"}
  
  var_predic<-names(tabla_entrena2)[2]
  if(length(names(tabla_entrena2))>2){
    for(i in 2:var_expl){
      var_predic<-paste(var_predic, names(tabla_entrena2)[i+1],sep=", ")
    }
  }
  
  #tabla datos de prueba
  tabla_no_entrenada<-tabla_entrena1[-inTraining,]
  #n de tabla prueba
  n2<-nrow(tabla_no_entrenada)  
  
  #-Defining data-
  data_prueba<-list("n"=n2,"var_expl"=var_expl,"y"=tabla_no_entrenada$Ausentismo2)
  for(i in 1:var_expl){
    #i<-1
    data_prueba[[i+3]]<-as.array(tabla_no_entrenada[,i+1])
    
  }
  
  for( j in 1:var_expl){
    #j<-1
    names(data_prueba)[j+3]<-sprintf("x%i",j)
    
  }
  
  x_prueba<-matrix(nrow=n2,ncol=var_expl)
  for( j in 1:var_expl){
    
    x_prueba[,j]<-data_prueba[[j+3]]
    
  }
  
  
  # x[i, ] %*% beta 
  
  
  if(Entidad=="NACIONAL"){
    titulo<-paste("Resultado de aplicar ",nombre_modelo,", utilizando una proporcion del: ",proporcion_entrena*100,"% del total de estados con elección ", tipo_elec," y utilizando como variables predictoras -> ", var_predic,":")
  }else{
    titulo<-paste("Resultado de aplicar ",nombre_modelo,", utilizando una proporcion del: ",proporcion_entrena*100,"% en la entidad de ", Entidad," y utilizando como variables predictoras -> ", var_predic,":")
  }
  
  
  Datos_entrenamiento_exportar<-tabla_resultados1[ inTraining,]
  Datos_prueba_exportar<-tabla_resultados1[ -inTraining,]
  
  return(list("Titulo"=titulo,
              "resumen"=modelo.summary,"DIC"=e1,"matriz_X"=x,"Tabla_no_usada"=tabla_no_entrenada,"Entidad"=Entidad,"TipoElec"=tipo_elec,
              "variables_explicativas"=var_predic,"tabla_entrena2"=tabla_entrena2,"matriz_X_prueba"=x_prueba,
              "tabla_resultados1"=tabla_resultados1,"vector_variables"=vector_variables,
              "Datos_entrenamiento_exportar"=Datos_entrenamiento_exportar,
              "Datos_prueba_exportar"=Datos_prueba_exportar))
}

plotear<-function(resumen_jags,tipo_de_liga="logit"){
  resumen_<-data.frame(resumen_jags$resumen)
  tabla_entrena2<-data.frame(resumen_jags$tabla_entrena2)
  y_estimadas<-resumen_[grep("yest",rownames(resumen_)),]
  titulo<-resumen_jags$Titulo
  
  betas<-resumen_[grep("beta",rownames(resumen_)),]
  
  coeficientes<-rbind(resumen_[1,],betas)
  coeficientes_final<-subset(coeficientes,select = c("mean","sd","X2.5.","X97.5."))
  
  names(coeficientes_final)<-c("Media","DE","cuantil 2.5%","cuantil 97.5%")
  names(coeficientes_final)<-c("Media","DE","lim.inf. 95%","lim. sup. 95%")
  
  medias_coef<-coeficientes_final$Media
  
  x<-resumen_jags$matriz_X
  x2<-matrix(cbind(rep(1,nrow(x)),x),ncol=ncol(x)+1)
  
  eta<-numeric(nrow(x))
  for(i in 1:nrow(x2))
    #i<-1
    for(j in 1:ncol(x2)){
      #j<-1
      eta[i]<-eta[i]+x2[i,j]*medias_coef[j]
      
    }
  if(tipo_de_liga=="logit"){
    
    p<-exp(eta)/(1+exp(eta))
    
  }else{
    
    p<-pnorm(eta)
  }
  
  
  tabla_comparativa<-data.frame(Y_Estimadas=y_estimadas$mean,Reales=tabla_entrena2$Ausentismo2,Combinacion_Lineal=eta)
  or2<-order(p)
  #   or3<-order(tabla_comparativa$Reales)
  #   t2<-data.frame(Probabilidad_ausentismo=p,tabla_comparativa)
  
  #   plot(p[or2],type="l",ylim=c(0,1.2),xlab="Casillas",ylab="Probabilidad de Ausentismo",main=resumen_jags$Entidad)
  #   points(tabla_comparativa$Reales[or2],cex=.5,col=2,type="p")  
  
  #   plot(p[or2],type="l",ylim=c(0,1.2),xlab="Casillas",ylab="Probabilidad de Ausentismo",main=titulo)
  #   points(tabla_comparativa$Reales[or2],cex=.5,col=2,type="p")
  
  plot(p[or2],type="l",ylim=c(0,1.2),xlab="Casillas
       (ordenadas segun el modelo de menor a mayor probabilidad)",ylab="Probabilidad de Ausentismo",main=paste("Comparativa de probabilidades de Ausentismo del modelo
vs Casos Reales"))
  points(tabla_comparativa$Reales[or2],cex=.5,col=2,type="p")
  #mtext(paste("(",resumen_jags$variables_explicativas,") ",tipo_de_liga,sep=""))
  
}

si_distintoCero<-function(numero){if(numero!=0){numero<-numero+1} 
  return(numero)}

concatenar_intervalo<-function(vector_de_inf_y_sup){
  
  intervalo<-paste("(",round(vector_de_inf_y_sup[1],2)," , ",round(vector_de_inf_y_sup[2],2),")",sep="")
  return(intervalo)
}

tablas_coeficientes<-function(resumen_jags,tipo_de_liga="logit"){
  #resumen_jags<-dataInput
  resumen_<-data.frame(resumen_jags$resumen)
  tabla_entrena2<-data.frame(resumen_jags$tabla_entrena2)
  betas<-resumen_[grep("beta",rownames(resumen_)),]
  coeficientes<-rbind(resumen_[1,],betas)
  coeficientes_final<-subset(coeficientes,select = c("mean","sd","X2.5.","X97.5."))
  names(coeficientes_final)<-c("Media","DE","cuantil 2.5%","cuantil 97.5%")
  names(coeficientes_final)<-c("Media","DE","Limite inferior del intervalo con 95% de probabilidad","Limite Superior del intervalo con 95% de probabilidad")
  
  medias_coef<-coeficientes_final$Media
  
  x<-resumen_jags$matriz_X
  x2<-matrix(cbind(rep(1,nrow(x)),x),ncol=ncol(x)+1)
  
  eta<-numeric(nrow(x))
  for(i in 1:nrow(x2)){
    #i<-1
    for(j in 1:ncol(x2)){
      #j<-1
      eta[i]<-eta[i]+x2[i,j]*medias_coef[j]
      
    }
  }
  
  
  ###Para la construccion de la tabla_resultados1
  #tabla_resultados1<-resumen_jags$tabla_resultados1
  tabla_resultados1<-as.matrix(resumen_jags$tabla_resultados1)
  tabla_resultados2<-matrix(cbind(rep(1,nrow(tabla_resultados1)),tabla_resultados1),ncol=ncol(tabla_resultados1)+1) ##Aqui ponemos 
  #colnames(tabla_resultados1)
  colnames(tabla_resultados2)<-c("constante",colnames(tabla_resultados1))
  ## una columna de 1's a la izquieda (antes) de las variables escogidas
  
  
  eta2<-numeric(nrow(tabla_resultados2))
  for(i in 1:nrow(tabla_resultados2)){
    #i<-1
    for(j in 1:ncol(x2)){       #### Aqui dejamos el x2 porque esa es la que tiene el numero de 
                                ####columnas igual al numero de variables que estaremos usando
                                #### mientras, que por el contrario, la tabla_resultados_2 tiene todos los campos para
                                #### la identificacion de la casilla que no se utilizaran en estos ciclos.
      #j<-1
      #class(tabla_resultados2[i,j])
      eta2[i]<-eta2[i]+as.numeric(tabla_resultados2[i,j])*medias_coef[j]
      
    }
  }
  
  
  if(tipo_de_liga=="logit"){
    
    p<-exp(eta)/(1+exp(eta))
    p_total<-exp(eta2)/(1+exp(eta2))
    
   }
    #else{
#     
#     p<-pnorm(eta)
#     p_total<-pnorm(eta2)
#     
#   }
  
  
  
  
  #tabla_comparativa<-data.frame(Y_Estimadas=y_estimadas$mean,Reales=tabla_entrena2$Ausentismo2,Combinacion_Lineal=eta)
  or2<-order(p)
  p1<-p[or2]
  
  or_total<-order(p_total,decreasing = TRUE)  ##Para que la tabla quede ordenada de mayor a menor probabilidad de ausentismo
  
  tabla_resultados2_1<-data.frame(tabla_resultados2)
  tabla_resultados2_1$Probabilidad_estimada<-p_total
  tabla_resultados3<-tabla_resultados2_1[or_total,]
  
  tabla_resultados4<-subset(tabla_resultados3,select=c("Llave.Casilla","Ausentismo2","Probabilidad_estimada"))

  
  #Ahora hagamos la tabla de coeficientes más adecuada. Ademas haremos dos tablas, una que se mostrá
  # y otra que se descarfará
  tabla_med_desest_y_lim_betas<-coeficientes_final
  
  opc2<-data.frame(variables=c("Intercepto","Porcentaje_Sustituciones", 
                               "porc_Rechazos","porc_NE",
                               "porc_Aptos","Casillas_x_CAE_escaladas",
                               "A1","B1","C1","Rural1",
                               "Urbana1", "Mixta1",
                               "porc_m_mesas","porc_h_mesas",
                               "porc_sin_e_mesas","porc_prim_mesas",
                               "porc_sec_mesas","porc_bach_mesas",
                               "porc_lic_mesas","edad_promedio_escalada_X_edo",
                               "edad_rango_escalada_X_edo",
                               "edad_promedio_escalada_Nacional",
                               "edad_rango_escalada_Nacional"))
  
  row.names(opc2)<-c("Intercepto","% Sustituciones", 
                     "% Rechazos","% NE",
                     "% Aptos","Casillas x CAE",
                     "Casilla A","Casilla B","Casilla C","Casilla Rural",
                     "Casilla Urbana", "Casilla Mixta",
                     "% Mujeres","% Hombres",
                     "% sin esolaridad","% con primaria",
                     "% con secundaria","% con bachillerato",
                     "% con licenciatura","Edad promedio de funcionarios (escalada por entidad)",
                     "Rango de edades de los funcionarios (escalada por entidad)",
                     "Edad promedio de funcionarios (escalada nacional)",
                     "Rango de edades de los funcionarios (escalada nacional)")
  
  data_variables<-data.frame(variables=resumen_jags$vector_variables)
  
  
  opc2$match <- match(opc2$variables,data_variables$variables, nomatch=0)
  match_matrix<-as.matrix(opc2$match)
  
  match_matrix2<-apply(match_matrix,1,FUN=si_distintoCero)
  match_matrix2[1]<-1 #por porner algun numero que ayude a que el cilo de abajo NO olvide tomar en cuenta al
  # Intercepto (alpha)
  opc2$match2<-match_matrix2
  
  betas_media<-numeric(nrow(opc2))
  betas_DesEst<-numeric(nrow(opc2))
  betas_LimInf<-numeric(nrow(opc2))
  betas_LimSup<-numeric(nrow(opc2))
  for (i in 1:nrow(opc2)){
    
    if(opc2$match2[i]!=0){
      betas_media[i]<-tabla_med_desest_y_lim_betas$Media[opc2$match2[i]]
      betas_DesEst[i]<-tabla_med_desest_y_lim_betas$DE[opc2$match2[i]]
      betas_LimInf[i]<-tabla_med_desest_y_lim_betas$`Limite inferior del intervalo con 95% de probabilidad`[opc2$match2[i]]
      betas_LimSup[i]<-tabla_med_desest_y_lim_betas$`Limite Superior del intervalo con 95% de probabilidad`[opc2$match2[i]]
    }
    
  }
  opc2$betas_media<-betas_media
  opc2$betas_DesEst<-betas_DesEst
  opc2$betas_LimInf<-betas_LimInf
  opc2$betas_LimSup<-betas_LimSup
  
  matrix_limites<-matrix(cbind(opc2[[6]],opc2[[7]]),ncol=2)
  
  columna_intervalos<-apply(matrix_limites,1,FUN=concatenar_intervalo)
  opc2$columna_intervalos<-columna_intervalos
  
  names(opc2)[4]<-"Pesos de las variables" 
  names(opc2)[5]<-"Desviación estándar"
  names(opc2)[6]<-"Limite inferior del intervalo con 95% de probabilidad" 
  names(opc2)[7]<-"Limite Superior del intervalo con 95% de probabilidad" 
  names(opc2)[8]<-"Intervalos del 95% de probabilidad"
  
  opc2_1<-subset(opc2,select=c("Pesos de las variables",
                               "Limite inferior del intervalo con 95% de probabilidad",
                               "Limite Superior del intervalo con 95% de probabilidad",
                               "Intervalos del 95% de probabilidad")) #Esto es lo que se exportara con el boton de descargar respectivo
  opc2_2<-subset(subset(opc2_1,select=c("Pesos de las variables","Intervalos del 95% de probabilidad"),
                        `Pesos de las variables`!=0)) #Esto se mostrara en pantalla
  
  
  
  
  
  
  return(list("coeficientes_final"=coeficientes_final,"Probabilidad_mayor"=p1[length(p)],
              "Propocion_de_Ausentismo"=mean(tabla_entrena2$Ausentismo2),
              "Casillas_con_predicciones_de_probabilidad_de_Ausentismo"=tabla_resultados3,
              "Casillas_con_predicciones_de_probabilidad_de_Ausentismo_compacta"=tabla_resultados4,
              "coeficientes_final_2_1"=opc2_1,"coeficientes_final_2_2"=opc2_2))
}

tabla_umbrales<-function(coeficientes_final_2_2,umbral_probabilidad){
  
  umbrales_x<-numeric(nrow(coeficientes_final_2_2)-1) #se quita uno porque el la tabla tiene 
                                          # tantas filas como variables más una que es del intercerpto
  for(i in 1:length(umbrales_x)){
    
    umbrales_x[i]<-round((logit(umbral_probabilidad)-coeficientes_final_2_2$`Pesos de las variables`[1])/coeficientes_final_2_2$`Pesos de las variables`[i+1],2) #nos brincarnos una fila por el intercepto
    
  }
  
  umbrales_1<-coeficientes_final_2_2[-1,]
  umbrales_1$`Umbrales para cada variable`<-umbrales_x #para descargar
  umbrales_1_2<-subset(umbrales_1,select="Umbrales para cada variable") #para mostrar en pantalla
  
  return(list("umbrales_1"=umbrales_1,"umbrales_1_2"=umbrales_1_2))
  
}
#Tabla_no_usada

plotear_datos_prueba<-function(resumen_jags,tipo_de_liga="logit"){
  resumen_<-data.frame(resumen_jags$resumen)
  tabla_prueba<-data.frame(resumen_jags$Tabla_no_usada)
  #y_estimadas2<-resumen_[grep("yest",rownames(resumen_)),]
  titulo<-resumen_jags$Titulo
  
  betas<-resumen_[grep("beta",rownames(resumen_)),]
  
  coeficientes<-rbind(resumen_[1,],betas)
  coeficientes_final<-subset(coeficientes,select = c("mean","sd","X2.5.","X97.5."))
  
  names(coeficientes_final)<-c("Media","DE","cuantil 2.5%","cuantil 97.5%")
  names(coeficientes_final)<-c("Media","DE","lim.inf. 95%","lim. sup. 95%")
  
  medias_coef<-coeficientes_final$Media
  
  x_prueba<-resumen_jags$matriz_X_prueba
  x2_prueba<-matrix(cbind(rep(1,nrow(x_prueba)),x_prueba),ncol=ncol(x_prueba)+1)
  
  eta<-numeric(nrow(x_prueba))
  for(i in 1:nrow(x2_prueba))
    #i<-1
    for(j in 1:ncol(x2_prueba)){
      #j<-1
      eta[i]<-eta[i]+x2_prueba[i,j]*medias_coef[j]
      
    }
  if(tipo_de_liga=="logit"){
    
    p<-exp(eta)/(1+exp(eta))
    
  }else{
    
    p<-pnorm(eta)
  }
  
  
  tabla_comparativa<-data.frame(
    #Y_Estimadas=y_estimadas2$mean,
    Reales=tabla_prueba$Ausentismo2,Combinacion_Lineal=eta)
  or2<-order(p)
  #   or3<-order(tabla_comparativa$Reales)
  #   t2<-data.frame(Probabilidad_ausentismo=p,tabla_comparativa)
  
  #   plot(p[or2],type="l",ylim=c(0,1.2),xlab="Casillas",ylab="Probabilidad de Ausentismo",main=resumen_jags$Entidad)
  #   points(tabla_comparativa$Reales[or2],cex=.5,col=2,type="p")  
  
  #   plot(p[or2],type="l",ylim=c(0,1.2),xlab="Casillas",ylab="Probabilidad de Ausentismo",main=titulo)
  #   points(tabla_comparativa$Reales[or2],cex=.5,col=2,type="p")
  
  plot(p[or2],type="l",ylim=c(0,1.2),xlab="Casillas
       (ordenadas segun el modelo de menor a mayor probabilidad)",ylab="Probabilidad de Ausentismo",main=paste("Comparativa de probabilidades de Ausentismo del modelo
vs Casos Reales para los datos de prueba"))
  points(tabla_comparativa$Reales[or2],cex=.5,col=2,type="p")
  #mtext(paste("(",resumen_jags$variables_explicativas,") ",tipo_de_liga,sep=""))
  
}

Calcular_Matriz_confusion<-function(resumen_jags,tipo_de_liga="logit",umbral=0.5){
  resumen_<-data.frame(resumen_jags$resumen)
  tabla_prueba<-data.frame(resumen_jags$Tabla_no_usada)
  #y_estimadas2<-resumen_[grep("yest",rownames(resumen_)),]
  #titulo<-resumen_jags$Titulo
  
  betas<-resumen_[grep("beta",rownames(resumen_)),]
  
  coeficientes<-rbind(resumen_[1,],betas)
  coeficientes_final<-subset(coeficientes,select = c("mean","sd","X2.5.","X97.5."))
  
  names(coeficientes_final)<-c("Media","DE","cuantil 2.5%","cuantil 97.5%")
  names(coeficientes_final)<-c("Media","DE","lim.inf. 95%","lim. sup. 95%")
  
  medias_coef<-coeficientes_final$Media
  
  x_prueba<-resumen_jags$matriz_X_prueba
  x2_prueba<-matrix(cbind(rep(1,nrow(x_prueba)),x_prueba),ncol=ncol(x_prueba)+1)
  
  x_prueba<-resumen_jags$matriz_X_prueba
  x2_prueba<-matrix(cbind(rep(1,nrow(x_prueba)),x_prueba),ncol=ncol(x_prueba)+1)
  
  eta<-numeric(nrow(x_prueba))
  for(i in 1:nrow(x2_prueba))
    #i<-1
    for(j in 1:ncol(x2_prueba)){
      #j<-1
      eta[i]<-eta[i]+x2_prueba[i,j]*medias_coef[j]
      
    }
  if(tipo_de_liga=="logit"){
    
    p<-exp(eta)/(1+exp(eta))
    
  }else{
    
    p<-pnorm(eta)
  }
  
  tabla_comparativa<-data.frame(
    #Y_Estimadas=y_estimadas2$mean,
    Reales=tabla_prueba$Ausentismo2,Probabilidad_estimada=p)
  #or2<-order(p)
  data_real_ausentismo<-subset(tabla_comparativa,Reales==1)
  data_real_NO_ausentismo<-subset(tabla_comparativa,Reales==0)
  
  verdaderos_positivos<-length(data_real_ausentismo$Probabilidad_estimada[which(data_real_ausentismo$Probabilidad_estimada>=umbral)])
  falsos_negativos<-length(data_real_ausentismo$Probabilidad_estimada[which(data_real_ausentismo$Probabilidad_estimada<=umbral)])
  falsos_positivos<-length(data_real_NO_ausentismo$Probabilidad_estimada[which(data_real_NO_ausentismo$Probabilidad_estimada>=umbral)])
  verdaderos_negativos<-length(data_real_NO_ausentismo$Probabilidad_estimada[which(data_real_NO_ausentismo$Probabilidad_estimada<=umbral)])
  
  matriz_confusion<-matrix(ncol=2,nrow=2)
  colnames(matriz_confusion)<-c("Positivos predichos", "Negativos predichos")
  rownames(matriz_confusion)<-c("Positivos Reales","Negativos reales")
  
  matriz_confusion[1,1]<-verdaderos_positivos
  matriz_confusion[1,2]<-falsos_negativos
  matriz_confusion[2,1]<-falsos_positivos
  matriz_confusion[2,2]<-verdaderos_negativos
  
  mat_conf<-as.data.frame(matriz_confusion)
  
  return(mat_conf)
}


################################################################
shinyServer(function(input, output,session) {
  
  plot_proporcion_Ausentismo<-plot_proporcion_Ausentismo()
  plot_cantidad_Ausentismo<-plot_cantidad_Ausentismo()
  plot_cantidad_Casillas<-plot_cantidad_Casillas()
  tabla<-tabla()
  
  #set.seed(122)
  output$map <- renderPlot({
    
    if(input$var=="Proporcion de Casillas con Ausentismo"){
      ggplot() + geom_polygon(data = plot_proporcion_Ausentismo, 
                              aes(x =long, 
                                  y = lat, 
                                  group = plot_proporcion_Ausentismo[[6]],
                                  fill = Proporcion_de_casillas_con_Ausentismo), 
                              color = "black", size = 0.25)+
        scale_fill_gradient(low = "yellow1", high = "firebrick3")
      
    }else if(input$var=="Cantidad de Casillas con Ausentismo"){
      
      ggplot() + geom_polygon(data = plot_cantidad_Ausentismo, 
                              aes(x =long, 
                                  y = lat, 
                                  group = plot_cantidad_Ausentismo[[6]],
                                  fill = Cantidad_de_casillas_con_Ausentismo), 
                              color = "black", size = 0.25)+
        scale_fill_gradient(low ="palegreen", high = "turquoise4")
      
    }else if(input$var=="Cantidad de Casillas"){
      ggplot() + geom_polygon(data = plot_cantidad_Casillas, 
                              aes(x =long, 
                                  y =lat, 
                                  group = plot_cantidad_Casillas[[6]],
                                  fill = Cantidad_de_casillas), 
                              color = "black", size = 0.25)+
        scale_fill_gradient(low = "lightcyan", high = "dodgerblue3")
      
    }
    
  })
  
  dataInput <- reactive({
    if(input$liga==3){
      preparar_datos_MH(tabla_datos=tabla,Entidad=input$Entidad,Concurrente=input$TipoElec,
                        proporcion_entrena = input$Proporcion,vector_variables=input$checkGroup,
                        iteraciones_MH=input$IteracionesMH,
                        calentamiento_jags = input$CalentamientoJags,modelo_MH=1)
    }else{
    preparar_datos(tabla_datos=tabla,Entidad=input$Entidad,Concurrente=input$TipoElec,
                   proporcion_entrena = input$Proporcion,vector_variables=input$checkGroup,
                   iteraciones_jags=input$IteracionesMH,
                   calentamiento_jags = input$CalentamientoJags,modelo_jags1 = input$liga)
    }
   
  })
  
  tablasInput <- reactive({
    if(input$liga==3){
      tablas_coeficientes_MH(dataInput())
    }else{
      tablas_coeficientes(dataInput())
    }
    
  })
  
  umbralesInput <- reactive({
  
    tabla_umbrales(coeficientes_final_2_2=tablasInput()$coeficientes_final_2_2,umbral_probabilidad=input$umbral)
    
  })
  
  plotInput <- reactive({
    if(input$liga==1){
      plotear(dataInput())
    }else if(input$liga==2){
      plotear(dataInput(),tipo_de_liga="probit")
    }else{
      plotear_MH(dataInput())
    }
  })
  
  output$plot1 <- renderPlot({
    print(plotInput())
  })
  
  ##Ploteo de los datos de prueba con el modelo

  plotInput2 <- reactive({
    if(input$liga==1){
      plotear_datos_prueba(dataInput())
    }else if(input$liga==2){
      plotear_datos_prueba(dataInput(),tipo_de_liga="probit")
    }else{
      plotear_MH(dataInput())
    }
  })
  
  output$plot2 <- renderPlot({
    print(plotInput2())
  })  
  
  output$sumario<-renderPrint({
    sumario<-dataInput()$Titulo
    sumario
  })
  
  output$tabla_resumen<-renderTable({
    
    tablasInput()$coeficientes_final
  
  })
  
  output$tabla_resumen_2_1<-renderTable({
    
    tablasInput()$coeficientes_final_2_1
    
  })
  
  output$tabla_resumen_2_2<-renderTable({
    
    tablasInput()$coeficientes_final_2_2
    
  })
  
  output$tabla_final_casillas_ordenadas<-renderDataTable({
    
    tablasInput()$Casillas_con_predicciones_de_probabilidad_de_Ausentismo_compacta
    
  }, options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  
  output$umbrales_1_2<-renderTable({
    
    umbralesInput()$umbrales_1_2
    
  })
  
  output$downloadData1 <- downloadHandler(
    filename = function() { 
      paste(input$Entidad,"_Casillas_con_probabilidades_de_ausentismo_",dataInput()$variables_explicativas,100*input$Proporcion,
            "-",100*(1-input$Proporcion),'.csv', sep='') 
    },
    content = function(file) {
      write.csv(tablasInput()$Casillas_con_predicciones_de_probabilidad_de_Ausentismo, file)
    }
  )
  
  output$downloadData2 <- downloadHandler(
    filename = function() { 
      paste(input$Entidad,"_Pesos_variables_",dataInput()$variables_explicativas,100*input$Proporcion,
            "-",100*(1-input$Proporcion),'.csv', sep='') 
    },
    content = function(file) {
      write.csv(tablasInput()$coeficientes_final_2_1, file)
    }
  )
  
  output$downloadData3 <- downloadHandler(
    filename = function() { 
      paste(input$Entidad,"_Datos_Entrenamiento_",dataInput()$variables_explicativas,100*input$Proporcion,
            "-",100*(1-input$Proporcion),'.csv', sep='') 
    },
    content = function(file) {
      write.csv(dataInput()$Datos_entrenamiento_exportar, file)
    }
  )
  
  output$downloadData4 <- downloadHandler(
    filename = function() { 
      paste(input$Entidad,"_Datos_Prueba_",dataInput()$variables_explicativas,100*input$Proporcion,
            "-",100*(1-input$Proporcion),'.csv', sep='') 
    },
    content = function(file) {
      write.csv(dataInput()$Datos_prueba_exportar, file)
    }
  )
  
  output$downloadData5 <- downloadHandler(
    filename = function() { 
      paste(input$Entidad,"_Umbrales_Variables_para_",100*input$umbral,"%_de_prob_de_ausentismo_",
            dataInput()$variables_explicativas,100*input$Proporcion,
            "-",100*(1-input$Proporcion),'.csv', sep='') 
    },
    content = function(file) {
      write.csv(umbralesInput()$umbrales_1, file)
    }
  )
    
#   output$tabla_resumen<-renderTable({
#     if(input$liga==3){
#     tablas_coeficientes_MH(dataInput())$coeficientes_final
#   }else{
#     tablas_coeficientes(dataInput())$coeficientes_final
#   }
#   })
#   
#   output$tabla_final_casillas_ordenadas<-renderTable({
#     if(input$liga==3){
#       tablas_coeficientes_MH(dataInput())$Casillas_con_predicciones_de_probabilidad_de_Ausentismo
#     }else{
#       tablas_coeficientes(dataInput())$Casillas_con_predicciones_de_probabilidad_de_Ausentismo
#     }
#   })
#   
  
  
  prep_matrizConfu_Input<-reactive({
    
    Calcular_Matriz_confusion(dataInput(),tipo_de_liga="logit",umbral=input$umbral)
    
  })
  
  output$mat_conf<-renderTable({
    #     dataset<-data.frame(DIC=dataInput()$DIC,Probabilidad_maxima=tablas_coeficientes(dataInput())$Probabilidad_mayor,Proporcion_Casillas_Con_Ausentismo_en_el_ambito=tablas_coeficientes(dataInput())$Propocion_de_Ausentismo)
    #     names(dataset)<-c("DIC","Probabilidad predica más alta","Propoción de Casillas con Ausentismo en el ámbito de análisis")
    #     dataset
    print(prep_matrizConfu_Input())
  })
  
  comparativaInput<-reactive({
    if(input$liga==1){
      dataset<-data.frame(DIC=dataInput()$DIC,Probabilidad_maxima=tablas_coeficientes(dataInput())$Probabilidad_mayor,Proporcion_Casillas_Con_Ausentismo_en_el_ambito=tablas_coeficientes(dataInput())$Propocion_de_Ausentismo)
      names(dataset)<-c("DIC","Probabilidad predicha más alta","Propoción de Casillas con Ausentismo en el ámbito de análisis")
      dataset
    }else if(input$liga==2){
      dataset<-data.frame(DIC=dataInput()$DIC,Probabilidad_maxima=tablas_coeficientes(dataInput(),tipo_de_liga="probit")$Probabilidad_mayor,Proporcion_Casillas_Con_Ausentismo_en_el_ambito=tablas_coeficientes(dataInput(),tipo_de_liga="probit")$Propocion_de_Ausentismo)
      names(dataset)<-c("DIC","Probabilidad predicha más alta","Propoción de Casillas con Ausentismo en el ámbito de análisis")
      dataset
    }else{
      dataset<-data.frame(Probabilidad_maxima=tablas_coeficientes(dataInput())$Probabilidad_mayor,Proporcion_Casillas_Con_Ausentismo_en_el_ambito=tablas_coeficientes(dataInput())$Propocion_de_Ausentismo)
      names(dataset)<-c("Probabilidad predicha más alta","Propoción de Casillas con Ausentismo en el ámbito de análisis")
      dataset
      
    }
  })
  
  output$comparativa<-renderTable({
    #     dataset<-data.frame(DIC=dataInput()$DIC,Probabilidad_maxima=tablas_coeficientes(dataInput())$Probabilidad_mayor,Proporcion_Casillas_Con_Ausentismo_en_el_ambito=tablas_coeficientes(dataInput())$Propocion_de_Ausentismo)
    #     names(dataset)<-c("DIC","Probabilidad predica más alta","Propoción de Casillas con Ausentismo en el ámbito de análisis")
    #     dataset
    print(comparativaInput())
  })
  
  observe({
   
    if (input$radio==1) {
      updateTabsetPanel(session,inputId= "inTabset", selected = "panel1")
    }else {
      updateTabsetPanel(session,inputId= "inTabset", selected = "panel2")
    }
  })
  
  
  
  
})
  

################################################################
# ESTIMATION OF A MEAN
# X <- as.matrix(cbind(1,iris[,2:4]))
# Y <- iris[ ,1]
# 
# nsim <- 10000
# init <- c(1,1,1,1,10)
# mh.y <- MHBayes(nsim, theta0=init, objdens1, proposal1, X, Y)
# estims <- mh.y$theta
# 
# simulacionesY<-SimulacionesYest(estims,X)
# sim<-simulacionesY$Simulaciones
# medias_sim<-simulacionesY$Medias_Simulaciones
# 
# plot(Y,medias_sim,xlim=c(4,8),ylim=c(3,11))
# abline(a=0,b=1)
