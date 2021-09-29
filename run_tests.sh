#!/bin/sh

#PYTHONPATH=. robot --loglevel=DEBUG --outputdir=examples examples/*.robot

PYTHONPATH=. robot --outputdir=tests tests/0*.robot

#open examples/report.html