import QtQuick 2.0

Item {
    id: rootWindow
    property bool showStatusBar: false
    property variant root: mainObject

    width: 960
    height: 540

    Main {
        id: mainObject
        anchors.fill: parent
    }
}
