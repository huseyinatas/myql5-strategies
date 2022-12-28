//+------------------------------------------------------------------+
//|                                                        buy-sell.mq5 |
//|                                          Copyright 2022, Hüseyin |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Hüseyin"
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include <Trade\trade.mqh>
CTrade BH;
int signal;
input double volume = 0.1;

void OnTick()
{
    double buy = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
    double sell = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

    double rsiData[];

    int RSI = iRSI(_Symbol, _Period, 14, PRICE_CLOSE);

    CopyBuffer(RSI, 0, 0, 3, rsiData);

    double rsiState = NormalizeDouble(rsiData[0], 2);

    if(rsiState > 60)
    {
        // Satış sinyali true döner
        signal = 1;
    }

    if(rsiState < 40)
    {
        // Alış sinyali
        signal = 0;
    }

    if(signal == 1 && PositionsTotal() == 0)
    {
        BH.Buy(volume, NULL, buy, 0, 0, NULL);
    }

    if(signal == 0 && PositionsTotal() == 0)
    {
        BH.Sell(volume, NULL, sell, 0, 0, NULL);
    }

    if(PositionsTotal() > 0)
    {
        long buySell = PositionGetInteger(POSITION_TYPE);
        if(buySell == 0 && signal == 0)
        {
            BH.PositionClose(_Symbol, -1);
        }else if(buySell == 1 && signal == 1) {
            BH.PositionClose(_Symbol, -1);
        }
    }
}