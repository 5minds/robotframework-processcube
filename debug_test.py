#!/usr/bin/env python
"""
Debug-Skript um Robot Tests mit Python-Debugger zu starten
"""
import sys
import pdb

# Setze PYTHONPATH
sys.path.insert(0, '.')

# Starte mit pdb
if __name__ == '__main__':
    pdb.set_trace()  # Breakpoint
    import robot
    robot.run('tests/07_external_task.robot', outputdir='tests')
