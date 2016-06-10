#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Panel steps
  output$panel_one <- renderUI({
    conditionalPanel(
      condition = "input.next_button > '-1'",
      box(as.character(input$next_button))
    )
  })
  output$panel_two <- renderUI({
    conditionalPanel(
      condition = "input.next_button > '0'",
      box(as.character(input$next_button))
    )
  })
  output$panel_three <- renderUI({
    conditionalPanel(
      condition = "input.next_button > '1'",
      box(as.character(input$next_button))
    )
  })
  
})
