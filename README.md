

# Sensor App - README


## Purpose
The purpose of this app is to collect data from all possible sensors of an iPhone that is placed into a lift and delivers its data into the cloud where it will be processed with the SMACK stack. Beside this the app is an example how to access the various sensors on the device and to use it as a starting point for an own project.

###### Currently the following "sensors" are used and can be activated in the UI:
* Gyrometer
* DeviceMotion
* Magnetometer
* BatteryLevel
* Microphone
* Light
* Beacon

### Data output

#### Accelerometer
[AppleDoc:](https://developer.apple.com/library/ios/documentation/CoreMotion/Reference/CMAccelerometerData_Class/index.html)The data represents an accelerometer event. It is a measurement of acceleration along the three spatial axes at a moment of time. A G is a unit of gravitation force equal to that exerted by the earth’s gravitational field (9.81 m s−2).

    {
        "z" : -1.003677368164062,
        "x" : -0.0066986083984375,
        "y" : -0.036865234375,
        "date" : "2016-09-05T14:49:18.413+02:00",
        "type" : "Accelerometer"
    }



#### Gyrometer
[AppleDoc:](https://developer.apple.com/library/ios/documentation/CoreMotion/Reference/CMGyroData_Class/index.html)
The data represents a single measurement of the device’s rotation rate.


The X-axis rotation rate in radians per second. The sign follows the right hand rule: If the right hand is wrapped around the X axis such that the tip of the thumb points toward positive X, a positive rotation is one toward the tips of the other four fingers.

The Y-axis rotation rate in radians per second. The sign follows the right hand rule: If the right hand is wrapped around the Y axis such that the tip of the thumb points toward positive Y, a positive rotation is one toward the tips of the other four fingers.

The Z-axis rotation rate in radians per second. The sign follows the right hand rule: If the right hand is wrapped around the Z axis such that the tip of the thumb points toward positive Z, a positive rotation is one toward the tips of the other four fingers.

    {
        "z" : -0.003133475338587232,
        "x" : -0.06178427202540229,
        "y" : 0.07116925170684153,
        "date" : "2016-09-03T08:40:17.552+02:00",
        "type" : "Gyro"
    }



#### Magnetometer
[AppleDoc:](https://developer.apple.com/library/ios/documentation/CoreMotion/Reference/CMMagnetometerData_Class/index.html) The data represents measurements of the magnetic field made by the device’s magnetometer.
The magnetic field is measured by the magnetometer. Note that this is the total magnetic field observed by the device which is equal to the Earth's geomagnetic field plus bias introduced from the device itself and its surroundings.

X-axis magnetic field in microteslas.
Y-axis magnetic field in microteslas.
Z-axis magnetic field in microteslas.

    {
        "z" : -645.7014770507812,
        "x" : -19.19688415527344,
        "y" : 140.535400390625,
        "date" : "2016-09-05T14:50:23.371+02:00",
        "type" : "Magnetometer"
    }



#### DeviceMotion
[AppleDoc:](https://developer.apple.com/library/ios/documentation/CoreMotion/Reference/CMDeviceMotion_Class/index.html) The data represents measurements of the attitude, rotation rate, and acceleration of a device. The accelerometer measures the sum of two acceleration vectors: gravity and user acceleration. User acceleration is the acceleration that the user imparts to the device. Because Core Motion is able to track a device’s attitude using both the gyroscope and the accelerometer, it can differentiate between gravity and user acceleration. A CMDeviceMotion object provides both measurements in the gravity and userAcceleration properties.
The attitide data represents a measurement of attitude—that is, the orientation of a body relative to a given frame of reference.
The X-axis rotation rate in radians per second. The sign follows the right hand rule: If the right hand is wrapped around the X axis such that the tip of the thumb points toward positive X, a positive rotation is one toward the tips of the other four fingers.

The Y-axis rotation rate in radians per second. The sign follows the right hand rule: If the right hand is wrapped around the Y axis such that the tip of the thumb points toward positive Y, a positive rotation is one toward the tips of the other four fingers.

The Z-axis rotation rate in radians per second. The sign follows the right hand rule: If the right hand is wrapped around the Z axis such that the tip of the thumb points toward positive Z, a positive rotation is one toward the tips of the other four fingers.
Quaternion represents a quaternion (one way of parameterizing attitude). If q is an instance of Quaternion, mathematically it represents the  following quaternion: q.x*i + q.y*j + q.z*k + q.w

Rotation:
X-axis rotation rate in radians/second. The sign follows the right hand 
rule (i.e. if the right hand is wrapped around the X axis such that the tip of the thumb points toward positive X, a positive rotation is one toward the tips of the other 4 fingers).
Y-axis rotation rate in radians/second. The sign follows the right hand rule (i.e. if the right hand is wrapped around the Y axis such that the tip of the thumb points toward positive Y, a positive rotation is one toward the tips of the other 4 fingers).
Z-axis rotation rate in radians/second. The sign follows the right hand rule (i.e. if the right hand is wrapped around the Z axis such that the tip of the thumb points toward positive Z, a positive rotation is one toward the tips of the other 4 fingers)
Pitch, yaw and roll are measured in radians. A pitch is a rotation around a lateral axis that passes through the device from side to side. A roll is a rotation around a longitudinal axis that passes through the device from its top to bottom. A yaw is a rotation around an axis that runs vertically through the device. It is perpendicular to the body of the device, with its origin at the center of gravity and directed toward the bottom of the device.

    {
    "attitude" : {
        "quaternion" : {
            "x" : 0.0180332360021854,
            "w" : 0.9998316704300516,
            "y" : -0.003365478874680562,
            "z" : -0.0003267357948271106
        },
        "rotationMatrix" : {
            "m13" : 0.006718040909618139,
            "m12" : -0.0007747425115667284,
            "m33" : 0.9993269443511963,
            "m32" : -0.0360582023859024,
            "m31" : -0.006741608958691359,
            "m21" : 0.0005319805932231247,
            "m11" : 0.9999771118164062,
            "m22" : 0.9993494153022766,
            "m23" : 0.03606259822845459
        },
        "pitch" : -0.006722463864462229
        "yaw" : -0.000722464864462227
        "roll" : -0.001732463864562228
        },
        "date" : "2016-09-05T14:49:26.286+02:00",
        "type" : "DeviceMotion"
    }



#### Barometer
[AppleDoc:](https://developer.apple.com/library/ios/documentation/CoreMotion/Reference/CMAltitudeData_class/index.html) The data encapsulates information about relative changes in altitude. You do not create instances of this class directly. When you want to receive altimeter changes, create an instance of the CMAltimeter class and use that object to query for events or to start the delivery of events. The altimeter object creates new instances of this class at appropriate times and delivers them to the handler you specify.

Altitude: The change in altitude (in meters) since the last reported event. For the first altitude event delivered to your altimeter object, the value of this property is 0. Subsequent events contain a number that reflects the relative change in altitude from the previously reported event. For example, if the altitude changed five meters between the first and second events, the value in this property is 5 for the second event.
Pressure: The recorded pressure, in kilopascals.

    {
        "relativeAltitude" : 0,
        "pressure" : 95.66769409179688,
        "date" : "2016-09-05T14:50:26.300+02:00",
        "type" : "Barometer"
    }



#### BatteryLevel
[AppleDoc:](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDevice_Class/index.html) The data encapsulates information and notifications about changes to the battery’s charge state (described by the batteryState property) and charge level (described by the batteryLevel property).
Battery states are Unknown, Unplugged, Charging and Full.
Battery level ranges from 0.0 (fully discharged) to 1.0 (100% charged). Before accessing this property, ensure that battery monitoring is enabled.

    {
        "type": "Battery",
        "date": "2016-09-05T14:49:18.413+02:00",
        "batteryLevel": "1.0",
        "batteryState": "Full"
    }



#### Microphone
[AppleDoc:](https://developer.apple.com/library/ios/documentation/AVFoundation/Reference/AVAudioRecorder_ClassReference/index.html) In iOS, the audio being recorded comes from the device connected by the user—built-in microphone or headset microphone, for example. In OS X, the audio comes from the system’s default audio input device as set by a user in System Preferences.
PeakPower returns the peak power for a given channel, in decibels, for the sound being recorded. The current peak power, in decibels, for the sound being recorded. A return value of 0 dB indicates full scale, or maximum power; a return value of -160 dB indicates minimum power (that is, near silence).
If the signal provided to the audio recorder exceeds ±full scale, then the return value may exceed 0 (that is, it may enter the positive range).
AveragePower returns the average power for a given channel, in decibels, for the sound being recorded. The current average power, in decibels, for the sound being recorded. A return value of 0 dB indicates full scale, or maximum power; a return value of -160 dB indicates minimum power (that is, near silence).

If the signal provided to the audio recorder exceeds ±full scale, then the return value may exceed 0 (that is, it may enter the positive range).

    {
        "peakPower" : -24.93737,
        "averagePower" : -31.9056,
        "date" : "2016-09-05T14:50:23.736+02:00",
        "type" : "Microphone"
    }




#### Light
[AppleDoc:](https://developer.apple.com/library/ios/documentation/AVFoundation/Reference/AVCaptureStillImageOutput_Class/index.html) The light data is a basic implementation to calculate the brightnes from a taken image as the ambient light sensor is not accessible with a public API. The idea is to grab an image periodicaly, iterate over every pixel and to map it to black and white regarding the RGB channels. 

    {
        "type": "Light",
        "date": "2016-09-05T14:49:18.413+02:00",
        "brightnes": "0.3414323"
    }



#### Beacon
[AppleDoc:](https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CLBeacon_class/index.html) The Beacon data represents a beacon that was encountered during region monitoring. You do not create instances of this class directly. The location manager object reports encountered beacons to its associated delegate object. You can use the information in a beacon object to identify which beacon was encountered.

The identity of a beacon is defined by its proximityUUID, major, and minor properties. These values are coded into the beacon itself. The accuracy of the proximity value, measured in meters from the beacon. It indicates the one sigma horizontal accuracy in meters. Use this property to differentiate between beacons with the same proximity value. Do not use it to identify a precise location for the beacon. Accuracy values may fluctuate due to RF interference. RSSI is the received signal strength of the beacon, measured in decibels. This value is the average RSSI value of the samples received since the range of the beacon was last reported to your app.

A negative value in this property signifies that the actual accuracy could not be determined.

    {
        "beacons": [{
            "accuracy": 4.084238652674522,
            "id": "F7826DA6-4FA2-4E98-8024-BC5B71E0893E",
            "major": 59314,
            "rssi": -88,
            "minor": 13391
        }, {
            "accuracy": 4.641588833612778,
            "id": "F7826DA6-4FA2-4E98-8024-BC5B71E0893E",
            "major": 60085,
            "rssi": -89,
            "minor": 55763
        }],
        "date": "2016-09-13T10:04:04.034+02:00",
        "type": "Beacon"
    }

## Implementation

The `AppDelegate` is the place where all models are initiated. They are implemented as a singleton.

### SettingModel
The SettingModel is the place where all the settings like the backend url are stored. It is important to create the Settingsmodel first as the app depends on the availibility of settings.

### SensorModel
The SensorModel is the place where the core of the app is running. Here all sensors are initialized are available for the app. Each Sensor has its own `FileWriterService` that works as a cache and flushes the content into a JSON file on disk if a threshold for this sensor is reached. For each sensor a `TransferService` is created that is responsible to transfer the data to the backend. For this the `Transferservice` instantiates a FileReaderService that loads the oldest JSON-file for the sensortype from disk. If the JSON was posted to the backend successfully the JSON file is deleted. 

The idea behind this is to have a very simple app that can be used from everybody without deep knowledge of iOS applications. And because the internet connection can not be assured on every floor the so a robust caching mechanism is needed.

### SenderModel
The SenderModel is the place where all senders are living. Currently there is only the implementation of a beacon that turns the device into an iBeacon. Please not that the app does not see the own beacon signal. If you want to implement some kind of morse app with the flash or the speaker feel free to implement it here.