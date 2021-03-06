# CORD19-NEKG Generation Pipeline

Several steps are involved in the generation the CORD19-NEKG RDF dataset.

### Named-entity recognition/disambiguation

The processing of the CORD-19 corpus (set of JSON documents) with [DBpedia Spotlight](https://www.dbpedia-spotlight.org/), [entity-fishing](https://github.com/kermitt2/entity-fishing) and [NCBO BioPortal annotator](http://bioportal.bioontology.org/annotatorplus) results in one JSON document per article and per named-entity recognition/disambiguation tool.

### Generation of annotations RDF files

The resulting JSON documents are imported into a MongoDB database. Pre-processed is then achieved using MongoDB aggregation queries, such as cleaning authors names and filtering out of named entities that are 1 or 2 characters long.
The scripts involved at this step are provided in [/src/mongo](../src/mongo).

RDF files are then generated using [Morph-xR2RML](https://github.com/frmichel/morph-xr2rml/), an implementation of the [xR2RML mapping language](http://i3s.unice.fr/~fmichel/xr2rml_specification.html) [1] for MongoDB databases.
Scripts and mapping files are provided in [/src/xR2RML](../src/xR2RML).

Finally, RDF files are imported into a Virtuoso OS instance as separate named graphs. 
Scripts are provided in [/src/virtuoso](../src/virtuoso).

### Generation of articles metadata RDF files

CORD-19 provides metadata about articles as a large CSV file. Similarly to the above steps, the file was imported into MongoDB and translated to RDF using Morph-xR2RML.

### References

[1] F. Michel, L. Djimenou, C. Faron-Zucker, and J. Montagnat. Translation of Relational and Non-Relational Databases into RDF with xR2RML.
In Proceedings of the *11th International Confenrence on Web Information Systems and Technologies (WEBIST 2015)*, Lisbon, Portugal, 2015.

