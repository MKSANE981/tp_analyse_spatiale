## Chargement de package
library(sf)
library(dplyr)

## Importer le fond communal “commune_francemetro_2021.shp”

commune_francemetro_2021 = st_read("Fonds/commune_francemetro_2021.shp",options = "ENCODING=WINDOWS-1252")

## Les informations qui apparaissent

## Faites un résumé/descriptif du contenu de l’objet importé, comme vous le feriez pour un dataframe.

summary(commune_francemetro_2021)

## Afficher maintenant (à l’aide de la fonction View) les dix premières lignes de la table et regarder la dernière colonne

View(commune_francemetro_2021 %>% head(10))

## Afficher le système de projection de la table en utilisant la fonction st_crs.

st_crs(commune_francemetro_2021)

## Créer une table “communes_Bretagne” ne contenant que les communes bretones.

communes_Bretagne = commune_francemetro_2021 %>%
  filter(reg=="53")  %>% 
  select(c("code", "libelle", "epc", "dep", "surf"))

View(communes_Bretagne)

## 6. Assurez-vous que cette nouvelle table est toujours un objet sf

class(communes_Bretagne) 

## Appliquer la fonction plot sur votre table. (Hint: l’argument lwd vous permet de jouer sur l’épaisseur des lignes)

plot(communes_Bretagne,lwd = 0.2)


## Faire la question précédente en utilisant st_geometry dans votre plot

plot(st_geometry(communes_Bretagne), lwd = 0.8)

## 9. Créer une variable de surface appelée “surf2” en utilisant les fonctions st_area() sur votre variable de geometry. En quelle unité est la variable créée ?

communes_Bretagne$surf2 = st_area(communes_Bretagne$geometry)

communes_Bretagne$surf2 %>% class() ## en units

## 10. Modifier la variable créée pour la convertir en km2

communes_Bretagne = communes_Bretagne %>% mutate(surf2 = units::set_units(surf2,"km^2"))

## 11. Les variables surf et surf2 sont-elles égales ? Pourquoi selon vous ?

View(communes_Bretagne %>% select(c(surf,surf2))) ## Non

## 12. L’objectif est de créer une table départementale “dept_bretagne” sans doublons. Cette table devra
## contenir le code departement et la superficie du département. 

commune_dep = communes_Bretagne %>% 
  group_by(dep) %>% 
  summarise(surf = sum(surf))

## Représenter le nouveau fond sur une carte avec la fonction plot

plot(commune_dep,lwd=0.5)

# Constituer cette fois un fond départemental en utilisant les fonctions summarise() et st_union(). A
# la différence de la table précedemment créée, le fond ne contiendra que le code dept et la geometry
# (aucune variable numérique ne sera utilisée). Faire ensuite un plot de votre table pour vérifier que les
# geometry ont bien été regroupés par département.

dept_bretagne = communes_Bretagne %>% 
  group_by(dep) %>% 
  summarise(geometry = st_union(geometry))

plot(st_geometry(dept_bretagne),lwd=0.8)

## 14. Créer une table “centroid_dept_bretagne” contenant les centroïdes des départements bretons.

centroid_dept_bretagne = st_centroid(dept_bretagne)

plot(centroid_dept_bretagne)

## Quel est le type de géometrie associé à ces centroïdes ?

class(centroid_dept_bretagne$geometry)

# Représenter les départements bretons et leurs centroïdes sur une même carte, avec deux appels à la
# fonction plot() et en ajoutant l’argument add = TRUE sur le second appel.

plot(st_geometry(dept_bretagne))
plot(st_geometry(centroid_dept_bretagne),add=TRUE)

# c. Ajouter le nom du départment dans le fond de centroïdes. La variable aura pour nom dept_lib.
# Plusieurs solutions sont possibles, la plus propre étant d’utiliser une petite table de passage et de la
# fusionner avec le fond de centroïdes.

## Récupérer les coordonnées des centroides 
coordonnees_centroides = st_coordinates(centroid_dept_bretagne)

## Fonction text

text(coordonnees_centroides[,1], coordonnees_centroides[,2], labels = centroid_dept_bretagne$dep)

View(st_intersects(centroid_dept_bretagne,dept_bretagne))

