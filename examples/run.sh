#!/bin/sh

#PYTHONPATH=.. robot --loglevel=DEBUG *.robot

PYTHONPATH=.. robot *.robot
open report.html