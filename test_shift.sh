#!/bin/sh
clear # Un peu facile si la commande reste au dessus :-)
until [ $# = 0 ]
do
  echo -n "Taper l'option suivante : "
  read Reslt
  if [ "$Reslt" = "$1" ]; then
    echo "Bien joué !"
  else
    echo "Non mais quand même !!! C'ÉTAIT $1 ET NON PAS $Reslt PETIT FRIPON !!!"
    sleep 3 # Juste pour le fun du script qui rage ;-p
    echo "Donc je te bannis de ubuntu-fr.org ! Et toc !! Tu ne peux rien contre moi !!!"
    exit 1
  fi
  shift # On défile
done
echo "Vous avez réussi !"
