# -*- coding: utf-8 -*-

import sys
import os
import logging
import ConfigParser

from PySide import QtCore
from PySide import QtGui
from PySide import QtDeclarative

from passant import platform
from passant import util
from passant import validator
from passant.formats import format_pgn
from passant.engines import engine_cecp

class PassantGUI(QtCore.QObject):
    def __init__(self):
        QtCore.QObject.__init__(self)
        self.app = QtGui.QApplication(["Passant"])
        self.app.setWindowIcon(QtGui.QIcon(''))
        self.validator = validator.MoveValidator()
        self.view = QtDeclarative.QDeclarativeView()
        self.view.closeEvent = self.close_main_window_callback
        self.context = self.view.rootContext()
        self.context.setContextProperty('main', self)
        self.active_square = ""
        self.current_player = "w"
        self.engine_player = ""
        self.valid_move = False
        self.game_info = {"event": "", "site": "", "date": "", "round": "", "white": "", "black": "", "result": ""}
        self.pause = False
        self.create_actions()
        self.view.setResizeMode(QtDeclarative.QDeclarativeView.SizeRootObjectToView)

        self.timer_white = QtCore.QTimer()
        self.timer_white.setInterval(500)
        self.timer_white.timeout.connect(self.timer_white_callback)
        self.timer_black = QtCore.QTimer()
        self.timer_black.setInterval(500)
        self.timer_black.timeout.connect(self.timer_black_callback)
        self.time_white = ""
        self.time_black = ""

        self.engine = engine_cecp.EngineCECP(self.engine_callback)
        self.on_engine_move.connect(self.make_engine_move)
        
        self.view.setAttribute(QtCore.Qt.WA_LockLandscapeOrientation)
        if platform.HARMATTAN:
            self.view.setSource(util.find_data_file("main_harmattan.qml"))
            self.view.showFullScreen()
        else:
            self.view.setSource(util.find_data_file("main_default.qml"))
            self.view.show()
        self.app.exec_()

    def create_actions(self):
        self.action_new_manual_game = QtGui.QAction(QtGui.QIcon(''), "New Manual Game".decode("utf-8"), self.view,
            triggered=self.new_manual_game_callback)
        self.context.setContextProperty('action_new_manual_game', self.action_new_manual_game)
        self.action_new_engine_game = QtGui.QAction(QtGui.QIcon(''), "New Engine Game".decode("utf-8"), self.view,
            triggered=self.new_engine_game_callback)
        self.context.setContextProperty('action_new_engine_game', self.action_new_engine_game)
        self.action_quit = QtGui.QAction(QtGui.QIcon(''), "Quit".decode("utf-8"), self.view,
            triggered=self.quit_app)
        self.context.setContextProperty('action_quit', self.action_quit)
        # Queening
        self.queening_str = "Promote pawn to?"
        self.context.setContextProperty('queening_str', self.queening_str)
        self.queen_str = "Queen"
        self.context.setContextProperty('queen_str', self.queen_str)
        self.rook_str = "Rook"
        self.context.setContextProperty('rook_str', self.rook_str)
        self.knight_str = "Knight"
        self.context.setContextProperty('knight_str', self.knight_str)
        self.bishop_str = "Bishop"
        self.context.setContextProperty('bishop_str', self.bishop_str)
        # Misc
        self.done_str = "Done"
        self.context.setContextProperty('done_str', self.done_str)
        self.manual_game_str = "Manual Game"
        self.context.setContextProperty('manual_game_str', self.manual_game_str)
        self.rotation_str = "Rotation"
        self.context.setContextProperty('rotation_str', self.rotation_str)
        self.time_str = "Time in minutes"
        self.context.setContextProperty('time_str', self.time_str)
        self.unlimited_str = "Unlimited"
        self.context.setContextProperty('unlimited_str', self.unlimited_str)
        self.white_str = "White"
        self.context.setContextProperty('white_str', self.white_str)
        self.black_str = "Black"
        self.context.setContextProperty('black_str', self.black_str)
        self.pause_str = "Pause"
        self.context.setContextProperty('pause_str', self.pause_str)
        self.seconds_per_move_str = "Seconds per move"
        self.context.setContextProperty('seconds_per_move_str', self.seconds_per_move_str)
        self.name_str = "Name"
        self.context.setContextProperty('name_str', self.name_str)

    def quit_app(self):
        self.view.hide()
        self.engine.quit_engine()
        self.app.exit()

    def close_main_window_callback(self, event):
        self.quit_app()

    def show_main_window(self):
        self.view.activateWindow()

    def new_manual_game_callback(self):
        self.view.rootObject().property("root").openManualGame()

    def new_engine_game_callback(self):
        if not os.path.isfile("/usr/bin/gnuchess"):
            _str = "You have to install Gnuchess to be able to play against engine!"
            self.view.rootObject().property("root").openAppError(_str)
        else:
            self.view.rootObject().property("root").openEngineGame()

    @QtCore.Slot(str)
    def start_new_manual_game(self, _time):
        self.engine.quit_engine()
        self.engine_player = ""
        self.reset_time()
        self.validator.new_game()
        self.current_player = "w"
        self.on_move.emit()
        self.active_square = ""
        self.on_square.emit()
        self.view.rootObject().property("root").startNewGame()
        if _time:
            self.time_white = int(_time) * 60000000000
            self.time_black = int(_time) * 60000000000
            self.view.rootObject().property("root").setTime("w", util.convert_ns(self.time_white))
            self.view.rootObject().property("root").setTime("b", util.convert_ns(self.time_black))
            self.timer_white.start()

    @QtCore.Slot(str, str)
    def start_new_engine_game(self, _player, _time):
        self.engine.quit_engine()
        self.reset_time()
        self.validator.new_game()
        self.current_player = "w"
        self.engine_player = _player
        self.on_move.emit()
        self.active_square = ""
        self.on_square.emit()
        self.view.rootObject().property("root").startNewGame()
        self.engine.start_engine("gnuchess")
        if _time:
            self.engine.set_time_per_move(_time)
        if self.engine_player == "w":
            self.engine.start_game()

    def engine_callback(self, _line):
        if _line.startswith("My move is"):
            _move = _line.split(":")[-1].strip(" \n")
            self.on_engine_move.emit(_move)

    def make_engine_move(self, _move):
        if self.engine_player:
            if len(_move) == 5:
                _piece = _move[4:]
                _move = _move[:4]
            self.set_active_square(_move[:2])
            self.view.rootObject().property("root").movePiece(_move[:2], _move[2:])
            self.set_active_square("")
            self.validator.validate_move(_move)
            if self.validator.queening_square:
                self.view.rootObject().property("root").addPiece(self.validator.queening_square, self.engine_player + _piece)
                self.validator.add_queening(_piece)
            if self.validator.removed_piece:
                self.view.rootObject().property("root").removePiece(self.validator.removed_piece)
            if self.validator.moved_piece:
                self.view.rootObject().property("root").movePiece(self.validator.moved_piece[:2], self.validator.moved_piece[2:])
            self.switch_current_player()
            self.on_move.emit()

    def reset_time(self):
        self.timer_white.stop()
        self.timer_black.stop()
        self.time_white = ""
        self.time_black = ""
        self.view.rootObject().property("root").setTime("w", "00:00")
        self.view.rootObject().property("root").setTime("b", "00:00")

    @QtCore.Slot()
    def save_game(self):
        format_pgn.save_format("passant.pgn", self.validator.moves, self.validator.boards, self.game_info)

    def timer_white_callback(self):
        self.time_white = self.time_white - 500000000
        self.view.rootObject().property("root").setTime("w", util.convert_ns(self.time_white))
        if self.time_white <= 0:
            self.timer_white.stop()
            self.timer_black.stop()
            self.time_white = ""
            self.time_black = ""

    def timer_black_callback(self):
        self.time_black = self.time_black - 500000000
        self.view.rootObject().property("root").setTime("b", util.convert_ns(self.time_black))
        if self.time_black <= 0:
            self.timer_white.stop()
            self.timer_black.stop()
            self.time_white = ""
            self.time_black = ""

    def switch_timer(self):
        if self.time_white:
            if self.current_player == "w":
                self.timer_white.start()
                self.timer_black.stop()
            else:
                self.timer_white.stop()
                self.timer_black.start()
            if self.pause:
                self.pause = False
                self.on_pause.emit()

    @QtCore.Slot(bool)
    def start_stop_timer(self, _start):
        if self.time_white:
            if _start:
                if self.current_player == "w":
                    self.timer_white.start()
                else:
                    self.timer_black.start()
                self.pause = False
            else:
                self.timer_white.stop()
                self.timer_black.stop()
                self.pause = True
            self.on_pause.emit()

    @QtCore.Slot(str)
    def validate_move(self, _move):
        if self.validator.validate_move(_move):
            self.valid_move = True
            if self.validator.removed_piece:
                self.view.rootObject().property("root").removePiece(self.validator.removed_piece)
            if self.validator.moved_piece:
                self.view.rootObject().property("root").movePiece(self.validator.moved_piece[:2], self.validator.moved_piece[2:])
            if self.validator.queening_square and self.current_player != self.engine_player:
                self.view.rootObject().property("root").openQueening()
            else:
                self.switch_current_player()
                self.on_move.emit()
                self.switch_timer()
                if self.engine_player:
                    self.engine.make_move(_move)
        else:
            self.valid_move = False

    @QtCore.Slot(str)
    def queening(self, _piece):
        self.validator.add_queening(_piece)
        self.view.rootObject().property("root").addPiece(self.validator.queening_square, self.current_player + _piece)
        self.switch_current_player()
        self.on_move.emit()
        self.switch_timer()
        self.view.rootObject().property("root").rotateAll()
        if self.engine_player:
            self.engine.make_move(self.validator.moves[-1] + _piece)

    def switch_current_player(self):
        if self.current_player == "w":
            self.current_player = "b"
        else:
            self.current_player = "w"

    @QtCore.Slot(str)
    def validate_square(self, _square):
        if self.validator.get_valid_square(_square):
            self.active_square = _square
            self.on_square.emit()

    def get_active_square(self):
        return self.active_square

    @QtCore.Slot(str)
    def set_active_square(self, _square):
        self.active_square = _square
        self.on_square.emit()

    def get_valid_move(self):
        return self.valid_move

    def get_current_player(self):
        return self.current_player

    def get_check(self):
        return self.validator.check

    def get_check_mate(self):
        return self.validator.check_mate

    def get_pause(self):
        return self.pause

    on_move = QtCore.Signal()
    on_engine_move = QtCore.Signal(str)
    valid_move_bool = QtCore.Property(bool, get_valid_move, notify=on_move)
    check_bool = QtCore.Property(bool, get_check, notify=on_move)
    check_mate_bool = QtCore.Property(bool, get_check_mate, notify=on_move)
    current_player_str = QtCore.Property(str, get_current_player, notify=on_move)
    engine_move_str = QtCore.Property(str, make_engine_move, notify=on_move)
    on_square = QtCore.Signal()
    active_square_name = QtCore.Property(str, get_active_square, notify=on_square)
    on_pause = QtCore.Signal()
    pause_bool = QtCore.Property(bool, get_pause, notify=on_pause)
