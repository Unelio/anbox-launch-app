#!/bin/bash
## Préchargement
DEVICE=`adb devices | grep emulator`
if [ -z "$DEVICE" ];
then
  # On lance une application inexistante pour précharger anbox
  nohup /snap/bin/anbox launch --action=android.intent.action.MAIN  --package=000
fi

## Lancement de l'application android (ex: ./android.sh dictionnaires)
URI=`adb shell pm list packages | grep $1 | tail -1`
ACTIVITY=`adb shell cmd package resolve-activity --brief ${URI#package:} | tail -n 1`

/snap/bin/anbox launch --action=android.intent.action.MAIN --package=${URI#package:} --component=${ACTIVITY//$'/'/} &

## Modification de la variable à rechercher pour récupérer la fenêtre à agrandir
case $1 in
  phpsysinfo)
    SEARCH=psiandroid
  ;;
  leconjugueur.nb)
    #SEARCH=nb
    SEARCH=nombres
  ;;
  leconjugueur)
    SEARCH=conjugueur
    LE=true # si la fenêtre de l'apk a pour titre "Le ..." (ex : ici "Le conjugueur")
  ;;
  *)
    SEARCH=$1
esac

## Changement des dimenssions de la fenêtre (ici: 1366x768)
if [ ! -z $LE ]
then
  while [ -z `wmctrl -l | grep " 0 " | grep -iF $SEARCH | awk '{print $5}'` ]
  do
    sleep 1
  done
  WINDOW=`wmctrl -l | grep " 0 " | grep -iF $SEARCH | awk '{print $5}'`
else
  while [ -z `wmctrl -l | grep " 0 " | grep -iF $SEARCH | awk '{print $4}'` ]
  do
    sleep 1
  done
  WINDOW=`wmctrl -l | grep " 0 " | grep -iF $SEARCH | awk '{print $4}'`
fi
wmctrl -r $WINDOW -e 0,-1,-1,1366,768
