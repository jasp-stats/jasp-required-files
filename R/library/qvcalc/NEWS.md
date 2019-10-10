# qvcalc 1.0.2

* (To do) Add an aesthetic for `ggplot`, as alternative to `plot.qv()`

# qvcalc 1.0.1

* Added an explicit method for "coxph" objects.

* Removed the `Suggests: pkgdown` dependence, because we no longer use Travis CI to deploy the documentation site.

# qvcalc 1.0.0

* Fixed a minor bug in `plot.qv()`

* Added an example to the help page for `plot.qv`, to show how to re-order the points/lines in a call to `plot.qv()`

# qvcalc 0.9-1

* Reorganised `qvcalc` as an S3 generic function, to allow others to provide class-specific methods.

* The package includes method `qvcalc.lm` for linear and generalized linear models.  The back-end computation is now done in `qvcalc.default`.

* The method for `BTabilities` objects is now moved to the `BradleyTerry2` package (version 1.0-8).  Thanks go to Heather Turner for that.

# qvcalc 0.9-0

* Minor tweaks to fix the dependencies `NOTE` on CRAN checks

# qvcalc 0.8-9

* Corrects an error in the calculation of the relative errors for simple contrasts. The formula used for this now agrees with the definition of relative error that was given in the Biometrika paper. Many thanks to Shaun Killingbeck for spotting the error in version 0.8-8. Also made some small improvements to examples, and cosmetic changes to avoid a `NOTE` in the latest CRAN checks.

-----

*This history starts with version 0.8-9 (3 February 2015).  Earlier versions are not listed here.*
