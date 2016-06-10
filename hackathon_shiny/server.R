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
        h2(paste0(f.generate_random_name(3))),
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
          DT::dataTableOutput("intermediary_table"),
          conditionalPanel(
            condition = "input.intermediary_table_row_last_clicked >= '1'",
            renderText({
              paste0("You've chosen to enlist the services of ",
                     f.get_intermediaries(country = input$country_select, 5)$Intermediary[as.integer(input$intermediary_table_row_last_clicked)],
                     ". He/She has facilitated the creation of at least ",
                     f.get_intermediaries(country = input$country_select, 5)$CorpsSetupPreviously[as.integer(input$intermediary_table_row_last_clicked)],
                     " offshore corporations.")
            })
          )
        ),
        width = 12
      )
    )
  })
  output$intermediary_table <- DT::renderDataTable({
    DT::datatable(f.get_intermediaries(country = input$country_select, 5), selection = "single", escape = FALSE,
                  options = list(paging = FALSE, searching = FALSE))
  })
  
  output$panel_three <- renderUI({
    pictures <- f.get_pictures(3)
    conditionalPanel(
      condition = "input.next_button > '1'",
      box(title = "Choose your corporation's jurisdiction:",
        fluidRow(
          column(3,
                 #h2(paste0(pictures$jurisdiction_description[1])),
                 h2(paste0(1), align="center"),
                 img(src = pictures$beach_url[1], width="100%")),
          column(3, offset = 1,
                 #h2(paste0(pictures$jurisdiction_description[2])),
                 h2(paste0(2), align="center"),
                 img(src = pictures$beach_url[2], width="100%")),
          column(3, offset = 1,
                 #h2(paste0(pictures$jurisdiction_description[3])),
                 h2(paste0(3), align="center"),
                 img(src = pictures$beach_url[3], width="100%"))
        ),
        selectInput("jurisdiction_select", label = "Choose your jurisdiction:", selected = "",
                    choices = c("", "1"=1,"2"=2,"3"=3)),
        conditionalPanel(
          condition = "input.jurisdiction_select != ''",
          h3(paste0("Excellent choice!\n")),
          renderText({
            paste0("You've chosen ", pictures$jurisdiction_description[as.integer(input$jurisdiction_select)], "!")
          }),
          renderText({
            paste0(pictures$n[as.integer(input$jurisdiction_select)],
                    " Offshore corporations are currently active in that area!")
          })
        ),
        width = 12
      )
    )
  })
  
})
