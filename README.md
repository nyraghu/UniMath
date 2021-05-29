# Fork of UniMath

## Introduction

The [UniMath][1] project is an effort to formalise a large body of
mathematics over the [univalent foundations][2].  At present the
formalisation is in the framework of the [Coq][3] proof assistant.

I have created this fork of the UniMath project to experiment with the
formalisation and learn from it.  The fork has no sanction from the
UniMath project.

## Disclaimer

I am not an expert on the subject, and, as I have mentioned above,
this fork is for my personal education.  Please visit the [UniMath
project site][1] for official information and code.

## Prerequisites

If you want to explore this fork, please note that I will assume that
you are

* familiar with the basics of Coq,
* working on a Unix-like operating system (Linux, macOS, etc.), and
* know how to run simple git commands.

## Setup

The fork uses the [Nix][4] package manager, and the [direnv][5] shell
extension.  Install them using the instructions on their project
sites, and then do

``` shell
git clone https://github.com/nyraghu/UniMath
cd UniMath
direnv allow
```

to set up the project.  The `direnv allow` step may take a while because
it makes Nix download and install several required packages.  After
its completion, the fork is ready to be built.

## Building

Building the fork means compiling the Coq files in it.  As the fork
uses Nix and direnv, it can be built in any environment that is
supported by these two tools.  This amounts to bash, or one of a few
other shells, running on a Unix-like operating system.

After setting up Nix and direnv as in the previous section, do

``` shell
make
```

in the top directory of the project (the one containing the file
`shell.nix`).  A successful exit of the `make` command indicates that
the Coq files in the fork have been compiled properly.

[1]: https://github.com/UniMath/UniMath
[2]: https://en.wikipedia.org/wiki/Univalent_foundations
[3]: https://coq.inria.fr/
[4]: https://github.com/NixOS/nix
[5]: https://github.com/direnv/direnv
