library(shiny)
library(shinydashboard)

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
                  menuItem("Paper", tabName = "paper", icon = icon("file-pdf-o")),
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
                                   image = "images/lal.png"),
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
                          div(style = "height:2000px; width:100%", includeHTML("intro.html"))),
                  
                  # Recommender Tab
                  # tabItem(tabName = "recom", 
                  #         div(style = "height:300px; width:100%", includeHTML("cosa.html"))),
                  
                  tabItem(tabName = "recom",uiOutput('mymap'),
                          helpText(a("mapa",
                                     href="https://s3-us-west-2.amazonaws.com/dpaequipo10/resultado/mapa.html",
                                     target="_blank"))
                  #         tags$iframe(
                  #   srcdoc = paste(readLines('mapa.html'), collapse = '\n'),
                  #   width = "100%",
                  #   height = "600px"
                  # )
                  ),
                          #htmlOutput("inc")),
                  
                  tabItem(tabName = "datafile",
                          style = "overflow-y:scroll;",
                          box(width = 12, height = "100px", #title = "User Inputs",
                              fileInput('file1', "Choose your .zip file with your Google's locations, serches and mails",
                                        accept = c(
                                          '.zip'
                                        )
                              )),
                          box(width = 12, height = "150px",
                              valueBoxOutput("progressBoxtodo",width = 12)),
                          box(width = 6, height = "150px", title = "Unzip",
                              infoBoxOutput("progressBox1",width = 6)),
                          box(width = 6, height = "150px", title = "All Up",#mails up",
                              valueBoxOutput("progressBox5",width = 6)),
                          box(width = 6, height = "150px", title = "Preproc's done",#mails",
                              valueBoxOutput("progressBox8",width = 6)),
                          # box(width = 6, height = "150px", title = "Analysis locations",
                          #     valueBoxOutput("progressBox10",width = 6)),
                          box(width = 6, height = "150px", title = "Analysis done",#mails",
                              valueBoxOutput("progressBox11",width = 6)),
                          box(width = 6, height = "150px", title = "Recommender",
                              valueBoxOutput("progressBox12",width = 6))    
                      
                          # # box(width = 15, height = "400px", title = "Progress",
                          # #     infoBox("All searches", 1, icon = icon("street-view"), fill = TRUE),
                          # box(width = 7, height = "200px", title = "All searches ready",
                          # valueBoxOutput("progressBox2",width = 7)),
                          # box(width = 7, height = "200px", title = "All searches up ",
                          #     valueBoxOutput("progressBox3",width = 7)),
                          # box(width = 7, height = "200px", title = "All locations up",
                          #     valueBoxOutput("progressBox4",width = 7)),
                          # box(width = 7, height = "200px", title = "Preproc searches",
                          #     valueBoxOutput("progressBox6",width = 7)),
                          # box(width = 7, height = "200px", title = "Preproc locations",
                          #     valueBoxOutput("progressBox7",width = 7)),
                          # box(width = 7, height = "200px", title = "Analysis searches",
                          #     valueBoxOutput("progressBox9",width = 7)),
                          # 

                  # ),
                  # 
                  # tabItem(tabName = "datafile",
                  #          style = "overflow-y:scroll;",
                  #          box(width = 15, height = "400px", title = "User Inputs",
                  #   infoBox("New Orders", 10 * 2, icon = icon("credit-card"), fill = TRUE),
                  #   infoBoxOutput("progressBox2"),
                  #   infoBoxOutput("approvalBox2")
                  #          )
                  )

                  )
                  )
                  )

