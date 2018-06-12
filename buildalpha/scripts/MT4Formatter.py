# -*- coding: utf-8 -*-
"""
Created on Sat Mar 31 12:01:44 2018

@author: Dave 
@modified: Mark Hewitt <http://www.markhewitt.co.za> 
BuildAlpha <https://www.buildalpha.com/> Dukascopy import script modified to handle basic MT4 exported data

@note You will want to modify the paths in input_file and ba_ready_file to suit your installation
      I put my scripts and data in a folder outside the BA installation, henc custom path
"""

import pandas as pd
from datetime import datetime
# ---------------------------
#  Configs - User adjust
#
input_file = "../data/EURUSD5.csv" 
ba_ready_file = "../data/EURUSD5.txt"
shift_amount = 0
volume_divider = 1 # leave as 1 unless you get BA error. increase to 100 or 1000 to reduce volume
 
# ----------------------
#  Do NOT Change 
#
df = pd.read_csv(input_file,delimiter=',',
                 names=['Date', 'Time', 'Open', 'High', 'Low', 'Close', 'Volume'],
                 index_col='Date_Time', parse_dates=[[0, 1]])

df = df.shift(shift_amount)[shift_amount:]
#df.index = [datetime.strptime(d,'%Y-%m-%d %H:%M') for d in df.index]
fh = open(ba_ready_file,'w')
fh.write("Date,Time,Open,High,Low,Close,Vol,OI\n")
for d,o,h,l,c,v in zip(df.index,df['Open'],df['High'],df['Low'],df['Close'],df['Volume']):
 fh.write("%s,%s,%.5f,%.5f,%.5f,%.5f,%d,%d\n" % (d.strftime('%m/%d/%Y'),d.strftime('%H:%M'),o,h,l,c,v/volume_divider,0))
fh.close()
