#!/bin/bash

# Peuple la base de donnée à grâce à SQL*Load.

# TODO: Décommenter tout ! (les lignes étaient commentées pour tester)
# sqlldr userid=admin/banane control=user/control.txt log=user/log.txt bad=user/bad.txt discard=user/disard.txt errors=0 skip=1
# sqlldr userid=admin/banane control=post/control.txt log=post/log.txt bad=post/bad.txt discard=post/disard.txt errors=0 skip=0
# sqlldr userid=admin/banane control=survey/control.txt log=survey/log.txt bad=survey/bad.txt discard=survey/disard.txt errors=0 skip=1
# sqlldr userid=admin/banane control=option/control.txt log=option/log.txt bad=option/bad.txt discard=option/disard.txt errors=0 skip=1
sqlldr userid=admin/banane control=answer/control.txt log=answer/log.txt bad=answer/bad.txt discard=answer/disard.txt errors=0 skip=1