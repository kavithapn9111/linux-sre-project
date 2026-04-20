#!/bin/bash

pkill -f app.py
nohup python3 app/app.py > app.log 2>&1 &
