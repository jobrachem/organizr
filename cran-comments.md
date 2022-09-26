## R CMD check results
There were no ERRORs or  WARNINGs. 

There were three NOTES in total.

Tested on:

- Local machine: macOS Monterey 12.6, R 4.2.0 (0 NOTES)
- R-hub: Windows Server 2022, R-devel, 64 bit (2 NOTES)
- R-hub: Ubuntu Linux 20.04.1 LTS, R-release, GCC (1 NOTE)
- R-hub: Fedora Linux, R-devel, clang, gfortran (2 NOTES)


### NOTE 1

```
* checking CRAN incoming feasibility ... [11s] NOTE

New submission

Possibly misspelled words in DESCRIPTION:
  Rmarkdown (8:5)
Maintainer: 'Johannes Brachem <jbrachem@posteo.de>'
```

It appeared on

- R-hub: Windows Server 2022, R-devel, 64 bit (2 NOTES)
- R-hub: Ubuntu Linux 20.04.1 LTS, R-release, GCC (1 NOTE)
- R-hub: Fedora Linux, R-devel, clang, gfortran (2 NOTES)

This note is about the spelling in the DESCRIPTION. I propose to ignore this 
note.

### NOTE 2

The second note is:

```
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```

It appeared on 

- (R-hub) Windows Server 2022, R-devel, 64 bit


As noted in [R-hub issue #503](https://github.com/r-hub/rhub/issues/503), 
this could be due to a bug/crash in MiKTeX and can likely be ignored.


### NOTE 3

```
* checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found
```

It appeared on 

- R-hub: Fedora Linux, R-devel, clang, gfortran

An [internet search](https://groups.google.com/g/r-sig-mac/c/7u_ivEj4zhM) 
suggests this note may be due to an outdated package on the server running 
R CMD check rather than a problem with the package organizr. Therefore I think
that this note can also be ignored.


## Downstream dependencies
This is the first release of this package. There are no downstream dependencies.
