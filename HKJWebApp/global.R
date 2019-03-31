suppressPackageStartupMessages({
  library(shiny)
  library(shinydashboard)
  library(shinyjs)
  library(RCurl)
  library(magick)
  library(png)
  library(shiny)
  library(shinyalert)
  library(leaflet)
  library(shinysense)
  library(config)
  library(httr)
  library(shinycssloaders)
  library(jsonlite)
  library(tidyverse)
})

#Read YELP API credentials. Do NOT sync the config file with github

credentials <- config::get()
