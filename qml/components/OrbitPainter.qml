import QtQuick 2.0

Canvas
{
    property var planetPositions
    property int lineThickness: 3
    property real zoom

    // -----------------------------------------------------------------------

    onPaint:
    {
        var context = getContext("2d");
        context.reset();

        for (var planetIdx = 0; planetIdx < planetPositions.length; ++planetIdx)
        {
            var planetPosition = planetPositions[planetIdx];
            if (planetPosition.planetConfig.visible)
            {
                var rotation = -planetPosition.orbitRotationInRad;
                var offset = -planetPosition.orbitOffset * zoom
                var a = planetPosition.orbitA * zoom
                var b = planetPosition.orbitB * zoom

                context.save();
                context.translate(width / 2.0, height / 2.0);
                context.rotate(rotation);
                context.translate(offset, 0.0);
                context.scale(1.0, b / a);
                context.beginPath();
                context.arc(0.0, 0.0, a, 0.0, 2.0 * Math.PI);
                context.restore();
                context.globalAlpha = planetPosition.displayedOpacity;
                context.lineWidth = lineThickness;
                context.strokeStyle = planetPosition.planetConfig.orbitColor;
                context.stroke();
            }
        }
    }
    onZoomChanged:
    {
        requestPaint();
    }
}
