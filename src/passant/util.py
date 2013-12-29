# -*- coding: utf-8 -*-

from __future__ import absolute_import

import os.path
from sys import argv


def find_data_file(filename):
    bin_dir = os.path.dirname(argv[0])
    locations = [
            os.path.join(bin_dir, '..', 'icons'),
            os.path.join(bin_dir, '..', 'data'),
            os.path.join(bin_dir, '..', 'data/ui'),
            os.path.join(bin_dir, '..', 'share/passant'),
            '/opt/passant/qml',
    ]

    for location in locations:
        fn = os.path.abspath(os.path.join(location, filename))
        if os.path.exists(fn):
            return fn

def write_config(config):
    _file = open(os.path.expanduser("~/.config/passant/passant-noedit.conf"), "w")
    config.write(_file)
    _file.close()
