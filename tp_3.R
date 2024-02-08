# Chargement des packages
library(dplyr)
library(sf)
library(mapsf)
library(readxl)
library(classInt)
library(ggpl)
library(leaflet)

# Exercice 1
# Le but de cet exercice est de discrétiser une variable continue et d’en observer les différents résultats selon
# la méthode choisie.
# Vous utiliserez le fond des communes de France metropolitaine sur lequel vous calculerez une variable de
# densité. Pour la variable de population, vous disposez notamment du fichier “Pop_legales_2019.xlsx” présent
# dans le dossier “U:/Eleves/Cartographie/Donnees”.

commune_francemetro_2021 = st_read("Fonds/commune_francemetro_2021.shp",options = "ENCODING=WINDOWS-1252")

Pop_legales_2019 <- read_excel("data/Pop_legales_2019.xlsx")

# #Commencez par vous créer votre jeu de données (jointure et création de variable). Attention avant de
# joindre vos données, il vous faudra d’abord homogénéiser la commune de Paris. Dans un fichier (fond
# communal), Paris est renseigné sous son code communal (75056). Dans l’autre, Paris est renseigné par
# arrondissement (75101 à 75120). Vous devrez donc regrouper les arrondissements pour avoir une seule
# ligne pour Paris. Cette ligne sera renseignée avec le CODGEO 75056.

View(Pop_legales_2019 %>% filter(COM %in% seq(75101,75120,1)))

cumul_paris = Pop_legales_2019 %>% filter(COM %in% seq(75101,75120,1)) %>% summarise(som = sum(PMUN19))

paris = data.frame(
  COM = 75056,
  NCC = "Paris",
  PMUN19 = cumul_paris[[1]])
 
Pop_legales_2019 = rbind(Pop_legales_2019,paris)
  
commune_francemetro_2021 = commune_francemetro_2021 %>% left_join(Pop_legales_2019,by =join_by("code"=="COM"))

commune_francemetro_2021 = commune_francemetro_2021 %>% mutate(DENSITE = PMUN19/surf)

commune_francemetro_2021 %>% filter(code==75056)

## Regarder rapidement la distribution de la variable de densite





## Exercice 2

# Représenter sous forme de carte le taux de pauvreté par département. Vous utiliserez le package mapsf. Vous
# trouverez de la documentation sur ce package ici. Vous utiliserez le fond “dep_francemetro_2021” ainsi que le
# fichier “Taux_pauvrete_dept_2021.xlsx” présent dans le dossier “U:/Eleves/Cartographie/Donnees”. Pour
# l’import de ce fichier, vous pouvez utiliser la fonction openxlsx::read.xlsx().




