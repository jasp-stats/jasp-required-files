\name{NEWS}
\title{News for Package 'psychTools'}
\section{Changes in psychTools version 1.9.5 (2019-05)}{ 
  \subsection{Introduction}{
    \itemize{
      \item Version 1.9.5 is the development release of the psychTools package. It is available as a source file for Macs or PCs in the repository at \url{http://personality-project.org/r}. The released version on CRAN is 1.9.5  The second digit reflects the year (i.e., 2019), the third set the month (i.e., 1.8.3 was released in March of 2018, the last two digits of development versions reflect  either an minor change or the day of any modifications, e.g. 1.8.3.3 was the third attempt to get 1.8.3 released.  1.7.8 was  released in August, 2017.
    \item To install this development version, use the command: install.packages("psychTools", repos="http://personality-project.org/r", type="source"). Remember to restart R and library(psych) to make the new version active.
       
      \item The psychTools package includes functions and data sets to accompany the psych package which does classic and modern psychometrics and to analyze personality  and experimental psychological data sets. The psych package has been developed as a supplement to courses in research methods in psychology, personality research, and graduate level psychometric theory. The functions are a supplement to the text (in progress): An introduction to psychometric theory with applications in R. 
      \item Additional functions are added sporadically.
      \item This news file reports changes that have been made as the package has been developed.
      \item To report bugs, send email to \url{mailto:revelle@northwestern.edu} using bug.report.
 }
 }
 } 
 
  
   \section{Changes in psychTools version 1.9.5 (2018-05-25)}{
    \subsection{Additions}{
    \itemize{
    \item Data sets and a few helper functions switched over from psych to psychTools to make psych a smaller package.
    \item Data sets included are: ability, bfi, epi.bfi,income, iqitems, msq, msqR, neo, sai, spi, and tai.
    \item Helper functions include the df2latex set, dfOrder, and the various file utilities such as read.clipboard.
   \item Version number increased to 1.9.5.18 as we work through minor fixes to the submission to meet the newly enforced more stringent requirements of CRAN
   \item Changed cat and print in interactive functions  (fileCreate) to message() following request from CRAN
   \item Following yet another request from CRAN, changed the read.file function to not automatically load an .rda file, but rather suggest how to load it.
   \item Changed the use of  \%in\% to is.element to get around some problems in the msqR help file
   \item Changed the examples in read.clipboard to donttest instead of dontrun because they are interactive
   \item Changed all dontrun to donttest following request from CRAN.
    
      }
       }
    \subsection{Bugs Fixed}{
    	\itemize{
  \item None yet
   	}
    	}
    	}
  
