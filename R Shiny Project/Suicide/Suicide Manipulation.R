library(dplyr)
library(tidyverse)

df = read.csv('./suicide.csv')
male_group = suicide %>% 
  filter(sex == 'male') %>% 
  summarise(total = sum(suicides_no))

female_group = suicide %>% 
  filter(sex == 'female') %>% 
  summarise(total = sum(suicides_no))

age_group = suicide %>% 
  group_by(generation)


female_group
male_group

country_group = suicide %>% 
  group_by(country) %>% 
  summarise(total = sum(suicides_no))

country_group

colnames(suicide)

annual_gdp = suicide %>% 
  group_by(country, year) %>% 
  summarise(sum(`gdp_for_year ($)`))
annual_gdp  

capita_gdp = suicide %>% 
  group_by(country, year, sex) %>% 
  summarise(sum(`gdp_per_capita ($)`))

generation = suicide %>% 
  group_by()


df %>%
  filter(country == 'Albania') %>%
  ggplot(aes(fill=!!sym('sex'), x = year, y = suicides_no)) +
  geom_bar(position='dodge', stat='identity')

# generate histobar plot that shows distribution of suicide based on age group
df %>%
  filter(country == 'Greece') %>%
  ggplot(aes(fill=!!sym('generation'), x = year, y = suicides_no)) +
  geom_bar(position='dodge', stat='identity')

test = df %>% 
  select(year, population, suicides_no) %>% 
  group_by(year) %>% 
  summarise(total_pop = sum(population),
           total_suicides = sum(suicides_no),
           percentage = (total_suicides/total_pop)*100)

head(test)

test_2 = df %>% 
  filter(country == "Greece", generation == "Generation X", sex == "female") %>% 
  group_by(year) %>% 
  summarise(total_pop = sum(population),
            total_suicides = sum(suicides_no),
            percentage = (total_suicides/total_pop)*100) %>% 
  select(year, percentage) %>% 
  arrange(desc(percentage)) %>% 
  top_n(1)

head(test_2)
