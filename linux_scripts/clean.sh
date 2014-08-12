#!/bin/bash

find . -name "Makefile*" |xargs rm -rf && echo "clean all Makefile files success."

find . -name "config*" | xargs rm -rf && echo "clean all configure files success."

find . -name "auto*" | xargs rm -rf && echo "clean all autoconf files success."

find . -name "[A-Z]*" -a -type f | xargs rm -rf && echo "clean all manul add files success."

find . -type l | xargs rm -rf && echo "clean all link files success."

rm -rf aclocal.m4 compile conbak stamp-h1 && echo "all other files."
