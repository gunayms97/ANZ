
anz <- read.csv("anz.csv", na.strings = c("NA",""))

head(anz,10)

colSums(is.na(anz))
#bpay_biller_code(92%) and merchant_code(92%);
#card_present_flag, merchant_id, merchant_suburb, merchant_state, merchant_long_lat(36%)

#delete columns with 92% NA's
anz <- anz[,-c(3,9)]

library(Amelia)
missmap(anz, col = c("black","grey"))
#overlap in missing columns

library(ggplot2)
library(tidyverse)

#Q1 - What is the average transaction amount?
mean(anz$amount) # 187.9336

#Q2 - How many transactions do customers make each month, on average?

#historgram of total amount transacted
mean_transactions<-anz %>%
  group_by(customer_id) %>%
  summarise(average_trans=round(n()/3,3))

ggplot(mean_transactions,aes(average_trans))+geom_histogram(bins = 20,fill="red")+
  labs(x="Monthly Average Transactions",y="Number of Customers",title="Monthly Average Transactions")

#Q3 Segment the dataset by transaction date and time

#changing date column's format
anz$date<-as.Date(anz$date,format = "%m/%d/%Y")

#extracting time and weekday of transaction
anz$extraction<-as.character(anz$extraction)

library(lubridate)
anz$hour<-hour(as.POSIXct(substr(anz$extraction,12,19),format="%H:%M:%S"))

anz$weekday<-weekdays(anz$date)

#remove extraction column
anz <- anz[,-15]

#Q4 - Visualise transaction volume and spending over the course of an average day or week.


#unique values
sapply(anz, function(x) length(unique(x)))

unique(anz$movement)
unique(anz$card_present_flag)

#Segment the transaction by date
monthly_volume<-anz %>% group_by(date=date) %>% summarise(volume=length(amount))
ggplot(monthly_volume,aes(x=date,y=volume))+geom_line()+ylim(100,200)


#
mean_spending_aug<- anz %>% select(date,amount) %>% filter(date >="2018-08-01" & date<="2018-08-31") %>%  group_by(date) %>% summarise(mean_spending=mean(amount))
ggplot(mean_spending_aug,aes(x=date,y=mean_spending))+geom_line()















