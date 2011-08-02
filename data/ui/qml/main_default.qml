import Qt 4.7

Item {
    id: rootWindow
    property bool showStatusBar: false
    property variant root: mainObject

    width: 848
    height: 480

    Main {
        id: mainObject
        anchors.fill: parent
    }
}
