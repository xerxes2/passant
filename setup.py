#!/usr/bin/env python

from distutils.core import setup

import glob
import os
import sys

SRC_DIR = 'src/'

d2p = lambda d: d[len(SRC_DIR):].replace('/', '.')
PACKAGES = [d2p(d) for d, dd, ff in os.walk(SRC_DIR) if '__init__.py' in ff]

SCRIPTS = glob.glob('bin/*')

DATA_FILES = [
    ('share/passant/qml', glob.glob('data/ui/qml/*.qml')),
    ('share/passant/qml2', glob.glob('data/ui/qml2/*.qml')),
    ('share/passant/pieces/white', glob.glob('data/pieces/white/*.svg')),
    ('share/passant/pieces/black', glob.glob('data/pieces/black/*.svg')),
    ('share/applications', ['data/passant.desktop']),
    ('share/pixmaps', ['data/passant.svg']),
]

sys.path.insert(0, SRC_DIR)
import passant

setup(
        name='passant',
        version=passant.__version__,
        description='Chess game',
        author='Jens Persson',
        author_email='xerxes2@gmail.com',
        url='http://github.org/xerxes2/passant',
        packages=PACKAGES,
        package_dir={ '': SRC_DIR },
        scripts=SCRIPTS,
        data_files=DATA_FILES,
)

if "install" in sys.argv:
    _prefix = "/usr"
    _rootdir = "/"
    for i in sys.argv:
        if i.startswith("--prefix"):
            _prefix = i[9:]
        elif i.startswith("--root"):
            _rootdir = i[7:]
    if os.path.exists(_rootdir +  _prefix + "/share/passant/qml/pieces"):
        os.remove(_rootdir + _prefix + "/share/passant/qml/pieces")
    os.symlink("../pieces", _rootdir + _prefix + "/share/passant/qml/pieces")
    if os.path.exists(_rootdir +  _prefix + "/share/passant/qml2/pieces"):
        os.remove(_rootdir + _prefix + "/share/passant/qml2/pieces")
    os.symlink("../pieces", _rootdir + _prefix + "/share/passant/qml2/pieces")
