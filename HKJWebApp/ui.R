# Define Header--------
header <- dashboardHeader(title = "SherlockAI")

#Define Sidebar -------------
sidebar <- dashboardSidebar(width = 250,
                            sidebarMenu(
                              id = "tabs",
                              menuItem(
                                text = "Prediction",
                                tabName = "prediction",
                                icon = icon('bar-chart')
                              ),
                              menuItem(
                                text = "Info",
                                tabName = "info",
                                icon = icon('info')
                              ),
                              menuItem(
                                text = "Map",
                                tabName = "map",
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

#Predictions Tab ----------------
prediction <- tabItem("prediction",
                      tags$script('
    $(document).on("keypress", function (e) {
       Shiny.onInputChange("key", e.which);
    });
  '),
                      useShinyjs(),
                      useShinyalert(),
                      includeCSS("stylesheet.css"),
                      fluidRow(box(solidHeader =  TRUE,
                          width = 7,
                          collapsible = TRUE,
                          videoOutput("test"))
                          )
                      )

# More Info Tab ---------------
moreInfo = function(title,link,description){
    column(6,
           div(class = "info-container",
               style = "width: 100%;",
               tags$header(class = "metadata classification",
                           style = "background:#994646; color: white; height: 60px;",
                           h3(class = "title",
                              style = "padding-top:15px; padding-left:15px",
                              title)),
               div(class = "description",
                   style = "height: 85px; background: #e0dede; padding-top:15px; padding-left:15px",
                   tags$p(description),
                   tags$p(),
                   tags$a(href = link,"Click Here for More.")
               )
           )
        )
  
}

info <- tabItem("info",
                h1(style = "font-weight:900;",
                   "Additional Information"),
                fluidRow(
                  moreInfo("American Cancer Society",
                           "https://www.cancer.org/cancer/skin-cancer/prevention-and-early-detection.html",
                           "All you need to know about skin cancer starting from Causes, Riskfactors, Prevention to Treatment."),
                  moreInfo("National Cancer Institute",
                           "https://www.cancer.gov/about-cancer/treatment/clinical-trials/disease/skin-cancer/treatment",
                           "Clinical Trials on effective ways to Detect Skin Cancer."),
                  moreInfo("St. Jude Childrens Hospital",
                           "https://www.stjude.org/disease/melanoma.html",
                           "More information of the Treatment of Melanoma on Children."),
                  moreInfo("Skin Care Foundation",
                           "https://www.aad.org/public/diseases/bumps-and-growths/moles/moles-in-children",
                           "Expert guides, Early Detection and Tips on Proactive Preventive Measures."),
                  moreInfo("Center for Desiese Control and Prevention",
                           "https://www.cdc.gov/spanish/especialescdc/cancerpiel/index.html",
                           "Skin Protection from Cancer, Spanish artical by the CDC."),
                  moreInfo("Science Daily",
                           "https://www.sciencedaily.com/releases/2018/07/180705113940.htm",
                           "Additional Research on Skin Cancer Detection Applications.")
                )
              )

# Game ---------

maps = tabItem("map",
               tags$script(src = "Location.js"),
               leafletOutput("maps")
               )

body <- dashboardBody(tabItems(prediction,info,maps))

ui <- dashboardPage(title = "HealthJawns",skin = 'red',header,sidebar,body)