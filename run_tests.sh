#!/bin/sh

PYTHONPATH=. python -m robot --name "run tests" --outputdir=tests tests/*.robot
