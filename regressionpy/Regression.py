# -*- coding: utf-8 -*-
"""
Created on Sat Mar 31 12:01:44 2018

@author: Ishan Shah
@modified: Mark Hewitt <http://www.markhewitt.co.za> 
Base on code from https://www.quantinsti.com/blog/gold-price-prediction-using-machine-learning-python/
"""

import sys

# LinearRegression is a machine learning library for linear regression 
from sklearn.linear_model import LinearRegression 

# pandas and numpy are used for data manipulation 
import pandas as pd 
import numpy as np

# matplotlib and seaborn are used for plotting graphs 
import matplotlib.pyplot as plt 
import seaborn 

# fix_yahoo_finance is used to fetch data 
import fix_yahoo_finance as yf

# get the symbol to process, default to script using H1 EURUSD
if len(sys.argv) == 1: sys.argv[1:] = ["EURUSD60"]
symbol = sys.argv[1]

print("Using symbol " + symbol)
print("Downloading historical data...");

# Read data 
#Df = yf.download(symbol,'2012-01-01','2018-06-07')

Df = pd.read_csv(symbol + '.csv', dtype={'Close':np.float32},
                     names=['Date', 'Time', 'Open', 'High', 'Low', 'Close', 'Volume'], 
                     index_col='Date_Time', parse_dates=[[0, 1]])

# Only keep close columns 
Df=Df[['Close']] 

# Drop rows with missing values 
Df= Df.dropna() 

# Plot the closing price of GLD 
#Df.Close.plot(figsize=(10,5)) 
#plt.ylabel(symbol + " Prices")
#print (symbol + " Price Series")
#plt.show()

#Define explanatory variables
Df['S_3'] = Df['Close'].shift(1).rolling(window=3).mean() 
Df['S_9']= Df['Close'].shift(1).rolling(window=9).mean() 
Df= Df.dropna() 
X = Df[['S_3','S_9']] 
X.head()

#Define dependent variable
y = Df['Close']
y.head()

#Split the data into train and test dataset
t=.8 
t = int(t*len(Df)) 

# Train dataset 
X_train = X[:t] 
y_train = y[:t]  

# Test dataset 
X_test = X[t:] 
y_test = y[t:]

#Create a linear regression model
linear = LinearRegression().fit(X_train,y_train)
print "Linear Regression equation"
print (symbol + " Price (y) =", \
round(linear.coef_[0],2), "* 3 Days Moving Average (x1)", \
round(linear.coef_[1],2), "* 9 Days Moving Average (x2) +", \
round(linear.intercept_,2), "(constant)")

#Predicting the Gold ETF prices
print ( X_test[len(X_test)-7:])
predicted_price = linear.predict(X_test)
print(predicted_price[len(predicted_price)-7:])

predicted_price = pd.DataFrame(predicted_price,index=y_test.index,columns = ['price'])  
predicted_price.plot(figsize=(10,5))  
y_test.plot()  
plt.legend(['predicted_price','actual_price'])  
plt.ylabel(symbol + " Price")  
plt.show()

#for bar in predicted_price:
#    print bar

# R square
r2_score = linear.score(X[t:],y[t:])*100  
print float("{0:.2f}".format(r2_score))
