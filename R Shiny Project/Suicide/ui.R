shinyUI(dashboardPage(
  dashboardHeader(title = "Suicide & Happiness Report"),
  
  
  dashboardSidebar(
    sidebarUserPanel("Mental Health Day",
                     image = "https://www.rtggroup.co.uk/wp-content/uploads/2018/10/World-Mental-Health.jpg"),
    #Adding photo on the sidebar...make it round too
    sidebarMenu(
      menuItem("Dashboard",
               tabName = "dashboard",
               icon = icon('align-justify')
      ),
      menuItem('World Map',
               tabName = 'world_map',
               icon = icon('map')
      ),
      menuItem(
        'Generation',
        tabName = 'generation',
        icon = icon('pagelines')
      ),
      menuItem("Raw data",
               tabName = "rawdata",
               icon = icon('database')
      )
      
    ),
    #Adding dropdown menu inside sidebar
    selectizeInput("country",
                   "Select Country to Display",
                   choices = unique(df$country))
  ),
  
  dashboardBody(#How to connect it to get data from the dropdown menu?
    # fluidRow(
    #     # Dynamic infoBoxes
    #     #Need to make them work somehow, as of now they don't
    #     infoBoxOutput("Percentageofsuicides"),
    #     infoBoxOutput("AnnualGDP"),
    #     infoBoxOutput("GDPPerCapita")
    # ),
    
    tabItems(
      tabItem(tabName = "dashboard",
              fluidPage(column(width = 12,
                box(width = 12,
                    plotOutput("year_plot"))
              ))),
      tabItem(tabName = "world_map",
              # the fluid row needs to be in the tabItem
              selectInput("year", "Select a year", choices = unique(df$year[order(df$year)])),
              fluidRow(box(htmlOutput("world_map")))),
      
      tabItem(tabName = 'generation',
              fluidRow( 
                # Dynamic infoBoxes
                #Need to make them work somehow, as of now they don't
                infoBoxOutput("statBox", width = 6),
                infoBoxOutput("maxBox", width = 6)
              ),
              
              fluidRow(
                box(
                  width = 6,
                  offset = 4,
                  selectizeInput('generation', 'Choose Generation', choices = unique(df$generation))
                ),
                box(
                  width = 6,
                  offset = 8,
                  selectInput('sex', 'Male Vs. Female', choices = unique(df$sex)) # needs to be unique or we get all the values in the column
                  # Can't have two widgets with the same name!
                )
              ),
              fluidRow(box(width = 12,
                           plotOutput('gen_plot')))
          ),
      tabItem(tabName = "rawdata")
      
    )
  )
))


