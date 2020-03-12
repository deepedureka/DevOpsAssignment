#!/bin/bash -xel
#First approach
ls -ltr
python --version
python3 --version
python3 holdPR.py
#Second Approach
wget -q -o holdPR.py https://github.com/deepkumarchaudhary/DevOpsAssignment/blob/master/holdPR.py
ls -ltr
python holdPR.py

#Poll SCM Configuration for thursday at 2 PM
#M H  DOM M DOW
#H 14 * * 4
Exit 0