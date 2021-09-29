#!/bin/sh

#PYTHONPATH=. robot --loglevel=DEBUG --outputdir=examples examples/*.robot

PYTHONPATH=. robot --name "run tests" --outputdir=tests tests/0*.robot

#open examples/report.html