# Version history

*This history starts with version 0.8-9 (3 February 2015).  Earlier versions are not listed here.*

### 0.9-1

(2017-09-18, submitted to CRAN)

Reorganised `qvcalc` as an S3 generic function, to allow others to provide class-specific methods.

The package includes method `qvcalc.lm` for linear and generalized linear models.  The back-end computation is now done in `qvcalc.default`.

The method for `BTabilities` objects is now moved to the `BradleyTerry2` package (version 1.0-8).  Thanks go to Heather Turner for that.

### 0.9-0 

(2016-03-30, on CRAN)

Minor tweaks to fix the dependencies NOTE on CRAN checks

### 0.8-9 

(2015-02-03, on CRAN)

Corrects an error in the calculation of the relative errors for simple contrasts. The formula used for this now agrees with the definition of relative error that was given in the Biometrika paper. Many thanks to Shaun Killingbeck for spotting the error in version 0.8-8. Also made some small improvements to examples, and cosmetic changes to avoid a NOTE in the latest CRAN checks.
