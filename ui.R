library(shiny)
library(jsonlite)


cities.file <- "data/cities.json" # https://health.data.ny.gov/resource/food-service-establishment-inspections-beginning-2005-active-.json?$select=facility_city&$where=food_service_description=%27Restaurant%27&$group=facility_city&$order=facility_city&$limit=2000
cities <- fromJSON(cities.file)
rests <- data.frame()

shinyUI(fluidPage(
   titlePanel("New York Restaurant Inspection Violations"),
   sidebarLayout(
      sidebarPanel(img(src="restaurant_sign.jpg",height=300,width=300),
                   selectizeInput("city",
                                  label="Select a city",
                                  choices=cities$facility_city,
                                  options=list(
                                     placeholder='Select One',
                                     onInitialize = I('function() { this.setValue(""); }'))
                                  ),
                   selectizeInput("rest",
                                  label="Select a restaurant",
                                  choices=rests,
                                  options=list(
                                     placeholder='Select One',
                                     onInitialize = I('function() { this.setValue(""); }'))
                                  )
      ),
      mainPanel(
         tags$div(class="header", checked=NA,
                  tags$a(href="http://www.health.ny.gov/regulations/nycrr/title_10/part_14/subpart_14-1.htm", "Source: New York State Department of Health")
         ),
         helpText("Choose a city and restaurant to see the violations from the last inspection."),
         strong(textOutput("city")),
         strong(textOutput("rest")),
         strong(textOutput("date")),
         br(),
         tableOutput("mytable")
         )
      )
   )
   )
