
import QtQuick 2.0

Item {
    id: contextMenuArea
    property variant items: []
    signal close
    signal response(int index)

    MouseArea {
        anchors.fill: parent
    }
    Rectangle {
        color: color_background
        anchors.fill: parent
        opacity: .9
    }
    ListView {
        model: contextMenuArea.items
        anchors.fill: parent
        header: Item { height: root.font_size * 5
                       width: parent.width
                       MouseArea { anchors.fill: parent
                                   onClicked: contextMenuArea.close()
                       }
                }
        footer: Item { height: root.font_size * 5
                       width: parent.width
                       MouseArea { anchors.fill: parent
                                   onClicked: contextMenuArea.close()
                       }
                }

        delegate: SelectableItem {
            Text {
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: root.font_size * 5
                }
                color: color_foreground
                font.pixelSize: root.font_size * 1.4
                text: modelData.text
            }
            onSelected: {
                contextMenuArea.close()
                modelData.trigger()
            }
        }
    }
}
