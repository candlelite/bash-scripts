#!/bin/bash
echo "Nombre d'arguments ... :  "$#
echo "Les arguments sont ... :  "$*
echo "Le second argument est :  "$2

echo "Et le code de retour du dernier echo est :  "$?echo ${#tab[@]}

my_table=("toto" "titi" "tutu" "lili")
echo "Le nombre d'éléments dans le tableau my_table est ${#my_table[@]}"
echo "Les éléments du tableau sont ${my_table[@]}"
echo "l'élément numéro 2 est ${my_table[2]}"

for i in ${!my_table[@]}; do echo ${my_table[i]}; done
echo "Tous les indices du tableau ${!my_table[@]}"


if [[ -f test_shift.sh ]]
then
    echo "Fichier présent"
else
    echo "Fichier absent"
fi

#favoritefood
if [ ${LANG:0:2} = "fr" ]; then
    echo "Vous aimez les moules frites !"
elif [ ${LANG:0:2} = "en" ]; then
    echo "You love the... pudding !"
elif [ ${LANG:0:2} = "es" ]; then
    echo "Te gusta el jamón !"
else
    echo ":'-("
fi
#Noter que $LANG n'a pas le préfixe '$'. ${$LANG:0:2} ne fonctionne pas !
