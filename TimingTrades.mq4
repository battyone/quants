//+------------------------------------------------------------------+
//|                                                 TimingTrades.mq4 |
//|                                                      Mark Hewitt |
//|                                      http:\\www.markhewitt.co.za |
//+------------------------------------------------------------------+
#property copyright "Mark Hewitt"
#property link      "http:\\www.markhewitt.co.za"
#property version   "1.00"
#property strict
//--- input parameters
input double   MondayLots=0.01;
input double   TuesdayLots=0.01;
input double   FridayLots=0.01;
input double   EULots=0.01;

datetime previousBar ;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
      previousBar = iTime(Symbol(),Period(),0);
      ObjectCreate(0,"prediction",OBJ_HLINE,0,0,0);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      if ( newBar(previousBar,Symbol(),Period()) ) {
         if ( MondayLots > 0 ) {
            if ( DayOfWeek() == 1 && Hour == 1 ) {
               OrderSend(Symbol(), OP_SELL, MondayLots, Bid, 0, 0, 0);
            } 
         }
         if ( TuesdayLots > 0 ) {
            if ( DayOfWeek() == 2 &&
         }
      }
  }
//+------------------------------------------------------------------+

// This function return the value true if the current bar/candle was just formed
// Inspired by: simplefx2.mq4, http://www.GetForexSoftware.com
bool newBar(datetime& previousBar,string symbol,int timeframe)
{
   if ( previousBar < iTime(symbol,timeframe,0) )
   {
      previousBar = iTime(symbol,timeframe,0);
      return(true);
   }
   else
   {
      return(false);
   }
}
