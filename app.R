#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(reactable)
library(Rawg)



# Define UI for application
ui <- tagList(

    tags$style("@import url(https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css);"),

    navbarPage(

        title = "Rawg Demo",

        tabPanel(

            title = "Search Game",

            fluidPage(

                # Application title
                fluidRow(
                    column(12, align="center",
                           p(strong("Note:"), "This is a demo of what can be achieved using the package Rawg."),
                           p("Have a look on the package", a("README", href="https://github.com/rabiibouhestine/Rawg/blob/master/README.md", target="_blank"), "and the", a("RAWG API documentation", href="https://rawg.io/apidocs", target="_blank"), "to see how to use the different functions in the package.")
                    ),
                ),

                br(),

                # Sidebar with a slider input for number of bins
                fluidRow(
                    column(6, offset = 3,
                           textInput(inputId="term", label=NULL, value="", width="100%", placeholder="Search game... The first 20 results from RAWG API will display in the table below..")
                    )
                ),

                br(),

                # Show a plot of the generated distribution
                fluidRow(
                    column(6, offset = 3,
                           reactableOutput("table")
                    )
                )

            )

        )

    ),

    tags$script(HTML("var header = $('.navbar > .container-fluid');
                       header.append('<div style=\"float:right;margin-top:15px;margin-left:10px;\"><a target=\"_blank\" href=\"https://github.com/rabiibouhestine/Rawg-demo\"><i class=\"fa fa-code\"></i> Source</a></div>');
                       console.log(header)")),

    tags$script(HTML("var header = $('.navbar > .container-fluid');
                       header.append('<div style=\"float:right;margin-top:15px;margin-left:10px;\"><a target=\"_blank\" href=\"https://github.com/rabiibouhestine/Rawg\"><i class=\"fa fa-github\"></i> Rawg</a></div>');
                       console.log(header)")),

)
















# Define server logic required to draw a histogram
server <- function(input, output) {

    output$table <- renderReactable({

        data <- games_list("https://rabiibouhestine.shinyapps.io/rawg-demo/", search=input$term)

        data <- data[c("background_image", "name", "released", "rating", "metacritic")]

        reactable(data,
                  columns = list(
                      background_image = colDef(
                          cell = function(value, index){
                              div(
                                  img(
                                      src = gsub("media/games", "media/resize/420/-/games", value),
                                      style = list(height="50px", width="80px")
                                  )
                              )
                          },
                          name = "Cover"
                      ),
                      name = colDef(
                          width = 300,
                          name = "Name"
                      ),
                      released = colDef(
                          name = "Release Date"
                      ),
                      rating = colDef(
                          name = "RAWG Rating"
                      ),
                      metacritic = colDef(
                          name = "MetaCritic"
                      )
                  )
        )
    })
}

# Run the application
shinyApp(ui = ui, server = server)
