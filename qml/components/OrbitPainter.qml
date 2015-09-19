import QtQuick 2.0

Canvas
{
    property var planetCalculationResults
    property int lineThickness: 3
    property real zoom

    // -----------------------------------------------------------------------

    onPaint:
    {
        var context = getContext("2d");
        context.reset();

        for (var planetIdx = 0; planetIdx < planetCalculationResults.length; ++planetIdx)
        {
            var planetCalculationResult = planetCalculationResults[planetIdx];
            if (planetCalculationResult.planetInfo.visible)
            {
                var rotation = -planetCalculationResult.planetInfo.w1 * Math.PI / 180.0;
                var offset = -planetCalculationResult.orbitOffset * zoom
                var a = planetCalculationResult.orbitA * zoom
                var b = planetCalculationResult.orbitB * zoom

                context.save();
                context.translate(width / 2.0, height / 2.0);
                context.rotate(rotation);
                context.translate(offset, 0.0);
                context.scale(1.0, b / a);
                context.beginPath();
                context.arc(0.0, 0.0, a, 0.0, 2.0 * Math.PI);
                context.restore();
                context.globalAlpha = planetCalculationResult.currentOpacityFactor;
                context.lineWidth = lineThickness;
                context.strokeStyle = planetCalculationResult.planetInfo.orbitColor;
                context.stroke();
            }
        }
    }
    onZoomChanged:
    {
        requestPaint();
    }
}
