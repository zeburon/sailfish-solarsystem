import QtQuick 2.0

SolarBodyImage
{
    id: root

    // -----------------------------------------------------------------------

    property real shadowPhase: 0.5
    property alias shadowOpacity: shadow.opacity

    // -----------------------------------------------------------------------

    function requestPaint()
    {
        shadowOnPlanet.requestPaint();
    }

    // -----------------------------------------------------------------------

    onShadowPhaseChanged:
    {
        requestPaint();
    }

    // -----------------------------------------------------------------------
    // shadow rendering
    Item
    {
        id: shadow

        anchors { centerIn: parent }
        opacity: 0.65

        Canvas
        {
            id: shadowOnPlanet

            width: imageWidth + 2
            height: imageHeight + 2
            anchors { centerIn: parent }
            visible: shadowPhase !== 0.5
            onPaint:
            {
                var phase = Math.floor(shadowPhase * 4);
                var phaseProgress = shadowPhase * 4 - phase;

                var radius = width / 2;
                var cx = width / 2;
                var cy = height / 2;

                var context = getContext("2d");
                context.reset();

                // define drawable area
                context.beginPath();
                context.arc(cx, cy, radius, 0, Math.PI * 2, false);
                if (phase === 1)
                {
                    context.save();
                    var s =  1 + Math.pow(1 - phaseProgress, 3) * 4;
                    context.scale(1.0, s);
                    context.arc(cx + (1 - phaseProgress) * radius, radius / s, radius, 0, Math.PI * 2, false);
                    context.restore();
                }
                else if (phase === 2)
                {
                    context.save();
                    var s = 1 + Math.pow(phaseProgress, 3) * 4;
                    context.scale(1, s);
                    context.arc(cx - phaseProgress * radius, radius / s, radius, 0, Math.PI * 2, false);
                    context.restore();
                }
                context.clip();

                // draw shadow
                context.translate(cx, cy);
                context.beginPath();
                if (phase < 2)
                {
                    context.scale(1, 1 + Math.pow(phaseProgress, 3) * 4);
                    context.arc(-phaseProgress * radius, 0, radius, 0, Math.PI * 2, false);
                }
                else
                {
                    context.scale(1, 1 + Math.pow(1 - phaseProgress, 3) * 4);
                    context.arc((1 - phaseProgress) * radius, 0, radius, 0, Math.PI * 2, false);
                }
                context.fillStyle = "black";
                context.fill();
            }
        }
    }
}
