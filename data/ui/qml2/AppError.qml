
import QtQuick 2.0

Item {
    id: appErrorArea
    signal close
    property variant message: ""

    Rectangle {
        color: color_background
        anchors.fill: parent
        opacity: .9
    }
    MouseArea {
        anchors.fill: parent
        onClicked: { appErrorArea.close()
        }
    }
    Text {
        id: header
        text: appErrorArea.message
        y: root.font_size
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: root.font_size * 1
        color: color_foreground
    }
    
}
