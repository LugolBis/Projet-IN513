#!/bin/bash

# Peuple la base de donnée à grâce à SQL*Load.

# TODO: Décommenter tout ! (les lignes étaient commentées pour tester)

# sqlldr userid=admin/banane control=user/control.txt log=user/log.txt bad=user/bad.txt discard=user/discard.txt errors=0 skip=1
# sqlldr userid=admin/banane control=post/control.txt log=post/log.txt bad=post/bad.txt discard=post/discard.txt errors=0 skip=0
# sqlldr userid=admin/banane control=survey/control.txt log=survey/log.txt bad=survey/bad.txt discard=survey/discard.txt errors=0 skip=1
# sqlldr userid=admin/banane control=option/control.txt log=option/log.txt bad=option/bad.txt discard=option/discard.txt errors=0 skip=1
# sqlldr userid=admin/banane control=answer/control.txt log=answer/log.txt bad=answer/bad.txt discard=answer/discard.txt errors=0 skip=1
# sqlldr userid=admin/banane control=vote/control.txt log=vote/log.txt bad=vote/bad.txt discard=vote/discard.txt errors=0 skip=1
# sqlldr userid=admin/banane control=private_message/control.txt log=private_message/log.txt bad=private_message/bad.txt discard=private_message/discard.txt errors=0 skip=1
# sqlldr userid=admin/banane control=receive/control.txt log=receive/log.txt bad=receive/bad.txt discard=receive/discard.txt errors=0 skip=1
# sqlldr userid=admin/banane control=signal/control.txt log=signal/log.txt bad=signal/bad.txt discard=signal/discard.txt errors=0 skip=1
# sqlldr userid=admin/banane control=draft/control.txt log=draft/log.txt bad=draft/bad.txt discard=draft/discard.txt errors=0 skip=1
sqlldr userid=admin/banane control=follow/control.txt log=follow/log.txt bad=follow/bad.txt discard=follow/discard.txt errors=0 skip=1