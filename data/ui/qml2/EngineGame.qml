
import QtQuick 2.0

Item {
    id: engineGameArea
    signal close
    property variant player: "w"

    Rectangle {
        color: color_background
        anchors.fill: parent
        opacity: .9
    }
    MouseArea {
        anchors.fill: parent
        onClicked: { engineGameArea.close()
                     name_input.focus = false
        }
    }
    Text {
        text: action_new_engine_game.text
        y: root.font_size
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: root.font_size * 1.5
        color: color_foreground
    }
    Text {
        text: seconds_per_move_str
        anchors.horizontalCenter: valuebar.horizontalCenter
        y: 100
        font.pixelSize: root.font_size * 1.1
        color: color_foreground
    }
    Rectangle {
        id: valuebar
        width: root.width / 2
        height: root.font_size * 3
        x: 20
        y: 150
        color: root.color_lowlight
        opacity: unlimited.checked? .5:1

        MouseArea {
            anchors.fill: parent
            onClicked: { if (unlimited.checked == false) {
                             value.text = Math.round(Math.pow((1 + (mouseX / parent.width)), 10))
                             progress.width = mouseX
                         }
            }
        }
        Rectangle {
            id: progress
            width: (Math.pow(1, 0.1) - 1) * parent.width
            color: root.color_highlight
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
        }
    }
    Text {
        id: value
        text: "1"
        anchors.centerIn: valuebar
        font.pixelSize: root.font_size * 1.5
        color: color_foreground
        opacity: unlimited.checked? .5:1
    }
    Rectangle {
        id: unlimited
        property bool checked: false
        width: 250
        height: root.font_size * 3
        x: 35
        y: 250
        color: unlimited.checked ? root.color_highlight: root.color_lowlight
        radius: rect_radius

        MouseArea {
            anchors.fill: parent
            onClicked: { if (unlimited.checked) {
                             unlimited.checked = false
                         }
                         else {
                             unlimited.checked = true
                         }
            }
        }
        Text {
            text: unlimited_str
            anchors.centerIn: parent
            font.pixelSize: root.font_size
            color: color_foreground
        }
    }
    Column {
        id: leftColumn
        x: font_size
        anchors { bottom: parent.bottom
                  bottomMargin: root.font_size
        }
        spacing: font_size / 2

        Text {
            anchors.right: parent.right
            color: color_foreground
            font.pixelSize: root.font_size * 1.2
            text: name_str + ":"
        }
        
    }
    Rectangle {
        width: 350
        height: font_size * 5
        color: color_background
        opacity: .01
        anchors {
            top: leftColumn.top
            left: leftColumn.right
        }
        MouseArea { anchors.fill: parent
        }
    }
    Column {
        id: rightColumn
        spacing: font_size / 4
        anchors {
            top: leftColumn.top
            left: leftColumn.right
            leftMargin: font_size / 2
        }
        Rectangle {
            width: 350
            height: font_size * 1.7
            color: color_lowlight
            radius: rect_radius
            
            TextInput {
                id: name_input
                width: 330
                height: font_size * 1.3
                x: 10
                y: 6
                color: color_foreground
                font.pixelSize: font_size

                Keys.onPressed: { if (event.key == Qt.Key_Return) {
                                      name_input.focus = false
                                  }
                }
            }
        }
        
    }
    Rectangle {
        id: white
        property bool checked: true
        width: 250
        height: root.font_size * 3
        y: 100
        anchors { right: parent.right
                  rightMargin: root.font_size
        }
        color: white.checked ? root.color_highlight: root.color_lowlight
        radius: rect_radius

        MouseArea {
            anchors.fill: parent
            onClicked: { if (white.checked == false) {
                             white.checked = true
                             black.checked = false
                             engineGameArea.player = "w"
                         }
            }
        }
        Text {
            text: white_str
            anchors.centerIn: parent
            font.pixelSize: root.font_size
            color: color_foreground
        }
    }
    Rectangle {
        id: black
        property bool checked: false
        width: 250
        height: root.font_size * 3
        y: white.y + root.font_size * 4
        anchors { right: parent.right
                  rightMargin: root.font_size
        }
        color: black.checked ? root.color_highlight: root.color_lowlight
        radius: rect_radius

        MouseArea {
            anchors.fill: parent
            onClicked: { if (black.checked == false) {
                             white.checked = false
                             black.checked = true
                             engineGameArea.player = "b"
                         }
            }
        }
        Text {
            text: black_str
            anchors.centerIn: parent
            font.pixelSize: root.font_size
            color: color_foreground
        }
    }
    Rectangle {
        width: 150
        height: root.font_size * 3
        anchors { right: parent.right
                  rightMargin: root.font_size
                  bottom: parent.bottom
                  bottomMargin: root.font_size
        }
        color: root.color_lowlight
        radius: rect_radius

        MouseArea {
            anchors.fill: parent
            onClicked: { engineGameArea.close()
                         name_input.focus = false
                         if (white.checked) {
                             root.white_player = name_input.text
                             root.black_player = "Gnuchess"
                             root.engine_player = "b"
                         }
                         else {
                             root.white_player = "Gnuchess"
                             root.black_player = name_input.text
                             root.engine_player = "w"
                         }
                         if (unlimited.checked) {
                             main.start_new_engine_game(root.engine_player, "")
                         }
                         else {
                             main.start_new_engine_game(root.engine_player, value.text)
                         }
            }
        }
        Text {
            text: done_str
            anchors.centerIn: parent
            font.pixelSize: root.font_size
            color: color_foreground
        }
        
    }
}
