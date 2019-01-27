#!/usr/bin/tcsh
./pa4b.csh $1:q >& tempfile.pa4
cat tempfile.pa4 | tr "\\" "%" | sed -f pa4.sed 
