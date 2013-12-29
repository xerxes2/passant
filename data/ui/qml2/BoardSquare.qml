
import QtQuick 2.0

Rectangle {
    id:  square
    property variant name: ""
    property variant piece: ""
    property bool odd: false
    signal clicked
    signal pressed
    signal released
    width: root.height / 8
    height: width
    color: root.active_square_name == square.name? root.color_active: square.odd? root.color_odd: root.color_even
    clip: true

    onClicked: { if (root.engine_player == root.current_player ) {
                 }
                 else if (root.active_square_name == square.name) {
                     main.set_active_square("")
                     root.active_square = ""
                 }
                 else if (root.active_square_name == "") {
                     main.validate_square(square.name)
                     if (root.active_square_name != "")
                         root.active_square = square
                 }
                 else {
                     main.validate_move(root.active_square_name + square.name)
                     if (main.valid_move_bool == true) {
                         if (square.piece != "") {
                             square.piece.parent = root
                             square.piece.anchors.centerIn = undefined
                             square.piece.anchors.top = root.bottom
                         }
                         square.piece = root.active_square.piece
                         square.piece.parent = square
                         square.piece.anchors.centerIn = square
                         root.active_square.piece = ""
                         root.active_square = ""
                         main.set_active_square("")
                         root.rotateAll()
                     }
                 }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: square.clicked()
        onPressed: square.pressed()
        onReleased: square.released()
    }
}
