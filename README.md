![Axidraw v3](http://v3ga.github.io/Images/Workshop_Bassens_axidraw/axidraw_v3_grid.JPG)

# WORKSHOP “PROCESSING ET TRACEUR AXIDRAW”
*Du mardi 26 novembre au mercredi 27 novembre 2019 à Stereolux*

Au croisement du design graphique et de la programmation, ce workshop propose d’utiliser Processing pour créer, générer et imprimer des formes géométriques à l’aide d’un robot à dessin, le traceur Axidraw.

https://www.stereolux.org/agenda/workshop-processing-et-traceur-axidraw

### Dossier de dépôt
http://bit.ly/processing-axidraw-stereolux

## Documentation
Cet outil permet de travailler avec une grille dont les motifs sont dessinés par programme pour chaque cellule. Deux modes de rendu sont implémentés :
* **un rendu direct** qui permet d’utiliser les commandes classiques de dessin processing (line, ellipse, rect, ...)
* **un rendu "indirect"** basé sur la création de polygones. Ce mode offre des avantages de possibilités de rendu (déformation , hachures)  mais un peu plus "difficile" à programmer.

```java
boolean bModeDirect = false; // active ou non le mode direct
```
Dans son architecture, l’outil est composé de trois blocs principaux représentés par les classes décrites ci-dessous.

#### GridCellRender
Cette classe expose des méthodes pour dessiner les cellules de la grille, dans les deux modes de l’outil.
C’est principalement dans cette classe que nous allons travailler en implémentant les méthodes de dessin.
Nous pourrons aussi créer une interface graphique propice à l’expérimentation et à l’exploration combinatoire des paramètres.
##### En mode direct
C'est la méthode *drawDirect()* de la classe qui est appelé avec en paramètre : 
* [Rect](http://toxiclibs.org/docs/core/toxi/geom/Rect.html) rect //  coordonnées de la cellule dans la grille
* int i, int j // indices de la cellule (horizontal & vertical)

```java
class GridCellRenderTemplate extends GridCellRender 
{
  GridCellRenderTemplate()
  {
    super("Template");
  }

  // ----------------------------------------------------------
  void drawDirect(Rect rect, int i, int j)
  {
    pushMatrix();
    translate(rect.x, rect.y);

    line(0, 0, rect.width, rect.height);
    line(0, rect.height, rect.width, 0);
    
    popMatrix();
  }
}
```


##### En mode indirect
En mode indirect, c'est la méthode *compute()* qui est appelé pour fabriquer des instances de [Polygon2D](htPolygon2D/toxiclibs.org/docs/core/toxi/geom/Polygon2D.html) à ajouter à la liste *listPolygons* de l'instance.
Cette méthode prend deux paramètres : 
* [Rect](http://toxiclibs.org/docs/core/toxi/geom/Rect.html) rect //  coordonnées de la cellule non déformée dans la grille
* [Polygon2D](http://toxiclibs.org/docs/core/toxi/geom/Polygon2D.html) quad //  coordonnées de la cellule déformée dans la grille

Exemple dans la classe *GridCellRenderQuad*

```java
// ----------------------------------------------------------
void compute(Rect rect, Polygon2D quad)
{
  // Copy the quad
  Polygon2D quadCopy = quad.copy(); 
  // Apply scale
  quadCopy.scaleSize(this.scalex, this.scaley);
  // Add to polygons list
  listPolygons.add( quadCopy );
  
  // Stripes ? 
  if (grid.bComputeStripes)
    computeStripes(quadCopy, grid.stripesAngleStrategy, grid.getFieldValue( quadCopy.getCentroid() ) );
}
```


#### GridField
Cette classe permet de fournir une valeur comprise entre 0 et 1 pour être utilisée pour moduler des variables de rendu de grille (espacement et angle de rotation de hachures, mise à l’échelle de motif, etc...)
Voir par exemple la classe *GridCellRenderEllipse* qui utilise cette valeur pour moduler l’espacement des hachures, ainsi que leur orientation.

#### Grid
Cette classe permet de gérer les caractéristiques principales de la grille (résolutions, dimensions, déformations)
Elle maintient une liste d'instances de *GridCellRender* et de *GridField*.

### Outils
* [Processing](www.processing.org) avec les librairies suivantes :
  * [controlP5](http://www.sojamo.de/libraries/controlP5/) par [Andreas Schlegel](http://www.sojamo.de/) 
  * [toxiclibs](http://toxiclibs.org/) par [Karsten Schmidt](http://postspectacular.com/)
* [Axidraw](www.axidraw.com)
* [Inkscape pour Axidraw](https://wiki.evilmadscientist.com/Axidraw_Software_Installation)


### Liens
* [History of computer art part 2 : plotters](https://piratefsh.github.io/2019/01/07/computer-art-history-part-2.html)
* [Joanie Lemercier / Alone in the desert](https://www.youtube.com/watch?v=p_wbldFTOeA)
* [The curse of truchet tiles](https://arearugscarpet.blogspot.com/2014/04/the-curse-of-truchets-tiles.html)
* [Vera Molnar / Randomness](https://vimeo.com/372579247)
* [Machines à dessiner sur Canopé](https://www.reseau-canope.fr/machines-a-dessiner)
* [#plottertwitter](https://twitter.com/hashtag/Plottertwitter) sur Twitter et [#axidraw](https://www.instagram.com/explore/tags/axidraw/) sur Instagram 

