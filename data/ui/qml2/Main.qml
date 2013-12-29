
import QtQuick 2.0

Rectangle {
    clip: true
    property variant active_square: ""
    property variant active_square_name: main.active_square_name
    property variant current_player: main.current_player_str
    property variant white_player: ""
    property variant black_player: ""
    property variant engine_player: ""
    property variant color_even: "#383838"
    property variant color_odd: "#282828"
    property variant color_player: "#060"
    property variant color_check: "#600"
    property variant color_check_mate: "#007"
    property variant color_lowlight: "#191919"
    property variant color_highlight: "#333"
    property variant color_foreground: "#eee"
    property variant color_background: "#000"
    property variant color_active: "#050"
    property variant font_size: 24
    property variant rect_radius: 14
    property bool rotation: false
    property bool pause: main.pause_bool
    property bool check: main.check_bool
    property bool check_mate: main.check_mate_bool
    color: color_background

    MouseArea {
        anchors.fill: parent
        onClicked: openContextMenu()
    }
    function openContextMenu() {
        contextMenu.state = 'opened'
        contextMenu.items = [action_new_manual_game, action_new_engine_game, action_quit]
    }
    function openQueening() {
        queening.state = 'opened'
    }
    function openManualGame() {
        manualGame.state = 'opened'
    }
    function openEngineGame() {
        engineGame.state = 'opened'
    }
    function openAppError(_message) {
        appError.state = 'opened'
        appError.message = _message
    }
    function startNewGame() {
        board.newGame()
        rotateAll()
        root.active_square = ""
    }
    function addPiece(_square, _piece) {
        board.addPiece(_square, _piece)
    }
    function movePiece(square_0, square_1) {
        board.movePiece(square_0, square_1)
    }
    function removePiece(_square) {
        board.removePiece(_square)
    }
    function rotateAll() {
        if (root.rotation == true){
            board.rotateSquares()
            if (root.current_player == "w") {
                clock_white.rotation = 0
                clock_black.rotation = 0
                pause_rect.rotation = 0
                name_white.rotation = 0
                name_black.rotation = 0
            }
            else {
                clock_white.rotation = 180
                clock_black.rotation = 180
                pause_rect.rotation = 180
                name_white.rotation = 180
                name_black.rotation = 180
            }
        }
    }
    function setTime(_player, _time) {
        if (_player == "w") {
            clock_white_time.text = _time
        }
        else {
            clock_black_time.text = _time
        }
    }
    Board {
       id: board
    }
    Rectangle {
        id: player
        width: 10
        height: 30
        x: root.height + 10
        y: root.current_player == "w"? root.height - 30: 0
        color: root.check? root.check_mate? root.color_check_mate: root.color_check: root.color_player
        
        MouseArea {
            anchors.fill: parent
            onClicked: main.save_game()
        }
    }
    Text {
        id: name_white
        text: white_player
        color: color_foreground
        font.pixelSize: root.font_size
        x: player.x + (root.font_size * 1.5)
        y: root.height - (root.font_size * 2)
    }
    Text {
        id: name_black
        text: black_player
        color: color_foreground
        font.pixelSize: root.font_size
        x: player.x + (root.font_size * 1.5)
        y: root.font_size
    }
    Rectangle {
        id: pause_rect
        property bool checked: false
        width: 200
        height: root.font_size * 3
        x: root.height + root.font_size
        anchors.verticalCenter: parent.verticalCenter
        color: root.pause ? root.color_highlight: root.color_lowlight
        radius: rect_radius

        MouseArea {
            anchors.fill: parent
            onClicked: { if (root.pause) {
                             main.start_stop_timer(true)
                         }
                         else {
                             main.start_stop_timer(false)
                         }
            }
        }
        Text {
            text: pause_str
            anchors.centerIn: parent
            font.pixelSize: root.font_size
            color: color_foreground
        }
        
    }
    Rectangle {
        id: clock_white
        width: 200
        height: 60
        color: color_background
        x: pause_rect.x
        anchors.top: pause_rect.bottom

        Text {
            id: clock_white_time
            anchors.centerIn: parent
            color: color_foreground
            font.pixelSize: root.font_size * 1.1
            text: "00:00"
        }
    }
    Rectangle {
        id: clock_black
        width: 200
        height: 60
        color: color_background
        x: pause_rect.x
        anchors.bottom: pause_rect.top

        Text {
            id: clock_black_time
            anchors.centerIn: parent
            color: color_foreground
            font.pixelSize: root.font_size * 1.1
            text: "00:00"
        }
    }
    ContextMenu {
        id: contextMenu
        width: parent.width
        opacity: 0

        anchors {
            top: parent.top
            bottom: parent.bottom
        }

        onClose: contextMenu.state = 'closed'
        //onResponse: controller.contextMenuResponse(index)

        state: 'closed'

        Behavior on opacity { NumberAnimation { duration: 300 } }

        states: [
            State {
                name: 'opened'
                PropertyChanges {
                    target: contextMenu
                    opacity: 1
                }
                AnchorChanges {
                    target: contextMenu
                    anchors.right: root.right
                }
            },
            State {
                name: 'closed'
                PropertyChanges {
                    target: contextMenu
                    opacity: 0
                }
                AnchorChanges {
                    target: contextMenu
                    anchors.right: root.left
                }
                StateChangeScript {
                    //script: controller.contextMenuClosed()
                }
            }
        ]

        transitions: Transition {
            AnchorAnimation { duration: 150 }
        }
    }
    Queening {
        id: queening
        width: parent.width
        opacity: 0

        anchors {
            top: parent.top
            bottom: parent.bottom
        }

        onClose: queening.state = 'closed'
        //onResponse: controller.contextMenuResponse(index)

        state: 'closed'

        Behavior on opacity { NumberAnimation { duration: 300 } }

        states: [
            State {
                name: 'opened'
                PropertyChanges {
                    target: queening
                    opacity: 1
                }
                AnchorChanges {
                    target: queening
                    anchors.right: root.right
                }
            },
            State {
                name: 'closed'
                PropertyChanges {
                    target: queening
                    opacity: 0
                }
                AnchorChanges {
                    target: queening
                    anchors.right: root.left
                }
                StateChangeScript {
                    //script: controller.contextMenuClosed()
                }
            }
        ]

        transitions: Transition {
            AnchorAnimation { duration: 150 }
        }
    }
    AppError {
        id: appError
        width: parent.width
        opacity: 0

        anchors {
            top: parent.top
            bottom: parent.bottom
        }

        onClose: appError.state = 'closed'
        state: 'closed'
        Behavior on opacity { NumberAnimation { duration: 300 } }

        states: [
            State {
                name: 'opened'
                PropertyChanges {
                    target: appError
                    opacity: 1
                }
                AnchorChanges {
                    target: appError
                    anchors.right: root.right
                }
            },
            State {
                name: 'closed'
                PropertyChanges {
                    target: appError
                    opacity: 0
                }
                AnchorChanges {
                    target: appError
                    anchors.right: root.left
                }
                StateChangeScript {
                    //script: controller.contextMenuClosed()
                }
            }
        ]

        transitions: Transition {
            AnchorAnimation { duration: 150 }
        }
    }
    ManualGame {
        id: manualGame
        width: parent.width
        height: parent.height
        opacity: 0

        anchors {
            top: parent.top
            bottom: parent.bottom
        }

        onClose: manualGame.state = 'closed'
        state: 'closed'
        Behavior on opacity { NumberAnimation { duration: 300 } }

        states: [
            State {
                name: 'opened'
                PropertyChanges {
                    target: manualGame
                    opacity: 1
                }
                AnchorChanges {
                    target: manualGame
                    anchors.right: root.right
                }
            },
            State {
                name: 'closed'
                PropertyChanges {
                    target: manualGame
                    opacity: 0
                }
                AnchorChanges {
                    target: manualGame
                    anchors.right: root.left
                }
                StateChangeScript {
                    //script: controller.contextMenuClosed()
                }
            }
        ]

        transitions: Transition {
            AnchorAnimation { duration: 150 }
        }
    }
    EngineGame {
        id: engineGame
        width: parent.width
        opacity: 0

        anchors {
            top: parent.top
            bottom: parent.bottom
        }

        onClose: engineGame.state = 'closed'
        state: 'closed'
        Behavior on opacity { NumberAnimation { duration: 300 } }

        states: [
            State {
                name: 'opened'
                PropertyChanges {
                    target: engineGame
                    opacity: 1
                }
                AnchorChanges {
                    target: engineGame
                    anchors.right: root.right
                }
            },
            State {
                name: 'closed'
                PropertyChanges {
                    target: engineGame
                    opacity: 0
                }
                AnchorChanges {
                    target: engineGame
                    anchors.right: root.left
                }
                StateChangeScript {
                    //script: controller.contextMenuClosed()
                }
            }
        ]

        transitions: Transition {
            AnchorAnimation { duration: 150 }
        }
    }
}
