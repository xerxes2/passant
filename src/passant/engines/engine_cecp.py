# -*- coding: utf-8 -*-

import subprocess
import thread

class EngineCECP():
    def __init__(self, _callback):
        self.commands = ["st"]
        self.output_callback = _callback

    def start_engine(self, _engine):
        self.engine = subprocess.Popen([_engine, "-q"], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        self.send_command("xboard")
        self.thread_id = thread.start_new_thread(self.engine_thread, ())

    def engine_thread(self):
        thread_id = self.thread_id
        self.output = []
        while thread_id == self.thread_id and self.thread_id != None:
            _line = self.engine.stdout.readline()
            self.output.append(_line)
            if len(self.output) > 20:
                self.output = self.output[10:]
            self.output_callback(_line)

    def send_command(self, _command):
        self.engine.stdin.write(_command + "\n")

    def quit_engine(self):
        self.thread_id = None
        try:
            self.engine.stdin.write("quit\n")
        except:
            pass

    def make_move(self, _move):
        self.send_command(_move)

    def set_time_per_move(self, _time):
        self.send_command("st " + _time)

    def start_game(self):
        self.send_command("go")
