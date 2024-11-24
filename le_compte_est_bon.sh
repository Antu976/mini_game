#!/usr/bin/env bash

count=0

# les bornes du nombre cible
min_nbr_cible=1
max_nbr_cible=100

# Bornage des nombre fournis
min_nbr_fournis=1
max_nbr_fournis=20

# Génération du nombre aléatoire du nombre cible
nbre_cible=$(shuf -i $min_nbr_cible-$max_nbr_cible -n 1)
#echo "Nombre cible : $nbre_cible"

# generation du groupe de nmbre aléatoire
nbres_fournis=$(shuf -i $min_nbr_fournis-$max_nbr_fournis -n 5 | tr '\n' ' ')

#echo "Les nombres fournis : $nbres_fournis"

# Liste des opérateurs mathématiques valides
operateurs_valides=('+' '*' '/' '-')

while [[ $resultat -ne $nbre_cible && $count -lt 5 ]]; do

read -p "Veuillez saisir une opération en utilisant seulement les nombres fournis ${nbres_fournis} : " operation

# Séparation et récupération des nbres un à un 
Nbres_saisies=($(echo "$operation" | grep -oE '[0-9]+'))

# Séparation et récupération des opérateurs
operateurs_utilises=($(echo "$operation" | grep -oE '[*\+/\-]'))

# vérification les nombres données sont bien celles fournis
    operation_valide=1
    for nbre in "${Nbres_saisies[@]}"; do
        if [[ ! " ${nbres_fournis[@]} " =~ " $nbre " ]]; then
            operation_valide=0
            echo " le nbre $nbre est invalide, elle ne fait pas partie des nbres fournis."
            break
        fi
    done

# Vérification si les opérateurs utilisés sont valides
    if [ $operation_valide -eq 1 ]; then
        for operateur in "${operateurs_utilises[@]}"; do
            if [[ ! " ${operateurs_valides[@]} " =~ " $operateur " ]]; then
                operation_valide=0
                echo " l'opérateur $operateur est invalide."
                break
            fi
        done
    fi

# Vérification des divisions par zéro
    if [[ "$operation" == *"/ 0"* ]]; then
        operation_valide=0
        echo "vous ne pouvez pas diviser par zero"
    fi


    if [ $operation_valide -eq 1 ]; then
        # Calcul de l'opération si elle est valide
        resultat=$(echo "$operation" | bc)


        # Vérifier si le résultat est égal au nombre cible
        if [[ $resultat -eq $nbre_cible ]]; then
            echo "Félicitations ! Vous avez atteint le nombre cible."
            break
        fi
    else
        echo "il y a un problème dans ce que vous proposez"
    fi




    ((count++))
    tentatives_restants=$(echo "5-$count" |bc)
    echo "vous êtes à $count essaie il reste $tentatives_restants tentative"


    # atteint des tentatives
    if [[ $count -ge 5 ]]; then
        echo "Game over vous avez échoué."
    fi

done 