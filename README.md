# Introduction

This repository will allow you compile pony programs using the esp-idf environment.

# Requirements

The esp-idf environment must already be installed. The "$IDF_PATH" must already be set.
Additionally some of the existing tools use docker. So it needs to be installed.


# Installation

To install, simply execute the "install.sh" script. This script will do the following:

1) Modify the esp-idf makefiles to take into account pony source files. 
   This include files that have ".pony" extension. The modification are 
   extracted from helpers/makefile.patch

2) Install ponyc.sh into "/usr/local/bin/"
   This executable is responsible of converting pony source files into
   objects. To do this the current script uses 2 docker containers.

Note: This is a highly experimental repository.
