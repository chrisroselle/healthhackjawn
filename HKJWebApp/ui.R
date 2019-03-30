# Define Header--------
header <- dashboardHeader(title = "HealthJawns")

#Define Sidebar -------------
sidebar <- dashboardSidebar(width = 250,
                            sidebarMenu(
                              id = "tabs",
                              menuItem(
                                text = "Prediction",
                                tabName = "prediction",
                                icon = icon('map-marker')
                              ),
                              menuItem(
                                text = "Analysis",
                                tabName = "analysis",
                                icon = icon('map-marker')
                                ),
                              menuItem(
                                text = "Info",
                                tabName = "info",
                                icon = icon('map-marker')
                              )
                            ))
# Video Output -------------
videoOutput = function(id,width = '100%',height= "100%"){
  
  #640, 480
  
  ns = NS(id)
  video_id = ns("video")
  button_id = ns("snap")
  canvas_id = ns("canvas")
  tagList(
    tags$video(id = video_id,
               width = width,
               height = height,
               autoplay = NA
    ),
    tags$button(id = button_id,"Snap Photo"),
    tags$canvas(id = canvas_id,width = 640,height = 480,style = "display:none"),
    tags$script(src = "CamJS.js")
  )
}

# Define Body -------------------
prediction <- tabItem("prediction",
                      useShinyjs(),
                      fluidRow(box(solidHeader =  TRUE,
                          width = 6,
                          collapsible = TRUE,
                          videoOutput("test"))
                          )
                      )


body <- dashboardBody(tabItems(prediction))

ui <- dashboardPage(title = "HealthJawns",header,sidebar,body)