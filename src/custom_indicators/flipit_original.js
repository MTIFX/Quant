General.prototype.Flipit = function (pOHLCV, periods, shift, pipSize) {
            var RecordCount = pOHLCV.getFieldByIndex(0).recordCount;
            var Results = new TASdk.Recordset();

            var mainSeries = new TASdk.Field();
            mainSeries.initialize(RecordCount, "Main");
            var shortSeries = new TASdk.Field();
            shortSeries.initialize(RecordCount, "Short");

            var pHigh = pOHLCV.getField('High');
            var pLow = pOHLCV.getField('Low');
            var pClose = pOHLCV.getField('Close');

            shift = pipSize * shift;

            var ma = new TASdk.MovingAverage();

            // Calculate the indicator ATR
            var highSet = ma.simpleMovingAverage(pHigh, periods, "High");
            var lowSet = ma.simpleMovingAverage(pLow, periods, "Low");

            var isUp = null;

            for (var j = 0; j < RecordCount + 1; j++) {
                mainSeries.setValue(j, NaN);
                shortSeries.setValue(j, NaN);
            }

            for (var i = periods + 1; i < RecordCount - 1; i++) {
                var hValue = highSet.value("High", i);
                var lValue = lowSet.value("Low", i);
                var cValue = pClose.value(i + 2);

                if (cValue == -1 || hValue == -1 || lValue == -1) {
                    continue;
                }

                if (isUp) {
                    mainSeries.setValue(i + 2, hValue);
                    mainSeries.setValue(i + 3, hValue);
                } else if (!isUp) {
                    shortSeries.setValue(i + 2, lValue);
                    shortSeries.setValue(i + 3, lValue);
                }

                if (isUp && cValue - hValue >= shift) {
                    isUp = false;
                }

                if (!isUp && lValue - cValue >= shift) {
                    isUp = true;
                }
            }

            Results.addField(mainSeries);
            Results.addField(shortSeries);

            return Results;
        };
