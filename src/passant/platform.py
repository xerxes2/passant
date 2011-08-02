# -*- coding: utf-8 -*-

from __future__ import absolute_import

import os.path

# Variables that can be used to query platform status
MAEMO = False
FREMANTLE = False
HARMATTAN = False
MEEGO = False
HANDSET = False
DESKTOP = True

def file_contains(filename, content):
    try:
        for line in open(filename):
            if content in line:
                return True
    except:
        return False

def detect():
    """Detect current environment
    This should be called once from the launcher.
    """
    global MAEMO
    global FREMANTLE
    global HARMATTAN
    global MEEGO
    global HANDSET
    global DESKTOP

    if os.path.exists('/etc/osso_software_version') or \
            os.path.exists('/proc/component_version') or \
            file_contains('/etc/issue', 'maemo') or \
            file_contains('/etc/issue', 'Harmattan') or \
            os.path.exists('/etc/meego-release'):
        HANDSET = True
        DESKTOP = False

        if os.path.exists('/etc/osso_software_version') or \
                os.path.exists('/proc/component_version') or \
                file_contains('/etc/issue', 'maemo') or \
                file_contains('/etc/issue', 'Harmattan'):
            MAEMO = True

            if file_contains('/etc/issue', 'Maemo 5'):
                FREMANTLE = True
            elif file_contains('/etc/issue', 'Harmattan'):
                HARMATTAN = True

        elif os.path.exists('/etc/meego-release'):
            MEEGO = True
