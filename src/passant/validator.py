# -*- coding: utf-8 -*-

class MoveValidator():
    def __init__(self):
        self.squares = ["a1", "b1", "c1", "d1", "e1", "f1", "g1", "h1",
            "a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2",
            "a3", "b3", "c3", "d3", "e3", "f3", "g3", "h3",
            "a4", "b4", "c4", "d4", "e4", "f4", "g4", "h4",
            "a5", "b5", "c5", "d5", "e5", "f5", "g5", "h5",
            "a6", "b6", "c6", "d6", "e6", "f6", "g6", "h6",
            "a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7",
            "a8", "b8", "c8", "d8", "e8", "f8", "g8", "h8"]

        self.chars = ["a", "b", "c", "d", "e", "f", "g", "h"]
        self.new_game()

    def new_game(self):
         self.current_board = {"a1": "wr", "b1": "wn", "c1": "wb", "d1": "wq", "e1": "wk", "f1": "wb", "g1": "wn", "h1": "wr",
            "a2": "wp", "b2": "wp", "c2": "wp", "d2": "wp", "e2": "wp", "f2": "wp", "g2": "wp", "h2": "wp",
            "a3": "", "b3": "", "c3": "", "d3": "", "e3": "", "f3": "", "g3": "", "h3": "",
            "a4": "", "b4": "", "c4": "", "d4": "", "e4": "", "f4": "", "g4": "", "h4": "",
            "a5": "", "b5": "", "c5": "", "d5": "", "e5": "", "f5": "", "g5": "", "h5": "",
            "a6": "", "b6": "", "c6": "", "d6": "", "e6": "", "f6": "", "g6": "", "h6": "",
            "a7": "bp", "b7": "bp", "c7": "bp", "d7": "bp", "e7": "bp", "f7": "bp", "g7": "bp", "h7": "bp",
            "a8": "br", "b8": "bn", "c8": "bb", "d8": "bq", "e8": "bk", "f8": "bb", "g8": "bn", "h8": "br"}
         self.boards = []
         self.moves = []
         self.boards.append(self.current_board.copy())
         self.current_player = "w"
         self.other_player = "b"
         self.check = False
         self.check_mate = False
         self.castling = False
         self.castling_w_a = True
         self.castling_w_h = True
         self.castling_b_a = True
         self.castling_b_h = True
         self.passant = False
         self.passant_square = ""
         self.queening = False

    def add_piece(self, _square, _piece):
        self.current_board[_square] = _piece

    def move_piece(self, square_0, square_1):
        self.current_board[square_1] = self.current_board[square_0]
        self.current_board[square_0] = ""

    def remove_piece(self, _square):
        self.current_board[_square] = ""

    def add_queening(self, _piece):
        self.add_piece(self.queening_square, self.current_player + _piece)
        self.validate_check_other()
        self.boards.append(self.current_board.copy())
        self.switch_player()

    def get_valid_square(self, _square):
        if self.current_board[_square].startswith(self.current_player):
            return True
        else:
            return False

    def validate_move(self, _move):
        square_0 = _move[:2]
        square_1 = _move[2:]
        self.piece = self.current_board[square_0][1:]
        self.removed_piece = ""
        self.queening_square = ""
        self.moved_piece = ""

        if not self.current_board[square_0].startswith(self.current_player):
            return False
        if self.current_board[square_1].startswith(self.current_player):
            return False

        # Validate move
        if self.piece == "k":
            if not self.validate_king(square_0, square_1):
                return False
            self.passant_square = ""
        elif self.piece == "r":
            if not self.validate_rook(square_0, square_1):
                return False
            self.passant_square = ""
        elif self.piece == "b":
            if not self.validate_bishop(square_0, square_1):
                return False
            self.passant_square = ""
        elif self.piece == "q":
            if not self.validate_queen(square_0, square_1):
                return False
            self.passant_square = ""
        elif self.piece == "n":
            if not self.validate_knight(square_0, square_1):
                return False
            self.passant_square = ""
        else:
            if not self.validate_pawn(square_0, square_1):
                return False

        # Move validated
        self.move_piece(square_0, square_1)
        # Special moves
        if self.passant:
            self.passant = False
            if self.current_player == "w":
                self.removed_piece = square_1[:1] + str(int(square_1[1:]) - 1)
            else:
                self.removed_piece = square_1[:1] + str(int(square_1[1:]) + 1)
            self.remove_piece(self.removed_piece)
        elif self.castling:
            self.castling = False
            if square_1 == "c1":
                self.moved_piece = "a1d1"
            elif square_1 == "g1":
                self.moved_piece = "h1f1"
            elif square_1 == "c8":
                self.moved_piece = "a8d8"
            else:
                self.moved_piece = "h8f8"
            self.move_piece(self.moved_piece[:2], self.moved_piece[2:])

        if not self.validate_check_current():
            self.current_board = self.boards[-1].copy()
            self.queening_square = ""
            return False

        self.validate_check_other()
        self.special_moves(square_0, square_1)

        if not self.queening_square:
            self.boards.append(self.current_board.copy())
            self.switch_player()
            
        self.moves.append(_move)
        return True

    def validate_pawn(self, square_0, square_1):
        if self.current_player == "w":
            if not int(square_0[1:]) < int(square_1[1:]):
                return False
            if int(square_0[1:]) == 2:
                if not int(square_1[1:]) - int(square_0[1:]) <= 2:
                    return False
                if int(square_1[1:]) - int(square_0[1:]) == 2:
                    if self.current_board[square_0[:1] + str(int(square_0[1:]) + 1)] != "" or \
                      square_0[:1] != square_1[:1]:
                        return False
            else:
                if not int(square_1[1:]) - int(square_0[1:]) == 1:
                    return False
            if square_0[:1] == square_1[:1]:
                if not self.current_board[square_1] == "":
                    return False
            else:
                if self.chars.index(square_0[:1]) - self.chars.index(square_1[:1]) > 1 or \
                    self.chars.index(square_0[:1]) - self.chars.index(square_1[:1]) < -1:
                    return False
                if self.current_board[square_1] == "" and square_1 != self.passant_square:
                    return False
                elif self.current_board[square_1] == "":
                    self.passant = True
            if int(square_1[1:]) - int(square_0[1:]) == 2:
                self.passant_square = square_0[:1] + str(int(square_0[1:]) + 1)
            else:
                self.passant_square = ""
        else:
            if not int(square_0[1:]) > int(square_1[1:]):
                return False
            if int(square_0[1:]) == 7:
                if not int(square_0[1:]) - int(square_1[1:]) <= 2:
                    return False
                if int(square_0[1:]) - int(square_1[1:]) == 2:
                    if self.current_board[square_0[:1] + str(int(square_0[1:]) - 1)] != "" or \
                      square_0[:1] != square_1[:1]:
                        return False
            else:
                if not int(square_0[1:]) - int(square_1[1:]) == 1:
                    return False
            if square_0[:1] == square_1[:1]:
                if not self.current_board[square_1] == "":
                    return False
            else:
                if self.chars.index(square_0[:1]) - self.chars.index(square_1[:1]) > 1 or \
                    self.chars.index(square_0[:1]) - self.chars.index(square_1[:1]) < -1:
                    return False
                if self.current_board[square_1] == "" and square_1 != self.passant_square:
                    return False
                elif self.current_board[square_1] == "":
                    self.passant = True
            if int(square_0[1:]) - int(square_1[1:]) == 2:
                self.passant_square = square_0[:1] + str(int(square_0[1:]) - 1)
            else:
                self.passant_square = ""

        return True

    def validate_king(self, square_0, square_1):
        if self.current_player == "w":
            if square_0 == "e1" and square_1 == "c1" and self.castling_w_a == True \
              and not self.current_board["b1"] and not self.current_board["c1"] \
                and not self.current_board["d1"] and not self.check and self.validate_check_current("d1"):
                self.castling = True
                return True
            elif square_0 == "e1" and square_1 == "g1" and self.castling_w_h == True \
              and not self.current_board["f1"] and not self.current_board["g1"] \
              and not self.check and self.validate_check_current("f1"):
                self.castling = True
                return True
        else:
            if square_0 == "e8" and square_1 == "c8" and self.castling_b_a == True \
              and not self.current_board["b8"] and not self.current_board["c8"] \
              and not self.current_board["d8"] and not self.check and self.validate_check_current("d8"):
                self.castling = True
                return True
            elif square_0 == "e8" and square_1 == "g8" and self.castling_b_h == True \
              and not self.current_board["f8"] and not self.current_board["g8"] \
              and not self.check and self.validate_check_current("f8"):
                self.castling = True
                return True

        if int(square_1[1:]) - int(square_0[1:]) > 1:
           return False
        if int(square_1[1:]) - int(square_0[1:]) < -1:
           return False
        if self.chars.index(square_1[:1]) - self.chars.index(square_0[:1]) > 1:
           return False
        if self.chars.index(square_1[:1]) - self.chars.index(square_0[:1]) < -1:
           return False

        return True

    def validate_rook(self, square_0, square_1):
        if square_0[:1] != square_1[:1] and square_0[1:] != square_1[1:]:
           return False

        if square_0[:1] == square_1[:1]:
            _char = square_0[:1]
            index_0 = int(square_0[1:]) + 1
            index_1 = int(square_1[1:])
            if index_0 > index_1:
                _int = index_0
                index_0 = index_1 + 1
                index_1 = _int - 1
            for i in range(index_0, index_1):
                if self.current_board[_char + str(i)] != "":
                   return False
        else:
            _number = square_0[1:]
            index_0 = self.chars.index(square_0[:1]) + 1
            index_1 = self.chars.index(square_1[:1])
            if index_0 > index_1:
                _int = index_0
                index_0 = index_1 + 1
                index_1 = _int - 1
            for i in range(index_0, index_1):
                if self.current_board[self.chars[i] + _number] != "":
                   return False

        return True

    def validate_bishop(self, square_0, square_1):
        coords_0 = (self.chars.index(square_0[:1]) + 1, int(square_0[1:]))
        coords_1 = (self.chars.index(square_1[:1]) + 1, int(square_1[1:]))
        
        if (coords_0[0] < coords_1[0] and coords_0[1] < coords_1[1]) or \
           (coords_0[0] > coords_1[0] and coords_0[1] > coords_1[1]):
            if not coords_0[0] - coords_1[0] == coords_0[1] - coords_1[1]:
                return False

            index_0 = coords_0[0]
            index_1 = coords_1[0] - 1
            index_3 = coords_0[1]
            if index_0 > index_1:
                _int = index_0
                index_0 = index_1 + 1
                index_1 = _int - 1
                index_3 = coords_1[1]
            for i in range(index_0, index_1):
                index_3 = index_3 + 1
                if self.current_board[self.chars[i] + str(index_3)] != "":
                   return False

        else:
            if not coords_1[0] - coords_0[0] == coords_0[1] - coords_1[1]:
                return False

            index_0 = coords_0[0]
            index_1 = coords_1[0] - 1
            index_3 = coords_0[1]
            if index_0 > index_1:
                _int = index_0
                index_0 = index_1 + 1
                index_1 = _int - 1
                index_3 = coords_1[1]
            for i in range(index_0, index_1):
                index_3 = index_3 - 1
                if self.current_board[self.chars[i] + str(index_3)] != "":
                   return False

        return True

    def validate_queen(self, square_0, square_1):
        if not self.validate_rook(square_0, square_1) and not self.validate_bishop(square_0, square_1):
            return False

        return True

    def validate_knight(self, square_0, square_1):
        coords_0 = (self.chars.index(square_0[:1]) + 1, int(square_0[1:]))
        coords_1 = (self.chars.index(square_1[:1]) + 1, int(square_1[1:]))

        if coords_0[0] == coords_1[0] - 1:
            if coords_1[1] != coords_0[1] + 2 and coords_1[1] != coords_0[1] - 2:
                return False
        elif coords_0[0] == coords_1[0] - 2:
            if coords_1[1] != coords_0[1] + 1 and coords_1[1] != coords_0[1] - 1:
                return False
        elif coords_0[0] == coords_1[0] + 1:
            if coords_1[1] != coords_0[1] + 2 and coords_1[1] != coords_0[1] - 2:
                return False
        elif coords_0[0] == coords_1[0] + 2:
            if coords_1[1] != coords_0[1] + 1 and coords_1[1] != coords_0[1] - 1:
                return False
        else:
            return False

        return True

    def special_moves(self, square_0, square_1):
        if self.piece == "p":
            if square_1[1:] == "1" or square_1[1:] == "8":
                self.queening_square = square_1
        elif self.piece == "r":
            if square_0 == "a1":
                self.castling_w_a = False
            elif square_0 == "h1":
                self.castling_w_h = False
            elif square_0 == "a8":
                self.castling_b_a = False
            elif square_0 == "h8":
                self.castling_b_h = False
        elif self.piece == "k":
            if self.current_player == "w":
                self.castling_w_a = False
                self.castling_w_h = False
            else:
                self.castling_b_a = False
                self.castling_b_h = False

    def validate_check_current(self, _square=None):
        if not _square:
            for _square in self.squares:
                if self.current_board[_square] == self.current_player + "k":
                    break

        self.current_player = self.other_player
        for i in self.squares:
            if self.current_board[i].startswith(self.other_player):
                _piece = self.current_board[i][1:]
                if _piece == "k":
                    if self.validate_king(i, _square):
                        self.switch_player()
                        return False
                elif _piece == "q":
                    if self.validate_queen(i, _square):
                        self.switch_player()
                        return False
                elif _piece == "r":
                    if self.validate_rook(i, _square):
                        self.switch_player()
                        return False
                elif _piece == "n":
                    if self.validate_knight(i, _square):
                        self.switch_player()
                        return False
                elif _piece == "b":
                    if self.validate_bishop(i, _square):
                        self.switch_player()
                        return False
                else:
                    if self.validate_pawn(i, _square):
                        self.switch_player()
                        return False

        self.switch_player()
        return True

    def validate_check_other(self):
        self.check = False
        for _square in self.squares:
            if self.current_board[_square] == self.other_player + "k":
                break

        for i in self.squares:
            if self.current_board[i].startswith(self.current_player):
                _piece = self.current_board[i][1:]
                if _piece == "q":
                    if self.validate_queen(i, _square):
                        self.check = True
                elif _piece == "r":
                    if self.validate_rook(i, _square):
                        self.check = True
                elif _piece == "n":
                    if self.validate_knight(i, _square):
                        self.check = True
                elif _piece == "b":
                    if self.validate_bishop(i, _square):
                        self.check = True
                else:
                    if self.validate_pawn(i, _square):
                        self.check = True

        if self.check:
            self.validate_check_mate()

    def validate_check_mate(self):
        self.check_mate = True
        _board = self.current_board
        self.current_board = _board.copy()
        self.switch_player()
        for square_0 in self.squares:
            if self.current_board[square_0].startswith(self.current_player):
                _piece = self.current_board[square_0][1:]
                for square_1 in self.squares:
                    if not self.current_board[square_1].startswith(self.current_player):
                        if _piece == "k":
                            if self.validate_king(square_0, square_1):
                                self.move_piece(square_0, square_1)
                                if self.validate_check_current():
                                    self.check_mate = False
                                else:
                                    self.current_board = _board.copy()
                        elif _piece == "q":
                            if self.validate_queen(square_0, square_1):
                                self.move_piece(square_0, square_1)
                                if self.validate_check_current():
                                    self.check_mate = False
                                else:
                                    self.current_board = _board.copy()
                        elif _piece == "r":
                            if self.validate_rook(square_0, square_1):
                                self.move_piece(square_0, square_1)
                                if self.validate_check_current():
                                    self.check_mate = False
                                else:
                                    self.current_board = _board.copy()
                        elif _piece == "n":
                            if self.validate_knight(square_0, square_1):
                                self.move_piece(square_0, square_1)
                                if self.validate_check_current():
                                    self.check_mate = False
                                else:
                                    self.current_board = _board.copy()
                        elif _piece == "b":
                            if self.validate_bishop(square_0, square_1):
                                self.move_piece(square_0, square_1)
                                if self.validate_check_current():
                                    self.check_mate = False
                                else:
                                    self.current_board = _board.copy()
                        else:
                            if self.validate_pawn(square_0, square_1):
                                self.move_piece(square_0, square_1)
                                if self.validate_check_current():
                                    self.check_mate = False
                                else:
                                    self.current_board = _board.copy()
        
        self.current_board = _board
        self.switch_player()

    def switch_player(self):
        if self.current_player == "w":
            self.current_player = "b"
            self.other_player = "w"
        else:
            self.current_player = "w"
            self.other_player = "b"

validator = MoveValidator()
