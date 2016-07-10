import QtQuick 2.0
import QtSensors 5.0 // ssh to emulator and type 'sudo pkcon install qt5-qtdeclarative-import-sensors'
import Sailfish.Silica 1.0

QtObject
{
    id: root

    // -----------------------------------------------------------------------

    property bool active
    property int longitudeSensorOffset:
    {
        if (app.deviceOrientation === Orientation.PortraitInverted)
            return 180;
        if (app.deviceOrientation === Orientation.Landscape)
            return -90;
        if (app.deviceOrientation === Orientation.LandscapeInverted)
            return 90;

        return 0;
    }
    property OrientationSensor orientationSensor: OrientationSensor
    {
        active: rotationSensor.active
        alwaysOn: false
    }
    property RotationSensor rotationSensor: RotationSensor
    {
        active: root.active
        alwaysOn: false
        onReadingChanged:
        {
            // calculate new values based on device orientation
            var newLongitude = reading.z + longitudeSensorOffset, newLatitude = 0, newRotation = 0;
            if (orientationSensor.reading.orientation === OrientationReading.TopUp)
            {
                newLatitude = -reading.x - 90;
                if (Math.abs(reading.y) < 45)
                {
                    newLatitude *= -1;
                }
                newRotation = -(reading.y - 180);
            }
            if (orientationSensor.reading.orientation === OrientationReading.TopDown)
            {
                newLatitude = -(reading.x - 90);
                if (Math.abs(reading.y) > 45)
                {
                    newLatitude *= -1;
                }
                newRotation = (reading.y - 180);
            }
            else if (orientationSensor.reading.orientation === OrientationReading.LeftUp)
            {
                newLatitude = reading.y + 90;
                newRotation = -reading.x;
            }
            else if (orientationSensor.reading.orientation === OrientationReading.RightUp)
            {
                newLatitude = -(reading.y - 90);
                newRotation = reading.x;
            }
            else if (orientationSensor.reading.orientation === OrientationReading.FaceUp)
            {
                newLatitude = -90;
            }
            else if (orientationSensor.reading.orientation === OrientationReading.FaceDown)
            {
                newLatitude = 90;
            }

            // normalize values
            newLatitude = Math.max(-89.0, Math.min(89.0, newLatitude));
            newRotation %= 180;
            if (newRotation > 90)
                newRotation -= 180;
            if (Math.abs(newRotation) > 30)
                newRotation = 0;

            // notify
            moveTo(newLatitude, newLongitude, newRotation);
        }
    }

    // -----------------------------------------------------------------------

    signal moveTo(var newLatitude, var newLongitude, var newRotation)
}
