## R CMD check results
There were no ERRORs or  WARNINGs. 

There were two NOTES in total.

Tested on:

- Local machine: macOS Monterey 12.6, R 4.2.0 (0 NOTES)
- R-hub: Windows Server 2022, R-devel, 64 bit (1 NOTES)
- R-hub: Fedora Linux, R-devel, clang, gfortran (1 NOTES)

### NOTE 1

```
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```

It appeared on 

- (R-hub) Windows Server 2022, R-devel, 64 bit


As noted in [R-hub issue #503](https://github.com/r-hub/rhub/issues/503), 
this could be due to a bug/crash in MiKTeX and can likely be ignored.


### NOTE 2

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
