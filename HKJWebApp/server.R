library(shiny)

getImage = function(input,output,session,
                    magick_object = FALSE,
                    returnRaw = FALSE){
  #Function returns the image as a png 
  ns = session$ns
  
  runjs(paste0("camJS('",ns(""),"');"))
  
  getImg <- function(txt,magick_object = FALSE) {
    txt = gsub("^.*?,","",txt)
    raw <- base64Decode(txt, mode="raw")
    if (all(as.raw(c(0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a))==raw[1:8])) { # it's a png...
      if(magick_object){
        img = magick::image_read(raw)
      }else{
        img <- png::readPNG(raw)
      }
      
      # transparent <- img[,,4] == 0
      # img <- as.raster(img[,,1:3])
      # img[transparent] <- NA
      return(img)
    } else if (all(as.raw(c(0xff, 0xd8, 0xff, 0xd9))==raw[c(1:2, length(raw)-(1:0))])) { # it's a jpeg...
      img <- jpeg::readJPEG(raw)
    } else stop("No Image!")
  }
  
  image = eventReactive(input$image,{
    
    image = getImg(input$image,magick_object = magick_object)
    
    return(list(raw = input$image,image = image))
  })
  
  return(image)
}

server <- function(input,output,session){
  runjs(paste0("getLocation();"))
  
  image = callModule(getImage,"test",magick_object = TRUE)
  
  observe({
    req(image())
    
    # fileConn <- file("output.txt")
    # writeLines(image()$raw, fileConn)
    # close(fileConn)
    
    showModal(modalDialog(
      title = "Calculating",
      "Processing Results!",
      footer = NULL,
      size = "m",
      easyClose = TRUE
    ))
    
    #Port 8080 blocked in building, works on servers
    request <- tryCatch({
      httr::POST(url = credentials$api_endpoint,
                 body = list(b64_image = image()$raw),
                 encode = "json")
    },error = function(e){
      shinyalert("Error","Problem Sending Data to Server",html = TRUE)
      return(400)
    })
    
    removeModal()
    
    if(status_code(request) == 200){
      happy <- c("🤗","🎉","🤩","😇","😎")
      medium <- c("🤭","😲","😣","🤨","🤔")
      sad <- c("💩","😰","☹️","🤒","🤮")

      randNum <- sample(1:5,1)
      
      content <- jsonlite::fromJSON(content(request, type = "text"))

      if(content$diagnosis_code %in% c("NV","BKL","DF","VASC")){
        emoji <- happy[randNum]
      }else if(content$diagnosis_code %in% c("IN","AKIEC")){
        emoji <- medium[randNum]
      }else if(content$diagnosis_code %in% c("MEL","BCC")){
        emoji <- sad[randNum]
      }else{
        emoji <- "No Response Found"
      }
      
      cat(content$diagnosis_code,"\n")
      cat(content$diagnosis_detail,"\n")
      
      
      showModal(modalDialog(
        title = emoji,
        paste(content$diagnosis_detail,content$confidence),
        footer = NULL,
        size = "m",
        easyClose = TRUE
      ))
      
      #shinyalert(paste0("<p style='font-size:70px;'>",emoji,"</p>"),paste(content$diagnosis_detail,content$confidence),html = TRUE)
      
    }

    
  })
  
  observeEvent(input$key,{
    if(input$key == 97){
      shinyalert("<p style='font-size:70px;'>💩</p>", "Oh no...",html = TRUE)
    }else if(input$key == 98){
      shinyalert("<p style='font-size:70px;'>🎉</p>","Hooray!",html = TRUE)
    }
  })
  
  
  card_swipe <- callModule(shinyswipr, "quote_swiper")
  
  observeEvent(card_swipe(),{
    print(card_swipe()) #show last swipe result. 
  }) 
  
  # Location
  
  output$maps <- renderLeaflet({
    req(input$location)
    
    lon <- input$location[["lon"]]
    lat <- input$location[["lat"]]
    
    #make api call
    search_results <- httr::GET("https://api.yelp.com/v3/businesses/search",
                      config = add_headers(Authorization = paste("Bearer",credentials$yelp_key)),
                      query = list(term = "dermatologist",
                                   latitude = lat,
                                   longitude = lon))
    

    search_results <- data.frame(jsonlite::fromJSON(content(search_results, type = "text")))
    
    if(nrow(search_results) == 0){
      shinyalert("No Businesses Found","No Skin Care Specialists in the Area",type = "error")
    }
    
    current_location <- makeAwesomeIcon(icon= 'flag', markerColor = 'red', iconColor = 'black')
    businesses <- makeAwesomeIcon(icon = "user-md", marker = "blue", iconColor = 'black')
    
    labels = sprintf(
      "Name: %s
      <br/> Location: %s
      <br/> Phone: %s",
      search_results$businesses.name,
      search_results$businesses.location$address1,
      search_results$businesses.phone
    )%>%
      lapply(htmltools::HTML)
    
    map <- leaflet()%>%
      addTiles()%>%
      addAwesomeMarkers(lng = lon,lat = lat,popup = "You are Here",icon = current_location)%>%
      addAwesomeMarkers(lng = search_results$businesses.coordinates$longitude, 
                        lat = search_results$businesses.coordinates$latitude,
                        popup = labels,
                        icon = businesses)
    
    return(map)
      
  })
  
}