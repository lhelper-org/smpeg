# SMPEG Library Development Guide

## Build Commands
- Configure: `./configure [options]` (see below for common options)
- Build: `make`
- Install: `make install`
- Clean: `make clean`
- Generate build system: `./autogen.sh` (runs autotools)
- Apply patches: `./apply_patches.sh`
- Test: Run `./plaympeg [file.mpg]` or `./gtv [file.mpg]`

## Dependencies

To build the dependencies we use lhelper, little library helper, even if it is not
generally used. We have a file named build.lhelper that lists the library we need.

The lhelper works by creating the environment and than it is activated using the
commands:

> lhelper create build # to use build.lhelper
> source $(lhelper env-source build) # to activate the environment

The same thing can be done interactively using:

> lhelper activate build # starts a subshell with the activated environment.

The lhelper environment will ensure the needed packages, essentially the SDL 1.2 library in this case,
are actually available.

If an additional external library is needed it should be added in the build.lhelper file.

## Configure Options
- `--enable-debug`: Disable optimizations, enable debugging
- `--enable-mmx`: Enable MMX IDCT decoding
- `--enable-assertions`: Enable consistency checks

## Code Style
- Class names: PascalCase with MPEG prefix (e.g., MPEGstream)
- Method names: camelCase
- Constants/macros: UPPERCASE
- Indentation: 4 spaces
- Header guards: Underscore prefix/suffix (_NAME_H_)
- Core library interface in C++ with C wrapper (smpeg.h)

## Project Structure
- `/audio`: MP3 audio components
- `/video`: MPEG-1 video components
- Core files: MPEG*, smpeg*
- Executables: plaympeg, gtv, glmovie

