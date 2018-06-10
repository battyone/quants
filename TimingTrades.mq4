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
			// Close oil trade on the Globex open tuesday morning
			if ( DayOfWeek() == 2 && Hour = 1 ) {
				closeTrade('XTIUSD');
			}
			// short oil at globex open monday morning
            if ( DayOfWeek() == 1 && Hour == 1 ) {
               OrderSend('XTIUSD', OP_SELL, MondayLots, Bid, 0, 0, 0);
            } 
         }
         if ( TuesdayLots > 0 ) {
			// close S&P trade at the open Wed morning
			if ( DayOfWeek() == 3 && Hour == 1 ) {
				closeTrade('SPX500');
			}
			// buy S&P tuesday open if Monday was a down day
            if ( DayOfWeek() == 2 && Hour == 1 && iClose(Symbol(),PERIOD_D1,1) < iOpen(Symbol(),PERIOD_D1,1) ) {
               OrderSend('SPX500', OP_BUY, TuesdayLots, Ask, 0, 0, 0);
			}
         }
		 if ( FridayLots > 0 ) {
		   // close gold trade at the open monday morning 
           if ( DayOfWeek() == 1 && Hour == 1 ) {
			 closeTrade('XAUUSD');
		   }
		   // buy gold on fridays and hold over weekend
           if ( DayOfWeek() == 5 && Hour == 1 ) {
               OrderSend('XAUUSD', OP_BUY, FridayLots, Ask, 0, 0, 0);
			}
		 }		 
		 if ( EULots > 0 ) {
		   // we hold EU short for 3 hours, so this is 3 hours + open hour
           if ( Hour == 14 ) {
			 closeTrade('EURUSD');
		   }
		   // short EU on Wed/Thur/Fri at 03:00 EST and hold for 3 hours
           if ( DayOfWeek() >= 3 && DayOfWeek() <= 5 && Hour == 11 ) {
               OrderSend('EURUSD', OP_SELL, EULots, Bid, 0, 0, 0);			  
		   }
		 }		 
      }
  }
//+------------------------------------------------------------------+

void closeTrade(symbol) {
	if ( int cc = OrdersTotal() - 1; cc >= 0; cc-- ) {
		if ( 
		if ( OrderSymbol() == symbol ) {
			OrderClose( );
		}
	}
}

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
