# *****************************************************************************
## Exemple de commandes/scripts pour ajouter des caractère dans un fichier
# ******************************************************************************


# ******************************************************************************
## Ajouter "##" au début de chaque ligne d'un fichier
cat fichier.txt | while read line
do
	echo "##$line"
done > fichier2.txt

## Peut s'écrire aussi sur une seule ligne
cat fichier.txt | while read line; do echo "##$line"; done > fichier2.txt

##
## sed s/[occurrence_cherchée]/[occurrence_de_substitution]/[comportement]
## grep occurrence /fichier/a/parcourir | cut ... | sed ...
sed 's/^/ ##/' fichier.txt

## ou remplacer tous les blancs dans le fichier ou la chaine par "_"
echo fichier.txt | sed -e "s/ /_/g" > fichier2.txt

## VOIR SED ET CUD SUR DOC.UBUNTU.ORG, C'EST SUPER BIEN faites
## On peut tout faire dans les fichiers avec ça  !!!!!!
