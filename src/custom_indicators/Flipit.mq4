//+------------------------------------------------------------------+
//|                                                       Flipit.mq4 |
//|                          Market Traders Institute Copyright 2017 |
//|                               http://education.markettraders.com |
//+------------------------------------------------------------------+

///////////////////////////////////////////////////////////////////////////////////////////////

#include <Library.mqh>

#property copyright   "Market Traders Institute  © 2017"
#property link        "http://education.markettraders.com"
#property description "Flipit"
#property strict

#property indicator_chart_window    // Indicator is drawn in the main window
#property indicator_buffers 2       // Number of buffers
#property indicator_color1 Blue     // Color of the 1st line
#property indicator_color2 Green      // Color of the 2nd line

extern int Periods = 14; 
extern int Pips = 5; 

bool Direction = NULL; 

Market market; 
Candle candle; 
Indicator indicator; 


 
// Main Series -> Buf_0
// Short Series -> Buf_1
double MainSeries[], ShortSeries[];             // Declaring arrays (for indicator buffers)

///////////////////////////////////////////////////////////////////////////////////////////////

int init()                          // Special function init()
  {
   SetIndexBuffer(0,MainSeries);         // Assigning an array to a buffer
   SetIndexStyle (0,DRAW_LINE,STYLE_SOLID,5);// Line style
   SetIndexBuffer(1,ShortSeries);         // Assigning an array to a buffer
   SetIndexStyle (1,DRAW_LINE,STYLE_DOT,5);// Line style
   return 0;                          // Exit the special funct. init()
  }

///////////////////////////////////////////////////////////////////////////////////////////////

int start()                         // Special function start()
  {
    double PipsInPoints = market.pipstopoints(Pips); 
   int i,                           // Bar index
       Counted_bars;                // Number of counted bars

///////////////////////////////////////////////////////////////////////////////////////////////

   Counted_bars=IndicatorCounted(); // Number of counted bars
   i=Bars-Counted_bars-1;           // Index of the first uncounted
   while(i>=0)                      // Loop for uncounted bars
     {
     
///////////////////////////////////////////////////////////////////////////////////////////////


      double hValue = indicator.ma(NULL, 0, Periods, 0, MODE_SMA, PRICE_HIGH, i);
      double lValue = indicator.ma(NULL, 0, Periods, 0, MODE_SMA, PRICE_LOW, i);  
      double cValue = indicator.ma(NULL, 0, Periods, 0, MODE_SMA, PRICE_CLOSE, (i - 2)); 
      

      // iterator i is the candle 
      if (Direction) {
          MainSeries[i - 2]  = hValue; 
          MainSeries[i - 3]  = hValue;
      }

      if (!Direction) {
        ShortSeries[i - 2] = lValue; 
        ShortSeries[i - 3] = lValue; 
      }

      if (Direction && cValue - hValue >= PipsInPoints ) Direction = 0; 
      if (!Direction && lValue - cValue >= PipsInPoints ) Direction = 1; 

     // MainSeries[i]  = High[i];             // Value of 0 buffer on i bar
     // ShortSeries[i] = Low[i];              // Value of 1st buffer on i bar

      i--;                          // Calculating index of the next bar
     }

///////////////////////////////////////////////////////////////////////////////////////////////

   return 0;                          // Exit the special funct. start()
  }

///////////////////////////////////////////////////////////////////////////////////////////////
