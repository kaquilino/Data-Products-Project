library(shiny)
library(jsonlite)
inspections.file <- "data/inspections.json" #https://health.data.ny.gov/resource/cnih-y5dw.json
inspections <- fromJSON(inspections.file)

shinyServer(function(input, output,session) {
   react.rests <- reactive({
      #rests <- fromJSON(paste('https://health.data.ny.gov/resource/food-service-establishment-inspections-beginning-2005-active-.json?$select=facility&$group=facility&$order=facility&facility_city=',URLencode(input$city),'&$limit=900',sep=""))
      rests <- subset(inspections,city==input$city,select=facility)
      rests$facility <- as.factor(rests$facility)
      rests <- levels(rests$facility)
      updateSelectizeInput(session,"rest",choices=rests)
   })
   
   react.insp <- reactive({
      subset(inspections,facility==input$rest,select=c(date,violations))
   })
   
   output$mytable <- renderTable({      
      if (input$rest>="1") {
         i <- react.insp()
         v <- unlist(strsplit(i$violations[1],"Item\\s+[0-9A-Z-]*\\s+"))
         data.frame(Violations=v[v != ""])}
      })
   
   output$city <- renderText({
      if (input$city>="1") {
         react.rests()
         paste("City: ",input$city)
      }
   })
   
   output$rest <- renderText({
      if (input$rest>="1") paste("Food Service Facility: ",input$rest)
   })
   output$date <- renderText({
      if (input$rest>="1") {
         i <- react.insp()
         paste("Last Inspection Date: ",substr(i$date[1],1,10))
      }
   })
})
