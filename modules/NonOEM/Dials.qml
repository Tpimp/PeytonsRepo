import QtQuick 2.15
import "RadialBar_arunpkqt"
import com.application.kzp 1.0
Rectangle{
    id:background
    anchors.fill: parent
    color:"#292929"
    FontLoader {
        id: verdanaFont
        source:"VERDANAB.TTF"
    }
    Rectangle{
        anchors.centerIn: parent
        height:background.height * .85
        width:background.height * .85
        radius:background.width /2 * .85
        color:"black"
        Text{
            anchors{
                horizontalCenter: parent.horizontalCenter
                top:parent.top
                topMargin:16
            }
            text:"KZP"
            font.pixelSize: 32
            color:"white"
            font.weight: Font.ExtraBold
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
        }
        Text{
            id:cpuTemp
            color:"white"
            font.pixelSize: 62
            font.family: verdanaFont.name
            horizontalAlignment: Text.Left
            verticalAlignment:Text.AlignVCenter
            font.weight: Font.ExtraBold
            anchors{
                verticalCenter:parent.verticalCenter
                left:parent.left
                leftMargin:24
                verticalCenterOffset:-26
            }
            visible:cpuAverage.valid
            text:"44"
        }
        Text{
            anchors{
                left:cpuTemp.right
                top:cpuTemp.top
                topMargin:8
            }
            visible:cpuTemp.visible
            font.pixelSize: 42
            color:"white"
            text:"°"
        }
        Text{
            id:cpuLabel
            color: "#143bff"
            text:"CPU"
            font.family: verdanaFont.name
            font.letterSpacing: -2
            font.pixelSize: 42
            style: Text.Sunken
            styleColor: "#1215a8"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.bold:Font.ExtraBold
            anchors{
                top:cpuTemp.bottom
                topMargin:-12
                horizontalCenter: cpuTemp.horizontalCenter
            }
        }
        Text{
            id:gpuTemp
            color:"white"
            font.family: verdanaFont.name
            font.pixelSize: 62
            horizontalAlignment: Text.right
            verticalAlignment:Text.AlignVCenter
            font.weight: Font.ExtraBold
            anchors{
                verticalCenter:parent.verticalCenter
                right:parent.right
                rightMargin:34
                verticalCenterOffset:-26
            }
            text:"44"
            visible:cpuAverage.valid
        }
        Text{
            anchors{
                left:gpuTemp.right
                top:gpuTemp.top
                topMargin:8
            }
            visible:gpuTemp.visible
            font.pixelSize: 42
            color:"white"
            text:"°"
        }
        Text{
            id:gpuLabel
            color: "#ffa200"
            text:"GPU"
            font.family: verdanaFont.name
            font.letterSpacing: -2
            font.pixelSize: 42
            style: Text.Sunken
            styleColor: "#cc8800"
            verticalAlignment: Text.Right
            horizontalAlignment: Text.AlignHCenter
            font.bold:Font.ExtraBold
            anchors{
                top:gpuTemp.bottom
                topMargin:-12
                horizontalCenter: gpuTemp.horizontalCenter
            }
        }
        Text{
            visible:!cpuAverage.valid
            anchors{
                horizontalCenter: parent.horizontalCenter
                verticalCenter:gpuTemp.verticalCenter
            }
            color:"white"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: verdanaFont.name
            text:"Initializing Sensors"
        }

        Image{
            id: waterIcon
            height: 32
            width: 32
            source:"qrc:/images/Droplet.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -42
            anchors.top: cpuLabel.bottom
            anchors.margins: 24
        }
        Text{
            anchors.left:waterIcon.right
            anchors.verticalCenter: waterIcon.verticalCenter
            anchors.margins: 6
            color:"white"
            font.pixelSize: 24
            font.family: verdanaFont.name
            font.bold: true
            text:DeviceConnection.liquidTemperature.toFixed(1) + "°"
        }
    }

    RadialBarShape{
        id: cpuDial
        rotation:0
        x:-2
        y:0
        width:320
        height:320
        startAngle: -60
        spanAngle:-90
        minValue:0
        maxValue:100
        value: 100
        dialWidth:32
        backgroundColor:"transparent"
        progressColor: "#4794ff"
        dialColor: "#88191414"
        dialType: RadialBarShape.DialType.NoDial
    }

    RadialBarShape{
        id: gpuDial
        rotation:180
        x:2
        y:0
        width:320
        height:320
        startAngle: 240
        spanAngle:90
        minValue:0
        maxValue:100
        value: 100
        dialWidth:32
        backgroundColor:"transparent"
        progressColor: "#ffa200"
        dialColor: "#44191414"
        dialType: RadialBarShape.DialType.NoDial
    }



    function setCPUValue(value: real) {
        let percent = (value/95);
        cpuDial.spanAngle = -(116 * percent);
        cpuTemp.text = value.toFixed()
    }

    function setGPUValue(value : real) {
        let percent = (value/105);
        gpuDial.spanAngle = (116 * percent);
        gpuTemp.text = value.toFixed()
    }

    SensorMonitor{
        id:cpuAverage
        sensor:CPU.AverageTemp
        onValueChanged:setCPUValue(value);
    }
    SensorMonitor{
        id:gpuCore
        sensor:CPU.AverageTemp
        device: 102
        onValueChanged:setGPUValue(value);
    }
    Component.onCompleted: {
        setCPUValue(cpuAverage.value);
        setGPUValue(gpuCore.value);
    }
}
