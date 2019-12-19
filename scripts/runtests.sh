#!/bin/bash

MODULES="controller_rest_edges controller_rest_resources m_rdf_tests $(ls ebin/*ginger*tests.beam|sed -e 's|ebin/||'|sed -e 's|.beam||')"
bin/zotonic runtests $MODULES
