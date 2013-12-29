
import QtQuick 2.0

Rectangle {
    id: boardArea

    function rotateSquares() {
        var squares = [a1, a2, a3, a4, a5, a6, a7, a8,
            b1, b2, b3, b4, b5, b6, b7, b8,
            c1, c2, c3, c4, c5, c6, c7, c8,
            d1, d2, d3, d4, d5, d6, d7, d8,
            e1, e2, e3, e4, e5, e6, e7, e8,
            f1, f2, f3, f4, f5, f6, f7, f8,
            g1, g2, g3, g4, g5, g6, g7, g8,
            h1, h2, h3, h4, h5, h6, h7, h8]
        var i=0;
        for (i=0; i<squares.length; i++) {
            if (root.current_player == "w") {
                squares[i].rotation = 0
            }
            else {
                 squares[i].rotation = 180
            }
        }
    }
    function addPiece(_square, _piece) {
        removePiece(_square)
        var component
        component = Qt.createComponent("Piece.qml")
        var new_piece
        var squares = [a1, a2, a3, a4, a5, a6, a7, a8,
            b1, b2, b3, b4, b5, b6, b7, b8,
            c1, c2, c3, c4, c5, c6, c7, c8,
            d1, d2, d3, d4, d5, d6, d7, d8,
            e1, e2, e3, e4, e5, e6, e7, e8,
            f1, f2, f3, f4, f5, f6, f7, f8,
            g1, g2, g3, g4, g5, g6, g7, g8,
            h1, h2, h3, h4, h5, h6, h7, h8]

        var i=0;
        for (i=0; i<squares.length; i++) {
            if (squares[i].name == _square) {
                new_piece = component.createObject(squares[i])
                squares[i].piece = new_piece
                if (_piece == "wq") {
                    new_piece.source = "pieces/white/queen.svg"
                }
                else if (_piece == "wr") {
                    new_piece.source = "pieces/white/rook.svg"
                }
                else if (_piece == "wn") {
                    new_piece.source = "pieces/white/knight.svg"
                }
                else if (_piece == "wb") {
                    new_piece.source = "pieces/white/bishop.svg"
                }
                else if (_piece == "bq") {
                    new_piece.source = "pieces/black/queen.svg"
                }
                else if (_piece == "br") {
                    new_piece.source = "pieces/black/rook.svg"
                }
                else if (_piece == "bn") {
                    new_piece.source = "pieces/black/knight.svg"
                }
                else if (_piece == "bb") {
                    new_piece.source = "pieces/black/bishop.svg"
                }
                break
            }
        }
    }
    function movePiece(square_0, square_1) {
        removePiece(square_1)
        var squares = [a1, a2, a3, a4, a5, a6, a7, a8,
            b1, b2, b3, b4, b5, b6, b7, b8,
            c1, c2, c3, c4, c5, c6, c7, c8,
            d1, d2, d3, d4, d5, d6, d7, d8,
            e1, e2, e3, e4, e5, e6, e7, e8,
            f1, f2, f3, f4, f5, f6, f7, f8,
            g1, g2, g3, g4, g5, g6, g7, g8,
            h1, h2, h3, h4, h5, h6, h7, h8]

        var i=0;
        for (i=0; i<squares.length; i++) {
            if (squares[i].name == square_0) {
                break
            }
        }
        var j=0
        for (j=0; j<squares.length; j++) {
            if (squares[j].name == square_1) {
                squares[i].piece.parent = squares[j]
                squares[j].piece = squares[i].piece
                squares[j].piece.anchors.centerIn = squares[j]
                squares[i].piece = ""
                break
            }
        }
    }
    function removePiece(_square) {
        var squares = [a1, a2, a3, a4, a5, a6, a7, a8,
            b1, b2, b3, b4, b5, b6, b7, b8,
            c1, c2, c3, c4, c5, c6, c7, c8,
            d1, d2, d3, d4, d5, d6, d7, d8,
            e1, e2, e3, e4, e5, e6, e7, e8,
            f1, f2, f3, f4, f5, f6, f7, f8,
            g1, g2, g3, g4, g5, g6, g7, g8,
            h1, h2, h3, h4, h5, h6, h7, h8]
        
        var i=0;
        for (i=0; i<squares.length; i++) {
            if (squares[i].name == _square && squares[i].piece != "") {
                squares[i].piece.parent = root
                squares[i].piece.anchors.centerIn = undefined
                squares[i].piece.anchors.top = root.bottom
                squares[i].piece = ""
                break
            }
        }
    }
    function newGame() {
        // Squares
        removePiece("a8")
        removePiece("b8")
        removePiece("c8")
        removePiece("d8")
        removePiece("e8")
        removePiece("f8")
        removePiece("g8")
        removePiece("h8")
        removePiece("a7")
        removePiece("b7")
        removePiece("c7")
        removePiece("d7")
        removePiece("e7")
        removePiece("f7")
        removePiece("g7")
        removePiece("h7")
        removePiece("a6")
        removePiece("b6")
        removePiece("c6")
        removePiece("d6")
        removePiece("e6")
        removePiece("f6")
        removePiece("g6")
        removePiece("h6")
        removePiece("a5")
        removePiece("b5")
        removePiece("c5")
        removePiece("d5")
        removePiece("e5")
        removePiece("f5")
        removePiece("g5")
        removePiece("h5")
        removePiece("a4")
        removePiece("b4")
        removePiece("c4")
        removePiece("d4")
        removePiece("e4")
        removePiece("f4")
        removePiece("g4")
        removePiece("h4")
        removePiece("a3")
        removePiece("b3")
        removePiece("c3")
        removePiece("d3")
        removePiece("e3")
        removePiece("f3")
        removePiece("g3")
        removePiece("h3")
        removePiece("a3")
        removePiece("b3")
        removePiece("c3")
        removePiece("d3")
        removePiece("e3")
        removePiece("f3")
        removePiece("g3")
        removePiece("h3")
        removePiece("a2")
        removePiece("b2")
        removePiece("c2")
        removePiece("d2")
        removePiece("e2")
        removePiece("f2")
        removePiece("g2")
        removePiece("h2")
        removePiece("a1")
        removePiece("b1")
        removePiece("c1")
        removePiece("d1")
        removePiece("e1")
        removePiece("f1")
        removePiece("g1")
        removePiece("h1")
        a8.piece = black_rook_0
        b8.piece = black_knight_0
        c8.piece = black_bishop_0
        d8.piece = black_queen
        e8.piece = black_king
        f8.piece = black_bishop_1
        g8.piece = black_knight_1
        h8.piece = black_rook_1
        a7.piece = black_pawn_0
        b7.piece = black_pawn_1
        c7.piece = black_pawn_2
        d7.piece = black_pawn_3
        e7.piece = black_pawn_4
        f7.piece = black_pawn_5
        g7.piece = black_pawn_6
        h7.piece = black_pawn_7
        a2.piece = white_pawn_0
        b2.piece = white_pawn_1
        c2.piece = white_pawn_2
        d2.piece = white_pawn_3
        e2.piece = white_pawn_4
        f2.piece = white_pawn_5
        g2.piece = white_pawn_6
        h2.piece = white_pawn_7
        a1.piece = white_rook_0
        b1.piece = white_knight_0
        c1.piece = white_bishop_0
        d1.piece = white_queen
        e1.piece = white_king
        f1.piece = white_bishop_1
        g1.piece = white_knight_1
        h1.piece = white_rook_1
        // Black
        black_rook_0.parent = a8
        black_rook_0.anchors.top = undefined
        black_rook_0.anchors.centerIn = a8
        black_knight_0.parent = b8
        black_knight_0.anchors.top = undefined
        black_knight_0.anchors.centerIn = b8
        black_bishop_0.parent = c8
        black_bishop_0.anchors.top = undefined
        black_bishop_0.anchors.centerIn = c8
        black_queen.parent = d8
        black_queen.anchors.top = undefined
        black_queen.anchors.centerIn = d8
        black_king.parent = e8
        black_king.anchors.top = undefined
        black_king.anchors.centerIn = e8
        black_bishop_1.parent = f8
        black_bishop_1.anchors.top = undefined
        black_bishop_1.anchors.centerIn = f8
        black_knight_1.parent = g8
        black_knight_1.anchors.top = undefined
        black_knight_1.anchors.centerIn = g8
        black_rook_1.parent = h8
        black_rook_1.anchors.top = undefined
        black_rook_1.anchors.centerIn = h8
        black_pawn_0.parent = a7
        black_pawn_0.anchors.top = undefined
        black_pawn_0.anchors.centerIn = a7
        black_pawn_1.parent = b7
        black_pawn_1.anchors.top = undefined
        black_pawn_1.anchors.centerIn = b7
        black_pawn_2.parent = c7
        black_pawn_2.anchors.top = undefined
        black_pawn_2.anchors.centerIn = c7
        black_pawn_3.parent = d7
        black_pawn_3.anchors.top = undefined
        black_pawn_3.anchors.centerIn = d7
        black_pawn_4.parent = e7
        black_pawn_4.anchors.top = undefined
        black_pawn_4.anchors.centerIn = e7
        black_pawn_5.parent = f7
        black_pawn_5.anchors.top = undefined
        black_pawn_5.anchors.centerIn = f7
        black_pawn_6.parent = g7
        black_pawn_6.anchors.top = undefined
        black_pawn_6.anchors.centerIn = g7
        black_pawn_7.parent = h7
        black_pawn_7.anchors.top = undefined
        black_pawn_7.anchors.centerIn = h7
        // White
        white_rook_0.parent = a1
        white_rook_0.anchors.top = undefined
        white_rook_0.anchors.centerIn = a1
        white_knight_0.parent = b1
        white_knight_0.anchors.top = undefined
        white_knight_0.anchors.centerIn = b1
        white_bishop_0.parent = c1
        white_bishop_0.anchors.top = undefined
        white_bishop_0.anchors.centerIn = c1
        white_queen.parent = d1
        white_queen.anchors.top = undefined
        white_queen.anchors.centerIn = d1
        white_king.parent = e1
        white_king.anchors.top = undefined
        white_king.anchors.centerIn = e1
        white_bishop_1.parent = f1
        white_bishop_1.anchors.top = undefined
        white_bishop_1.anchors.centerIn = f1
        white_knight_1.parent = g1
        white_knight_1.anchors.top = undefined
        white_knight_1.anchors.centerIn = g1
        white_rook_1.parent = h1
        white_rook_1.anchors.top = undefined
        white_rook_1.anchors.centerIn = h1
        white_pawn_0.parent = a2
        white_pawn_0.anchors.top = undefined
        white_pawn_0.anchors.centerIn = a2
        white_pawn_1.parent = b2
        white_pawn_1.anchors.top = undefined
        white_pawn_1.anchors.centerIn = b2
        white_pawn_2.parent = c2
        white_pawn_2.anchors.top = undefined
        white_pawn_2.anchors.centerIn = c2
        white_pawn_3.parent = d2
        white_pawn_3.anchors.top = undefined
        white_pawn_3.anchors.centerIn = d2
        white_pawn_4.parent = e2
        white_pawn_4.anchors.top = undefined
        white_pawn_4.anchors.centerIn = e2
        white_pawn_5.parent = f2
        white_pawn_5.anchors.top = undefined
        white_pawn_5.anchors.centerIn = f2
        white_pawn_6.parent = g2
        white_pawn_6.anchors.top = undefined
        white_pawn_6.anchors.centerIn = g2
        white_pawn_7.parent = h2
        white_pawn_7.anchors.top = undefined
        white_pawn_7.anchors.centerIn = h2
    }
    // Row 0
    BoardSquare {
        id: a8
        name: "a8"
        x: 0
        y: 0
        piece: black_rook_0
    }
    BoardSquare {
        id: b8
        name: "b8"
        x: width
        y: 0
        odd: true
        piece: black_knight_0
    }
    BoardSquare {
        id: c8
        name: "c8"
        x: width * 2
        y: 0
        piece: black_bishop_0
    }
    BoardSquare {
        id: d8
        name: "d8"
        x: width * 3
        y: 0
        odd: true
        piece: black_queen
    }
    BoardSquare {
        id: e8
        name: "e8"
        x: width * 4
        y: 0
        piece: black_king
    }
    BoardSquare {
        id: f8
        name: "f8"
        x: width * 5
        y: 0
        odd: true
        piece: black_bishop_1
    }
    BoardSquare {
        id: g8
        name: "g8"
        x: width * 6
        y: 0
        piece: black_knight_1
    }
    BoardSquare {
        id: h8
        name: "h8"
        x: width * 7
        y: 0
        odd: true
        piece: black_rook_1
    }
    // Row 1
    BoardSquare {
        id: a7
        name: "a7"
        x: 0
        y: width * 1
        odd: true
        piece: black_pawn_0
    }
    BoardSquare {
        id: b7
        name: "b7"
        x: width * 1
        y: width * 1
        piece: black_pawn_1
    }
    BoardSquare {
        id: c7
        name: "c7"
        x: width * 2
        y: width * 1
        odd: true
        piece: black_pawn_2
    }
    BoardSquare {
        id: d7
        name: "d7"
        x: width * 3
        y: width * 1
        piece: black_pawn_3
    }
    BoardSquare {
        id: e7
        name: "e7"
        x: width * 4
        y: width * 1
        odd: true
        piece: black_pawn_4
    }
    BoardSquare {
        id: f7
        name: "f7"
        x: width * 5
        y: width * 1
        piece: black_pawn_5
    }
    BoardSquare {
        id: g7
        name: "g7"
        x: width * 6
        y: width * 1
        odd: true
        piece: black_pawn_6
    }
    BoardSquare {
        id: h7
        name: "h7"
        x: width * 7
        y: width * 1
        piece: black_pawn_7
    }
    // Row 2
    BoardSquare {
        id: a6
        name: "a6"
        x: 0
        y: width * 2
    }
    BoardSquare {
        id: b6
        name: "b6"
        x: width * 1
        y: width * 2
        odd: true
    }
    BoardSquare {
        id: c6
        name: "c6"
        x: width * 2
        y: width * 2
    }
    BoardSquare {
        id: d6
        name: "d6"
        x: width * 3
        y: width * 2
        odd: true
    }
    BoardSquare {
        id: e6
        name: "e6"
        x: width * 4
        y: width * 2
    }
    BoardSquare {
        id: f6
        name: "f6"
        x: width * 5
        y: width * 2
        odd: true
    }
    BoardSquare {
        id: g6
        name: "g6"
        x: width * 6
        y: width * 2
    }
    BoardSquare {
        id: h6
        name: "h6"
        x: width * 7
        y: width * 2
        odd: true
    }
    // Row 3
    BoardSquare {
        id: a5
        name: "a5"
        x: 0
        y: width * 3
        odd: true
    }
    BoardSquare {
        id: b5
        name: "b5"
        x: width
        y: width * 3
    }
    BoardSquare {
        id: c5
        name: "c5"
        x: width * 2
        y: width * 3
        odd: true
    }
    BoardSquare {
        id: d5
        name: "d5"
        x: width * 3
        y: width * 3
    }
    BoardSquare {
        id: e5
        name: "e5"
        x: width * 4
        y: width * 3
        odd: true
    }
    BoardSquare {
        id: f5
        name: "f5"
        x: width * 5
        y: width * 3
    }
    BoardSquare {
        id: g5
        name: "g5"
        x: width * 6
        y: width * 3
        odd: true
    }
    BoardSquare {
        id: h5
        name: "h5"
        x: width * 7
        y: width * 3
    }
    // Row 4
    BoardSquare {
        id: a4
        name: "a4"
        x: 0
        y: width * 4
    }
    BoardSquare {
        id: b4
        name: "b4"
        x: width
        y: width * 4
        odd: true
    }
    BoardSquare {
        id: c4
        name: "c4"
        x: width * 2
        y: width * 4
    }
    BoardSquare {
        id: d4
        name: "d4"
        x: width * 3
        y: width * 4
        odd: true
    }
    BoardSquare {
        id: e4
        name: "e4"
        x: width * 4
        y: width * 4
    }
    BoardSquare {
        id: f4
        name: "f4"
        x: width * 5
        y: width * 4
        odd: true
    }
    BoardSquare {
        id: g4
        name: "g4"
        x: width * 6
        y: width * 4
    }
    BoardSquare {
        id: h4
        name: "h4"
        x: width * 7
        y: width * 4
        odd: true
    }
    // Row 5
    BoardSquare {
        id: a3
        name: "a3"
        x: 0
        y: width * 5
        odd: true
    }
    BoardSquare {
        id: b3
        name: "b3"
        x: width
        y: width * 5
    }
    BoardSquare {
        id: c3
        name: "c3"
        x: width * 2
        y: width * 5
        odd: true
    }
    BoardSquare {
        id: d3
        name: "d3"
        x: width * 3
        y: width * 5
    }
    BoardSquare {
        id: e3
        name: "e3"
        x: width * 4
        y: width * 5
        odd: true
    }
    BoardSquare {
        id: f3
        name: "f3"
        x: width * 5
        y: width * 5
    }
    BoardSquare {
        id: g3
        name: "g3"
        x: width * 6
        y: width * 5
        odd: true
    }
    BoardSquare {
        id: h3
        name: "h3"
        x: width * 7
        y: width * 5
    }
    // Row 6
    BoardSquare {
        id: a2
        name: "a2"
        x: 0
        y: width * 6
        piece: white_pawn_0
    }
    BoardSquare {
        id: b2
        name: "b2"
        x: width
        y: width * 6
        odd: true
        piece: white_pawn_1
    }
    BoardSquare {
        id: c2
        name: "c2"
        x: width * 2
        y: width * 6
        piece: white_pawn_2
    }
    BoardSquare {
        id: d2
        name: "d2"
        x: width * 3
        y: width * 6
        odd: true
        piece: white_pawn_3
    }
    BoardSquare {
        id: e2
        name: "e2"
        x: width * 4
        y: width * 6
        piece: white_pawn_4
    }
    BoardSquare {
        id: f2
        name: "f2"
        x: width * 5
        y: width * 6
        odd: true
        piece: white_pawn_5
    }
    BoardSquare {
        id: g2
        name: "g2"
        x: width * 6
        y: width * 6
        piece: white_pawn_6
    }
    BoardSquare {
        id: h2
        name: "h2"
        x: width * 7
        y: width * 6
        odd: true
        piece: white_pawn_7
    }
    // Row 7
    BoardSquare {
        id: a1
        name: "a1"
        x: 0
        y: width * 7
        odd: true
        piece: white_rook_0
    }
    BoardSquare {
        id: b1
        name: "b1"
        x: width
        y: width * 7
        piece: white_knight_0
    }
    BoardSquare {
        id: c1
        name: "c1"
        x: width * 2
        y: width * 7
        odd: true
        piece: white_bishop_0
    }
    BoardSquare {
        id: d1
        name: "d1"
        x: width * 3
        y: width * 7
        piece: white_queen
    }
    BoardSquare {
        id: e1
        name: "e1"
        x: width * 4
        y: width * 7
        odd: true
        piece: white_king
    }
    BoardSquare {
        id: f1
        name: "f1"
        x: width * 5
        y: width * 7
        piece: white_bishop_1
    }
    BoardSquare {
        id: g1
        name: "g1"
        x: width * 6
        y: width * 7
        odd: true
        piece: white_knight_1
    }
    BoardSquare {
        id: h1
        name: "h1"
        x: width * 7
        y: width * 7
        piece: white_rook_1
    }
    // Black pieces
    Image {
        id: black_rook_0
        source: "pieces/black/rook.svg"
        anchors.centerIn: parent
        parent: a8
    }
    Image {
        id: black_knight_0
        source: "pieces/black/knight.svg"
        anchors.centerIn: parent
        parent: b8
    }
    Image {
        id: black_bishop_0
        source: "pieces/black/bishop.svg"
        anchors.centerIn: parent
        parent: c8
    }
    Image {
        id: black_queen
        source: "pieces/black/queen.svg"
        anchors.centerIn: parent
        parent: d8
    }
    Image {
        id: black_king
        source: "pieces/black/king.svg"
        anchors.centerIn: parent
        parent: e8
    }
    Image {
        id: black_bishop_1
        source: "pieces/black/bishop.svg"
        anchors.centerIn: parent
        parent: f8
    }
    Image {
        id: black_knight_1
        source: "pieces/black/knight.svg"
        anchors.centerIn: parent
        parent: g8
    }
    Image {
        id: black_rook_1
        source: "pieces/black/rook.svg"
        anchors.centerIn: parent
        parent: h8
    }
    Image {
        id: black_pawn_0
        source: "pieces/black/pawn.svg"
        anchors.centerIn: parent
        parent: a7
    }
    Image {
        id: black_pawn_1
        source: "pieces/black/pawn.svg"
        anchors.centerIn: parent
        parent: b7
    }
    Image {
        id: black_pawn_2
        source: "pieces/black/pawn.svg"
        anchors.centerIn: parent
        parent: c7
    }
    Image {
        id: black_pawn_3
        source: "pieces/black/pawn.svg"
        anchors.centerIn: parent
        parent: d7
    }
    Image {
        id: black_pawn_4
        source: "pieces/black/pawn.svg"
        anchors.centerIn: parent
        parent: e7
    }
    Image {
        id: black_pawn_5
        source: "pieces/black/pawn.svg"
        anchors.centerIn: parent
        parent: f7
    }
    Image {
        id: black_pawn_6
        source: "pieces/black/pawn.svg"
        anchors.centerIn: parent
        parent: g7
    }
    Image {
        id: black_pawn_7
        source: "pieces/black/pawn.svg"
        anchors.centerIn: parent
        parent: h7
    }
    // White pieces
    Image {
        id: white_rook_0
        source: "pieces/white/rook.svg"
        anchors.centerIn: parent
        parent: a1
    }
    Image {
        id: white_knight_0
        source: "pieces/white/knight.svg"
        anchors.centerIn: parent
        parent: b1
    }
    Image {
        id: white_bishop_0
        source: "pieces/white/bishop.svg"
        anchors.centerIn: parent
        parent: c1
    }
    Image {
        id: white_queen
        source: "pieces/white/queen.svg"
        anchors.centerIn: parent
        parent: d1
    }
    Image {
        id: white_king
        source: "pieces/white/king.svg"
        anchors.centerIn: parent
        parent: e1
    }
    Image {
        id: white_bishop_1
        source: "pieces/white/bishop.svg"
        anchors.centerIn: parent
        parent: f1
    }
    Image {
        id: white_knight_1
        source: "pieces/white/knight.svg"
        anchors.centerIn: parent
        parent: g1
    }
    Image {
        id: white_rook_1
        source: "pieces/white/rook.svg"
        anchors.centerIn: parent
        parent: h1
    }
    Image {
        id: white_pawn_0
        source: "pieces/white/pawn.svg"
        anchors.centerIn: parent
        parent: a2
    }
    Image {
        id: white_pawn_1
        source: "pieces/white/pawn.svg"
        anchors.centerIn: parent
        parent: b2
    }
    Image {
        id: white_pawn_2
        source: "pieces/white/pawn.svg"
        anchors.centerIn: parent
        parent: c2
    }
    Image {
        id: white_pawn_3
        source: "pieces/white/pawn.svg"
        anchors.centerIn: parent
        parent: d2
    }
    Image {
        id: white_pawn_4
        source: "pieces/white/pawn.svg"
        anchors.centerIn: parent
        parent: e2
    }
    Image {
        id: white_pawn_5
        source: "pieces/white/pawn.svg"
        anchors.centerIn: parent
        parent: f2
    }
    Image {
        id: white_pawn_6
        source: "pieces/white/pawn.svg"
        anchors.centerIn: parent
        parent: g2
    }
    Image {
        id: white_pawn_7
        source: "pieces/white/pawn.svg"
        anchors.centerIn: parent
        parent: h2
    }
}
