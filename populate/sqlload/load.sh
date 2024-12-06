#!/bin/bash

# Peuple la base de donnée à grâce à SQL*Load.

sqlldr userid=admin/banane control=user_control.txt log=user_log.txt bad=user_bad.txt discard=user_disard.txt errors=0 skip=1