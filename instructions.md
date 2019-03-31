## Instructions to run ShinyApp Locally

1. Install R and RStudio
2. Install all the packages given in HKJWebApp/global.R
3. Set up YELP API key and include it in a config.yml file as shown format shown below
4. Run Application with `shiny::runApp(launch.browser = TRUE)`

### Sample config.yml file
**note the additional new line after the last line is important**
The api_end point is used to communicate with the python ML servers.

default:
    yelp_key: <Your YELP API KEY>
    api_endpoint: 'http://ec2-52-14-190-7.us-east-2.compute.amazonaws.com:8080/api/result'
    
## To Access the Running Web Application

The application is deployed to shinyapps.io a free to use hosting service by RStudio with preconfigered Shiny servers. Follow the following link to access the deployed application: https://sakash.shinyapps.io/hkjwebapp/
