import QtQuick 2.0

Canvas
{
    property list<PlanetInfo> planetInfos
    property int lineThickness: 3
    property real zoom

    onPaint:
    {
        var context = getContext("2d");
        context.reset();

        for (var planetIdx = 0; planetIdx < planetInfos.length; ++planetIdx)
        {
            var planetInfo = planetInfos[planetIdx];
            var rot = -planetInfo.w1 * Math.PI / 180.0;
            var offset = -planetInfo.orbitOffset * zoom
            var a = planetInfo.orbitA * zoom
            var b = planetInfo.orbitB * zoom

            context.save();
            context.translate(width / 2.0, height / 2.0);
            context.rotate(rot);
            context.translate(offset, 0.0);
            context.scale(1.0, b / a);
            context.beginPath();
            context.arc(0.0, 0.0, a, 0.0, 2.0 * Math.PI);
            context.restore();
            context.globalAlpha = planetInfo.orbitAlpha * planetInfo.currentOpacityFactor;
            context.lineWidth = lineThickness;
            context.strokeStyle = planetInfo.orbitColor;
            context.stroke();
        }
    }

    onZoomChanged:
    {
        requestPaint();
    }
}
