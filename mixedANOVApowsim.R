
#Function to run power analysis (simulated) for the interaction between  2 (within subjects) by 3 (between subjects) in an ANOVA
#requires many inputs, takes a while to run based on number of simulations
ws2_by_bs3_anova_int_pow <- function (n1, n2, n3, m1_t1, m1_t2,
                             m2_t1, m2_t2, m3_t1, m3_t2,
                             sd1_t1, sd1_t2, sd2_t1, sd2_t2,
                             sd3_t1, sd3_t2, numsims = 1000,
                             lb = -Inf, ub = Inf) {
  require(truncnorm)
  require(car)
  
  results <- rep(NA, numsims)
  
  for (i in 1:numsims){
    ## Generate data from true distributions: Use truncated norm in case measures have limits as most scales do
    sim.data.g1_t1 <- rtruncnorm(n1, a=lb, b=ub, mean = m1_t1, sd = sd1_t1)
    sim.data.g1_t2 <- rtruncnorm(n1, a=lb, b=ub, mean = m1_t2, sd = sd1_t2)
    sim.data.g2_t1 <- rtruncnorm(n2, a=lb, b=ub, mean = m2_t1, sd = sd2_t1)
    sim.data.g2_t2 <- rtruncnorm(n2, a=lb, b=ub, mean = m2_t2, sd = sd2_t2)
    sim.data.g3_t1 <- rtruncnorm(n3, a=lb, b=ub, mean = m3_t1, sd = sd3_t1)
    sim.data.g3_t2 <- rtruncnorm(n3, a=lb, b=ub, mean = m3_t2, sd = sd3_t2)
    
    #combine simulated data for groups and add group label
    g1 <- cbind(sim.data.g1_t1, sim.data.g1_t2, "G1")
    g2 <- cbind(sim.data.g2_t1, sim.data.g2_t2, "G2")
    g3 <- cbind(sim.data.g3_t1, sim.data.g3_t2, "G3")
    
    #combine all simulated data and change group to factor
    simuldat <- data.frame(rbind(g1, g2, g3))
    colnames(simuldat) <- c("Time.1", "Time.2", "Group")
    simuldat$Group <- factor(simuldat$Group)
    
    #create time  data frame/factor
    simtime <- as.data.frame(factor(c("Time1", "Time2")))
    colnames(simtime) <- "simtime" 
    
    #run model only tests if the w/s X b/s interaction term is significant
    simanova <- lm(cbind(simuldat$Time.1, simuldat$Time.2)~Group, data = simuldat)
    wssimanova <- Anova(simanova, idata = simtime, idesign = ~simtime, type = 3)
    simanvares <- summary(wssimanova, multivariate = F)
    results[i] <- simanvares$univariate.tests[24] < .05
  }
  #return result
  power <- round(mean(results), 3)
  power_result <- paste("Power is ", power)
  print(power_result)
}

ws2_by_bs3_anova_int_pow(n1 = 54, n2 = 17, n3 = 32,
                         m1_t1 = 12.78, m1_t2 = 15.94,
                         m2_t1 = 49.53, m2_t2 = 45.50,
                         m3_t1 = 75.19, m3_t2 = 55.66,
                         sd1_t1 = 11.6, sd1_t2 = 24.09,
                         sd2_t1 = 6.50, sd2_t2 = 22.32,
                         sd3_t1 = 13.65, sd3_t2 = 22.65,
                         lb = 0, ub = 100, numsims = 5000)

library(ggplot2)
library(gridExtra)

truncsim <- rtruncnorm(100, a = 0 , b = 100, mean = 12.78, sd = 11.6)
normsim <- rnorm(100, mean = 12.78, sd = 11.6)
data <- as.data.frame(cbind(truncsim, normsim))
data$normtrunc <- ifelse(normsim < 0, 0, normsim)

p1 <- ggplot(data, aes(x = truncsim))+geom_histogram()
p2 <- ggplot(data, aes(x = normsim))+geom_histogram()
p3 <- ggplot(data, aes(x = normtrunc))+geom_histogram()

grid.arrange(p1, p2, p3)


psych::describe(data)
