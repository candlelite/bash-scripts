
lister () {
  echo "exécution de la fonction lister"
  # find accepte plusieurs -execportions de la commande. Par exemple:
  # find . -name "*.txt" -exec echo {} \; -exec grep banana {} \;
  # Notez que dans ce cas, la deuxième commande ne s'exécutera que si la première retourne correctement, comme mentionné par @Caleb. Si vous souhaitez que les deux commandes s'exécutent indépendamment de leur succès ou échec, vous pouvez utiliser cette construction:
  # find . -name "*.txt" \( -exec echo {} \; -o -exec true \; \) -exec grep banana {} \;
  # find . -maxdepth 1 -iname "*.JPG" -printf "%P\n"
  # -----------------------------------------------------
  # mémoriser l'IFS actuel
  R=$IFS
  # changer l'IFS à cause de l'espace dans les noms de répertoire
  # « Internal Field Separator »
  IFS=’$'\n'’
  # activer l'option case non sensitive de bash
  shopt -s nocaseglob
  for i in `ls --sort=time -r *.JPG`
  do
    echo "Add in img_list : $i"
    #convert "$i" -resize 200x200 "genegal/th_$i"
    img_liste[${#img_liste[*]}]="$i"
  done
  # rétablir l'option case sensitive de bash
  shopt -u nocaseglob
  # rétablir l'IFS
  IFS=$R
  echo "Total img in img_list : "${#img_liste[@]}
}

traitimage () {
  echo "exécution de la fonction traitimage"
  echo ${img_liste[*]}
  # mémoriser l'IFS actuel
  R=$IFS
  # changer l'IFS à cause de l'espace dans les noms de répertoire
  IFS=’$'\n'’
  for image in ${img_liste[*]}
  do
    echo -e " traitement img : $image"
    # créer la mignature "th_image.jpg
    # si le thumbnail de l'image n'existe pas déjà
    # ou alors que le thumbnail est plus ancien que l'image originale
    [ ! -e "$repertoire/genegal/`date -r $image '+%Y-%m-%d %H-%M-%S'`.jpg" -o "$repertoire/genegal/`date -r $image '+%Y-%m-%d %H-%M-%S'`.jpg" -ot "$image" ] && convert "$image" -resize 1024x1024 -interlace Plane -quality 75% "$repertoire/genegal/`date -r $image '+%Y-%m-%d %H-%M-%S'`.jpg"
    # avec identify de ImageMagic, on peut avoir la vraie date originale, mais ça ne fonction pas avec les photos faites avec Android
    # echo '<a href="'../$image'"><img src="'$repertoire/genegal/th_${image##*/}'" title="'`identify -verbose $image | grep DateTimeOriginal`'" /></a>' >> "$sortie"
    # recherche de la date d'un fichier avec find et cut
    # echo '<a href="'../$image'"><img src="'$repertoire/genegal/th_${image##*/}'" title="'`find . -name $image -printf "%t"| cut -d ' ' -f 1-6`'" /></a>' >> "$sortie"
    # recherche de la date d'un fichier avec date
    echo '<a href="'../$image'"><img src="'$repertoire/genegal/`date -r $image '+%Y-%m-%d %H-%M-%S'`.jpg'" title="'`date -r $image '+%A%d %B %Y'`'" /></a>' >> "$sortie"
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
[ ! -z "$1" ] && repertoire="$1" || repertoire="$PWD"
echo "$repertoire"
# si le paramètre $1 existe est que c'est un répertoire, appeler la fonction lister,
# sinon message et arrêt du script
if [ -e "$repertoire" -a -d "$repertoire" ]
then
  MEMPWD="$PWD"
  cd "$repertoire"
  lister
  if [ -n "$img_liste" ]
  then
    # créer le répertoire "genegal" s'il n'existe pas déjà
    [ ! -e "$repertoire/genegal" ] && mkdir "$repertoire/genegal"
    # création d'un fichier vide genegal.html
    sortie="$repertoire"/genegal/genegal.html
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
  cd "$MEMPWD"
  pwd
else
  echo "$repertoire n'est pas un répertoire"
  exit;
fi
