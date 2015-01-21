library(shiny)
library(jsonlite)


cities.file <- "data/cities.json" # https://health.data.ny.gov/resource/food-service-establishment-inspections-beginning-2005-active-.json?$select=facility_city&$group=facility_city&$order=facility_city&$limit=2000
cities <- fromJSON(cities.file)
rests <- data.frame()

shinyUI(fluidPage(
   titlePanel("Inspection Violations"),
   sidebarLayout(
      sidebarPanel(p("Food Service Establishments - New York"), 
                   img(src="restaurant_sign.jpg",height=300,width=300),
                   selectizeInput("city",
                                  label="Select a city in New York",
                                  choices=cities$facility_city,
                                  options=list(
                                     placeholder='Select One',
                                     onInitialize = I('function() { this.setValue(""); }'))
                                  ),
                   selectizeInput("rest",
                                  label="Select a Restaurant",
                                  choices=rests,
                                  options=list(
                                     placeholder='Select One',
                                     onInitialize = I('function() { this.setValue(""); }'))
                                  ),
                   tags$div(class="header", checked=NA,
                            tags$a(href="http://www.health.ny.gov/regulations/nycrr/title_10/part_14/subpart_14-1.htm", "Source: New York State DOH")
                            )
      ),
      mainPanel(
         p("Choose a city and restaurant to see the violations from the last inspection."),
         strong(textOutput("city")),
         strong(textOutput("rest")),
         strong(textOutput("date")),
         br(),
         tableOutput("mytable")
         )
      )
   )
   )
