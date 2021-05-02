#!/bin/sh

#PYTHONPATH=. robot --loglevel=DEBUG --outputdir=examples examples/*.robot

PYTHONPATH=. robot --outputdir=examples examples/*.robot

open examples/report.html