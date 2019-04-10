#!/bin/bash

cd `dirname $0`/..
for i in modules/mod_ginger*/translations/template/*.pot
do
    pushd `dirname $i` > /dev/null
    if [ -e "../nl.po" ]
    then
        echo "Merging into nl.po from '$i'"
        msgmerge --update ../nl.po `basename $i`
    else
        echo "Making new nl.po from '$i'"
        cp `basename $i` ../nl.po
    fi
    popd > /dev/null
done

