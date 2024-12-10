#!/bin/bash

# Peuple la base de donnée à grâce à SQL*Load.

# TODO: Décommenter tout ! (les lignes étaient commentées pour tester)
# sqlldr userid=admin/banane control=user/control.txt log=user/log.txt bad=user/bad.txt discard=user/disard.txt errors=0 skip=1
sqlldr userid=admin/banane control=post/control.txt log=post/log.txt bad=post/bad.txt discard=post/disard.txt errors=0 skip=0
