#!/bin/bash

bin/zotonic runtests "$(ls ebin/*ginger*tests.beam | sed -e 's|ebin/||' | sed -e 's|.beam||')"
