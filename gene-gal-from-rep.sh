#!/bin/bash
## créer une page html à partir d'un répertoire donné, ou sinon du répertoire
## dans lequel on se trouve
## cette version ne fonctionne pas avec un tri sur les photos car ce n'est pas
## un ls qui est fait dans la fonction lister

lister () {
  # lister les fichiers du répertoire $1
  for i in "$repertoire"/*.jpg "$repertoire"/*.JPG
  do
    echo $i
    if [ -f "$i" ]
    then
      img_liste[${#img_liste[*]}]="$i"
    fi
  done
  echo ${#img_liste[@]}
}

traitimage () {
  echo "exécution de la fonction traitimage"
  echo ${#img_liste[@]}
  echo ${img_liste[*]}
  # mémoriser l'IFS actuel
  R=$IFS
  # changer l'IFS à cause de l'espace dans les noms de répertoire
  IFS=’
’
  for image in ${img_liste[*]}
  do
    echo "++++++++++++++++++++++++++++++++++++"
    echo "$image"
    echo "++++++++++++++++++++++++++++++++++++"
    echo -e "image = $image\n"
    # créer la mignature "th_image.jpg
    # si le thumbnail de l'image n'existe pas déjà
    # ou alors que le thumbnail est plus ancien que l'image originale
    [ ! -e "$repertoire/genegal/th_${image##*/}" -o "$repertoire/genegal/th_${image##*/}" -ot "$image" ] && convert "$image" -resize 200x200 "$repertoire/genegal/th_${image##*/}"
    echo convert "$image" -resize 200x200 "$repertoire/genegal/th_${image##*/}"
    echo '<a href="'$image'"><img src="'$repertoire/genegal/th_${image##*/}'" alt="" /></a>' >> "$sortie"
    # contient le chemin complet du fichier de l'image
    # echo "$image\n"
    # donne le basename du fichier (sans le répertoire)
    # echo ${image##*/}
  done
  # rétablir l'IFS
  IFS=$R
}

# si un paramètre est récupéré dans $1, répertoire=$1
# sinon répertoire = répertoire courant au moment du lancement du programme
echo "$1"
[ ! -z "$1" ] && repertoire="$1" || repertoire="$PWD"
echo "$repertoire"
# si le paramètre $1 existe est que c'est un répertoire, appeler la fonction lister,
# sinon message et arrêt du script
[ -e "$repertoire" -a -d "$repertoire" ] && lister "$repertoire" || { echo "$repertoire n'est pas un répertoire" && exit; }
# s'il y a bien des images dans le répertoire appeler la fonction traitimag
if [ -n "$img_liste" ]
then
  # créer le répertoire "genegal" s'il n'existe pas déjà
  [ ! -e "$repertoire/genegal" ] && mkdir "$repertoire/genegal"
  # création d'un fichier vide genegal.html
  sortie="$repertoire"/genegal/genegal.html
  echo $sortie
  echo '' > "$sortie"
  # début du code html
  echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" >
     <head>
         <title>Ma galerie</title>
         <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
         <style type="text/css">
         a img { border:0; }
         </style>
     </head>
     <body>
        <p>' >> "$sortie"
  traitimage
  # fin du code html
  echo '      </p>
   </body>
</html>' >> "$sortie"
else
  echo "Il n'y pas pas d'image dans $repertoire"
  exit
fi
