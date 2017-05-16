library(shiny)
library(shinydashboard)


indicador_unzip<-function(indicador){
  if(indicador==0){
    print("generando consulta a S3")
    res<-read.csv(
      "indicadores/indicador_unzip.csv",
      #   textConnection(getURL(
      # "https://s3-us-west-2.amazonaws.com/vis4googlet/indicador_unzip.csv")),
      header=T)$indicador
  }else{
    print("consultas a S3 concluidas")
    res<-indicador
  }
  return(res)
}

indicador_agruparbusquedas<-function(indicador){
  if(indicador==0){
    print("generando consulta a S3")
    res<-read.csv(
      "indicadores/indicador_agruparbusquedas.csv",
      #   textConnection(getURL(
      # "https://s3-us-west-2.amazonaws.com/vis4googlet/indicador_agruparbusquedas.csv")),
      header=T)$indicador
  }else{
    print("consultas a S3 concluidas")
    res<-indicador
  }
  return(res)
}

indicador_uptodasbusquedas<-function(indicador){
  if(indicador==0){
    print("generando consulta a S3")
    res<-read.csv(
      "indicadores/indicador_uptodasbusquedas.csv",
      #   textConnection(getURL(
      # "https://s3-us-west-2.amazonaws.com/vis4googlet/indicador_uptodasbusquedas.csv")),
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
    res<-read.csv(
      "indicadores/indicador_uptodasubicaciones.csv",
      #   textConnection(getURL(
      # "https://s3-us-west-2.amazonaws.com/vis4googlet/indicador_uptodasubicaciones.csv")),
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
    res<-read.csv(
      "indicadores/indicador_uptodosmails.csv",
      #   textConnection(getURL(
      # "https://s3-us-west-2.amazonaws.com/vis4googlet/indicador_uptodosmails.csv")),
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
    res<-read.csv(
      "indicadores/indicador_preprocbusquedas_fin.csv",
      #   textConnection(getURL(
      # "https://s3-us-west-2.amazonaws.com/vis4googlet/indicador_preprocbusquedas_fin.csv")),
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
    res<-read.csv(
      "indicadores/indicador_preprocubicaciones_fin.csv",
      #   textConnection(getURL(
      # "https://s3-us-west-2.amazonaws.com/vis4googlet/indicador_preprocubicaciones_fin.csv")),
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
    res<-read.csv(
      "indicadores/indicador_preprocmails_fin.csv",
      #   textConnection(getURL(
      # "https://s3-us-west-2.amazonaws.com/vis4googlet/indicador_preprocmails_fin.csv")),
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
    res<-read.csv(
      "indicadores/indicador_analisisbusquedas_fin.csv",
      #   textConnection(getURL(
      # "https://s3-us-west-2.amazonaws.com/vis4googlet/indicador_analisisbusquedas_fin.csv")),
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
    res<-read.csv(
      "indicadores/indicador_analisisubicaciones_fin.csv",
      #   textConnection(getURL(
      # "https://s3-us-west-2.amazonaws.com/vis4googlet/indicador_analisisubicaciones_fin.csv")),
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
    res<-read.csv(
      "indicadores/indicador_analisismails_fin.csv",
      #   textConnection(getURL(
      # "https://s3-us-west-2.amazonaws.com/vis4googlet/indicador_analisismails_fin.csv")),
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
    res<-read.csv(
      "indicadores/indicador_recomendaciones_fin.csv",
      #   textConnection(getURL(
      # "https://s3-us-west-2.amazonaws.com/vis4googlet/indicador_recomendaciones_fin.csv")),
      header=T)$indicador
  }else{
    print("consultas a S3 concluidas")
    res<-indicador
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