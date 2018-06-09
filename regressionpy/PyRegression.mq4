//+------------------------------------------------------------------+
//|                                                 PyRegression.mq4 |
//|                                                      Mark Hewitt |
//|                                      http:\\www.markhewitt.co.za |
//+------------------------------------------------------------------+
#property copyright "Mark Hewitt"
#property link      "http:\\www.markhewitt.co.za"
#property version   "1.00"
#property strict
//--- input parameters
input int      SlowMA=3;
input int      FastMA=9;
input double   m1;
input double   m2;
input double   Constant;
input double   Lots = 0.01;
input string   Magic = "PyReg";

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
    ObjectDelete(0,"prediction");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      if ( newBar(previousBar,Symbol(),Period()) ) {
         
         // apply the regression formula:
         // price = m1 * FastMA(1) + m2 * SlowMA(1) + c
         // @see https://www.quantinsti.com/blog/gold-price-prediction-using-machine-learning-python/ for explaination
         
         double price = (m1 * iMA(Symbol(),Period(),FastMA,0,MODE_SMA,PRICE_CLOSE,1)) + 
                        (m2 * iMA(Symbol(),Period(),SlowMA,0,MODE_SMA,PRICE_CLOSE,1))+ 
                        Constant;
         ObjectMove(0,"prediction",0,0,price);
         
         // work out what price we predicted last time, the direction is from prediction to prediction, as the prediction
         // is always wrong, the direction is not hence we use it as a guideline to be long or short
         double last_prediction =(m1 * iMA(Symbol(),Period(),FastMA,0,MODE_SMA,PRICE_CLOSE,2)) + 
                        (m2 * iMA(Symbol(),Period(),SlowMA,0,MODE_SMA,PRICE_CLOSE,2))+ 
                        Constant; 
         int order_type = ( price > last_prediction ? OP_BUY : OP_SELL );
         
         for (int cc = OrdersTotal() - 1; cc >= 0; cc--)
         {
             if ( !OrderSelect(cc, SELECT_BY_POS) ) { continue; }
             if ( OrderComment() == Magic && OrderSymbol() == Symbol() ) {
                 // exisitng order so ignore if its already in our direction, cut and reverse otherwise
                 if (  OrderType() != order_type ) {
                     OrderClose(OrderTicket(),OrderLots(),( OrderType() == OP_SELL ? Ask : Bid ),0,clrAliceBlue);
                     OrderSend(Symbol(), order_type, Lots, ( OrderType() == OP_SELL ? Bid : Ask ), 0, 0, 0); 
                     return;
                 }
             }
      }
      
      // no orders open, so we place one now
      OrderSend(Symbol(), order_type, Lots, ( OrderType() == OP_SELL ? Bid : Ask ), 0, 0, 0);
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
