library(shiny)
library(shinydashboard)
library(RCurl)

path<-"https://s3-us-west-2.amazonaws.com/dpaequipo10/indicadores/"

indicador_unzip<-function(){
  if(file.exists("/tmp/todo_googlet.zip")){
    return(1)
  }else{
    return(0)}
}

indicador_agruparbusquedas<-function(){
  if(file.exists("/tmp/todas_busquedas.json")){
    return(1)
  }else{
    return(0)}
}

indicador_uptodasbusquedas<-function(indicador){
  if(indicador==0){
    print("generando consulta a S3")
    res<-read.csv(textConnection(getURL(
      paste(path,"indicador_uptodasbusquedas.csv",sep=""))),
      header=T)$indicador
  }else{
    print("consultas a S3 concluidas")
    res<-indicador
  }
  return(res)
}

indicador_uptodasubicaciones<-function(indicador){
  if(indicador==0){
    print("generando consulta a S3")
    res<-read.csv(textConnection(getURL(
      paste(path,"indicador_uptodasubicaciones.csv",sep=""))),
      header=T)$indicador
  }else{
    print("consultas a S3 concluidas")
    res<-indicador
  }
  return(res)
}

indicador_uptodosmails<-function(indicador){
  if(indicador==0){
    print("generando consulta a S3")
    res<-read.csv(textConnection(getURL(
      paste(path,"indicador_uptodosmails.csv",sep=""))),
      header=T)$indicador
  }else{
    print("consultas a S3 concluidas")
    res<-indicador
  }
  return(res)
}

indicador_preprocbusquedas_fin<-function(indicador){
  if(indicador==0){
    print("generando consulta a S3")
    res<-read.csv(textConnection(getURL(
      paste(path,"indicador_preprocbusquedas_fin.csv",sep=""))),
      header=T)$indicador
  }else{
    print("consultas a S3 concluidas")
    res<-indicador
  }
  return(res)
}

indicador_preprocubicaciones_fin<-function(indicador){
  if(indicador==0){
    print("generando consulta a S3")
    res<-read.csv(textConnection(getURL(
      paste(path,"indicador_preprocubicaciones_fin.csv",sep=""))),
      header=T)$indicador
  }else{
    print("consultas a S3 concluidas")
    res<-indicador
  }
  return(res)
}

indicador_preprocmails_fin<-function(indicador){
  if(indicador==0){
    print("generando consulta a S3")
    res<-read.csv(textConnection(getURL(
      paste(path,"indicador_preprocmails_fin.csv",sep=""))),
      header=T)$indicador
  }else{
    print("consultas a S3 concluidas")
    res<-indicador
  }
  return(res)
}

indicador_analisisbusquedas_fin<-function(indicador){
  if(indicador==0){
    print("generando consulta a S3")
    res<-read.csv(textConnection(getURL(
      paste(path,"indicador_analisisbusquedas_fin.csv",sep=""))),
      header=T)$indicador
  }else{
    print("consultas a S3 concluidas")
    res<-indicador
  }
  return(res)
}

indicador_analisisubicaciones_fin<-function(indicador){
  if(indicador==0){
    print("generando consulta a S3")
    res<-read.csv(textConnection(getURL(
      paste(path,"indicador_analisisubicaciones_fin.csv",sep=""))),
      header=T)$indicador
  }else{
    print("consultas a S3 concluidas")
    res<-indicador
  }
  return(res)
}

indicador_analisismails_fin<-function(indicador){
  if(indicador==0){
    print("generando consulta a S3")
    res<-read.csv(textConnection(getURL(
      paste(path,"indicador_analisismails_fin.csv",sep=""))),
      header=T)$indicador
  }else{
    print("consultas a S3 concluidas")
    res<-indicador
  }
  return(res)
}

indicador_recomendaciones_fin<-function(indicador){
  if(indicador==0){
    print("generando consulta a S3")
    res<-read.csv(textConnection(getURL(
      paste(path,"indicador_recomendaciones_fin.csv",sep=""))),
      header=T)$indicador
  }else{
    print("consultas a S3 concluidas")
    res<-indicador
  }
  return(res)
}

dibujandomapa<-function(indicador){
  if(indicador==0){
    print("generando otra vez la carga del archivo")
    res<-'cosa.html'
  }else{
  print("ya se descarga de s3")
  res<-'mapa.html'
  }
  return(res)
}

# indicador_preprocbusquedas_inicio<-function(indicador){
#   if(indicador==0){
#     print("generando consulta a S3")
#     res<-read.csv(
#       "indicadores/indicador_preprocbusquedas_inicio.csv",
#       #   textConnection(getURL(
#       # "https://s3-us-west-2.amazonaws.com/vis4googlet/indicador_preprocbusquedas_inicio.csv")),
#       header=T)$indicador
#   }else{
#     print("consultas a S3 concluidas")
#     res<-indicador
#   }
#   return(res)
# }

# indicador_preprocubicaciones_inicio<-function(indicador){
#   if(indicador==0){
#     print("generando consulta a S3")
#     res<-read.csv(
#       "indicadores/indicador_preprocubicaciones_inicio.csv",
#       #   textConnection(getURL(
#       # "https://s3-us-west-2.amazonaws.com/vis4googlet/indicador_preprocubicaciones_inicio.csv")),
#       header=T)$indicador
#   }else{
#     print("consultas a S3 concluidas")
#     res<-indicador
#   }
#   return(res)
# }

# indicador_preprocmails_inicio<-function(indicador){
#   if(indicador==0){
#     print("generando consulta a S3")
#     res<-read.csv(
#       "indicadores/indicador_preprocmails_inicio.csv",
#       #   textConnection(getURL(
#       # "https://s3-us-west-2.amazonaws.com/vis4googlet/indicador_preprocmails_inicio.csv")),
#       header=T)$indicador
#   }else{
#     print("consultas a S3 concluidas")
#     res<-indicador
#   }
#   return(res)
# }