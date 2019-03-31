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
                                text = "Info",
                                tabName = "info",
                                icon = icon('map-marker')
                              ),
                              menuItem(
                                text = "Game",
                                tabName = "game",
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
                          width = 6,
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
                           "https://www.cancer.org/cancer/melanoma-skin-cancer/about.html",
                           "More Information about the effect and prevention of Melanoma"),
                  moreInfo("SkinCancer.Org",
                           "https://www.skincancer.org/prevention/skin-cancer-and-skin-of-color-reference",
                           "Some more Information"),
                  moreInfo("SkinCancer.Org",
                           "https://www.skincancer.org/prevention/skin-cancer-and-skin-of-color-reference",
                           "Some more Information"),
                  moreInfo("SkinCancer.Org",
                           "https://www.skincancer.org/prevention/skin-cancer-and-skin-of-color-reference",
                           "Some more Information"),
                  moreInfo("SkinCancer.Org",
                           "https://www.skincancer.org/prevention/skin-cancer-and-skin-of-color-reference",
                           "Some more Information"),
                  moreInfo("SkinCancer.Org",
                           "https://www.skincancer.org/prevention/skin-cancer-and-skin-of-color-reference",
                           "Some more Information")
                )
              )

# Game ---------

maps = tabItem("maps",
               leafletOutput("maps")
               )

body <- dashboardBody(tabItems(prediction,info,game))

ui <- dashboardPage(title = "HealthJawns",skin = 'red',header,sidebar,body)