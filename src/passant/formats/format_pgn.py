# -*- coding: utf-8 -*-

from passant.validator import validator

_squares = ["a1", "b1", "c1", "d1", "e1", "f1", "g1", "h1",
            "a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2",
            "a3", "b3", "c3", "d3", "e3", "f3", "g3", "h3",
            "a4", "b4", "c4", "d4", "e4", "f4", "g4", "h4",
            "a5", "b5", "c5", "d5", "e5", "f5", "g5", "h5",
            "a6", "b6", "c6", "d6", "e6", "f6", "g6", "h6",
            "a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7",
            "a8", "b8", "c8", "d8", "e8", "f8", "g8", "h8"]

def save_format(_file, _moves, _boards, _info):
    event_tag = """[Event "%s"]""" %(_info["event"])
    site_tag = """[Site "%s"]""" %(_info["site"])
    date_tag = """[Date "%s"]""" %(_info["date"])
    round_tag = """[Round "%s"]""" %(_info["round"])
    white_tag = """[White "%s"]""" %(_info["white"])
    black_tag = """[Black "%s"]""" %(_info["black"])
    result_tag = """[Result "%s"]""" %(_info["result"])

    _out = open(_file, "w")
    _out.write(event_tag + "\n")
    _out.write(site_tag + "\n")
    _out.write(date_tag + "\n")
    _out.write(round_tag + "\n")
    _out.write(white_tag + "\n")
    _out.write(black_tag + "\n")
    _out.write(result_tag + "\n")
    _out.write("\n")

    validator.new_game()
    pgn_moves = []
    _result = ""
    for i in range(len(_moves)):
        validator.validate_move(_moves[i])
        square_0 = _moves[i][:2]
        square_1 = _moves[i][2:]

        if validator.boards[i][square_1] == "":
            _hit = ""
        else:
            _hit = "x"
        if validator.check:
            if validator.check_mate:
                _check = "#"
                if validator.current_player == "w":
                    _result = " 0-1"
                else:
                    _result = " 1-0"
            else:
                _check = "+"
        else:
            _check = ""
        if validator.queening_square:
            validator.add_queening(_boards[i + 1][validator.queening_square][1:])

        if validator.boards[i + 1][square_1].endswith("k"):
            if validator.moved_piece == "a1d1" or validator.moved_piece == "a8d8":
                pgn_moves.append("O-O-O" + _check + _result)
            elif validator.moved_piece == "h1f1" or validator.moved_piece == "h8f8":
                pgn_moves.append("O-O" + _check + _result)
            else:
                pgn_moves.append("K" + _hit + square_1 + _check + _result)
        elif validator.boards[i + 1][square_1].endswith("q") and not validator.queening_square:
            pgn_moves.append("Q" + _hit + square_1 + _check + _result)
        elif validator.boards[i + 1][square_1].endswith("r") and not validator.queening_square:
            pgn_moves.append("R" + _hit + square_1 + _check + _result)
        elif validator.boards[i + 1][square_1].endswith("n") and not validator.queening_square:
            pgn_moves.append("N" + _hit + square_1 + _check + _result)
        elif validator.boards[i + 1][square_1].endswith("b") and not validator.queening_square:
            pgn_moves.append("B" + _hit + square_1 + _check + _result)
        else:
            if validator.queening_square:
                _queening = "=" + validator.boards[i + 1][square_1][1:].upper()
            else:
                _queening = ""
            if square_0[:1] != square_1[:1]:
                pgn_moves.append(square_0[:1] + "x" + square_1 + _queening + _check + _result)
            else:
                pgn_moves.append(square_1 + _queening + _check + _result)

    _move = 1
    _str = ""
    for i in range(len(pgn_moves)):
        if i / 2 * 2 == i:
            if len(_str + str(_move) + ".") > 80:
                _out.write(_str.strip() + "\n")
                _str = ""
            _str = _str + str(_move) + ". "
            _move = _move + 1

        if len(_str  + pgn_moves[i]) > 80:
            _out.write(_str.strip() + "\n")
            _str = ""
        _str = _str + pgn_moves[i] + " "

    _out.write(_str.strip() + "\n")
    _out.close()
