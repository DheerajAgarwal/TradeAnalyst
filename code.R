

#Stock returns in log

# GOOGL_log_returns<-GOOGL%>%Ad()%>%dailyReturn(type='log')
WOW_log_returns<-WOW.AX%>%Ad()%>%dailyReturn(type='log')
ETHI_log_returns<-ETHI.AX%>%Ad()%>%dailyReturn(type='log')


#Mean of log stock returns 

# GOOGL_mean_log<-mean(GOOGL_log_returns)
WOW_mean_log<-mean(WOW_log_returns)
ETHI_mean_log<-mean(ETHI_log_returns)


#round it to 4 decimal places

mean_log<-c(
  # GOOGL_mean_log,
  WOW_mean_log,
  ETHI_mean_log)
mean_log<-round(mean_log,4)

#standard deviation of log stock returns

# GOOGL_sd_Log<-sd(GOOGL_log_returns)
WOW_sd_Log<-sd(WOW_log_returns)
ETHI_sd_Log<-sd(ETHI_log_returns)


#round it to 4 decimal places 

sd_log<-c(
  # GOOGL_sd_Log, 
  WOW_sd_Log, 
  ETHI_sd_Log)
sd_log<-round(sd_log,4)

#create data frame

graphic1 <- data.frame(
  rbind(
    # c("GOOGL",GOOGL_mean_log,GOOGL_sd_Log),
    c("WOW.AX",WOW_mean_log,WOW_sd_Log),
    c("ETHI.AX",ETHI_mean_log,ETHI_sd_Log)
    )
  ,stringsAsFactors = FALSE)


graphic1<-data.frame(mean_log,sd_log)
rownames(graphic1)<-c(
  # "GOOGL", 
  "WOW.AX", 
  "ETHI.AX")
colnames(graphic1)<-c("Mean_Log_Return", "Sd_Log_Return")

#Data frame contains the 4 companies with each company's average log return and standard deviation.

#Use R to observe a stock's performance
#chart components: bollinger bands, % bollinger change, volume, moving average convergence divergence

# GOOGL%>%Ad()%>%chartSeries()
# GOOGL%>%chartSeries(TA='addBBands();addBBands(draw="p");addVo();addMACD()',subset='2018')

WOW.AX%>%Ad()%>%chartSeries()
WOW.AX%>%chartSeries(TA='addBBands();addBBands(draw="p");addVo();addMACD()',subset='2019')

ETHI.AX%>%Ad()%>%chartSeries()
ETHI.AX%>%chartSeries(TA='addBBands();addBBands(draw="p");addVo();addMACD()',subset='2019')

#random walk: Rooted in past performance is not an indicator of future results. Price fluctuations can not be predicted with accuracy


mu<-ETHI_mean_log
sig<-ETHI_sd_Log
testsim<-rep(NA,504)

#generate random daily exponent increase rate using AMZN's mean and sd log returns

#one year 252 trading days, simulate for 1 years 
# 1*252 trading days

predict_horizon_yrs = 1
trading_days_yr = 252

price<-rep(NA,trading_days_yr*predict_horizon_yrs)


#most recent price
price[1]<-as.numeric(ETHI.AX$ETHI.AX.Adjusted[length(ETHI.AX$ETHI.AX.Adjusted),])

#start simulating prices

for(i in 2:length(testsim)){
  price[i]<-price[i-1]*exp(rnorm(1,mu,sig))
}

random_data<-cbind(price,1:(trading_days_yr*predict_horizon_yrs))
colnames(random_data)<-c("Price","Day")
random_data<-as.data.frame(random_data)

random_data%>%
  ggplot(aes(Day,Price))+
  geom_line()+
  labs(title=paste0("BetaShares Ethical (ETHI.AX) price simulation for future ", predict_horizon_yrs, "year(s) starting ", today))

#Used plotly to create a visualization of each stock's risk v reward. 
#Risk: standard deviation of log returns
#Reward: mean of log returns

xlab<-list(title="Reward", titlefont='f')
ylab<-list(title="Risk", titlefont='f')

plot_ly(x=graphic1[,1],y=graphic1[,2],text=rownames(graphic1),type='scatter',mode="markers",marker=list(color=c("black","blue","red","grey","green")))%>%layout(title="Risk v Reward",xaxis=xlab,yaxis=ylab)

#Average stock daily return


probs<-c(0.005,0.025,0.25,0.5,0.75,0.975,0.995)

 
# GOOGL_dist<-GOOGL_log_returns%>%quantile(probs=probs,na.rm=TRUE)
# GOOGL_mean<-mean(GOOGL_log_returns,na.rm=TRUE)
# GOOGL_sd<-sd(GOOGL_log_returns,na.rm=TRUE)
# 
# GOOGL_mean%>%exp() # 1.000651

ETHI_dist<-ETHI_log_returns%>%quantile(probs=probs,na.rm=TRUE)
ETHI_mean<-mean(ETHI_log_returns,na.rm=TRUE)
ETHI_sd<-sd(ETHI_log_returns,na.rm=TRUE)

ETHI_mean%>%exp() #1.000699

#monte carlo simulation: incredibly useful forecasting tool to predict outcomes of events with many random variables


N<-500
mc_matrix<-matrix(nrow=predict_horizon_yrs*trading_days_yr,ncol=N)
mc_matrix[1,1]<-as.numeric(ETHI.AX$ETHI.AX.Adjusted[length(ETHI.AX$ETHI.AX.Adjusted),])

for(j in 1:ncol(mc_matrix)){
  mc_matrix[1,j]<-as.numeric(ETHI.AX$ETHI.AX.Adjusted[length(ETHI.AX$ETHI.AX.Adjusted),])
  for(i in 2:nrow(mc_matrix)){
    mc_matrix[i,j]<-mc_matrix[i-1,j]*exp(rnorm(1,mu,sig))
  }
}

name<-str_c("Sim ",seq(1,500))
name<-c("Day",name)

final_mat<-cbind(1:(trading_days_yr*predict_horizon_yrs),mc_matrix)
final_mat<-as_tibble(final_mat)
colnames(final_mat)<-name

dim(final_mat) #1008 501

final_mat %>%
  gather("Simulation","Price",2:500) %>%
  ggplot(aes(x=Day,y=Price,Group=Simulation))+
  geom_line(alpha=0.2)+
  labs(title="BetaShares Ethical (ETHI.AX): 500 Monte Carlo Simulations for 4 Years")+
  theme_bw()

#is it likely? Check the confidence interval

#Checking the correlation of 4 stocks: tesla, facebook, google, amazon


data<-cbind(
  # diff(log(Cl(AMZN))),
  # diff(log(Cl(GOOGL))),
  # diff(log(Cl(AAPL))),
  # diff(log(Cl(FB))),
  diff(log(Cl(WOW.AX))),
  diff(log(Cl(ETHI.AX)))
  )
chart.Correlation(data)


