
import Qt 4.7

Item {
    id: queeningArea
    signal close

    Rectangle {
        color: color_background
        anchors.fill: parent
        opacity: .9
    }
    MouseArea {
        anchors.fill: parent
    }
    Text {
        text: queening_str
        y: root.font_size
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: root.font_size * 1.5
        color: color_foreground
    }
    Rectangle {
        id: queen
        width: 180
        height: root.font_size * 3
        x: 35
        y: root.font_size * 3.5
        color: color_lowlight
        radius: 14

        MouseArea {
            anchors.fill: parent
            onClicked: { queeningArea.close()
                         main.queening("q")
            }
        }
        Text {
            text: queen_str
            anchors.centerIn: parent
            font.pixelSize: root.font_size
            color: color_foreground
        }
        
    }
    Rectangle {
        id: rook
        width: 180
        height: root.font_size * 3
        x: queen.x + queen.width + 20
        y: root.font_size * 3.5
        color: color_lowlight
        radius: 14

        MouseArea {
            anchors.fill: parent
            onClicked: { queeningArea.close()
                         main.queening("r")
            }
        }
        Text {
            text: rook_str
            anchors.centerIn: parent
            font.pixelSize: root.font_size
            color: color_foreground
        }
        
    }
    Rectangle {
        id: knight
        width: 180
        height: root.font_size * 3
        x: rook.x + rook.width + 20
        y: root.font_size * 3.5
        color: color_lowlight
        radius: 14

        MouseArea {
            anchors.fill: parent
            onClicked: { queeningArea.close()
                         main.queening("n")
            }
        }
        Text {
            text: knight_str
            anchors.centerIn: parent
            font.pixelSize: root.font_size
            color: color_foreground
        }
        
    }
    Rectangle {
        id: bishop
        width: 180
        height: root.font_size * 3
        x: knight.x + knight.width + 20
        y: root.font_size * 3.5
        color: color_lowlight
        radius: 14

        MouseArea {
            anchors.fill: parent
            onClicked: { queeningArea.close()
                         main.queening("b")
            }
        }
        Text {
            text: bishop_str
            anchors.centerIn: parent
            font.pixelSize: root.font_size
            color: color_foreground
        }
        
    }
    
}
