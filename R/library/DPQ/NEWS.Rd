% Check from R:
%  news(db = tools:::.build_news_db_from_package_NEWS_Rd("~/R/Pkgs/DPQ/inst/NEWS.Rd"))
\name{NEWS}
\title{DPQ News}
\encoding{UTF-8}

\section{Version 0.3-5 (2019-10-18, svn r131)}{
  \subsection{NEW FEATURES}{
    \itemize{
      \item \code{pnbetaAS310()} gained a \code{useAS226} option.

      \item New \code{okLongDouble()} function, notably for detecting that
      with a \command{valgrind}ed version of \R, \code{long double} C
      arithmetic seems to silently switch to (simple) \code{double} precision.
    }
  }
  \subsection{BUG FIXES}{
    \itemize{
      \item long double printing from C now should happen correctly on all
      platforms including 32- and 64-bit Windows.
    }
  }
}

\section{Version 0.3-4 (2019-10-16, svn r125)}{
  \subsection{NEW FEATURES}{
    \itemize{
      \item more efficient (internally vectorized) \code{dntJKBf()}.
      Consequently, \code{dntJKBf1()} is deprecated now.

      \item \code{pntR()} (and \code{pntR1()}) get new option
      \code{use.pnorm} (the default of which had been hard coded previously).
    }
  }
  \subsection{BUG FIXES}{
    \itemize{
      \item fix thinko in \code{any_mpfr()} and \code{all_mpfr()}.

      \item \code{pnchisqRC()}'s C code gave severe valgrind warnings;
      fixed printing of \code{long double} etc;
      also added special MinGW deal in Windows.

      \item \code{ppoisD()} behaves differently in a valgrinded version;
      for now, reproducible only when using valgrind on non-valgrinded
      installed package.
    }
  }
}


\section{Version 0.3-3 (2019-09-24, svn r110)}{
  \subsection{NEW FEATURES}{
    \itemize{
      \item Renamed (and generalized / merged) many functions to have less "." in names.

      \item New \code{pnbetaAS310()} function interfacing to my
      \emph{corrected} C version of 'ASA 310' (2007).

      \item New \code{algdiv()} function interfacing to the 'TOMS 708' version of
      our \code{logQab()}.

      \item New \code{pl2curves()} which generalizes (somewhat) previous
      function \code{p.dnchiB()}.

      \item Made \code{newton()} more flexible with new \code{xMin} and
      \code{xMax} arguments which are notably useful for \code{q*()}
      (quantile function) computations.

      Correspondingly replaced previous \code{qchisq2()} and
      \code{qchisqA()} with new \code{qchisqN()} (\sQuote{N}ewton).

      \item new \code{pnchisqRC()}, a version of R's C level non-central
      chi-squared, with additional options.

      \item \dQuote{new} \code{logspace.add()} and \code{logspace.sub()}.

      \item \dQuote{new} \code{pnchisqT93()} (plus its two auxiliaries),
      implementing Temme(1993)'s approximations.

      \item \dQuote{new} \code{pnchisqBolKuz()} and \code{qnchisqBolKuz()}
      implementing Bol'shev and Kuznetzov (1963)'s approximations.

      \item \dQuote{new} \code{pnchi1sq()} and \code{pnchi2sq()} with
      \dQuote{exact} formulas for the special cases \code{df=1} and
      \code{df=3}.

      \item simplified formula in \code{dtWV()}.
    }
  }
  \subsection{BUG FIXES}{
    \itemize{
      \item \code{qnchisqPearson(pp, df=DF, ncp=100)} and
      \code{qnchisqSankaran_d(*)} no longer return \code{NaN} for very
      large \code{DF = 1e200}.

      \item \code{pnchisq()} now also has default \code{verbose = 0} as all
      other such functions with \code{verbose} (or \code{trace[.lev]}
      optional argument.
    }
  }
}

\section{Version 0.3-0 [2018-08-28]}{
  \subsection{NEW FEATURES}{
    \itemize{
      \item Move many of my up to 15 years old DPQ computation utilities
      into a package, to become public, \dQuote{bloggable}, etc.
    }
  }
}
