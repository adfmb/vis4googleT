library(shiny)
library(shinydashboard)
# library(shinyjs)
# jsResetCode <- "shinyjs.reset = function() {history.go(0)}"

dashboardPage(title = "Go and Google Yourself!",
              skin = ("blue"),
              dashboardHeader(title = "Go & Google yourself",
                              
                              # Email Sharing link
                              tags$li(class = "dropdown",
                                      tags$a(href = "mailto:?Subject=Go Google Yourself&Body=Visualize the life you've build on Google's world... and let us suggest you one thing or two... ",
                                             tags$img(height = "18px", 
                                                      src = "images/email.png")
                                      )
                              ),
                              
                              # Twitter Sharing Link
                              tags$li(class = "dropdown",
                                      tags$a(href = "http://twitter.com/share?text=Go Google Yourself&Body=Visualize the life you've build on Google's world... and let us suggest you one thing or two... http://https://www.facebook.com/Go-google-yourself-1991980714370104/?ref=br_rs", 
                                             target = "_blank", 
                                             tags$img(height = "18px", 
                                                      src = "images/twitter.png")
                                      )
                              ),
                              
                              # Facebook Sharing link
                              tags$li(class = "dropdown",
                                      tags$a(href = "http://www.facebook.com/sharer.php?u=https://www.facebook.com/Go-google-yourself-1991980714370104/?ref=br_rs", 
                                             target = "_blank", 
                                             tags$img(height = "18px", 
                                                      src = "images/facebook.png")
                                      )
                              ),
                              
                              # LinkedIn Sharing link
                              tags$li(class = "dropdown",
                                      tags$a(href = "http://www.linkedin.com/shareArticle?mini=true&url=https://www.facebook.com/Go-google-yourself-1991980714370104/?ref=br_rs", 
                                             target = "_blank", 
                                             tags$img(height = "18px", 
                                                      src = "images/linkedin.png")
                                      )
                              )
              ),
              
              dashboardSidebar(
                sidebarMenu(
                  menuItem("Introduction", tabName = "intro", icon = icon("home")),
                  menuItem("Data", tabName = "datafile", icon = icon("table")),
                  menuItem("Analysis", tabName = "analysis", icon = icon("binoculars")),
                  menuItem("Pipeline", tabName = "pip", icon = icon("file-pdf-o")),
                  menuItem("Recommender", tabName = "recom", icon = icon("microphone")),
                  menuItem("About", tabName = "about", icon = icon("info")),
                  hr(),
                  sidebarUserPanel(name = a("Alfredo M", target = "_blank_",
                                            href = "https://github.com/adfmb"), 
                                   subtitle = "Data Scientist",
                                   image = "images/adf.png"),
                  sidebarUserPanel(name = a("Pedro H", target = "_blank_",
                                            href = "https://github.com/pedrohserrano"), 
                                   subtitle = "Data Scientist",
                                   image = "images/pit.png"),
                  sidebarUserPanel(name = a("Eduardo M", target = "_blank_",
                                            href = "https://github.com/eduardomtz"), 
                                   subtitle = "Computer Scientist",
                                   image = "images/lal02.png"),
                  sidebarUserPanel(name = a("Alain C", target = "_blank_",
                                            href = "https://github.com/acabrerag"), 
                                   subtitle = "Data Scientist",
                                   image = "images/ala.png"),
                  hr(),
                  menuItem("Source code", icon = icon("file-code-o"), 
                           href = "https://github.com/adfmb/vis4googleT"),
                  menuItem("Bug Reports", icon = icon("bug"),
                           href = "https://github.com/adfmb/vis4googleT/issues")
                )
              ),
              
              dashboardBody(
                tags$head(includeScript("www/js/google-analytics.js"),
                          HTML('<link rel="apple-touch-icon" sizes="57x57" href="icons/apple-icon-57x57.png">
                               <link rel="apple-touch-icon" sizes="60x60" href="icons/apple-icon-60x60.png">
                               <link rel="apple-touch-icon" sizes="72x72" href="icons/apple-icon-72x72.png">
                               <link rel="apple-touch-icon" sizes="76x76" href="icons/apple-icon-76x76.png">
                               <link rel="apple-touch-icon" sizes="114x114" href="icons/apple-icon-114x114.png">
                               <link rel="apple-touch-icon" sizes="120x120" href="icons/apple-icon-120x120.png">
                               <link rel="apple-touch-icon" sizes="144x144" href="icons/apple-icon-144x144.png">
                               <link rel="apple-touch-icon" sizes="152x152" href="icons/apple-icon-152x152.png">
                               <link rel="apple-touch-icon" sizes="180x180" href="icons/apple-icon-180x180.png">
                               <link rel="icon" type="image/png" sizes="192x192"  href="icons/android-icon-192x192.png">
                               <link rel="icon" type="image/png" sizes="32x32" href="icons/favicon-32x32.png">
                               <link rel="icon" type="image/png" sizes="96x96" href="icons/favicon-96x96.png">
                               <link rel="icon" type="image/png" sizes="16x16" href="icons/favicon-16x16.png">
                               <link rel="manifest" href="icons/manifest.json">
                               <meta name="msapplication-TileColor" content="#ffffff">
                               <meta name="msapplication-TileImage" content="icons/ms-icon-144x144.png">
                               <meta name="theme-color" content="#ffffff">')),
                tabItems(
                  # Introduction Tab
                  tabItem(tabName = "intro", 
                          div(style = "height:2800px; width:100%", includeHTML("intro.html"))),
                  
                  
                  tabItem(tabName = "datafile",
                          style = "overflow-y:scroll;",
                          box(width = 12, height = "130px", #title = "User Inputs",
                              actionButton("awsc", "Active yours credentials"),
                              
                              fileInput('file1', "Choose your .zip file with your Google's locations, serches and mails",
                                        accept = c('.zip'))),
                          box(width = 12, height = "150px",
                              valueBoxOutput("progressBoxtodo",width = 12)),
                          box(width = 6, height = "150px", title = "Unzip",
                              infoBoxOutput("progressBox1",width = 6)),
                          box(width = 6, height = "150px", title = "All Up",#mails up",
                              valueBoxOutput("progressBox5",width = 6)),
                          box(width = 6, height = "150px", title = "Preproc's done",#mails",
                              valueBoxOutput("progressBox8",width = 6)),
                          box(width = 6, height = "150px", title = "Analysis done",#mails",
                              valueBoxOutput("progressBox11",width = 6)),
                          box(width = 6, height = "150px", title = "Recommender",
                              valueBoxOutput("progressBox12",width = 6)),
                          box(width = 6, height = "150px", title = "Have fun one more time",
                              actionButton("go", "Reset All"))),
                          # box( width = 6, height = "150px", title = "Shutdown",
                          #      useShinyjs(),                                           # Include shinyjs in the UI
                          #      extendShinyjs(text = jsResetCode),                      # Add the js code to the page
                          #      actionButton("reset_button", "Reset Page"))),
                  
                  tabItem(tabName = "analysis",
                          style = "overflow-y:scroll;",
                          box(width = 15, height = "500px",
                              plotOutput("plot"))),
                          
                  tabItem(tabName = "pip",
                          img(src="images/pipeline.png", height = 700, width = 1200)),

                  tabItem(tabName = "recom",
                          div(style = "height:500px; width:120%", htmlOutput("mymap")),#includeHTML("mymap")),#"mapa.html")),
                          style = "overflow-y:scroll;",
                          box(width = 15, height = "150px", title = "Better view...",
                              helpText(a("mapa",
                                     href="https://s3-us-west-2.amazonaws.com/dpaequipo10/resultado/mapa.html",
                                     target="_blank")),
                              helpText(a("luigi",
                                     href="http://54.186.247.137:8082/static/visualiser/index.html",
                                     target="_blank")),
                              helpText(a("versión beta (exposición) en aws",
                                     href="http://52.27.55.98:3838",
                                     target="_blank"))
                          )
                          )

                  )
                  )
                  )

