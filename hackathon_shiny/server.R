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
  # Name Panel
  output$panel_one <- renderUI({
    conditionalPanel(
      condition = "input.next_button > '-1'",
      box(
        title = "Generate your corporation's name:",
        solidHeader = TRUE,
        f.generate_random_name(3),
        width = 12
      )
    )
  })
  output$panel_two <- renderUI({
    conditionalPanel(
      condition = "input.next_button > '0'",
      box(
        title = "Locate your local intermediary:",
        solidHeader = TRUE,
        selectInput("country_select", label = "Originating Country:", selected = "",
                    choices = c("", sort(unique(as.character(intermed_countries$ent_countries))))),
        conditionalPanel(
          condition = "input.country_select != ''",
          renderDataTable({
            f.get_intermediaries(country = input$country_select, 5)
          }, escape = FALSE, options = list(paging = FALSE, searching = FALSE))
        ),
        width = 12
      )
    )
  })
  output$panel_three <- renderUI({
    conditionalPanel(
      condition = "input.next_button > '1'",
      box(as.character(input$next_button))
    )
  })
  
})
