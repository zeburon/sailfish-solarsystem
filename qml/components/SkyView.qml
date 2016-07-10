import QtQuick 2.0
import QtSensors 5.0 // ssh to emulator and type 'sudo pkcon install qt5-qtdeclarative-import-sensors'
import Sailfish.Silica 1.0
import harbour.solarsystem.Projector 1.0
import harbour.solarsystem.DateTime 1.0

import "../globals.js" as Globals

Canvas
{
    id: root

    // -----------------------------------------------------------------------

    // settings
    property bool showLabels: true
    property bool showAzimuth: true
    property bool showEquator: true
    property bool showEcliptic: true
    property bool zoomedOut: false
    property bool animateSun: true
    property bool animateZoom: false

    // view-related properties
    property real latitude: settings.latitude
    property real longitude: settings.longitude
    property real fieldOfViewZoomedIn: 90
    property real fieldOfViewZoomedOut: 120
    property real currentFieldOfView: zoomedOut ? fieldOfViewZoomedIn : fieldOfViewZoomedOut
    property real zoomZoomedIn: 1.0
    property real zoomZoomedOut: 0.5
    property real currentZoom: zoomedOut ? zoomZoomedOut : zoomZoomedIn
    property real visibleRadius: 1.175 * Math.sqrt(2.0 * Math.pow(Math.max(width, height), 2.0)) * currentZoom / 2.0
    property real visibleRadiusSquared: visibleRadius * visibleRadius
    property real visibleRadiusFadeStart: visibleRadius - 40

    // mouse-look properties
    property real longitudeLookOffset: 0
    property real latitudeLookOffset: 40
    property real lookRotation: 0
    property real displayedLongitudeLookOffset: longitudeLookOffset
    property real displayedLatitudeLookOffset: latitudeLookOffset
    property int mouseXStart
    property int mouseLongitudeOffsetStart
    property int mouseYStart
    property int mouseLatitudeOffsetStart
    property bool mouseDragged: false

    // solar system information
    property alias solarSystem: solarSystem
    property alias sun: solarSystem.sun
    property alias earth: solarSystem.earth
    property alias moon: solarSystem.moon
    property alias mars: solarSystem.mars

    // rendering
    property var painters: []
    property var trackedPainter: null
    property var images: []

    // -----------------------------------------------------------------------

    signal clickedOnPlanet(var solarBody, var solarSystem)
    signal clickedOnEmptySpace()
    signal showHelpText(string text)
    signal repaintImages()

    // -----------------------------------------------------------------------

    function init()
    {
        for (var bodyIdx = 0; bodyIdx < solarSystem.solarBodies.length; ++bodyIdx)
        {
            var solarBody = solarSystem.solarBodies[bodyIdx];
            if (solarBody === earth)
                continue;

            var painter = solarBodyPainterComponent.createObject(null, {"solarBody": solarBody});
            painters.push(painter);

            var image = planetImageComponent.createObject(items, {"solarBody": solarBody, "painter": painter});

            repaintImages.connect(image.requestPaint);
            images.push(image);
            var label = solarBodyLabelComponent.createObject(items, {"solarBody": solarBody, "painter": painter, "yOffset": image.imageHeight * 0.3});
        }

        painter = solarBodyPainterComponent.createObject(null, {"solarBody": sun});
        painters.push(painter);
        image = sunImageComponent.createObject(items, {"solarBody": sun, "painter": painter});
        images.push(image);
    }

    // -----------------------------------------------------------------------

    function update(dateTime)
    {
        if (dateTime.string !== solarSystem.dateTime.string)
        {
            solarSystem.dateTime.string = dateTime.string;
            for (var painterIdx = 0; painterIdx < painters.length; ++painterIdx)
            {
                var painter = painters[painterIdx];
                painter.calculateRelativeCoordinates();
                painter.calculatePhase();
            }
        }
        requestPaint();
    }

    // -----------------------------------------------------------------------

    function reactivate()
    {
        repaintCanvasAndImages();
    }

    // -----------------------------------------------------------------------

    function repaintCanvasAndImages()
    {
        requestPaint();
        repaintImages();
    }

    // -----------------------------------------------------------------------

    function drawCircle(context, coordinates, color, radius)
    {
        if (coordinates.z >= 0)
        {
            context.beginPath();
            context.arc(coordinates.x, coordinates.y, radius, 0, 2 * Math.PI, false);
            context.fillStyle = color;
            context.fill();
        }
    }

    // -----------------------------------------------------------------------

    function drawLabel(context, coordinates, color, label)
    {
        if (coordinates.z > 0)
        {
            context.globalAlpha = 0.6 * calculateOpacity(coordinates.x, coordinates.y);
            drawCircle(context, coordinates, color, 5);
            context.fillStyle = color;
            context.fillText(label, coordinates.x, coordinates.y - 10);
        }
    }

    // -----------------------------------------------------------------------

    function drawPath(context, coordinates)
    {
        if (coordinates.length < 2)
            return;

        var lastX = coordinates[coordinates.length - 1].x, lastY = coordinates[coordinates.length - 1].y, dX = 0, dY = 0, segmentLength = 0;
        for (var idx = 0; idx < coordinates.length; ++idx)
        {
            var point = coordinates[idx];
            if (point.z > 0.0 && point.length() < visibleRadius)
            {
                dX = point.x - lastX;
                dY = point.y - lastY;
                if (segmentLength === 1)
                {
                    if (idx > 1)
                    {
                        var positionOnBorder = getPositionOnBorder(point.x, point.y, -dX, -dY);
                        context.moveTo(positionOnBorder[0], positionOnBorder[1]);
                    }
                    else
                    {
                        context.moveTo(lastX, lastY);
                    }
                }
                if (segmentLength >= 1)
                {
                    context.lineTo(point.x, point.y);
                }
                lastX = point.x;
                lastY = point.y;
                ++segmentLength;
            }
            else
            {
                if (segmentLength >= 1)
                {
                    var positionOnBorder = getPositionOnBorder(lastX, lastY, dX, dY);
                    context.lineTo(positionOnBorder[0], positionOnBorder[1]);
                }
                segmentLength = 0;
            }
        }
    }

    // -----------------------------------------------------------------------

    function getPositionOnBorder(xPos, yPos, dX, dY)
    {
        var xPosSquared = xPos * xPos;
        var yPosSquared = yPos * yPos;
        var dXSquared = dX * dX;
        var dYSquared = dY * dY;

        var factor = (Math.sqrt(-(dYSquared * xPosSquared - 2.0 * dX * dY * xPos * yPos + dXSquared * yPosSquared - visibleRadiusSquared * (dXSquared + dYSquared))) - dX * xPos - dY * yPos) / (dXSquared + dYSquared);
        return [xPos + factor * dX, yPos + factor * dY];
    }

    // -----------------------------------------------------------------------

    function drawAzimuth(context)
    {
        var skyLongitude, skyLatitude;

        context.lineWidth = 2;

        // upper hemisphere
        context.strokeStyle = "#9999ff";
        context.globalAlpha = 0.3 * (1.0 - Math.max(0.0, Math.min(1.0, (displayedLatitudeLookOffset / -50.0))));
        if (context.globalAlpha > 0.0)
        {
            for (skyLongitude = 0; skyLongitude < 180; skyLongitude += 90)
            {
                var upperCoordinates = [];
                for (skyLatitude = 0; skyLatitude <= 180; skyLatitude += 10)
                {
                    upperCoordinates.push(projector.sphericalAzimuthalToScreenCoordinates(skyLongitude, skyLatitude));
                }
                context.beginPath();
                drawPath(context, upperCoordinates);
                context.stroke();
            }
        }

        // lower hemisphere
        context.strokeStyle = "#88cc00";
        context.globalAlpha = 0.3 * (1.0 - Math.max(0.0, Math.min(1.0, (displayedLatitudeLookOffset / 50.0))));
        if (context.globalAlpha > 0.0)
        {
            for (skyLongitude = 0; skyLongitude < 180; skyLongitude += 90)
            {
                var lowerCoordinates = [];
                for (skyLatitude = 0; skyLatitude <= 180; skyLatitude += 10)
                {
                    lowerCoordinates.push(projector.sphericalAzimuthalToScreenCoordinates(skyLongitude, -skyLatitude));
                }
                context.beginPath();
                drawPath(context, lowerCoordinates);
                context.stroke();
            }
        }

        // horizon
        context.globalAlpha = 0.4 * (1.0 - Math.max(0.0, Math.min(1.0, (Math.abs(displayedLatitudeLookOffset) / 80.0))));
        context.lineWidth = 4;
        context.strokeStyle = "white";
        var equatorCoordinates = [];
        var longitudeOffset = displayedLongitudeLookOffset - 90;
        var longitudeRange = Math.min(180, (currentFieldOfView / 1) / currentZoom);
        for (skyLongitude = -longitudeRange; skyLongitude <= longitudeRange; skyLongitude += 10)
        {
            equatorCoordinates.push(projector.sphericalAzimuthalToScreenCoordinates(skyLongitude + longitudeOffset, 0));
        }
        context.beginPath();
        drawPath(context, equatorCoordinates);
        context.stroke();

        // labels
        for (skyLongitude = 0; skyLongitude < 360; skyLongitude += 90)
        {
            var direction;
            switch (skyLongitude)
            {
                case 0:   direction = qsTr("E"); break;
                case 90:  direction = qsTr("N"); break;
                case 180: direction = qsTr("W"); break;
                case 270: direction = qsTr("S"); break;
            }
            drawLabel(context, projector.sphericalAzimuthalToScreenCoordinates(skyLongitude, 0), "white", direction);
        }
        context.globalAlpha = 0.6;
        drawCircle(context, projector.sphericalAzimuthalToScreenCoordinates(0, 90), "#9999ff", 3);
        drawCircle(context, projector.sphericalAzimuthalToScreenCoordinates(0, -90), "#88cc00", 3);
    }

    // -----------------------------------------------------------------------

    function drawEquator(context)
    {
        var coordinates = [];
        var longitudeOffset = -displayedLongitudeLookOffset - (dateTime.siderealTime / 24) * 360;
        for (var skyLongitude = -180; skyLongitude <= 200; skyLongitude += 20)
        {
            coordinates.push(projector.sphericalEquatorialToScreenCoordinates(skyLongitude + longitudeOffset, 0));
        }
        context.globalAlpha = 0.3;
        context.lineWidth = 4;
        context.beginPath();
        drawPath(context, coordinates);
        context.strokeStyle = "#999966";
        context.stroke();
    }

    // -----------------------------------------------------------------------

    function drawEcliptic(context)
    {
        var coordinates = [];
        var longitudeOffset = -displayedLongitudeLookOffset - (dateTime.siderealTime / 24) * 360;
        for (var skyLongitude = -180; skyLongitude <= 200; skyLongitude += 20)
        {
            coordinates.push(projector.sphericalEclipticToScreenCoordinates(skyLongitude + longitudeOffset, 0));
        }
        context.globalAlpha = 0.3;
        context.lineWidth = 4;
        context.beginPath();
        drawPath(context, coordinates);
        context.strokeStyle = "cyan";
        context.stroke();
    }

    // -----------------------------------------------------------------------

    function drawBorder(context)
    {
        context.globalAlpha = 0.5;
        context.lineWidth = 4;
        context.beginPath();
        context.arc(0, 0, visibleRadius, 0, 2 * Math.PI, false);
        context.strokeStyle = "#88b0e7";
        context.stroke();
    }

    // -----------------------------------------------------------------------

    function calculateOpacity(xPos, yPos)
    {
        return Math.max(0.0, 1.0 - Math.max(0.0, (Math.sqrt(xPos * xPos + yPos * yPos) - visibleRadiusFadeStart) / (visibleRadius - visibleRadiusFadeStart)));
    }

    // -----------------------------------------------------------------------

    function click(mouseX, mouseY)
    {
        var closestPainter = getClosestPainter(mouseX, mouseY);
        if (closestPainter)
        {
            clickedOnPlanet(closestPainter.solarBody, solarSystem);
        }
        else
        {
            clickedOnEmptySpace();
        }
    }

    // -----------------------------------------------------------------------

    function pressAndHold(mouseX, mouseY)
    {
        var closestPainter = getClosestPainter(mouseX, mouseY);
        if (closestPainter)
        {
            trackedPainter = closestPainter;
            requestPaint();
        }
    }

    // -----------------------------------------------------------------------

    function getClosestPainter(mouseX, mouseY)
    {
        var closestPainter;
        var minDistance = 99999;

        for (var imageIdx = 0; imageIdx < images.length; ++imageIdx)
        {
            var image = images[imageIdx];
            if (!image.visible)
                continue;

            var dx = image.x - mouseX;
            var dy = image.y - mouseY;
            var distance = Math.sqrt(dx * dx + dy * dy);
            if (distance < minDistance && distance < Globals.PLANET_CLICK_AREA_SIZE * currentZoom)
            {
                closestPainter = image.painter;
                minDistance = distance;
            }
        }
        return closestPainter;
    }

    // -----------------------------------------------------------------------

    function generateHelpText()
    {
        showHelpText("");
    }

    // -----------------------------------------------------------------------

    onVisibleChanged:
    {
        if (visible)
        {
            generateHelpText();
        }
    }
    onCurrentZoomChanged:
    {
        requestPaint();
    }
    onZoomZoomedInChanged:
    {
        disableZoomAnimationTimer.start();
    }
    onZoomZoomedOutChanged:
    {
        disableZoomAnimationTimer.start();
    }
    onFieldOfViewZoomedInChanged:
    {
        disableZoomAnimationTimer.start();
    }
    onFieldOfViewZoomedOutChanged:
    {
        disableZoomAnimationTimer.start();
    }
    onPaint:
    {
        if (!solarSystem.dateTime.valid)
            return;

        var context = getContext("2d");
        context.reset();
        context.font = "bold 12pt sans-serif";
        context.textAlign = "center";
        context.translate(width / 2.0, height / 2.0);
        context.rotate(lookRotation * (Math.PI / 180));

        // calculate new projection parameters
        projector.update();
        if (trackedPainter && !rotationSensor.active)
        {
            trackedPainter.applyRelativeCoordinates();
            longitudeLookOffset = 180.0 - trackedPainter.azimuthalLongitude;
            latitudeLookOffset  = trackedPainter.azimuthalLatitude;
            projector.update();

            var riseTransitSetTimes = projector.getRiseTransitSetTimes(trackedPainter.geocentricLongitude, trackedPainter.geocentricLatitude, trackedPainter.solarBody.orbitalElements.averageLongitudeChangePerDay / 24.0);
            riseLabel.time    = riseTransitSetTimes.x;
            transitLabel.time = riseTransitSetTimes.y;
            setLabel.time     = riseTransitSetTimes.z;
        }

        // helper lines
        if (showAzimuth)
            drawAzimuth(context);
        if (showEquator)
            drawEquator(context);
        if (showEcliptic)
            drawEcliptic(context);

        drawBorder(context);

        // stars
        context.globalAlpha = 1.0;
        for (var starIdx = 0; starIdx < galaxy.stars.length; ++starIdx)
        {
            var star = galaxy.stars[starIdx];
            var projectedStarCoordinates = projector.sphericalEquatorialToScreenCoordinates(star.rightAscensionDegrees, star.declination);
            drawCircle(context, projectedStarCoordinates, "yellow", star.displayedSize * root.currentZoom);
        }

        // sun, planets and moon
        for (var painterIdx = 0; painterIdx < painters.length; ++painterIdx)
        {
            var painter = painters[painterIdx];
            painter.applyRelativeCoordinates();
            painter.displayedOpacity *= calculateOpacity(painter.projectedX, painter.projectedY);
        }
    }

    // -----------------------------------------------------------------------

    Component
    {
        id: solarBodyPainterComponent

        SkyViewSolarBodyPainter
        {
            sun: root.sun
            earth: root.earth
            moon: root.moon
            mars: root.mars
            width: root.width
            height: root.height
        }
    }
    Component
    {
        id: planetImageComponent

        SkyViewSolarBodyImage
        {
            property var painter

            x: painter.displayedX
            y: painter.displayedY
            z: painter.displayedZ
            visible: painter.visible
            rotation: painter.displayedRotation
            scale: root.currentZoom * painter.displayedScale
            opacity: painter.displayedOpacity
            shadowPhase: painter.displayedPhase
            useSmallImage: solarBody === moon ? false : true
            highlighted: painter === root.trackedPainter
        }
    }
    Component
    {
        id: sunImageComponent

        SunImage
        {
            property var painter

            x: painter.displayedX
            y: painter.displayedY
            z: painter.displayedZ
            visible: painter.visible
            rotation: painter.displayedRotation
            scale: root.currentZoom
            opacity: painter.displayedOpacity
            animated: root.animateSun
            highlighted: painter === root.trackedPainter
        }
    }
    Component
    {
        id: solarBodyLabelComponent

        SolarBodyLabel
        {
            property var painter

            x: painter.displayedX
            y: painter.displayedY
            z: painter.displayedZ + 1
            visible: painter.visible && root.showLabels
            opacity: painter.displayedOpacity
            yOffsetScale: root.currentZoom
            highlighted: painter === root.trackedPainter
        }
    }

    // -----------------------------------------------------------------------

    SolarSystem
    {
        id: solarSystem

        showDwarfPlanets: settings.showDwarfPlanets
    }
    Galaxy
    {
        id: galaxy
    }
    Projector
    {
        id: projector

        dateTime: solarSystem.dateTime
        longitude: root.longitude
        latitude: root.latitude
        longitudeLookOffset: root.displayedLongitudeLookOffset
        latitudeLookOffset: root.displayedLatitudeLookOffset
        width: root.width
        height: root.height
        zoom: root.currentZoom
        fieldOfView: root.currentFieldOfView
    }

    Item
    {
        id: items

        anchors { fill: parent }
        rotation: lookRotation
        visible: solarSystem.valid
    }
    RiseAndSetLabel
    {
        id: riseLabel

        visible: trackedPainter !== null
        horizontalAlignment: Text.Left
        verticalAlignment: Text.Bottom
        anchors { left: parent.left; leftMargin: Theme.paddingLarge; bottom: parent.bottom }

        Label
        {
            anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.top }
            color: parent.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
            text: qsTr("Rise")
        }
    }
    RiseAndSetLabel
    {
        id: transitLabel

        visible: trackedPainter !== null
        horizontalAlignment: Text.Center
        verticalAlignment: Text.Bottom
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }

        Label
        {
            anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.top }
            color: parent.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
            text: qsTr("Transit")
        }
    }
    RiseAndSetLabel
    {
        id: setLabel

        visible: trackedPainter !== null
        horizontalAlignment: Text.Right
        verticalAlignment: Text.Bottom
        anchors { right: parent.right; rightMargin: Theme.paddingLarge; bottom: parent.bottom }

        Label
        {
            anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.top }
            color: parent.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
            text: qsTr("Set")
        }
    }

    MouseArea
    {
        id: mouseArea

        anchors { fill: parent }
        onPressed:
        {
            mouseXStart = mouse.x;
            mouseYStart = mouse.y;
            mouseLongitudeOffsetStart = longitudeLookOffset;
            mouseLatitudeOffsetStart = latitudeLookOffset;
            mouseDragged = false;
        }
        onPositionChanged:
        {
            if (rotationSensor.active)
                return;

            longitudeLookOffset = mouseLongitudeOffsetStart + (360 / width) * -(mouse.x - mouseXStart);
            longitudeLookOffset = longitudeLookOffset % 360;
            latitudeLookOffset  = mouseLatitudeOffsetStart + (180 / height) * -(mouse.y - mouseYStart);
            latitudeLookOffset  = Math.max(-89.0, Math.min(89.0, latitudeLookOffset));

            if (!mouseDragged)
            {
                var dx = mouseLongitudeOffsetStart - longitudeLookOffset;
                var dy = mouseLatitudeOffsetStart - latitudeLookOffset;
                if (Math.sqrt(dx * dx + dy * dy) > 2)
                {
                    mouseDragged   = true;
                    trackedPainter = null;
                }
            }

            if (!repaintTimer.running)
                repaintTimer.start();
        }
        onPressAndHold:
        {
            if (!mouseDragged && !rotationSensor.active)
                root.pressAndHold(mouse.x, mouse.y);
        }
        onClicked:
        {
            if (!mouseDragged)
                root.click(mouse.x, mouse.y);
        }

        preventStealing: true
        propagateComposedEvents: false
    }


    Timer
    {
        id: disableZoomAnimationTimer

        interval: 10
        repeat: false
    }
    Behavior on currentZoom
    {
        enabled: root.animateZoom && !disableZoomAnimationTimer.running

        NumberAnimation { easing.type: Easing.InOutQuart; duration: Globals.ZOOM_ANIMATION_DURATION_MS }
    }
    Behavior on currentFieldOfView
    {
        enabled: root.animateZoom && !disableZoomAnimationTimer.running

        NumberAnimation { easing.type: Easing.InOutQuart; duration: Globals.ZOOM_ANIMATION_DURATION_MS }
    }

    // -----------------------------------------------------------------------

    // orientation tracking
    SkyViewRotationSensor
    {
        id: rotationSensor

        active: app.active && page.active && settings.trackOrientation
        onActiveChanged:
        {
            if (!active)
            {
                lookRotation = 0;
            }
        }
        onMoveTo:
        {
            longitudeLookOffset = newLongitude;
            latitudeLookOffset  = newLatitude;
            lookRotation        = newRotation;
            if (!repaintTimer.running)
                repaintTimer.start();
        }
    }
    Behavior on displayedLongitudeLookOffset
    {
        enabled: !trackedPainter

        RotationAnimation { id: longitudeLookOffsetAnimation; direction: RotationAnimation.Shortest; easing.type: Easing.OutQuad; duration: rotationSensor.active ? 800 : 100 }
    }
    Behavior on displayedLatitudeLookOffset
    {
        enabled: !trackedPainter

        RotationAnimation { id: latitudeLookOffsetAnimation; direction: RotationAnimation.Shortest; easing.type: Easing.OutQuad; duration: rotationSensor.active ? 800 : 100 }
    }
    Behavior on lookRotation
    {
        RotationAnimation { id: lookRotationAnimation; direction: RotationAnimation.Shortest; easing.type: Easing.OutQuad; duration: 1200 }
    }
    Timer
    {
        id: repaintTimer

        interval: 10
        repeat: false
        onTriggered:
        {
            requestPaint();
            if (longitudeLookOffsetAnimation.running || longitudeLookOffsetAnimation.running || lookRotationAnimation.running)
                start();
        }
    }
}
