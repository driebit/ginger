#!/bin/bash

MODULES="controller_rest $(ls ebin/*ginger*tests.beam|sed -e 's|ebin/||'|sed -e 's|.beam||')"
bin/zotonic runtests $MODULES
