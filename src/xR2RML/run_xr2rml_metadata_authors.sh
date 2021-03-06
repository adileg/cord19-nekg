#!/bin/bash
#
# This script runs Morph-xR2RML to produce the RDF version of the CORD19 metadata.csv file
#
# Input argument:
# - arg1: the MongoDB collection to query, e.g. cord19_csv
# - arg2: xR2RML template mapping file
#
# Author: F. Michel, UCA, CNRS, Inria

XR2RML=.

help()
{
  exe=$(basename $0)
  echo "Usage: $exe <MongoDB collection name> <xR2RML mapping template>"
  echo "Example:"
  echo "   $exe  cord19_json_light  xr2rml_metadata_authors_tpl.ttl"
  exit 1
}

# --- Read input arguments
collection=$1
if [[ -z "$collection" ]] ; then help; fi

mappingTemplate=$2
if [[ -z "$mappingTemplate" ]] ; then help; fi


# --- Init log file
mkdir $XR2RML/logs &> /dev/null
log=$XR2RML/logs/run_xr2rml_${collection}_authors.log
echo -n "" > $log

# --- Substitute placeholders in the xR2RML template file
mappingFile=/tmp/xr2rml_$$.ttl
awk "{ gsub(/{{collection}}/, \"$collection\"); \
       print }" \
    $XR2RML/${mappingTemplate} > $mappingFile
echo "-- xR2RML mapping file --" >> $log
cat $mappingFile >> $log


echo "--------------------------------------------------------------------------------------" >> $log
date  >> $log
java -Xmx4g \
     -Dlog4j.configuration=file:$XR2RML/log4j.properties \
     -jar "$XR2RML/morph-xr2rml-dist-1.1-RC2-jar-with-dependencies.jar" \
     --configDir $XR2RML \
     --configFile xr2rml.properties \
     --mappingFile $mappingFile \
     --output $XR2RML/output_${collection}_authors.ttl \
     >> $log
date >> $log

rm -f $mappingFile
