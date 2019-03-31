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
  image = callModule(getImage,"test",magick_object = TRUE)
  
  # observe({
  #   req(image())
  #   
  #   image_write(image()$image,path = "test.png",format = "png")
  # })
  
  observe({
    req(input$key)
    if(input$key == 97){
      shinyalert("<p style='font-size:70px;'>💩</p>", "Oh no...",html = TRUE)
    }else if(input$key == 98){
      shinyalert("<p style='font-size:70px;'>🎉</p>","Hooray!",html = TRUE)
    }
    
    
    card_swipe <- callModule(shinyswipr, "quote_swiper")
    
    observeEvent(card_swipe(),{
      print(card_swipe) #show last swipe result. 
    }) 
    
  })
}