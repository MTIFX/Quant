//+------------------------------------------------------------------+
//|                                                    ClassTest.mq4 |
//|                         Copyright 2016, Market Traders Institute |
//|                              http://education.markettraders.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Market Traders Institute"
#property link      "http://education.markettraders.com/"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

// SL = 20
// TP = 60
// Risk = 2% 

#include <Library.mqh>

extern bool Direction = 0; 
extern double stopLoss = 50; 
extern double TakeProfit = 150; 
extern double riskPercent = 1; 
extern int MaxOrders = 0;

double LongSL, LongTP, ShortSL, ShortTP;  

Trade trade; 
Indicator indicator; 
Market market; 
Candle candle; 

////////////////////////////////////////////////////////////////////////////////////////////////////////

double FlipitUp() {
   return iCustom(NULL, 0, "Flipit", 1, 0); 
}

double FlipitDown() {
   return iCustom(NULL, 0, "Flipit", 1, 1); 
}


////////////////////////////////////////////////////////////////////////////////////////////////////////

/* 
void GoLong() {}

void GoShort() 

*/ 

////////////////////////////////////////////////////////////////////////////////////////////////////////


/* 

Readings above 80 indicate a security is trading near the top of its high-low range; readings below 20 indicate the security is trading near the bottom of its high-low range.

*/ 

bool LongCondition() {
//  return ((StochasticShort(30) < 10 ) && ((StochasticMedium(240) < 10 )) && (StochasticLong(1440) < 10)); 
  // return ((StochasticMedium(240) < 10 ) && (StochasticLong(1440) < 10)); 
  
  // return ((StochasticShortPrevious(30) < StochasticShort(30) && (StochasticShort(30) < 10 ) && (StochasticMedium(240) < 10 )) && (StochasticLong(1440) < 10)); 
  return ((StochasticShortPrevious(30) < StochasticShort(30) && StochasticShort(30) < 10 && (StochasticMedium(240) < 10 )));


}

bool ShortCondition() {
   //  return ((StochasticShort(30) < 10 ) && ((StochasticMedium(240) < 10 )) && (StochasticLong(1440) < 10)); 
   // return ((StochasticMedium(240) > 90 ) && (StochasticLong(1440) > 90)); 
   // return ((StochasticShortPrevious(30) > StochasticShort(30) && (StochasticShort(30) > 90 ) && (StochasticMedium(240) > 90 )) && (StochasticLong(1440) > 90)); 
   return ((StochasticShortPrevious(30) > StochasticShort(30) && StochasticShort(30) > 90 && (StochasticMedium(240) > 90 )));
}

////////////////////////////////////////////////////////////////////////////////////////////////////////



int OnInit()
  {
stopLoss = stopLoss * 10; 
TakeProfit = TakeProfit * 10; 
// StopTrading = 0; 

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
void OnTick() {

  int TotalOrders = trade.total(); 
  double stoploss = market.pipstopoints(stopLoss); 
  double takeprofit = market.pipstopoints(TakeProfit); 
  double lots = trade.lotsize(riskPercent, stopLoss); 


// Print(FlipitUp); 
// Print(FlipitDown); 
/* 
Print("short: ", +StochasticShort(15)); 
Print("medium: ", StochasticMedium(60)); 
Print("long: ", StochasticLong(1440)); 

*/

/* 

Readings above 80 indicate a security is trading near the top of its high-low range; readings below 20 indicate the security is trading near the bottom of its high-low range.

*/ 


if (TotalOrders <= MaxOrders) {
  if ( LongCondition() ) {
       int buytradeticket = OrderSend(NULL, OP_BUY, lots, Ask, 10, Ask - stoploss , Ask + takeprofit, "trade", 1234, 0, clrGreen); 
    }

    if ( ShortCondition() ) {
       int selltradeticket = OrderSend(NULL, OP_SELL, lots, Bid, 10, Bid + stoploss, Bid - takeprofit, "trade", 1234, 0, clrBlue); 
    }

}

////////////////////////////////////////////////////////////////////////////////////////////////////////




  /* 
  Print("stoploss: ", +stoploss); 
  Print("takeprofit: ", +takeprofit); 
  Print ("LongSL: ", +LongSL); 
  Print ("ShortSL: ", +ShortSL); 
  Print ("ShortTP: ", +ShortTP); 
  Print (""); 
  Print("Current Ask: ", +Ask); 
  Print("Current Bid: ", +Bid); 

  

    if (TotalOrders <= MaxOrders) { 
	
	if ( Direction == 1 ) {
    	 int buytradeticket = OrderSend(NULL, OP_BUY, lots, Ask, 10, Ask - stoploss , Ask + takeprofit, "trade", 1234, 0, clrGreen); 
    }

    if ( Direction == 0 ) {
    	 int selltradeticket = OrderSend(NULL, OP_SELL, lots, Bid, 10, Bid + stoploss, Bid - takeprofit, "trade", 1234, 0, clrBlue); 
    }

}


*/
////////////////////////////////////////////////////////////////////////////////////////////////////////


}







/* 




Triple Screen MTF 














*/

////////////////////////////////////////////////////////////////////////////////////////////////////////

double StochasticShort(int StochasticShortTF) {
  return (iStochastic(NULL, StochasticShortTF, 20, 5, 5, MODE_SMA, 0, MODE_MAIN, 1)); 
}

double StochasticMedium(int StochasticMediumTF) {
  return (iStochastic(NULL, StochasticMediumTF, 20, 5, 5, MODE_SMA, 0, MODE_MAIN, 1)); 
}

double StochasticLong(int StochasticLongTF) {
  return (iStochastic(NULL, StochasticLongTF, 20, 5, 5, MODE_SMA, 0, MODE_MAIN, 1)); 
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

double StochasticShortPrevious(int StochasticShortTF) {
  return (iStochastic(NULL, StochasticShortTF, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 2)); 
}

double StochasticMediumPrevious(int StochasticMediumTF) {
  return (iStochastic(NULL, StochasticMediumTF, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 2)); 
}

double StochasticLongPrevious(int StochasticLongTF) {
  return (iStochastic(NULL, StochasticLongTF, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 2)); 
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
