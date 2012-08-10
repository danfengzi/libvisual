Libvisual
=========

What's Libvisual?
------------------

Libvisual is a library that acts as a middle layer between
Applications that want audio visualisation, and audio visualisation
plugins. It is aimed at providing a common interface between
application developers with a need for audio visualisation and
developers who write visualisations.

Why Libvisual?
--------------

As an application developer, using Libvisual provides you an easy way
to do audio visualisation. When using Libvisual you'll have easy
access to all the visualisations that are written for Libvisual.

As a plugin writer, Libvisual provides a nice host for your plugin.
It runs analysis over the audio input usage and handles all everything
necessary for display in any Libvisual-using application.

License
-------

The Libvisual library that is in libvisual/ is licensed under the
Lesser GNU General Public License (LGPL) v2.1
([full text](http://www.gnu.org/licenses/lgpl-2.1.html)).

The example applications in examples/ are licensed under the General
GNU Public License (GPL) v2
([full text](http://www.gnu.org/licenses/gpl-2.0.html)).

The tools in tools/ are licensed under the GPLv2.

Development
-----------

If you would like to use Libvisual for your applications, write
plugins or hack on the core, please read HACKING. It contains some
very useful information regarding our coding policies and such.

Software Requirements
---------------------

###C/C++ compiler###

Libvisual uses several C99 and C++11 features for its modern API
design and implementation, and as such, requires an up-to-date C/C++
compiler to build. Compilers tested and known to work are GCC 4.6 and
Clang 3.1.

*There is a known problem using Clang 3.1 with libstdc++ 4.6/4.7. It
is easily fixed with the one-line patch to libstdc++ found
[here](http://clang.llvm.org/libstdc++4.7-clang11.patch).*

###Libraries####

The core library is fairly self-contained and requires almost very
little dependencies other than the standard C99 and C++11 libraries.

The [Oil Runtime Compiler](http://code.entropywave.com/orc) (ORC) is
required for generating a portion of Libvisual's SIMD routines.

GNU Gettext is optionally required (see note) for
internationalisation.

The bundled examples, benchmarks and test programs mostly require
[SDL 1.2](http://libsdl.org).

Note: Gettext is integrated into glibc on Linux.

Compiling and installing
------------------------

####Configuration####

Building Libvisual requires [CMake 2.8](http://www.cmake.org) or
above. The command to configure the build is:

    cmake .

To set a installation prefix, add `-DCMAKE_INSTALL_PREFIX=<prefix>` to
the commandline.

CMake comes with a wizard mode that hand holds you through the entire
process, prompting you for each configurable option. To use it, run:

    cmake -i .

Alternatively, CMake has a neat GUI that can be run with:

    cmake-gui .

####Building####

Once configuration is complete, run Make to begin the compiling.

    make

####Installing####

After compilation is finished, install the built library with:

    make install