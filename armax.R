# armax system identification
# helon - 4/9/18
# mec2015 - system identification - puc-rio



rm(list=ls()) # remove all vars and functions
cat("\014")   # clean console
while(!is.null(dev.list())) dev.off()     # clear all graphs

# load libraries
library(ggplot2) # fancy plots
library(signal)  # filter for input signal
library(MASS)    # use ginv
library(tidyverse) # data utils

library(narmax)



# load functions
source("library_sysid.R")


con = file("robot_arm.dat", "r")
line = read.delim("robot_arm.dat")
data <- matrix(scan("robot_arm.dat"),nrow=2048,byrow=TRUE)

ye <- data[1:1024]
ue <- data[1:1024]

yv <- data[1024:2048]
uv <- data[1024:2048]


# allows reproducibility
set.seed(42)
#model parameters
na = 8
nb = 6
nc = 8
mdl <- armax(ny=na, nu=nb,ne=nc)

mdl <- estimate(mdl,ye,ue)
print(mdl)

Pe1 <- predict(mdl, ye, ue, K = 1) # one-step-ahead

Pe1$ploty

Pe1$plote

Pa0 <- predict(mdl, yv, uv, K = 0) # free-run

Pa0$ploty

Pa0$plote


library(plotly)

fig <- plot_ly(Pa0$dfpred, x = Pa0$dfpred$t, y = Pa0$dfpred$y, name = 'Measured',
               type = 'scatter', mode = 'lines')
fig <- fig %>% add_trace(y = Pa0$dfpred$yh, name = 'predicted',
                         line = list(color = 'rgb(205, 12, 24)', width = 2,
                                     dash = 'dot'))
#fig <- fig %>% add_trace(y = ~trace_2, name = 'trace 2', mode = 'markers')
fig





