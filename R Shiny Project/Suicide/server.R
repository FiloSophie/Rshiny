shinyServer(function(input, output){
    
    output$year_plot <- renderPlot({
      # generate plot that shows total suicides per year
      df %>%
        filter(country == input$country) %>%
        group_by(year) %>%
        summarise(total_suicides = sum(suicides_no)) %>%
        ggplot() +
        geom_line(aes(x = year, y = total_suicides)) +
        geom_point(aes(x = year, y = total_suicides))
        ### ADD TITLE HERE ###
        #+ ggtitle()
    })
    
    output$gen_plot <- renderPlot({
      # generate histobar plot that shows distribution of suicide based on age group
      df %>%
        filter(country == input$country, sex == input$sex, generation == input$generation) %>%
        ggplot(aes(
          # fill = !!sym(input$generation),
          x = year,
          y = suicides_no
        )) +
        geom_bar(poc sition = 'dodge', stat = 'identity') +
        ggtitle(paste(input$sex, 'Generation', paste0('"',input$generation,'"'), "Suicides in", input$country))
    })

    
    #Dynamic Infobox
    #####################################################
    ########Beggining of fucking MAHEM #################
    
    #This should be showing the percentage of suicides
    
    output$statBox = renderInfoBox({
      global_stats = df %>%
        select(year, population, suicides_no) %>%
        group_by(year) %>%
        summarise(total_pop = sum(population),
                  total_suicides = sum(suicides_no),
                  percentage = (total_suicides/total_pop)*100)
      infoBox(title = '%', global_stats, icon = icon("hand-o-up"))
    })

    output$maxBox <- renderInfoBox({
      max_value <- df %>% 
        filter(country == input$country, generation == input$generation, sex == input$sex) %>% 
        group_by(year) %>% 
        summarise(total_pop = sum(population),
                  total_suicides = sum(suicides_no),
                  percentage = (total_suicides/total_pop)*100) %>% 
        select(year, percentage) %>% 
        arrange(desc(percentage)) %>% 
        top_n(1)

      infoBox(paste("Most Suicides in:", max_value$year),
              paste("Suicide Percent of Country Pop.:", paste0(round(max_value$percentage, 5), "%")),
              icon = icon("hand-o-up"))
    })
    ############### END ####################
    
    
    # GoogleVis global map
    output$world_map <- renderGvis({
      
      df %>%
        filter(year == input$year) %>% #, sex == input$sex2, generation == input$generation2
        group_by(country) %>% 
        summarise(total_suicides = sum(suicides_no)) %>% 
        gvisGeoChart(
          country,
          options = list(
            region = "world",
            displayMode = "regions",
            resolution = "countries",
            width = "auto",
            height = "auto"
          )
        )
    })
    
    
    
    # using width="auto" and height="auto" to
    # automatically adjust the map size
    
    # show statistics using infoBox
    # output$Percentageofsuicides <- renderInfoBox({
    #     perc<- "Percentage", paste0( input$)
    #max_state <-
    #state_stat$state.name[state_stat[,input$selected] == max_value]
    #infoBox(max_state, max_value, icon = icon("hand-o-up"))
    # })
    #     output$minBox <- renderInfoBox({
    #         min_value <- min(state_stat[,input$selected])
    #         min_state <-
    #             state_stat$state.name[state_stat[,input$selected] == min_value]
    #         infoBox(min_state, min_value, icon = icon("hand-o-down"))
    #     })
    #     output$avgBox <- renderInfoBox(
    #         infoBox(paste("AVG.", input$selected),
    #                 mean(state_stat[,input$selected]),
    #                 icon = icon("calculator"), fill = TRUE))
})
