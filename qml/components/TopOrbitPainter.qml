import QtQuick 2.0

Canvas
{
    property var solarBodyInfos
    property int lineThickness: 3
    property real zoom: 1.0

    // -----------------------------------------------------------------------

    onPaint:
    {
        var context = getContext("2d");
        context.reset();

        for (var bodyIdx = 0; bodyIdx < solarBodyInfos.length; ++bodyIdx)
        {
            var info = solarBodyInfos[bodyIdx];
            if (info.solarBody.visible && info.parentInfo === null)
            {
                var rotation = -info.orbitRotation;
                var offset = -info.orbitOffset * zoom;
                var a = info.orbitA * zoom;
                var b = info.orbitB * zoom;

                context.save();
                context.translate(width / 2.0, height / 2.0);
                context.rotate(rotation);
                context.translate(offset, 0.0);
                context.scale(1.0, b / a);
                context.beginPath();
                context.arc(0.0, 0.0, a, 0.0, 2.0 * Math.PI);
                context.restore();
                context.globalAlpha = info.displayedOpacity;
                context.lineWidth = lineThickness;
                context.strokeStyle = info.solarBody.orbitColor;
                context.stroke();
            }
        }
    }
    onZoomChanged:
    {
        requestPaint();
    }
}
