/* This is MODIFIED version of R's Mathlib */

/* -*- C -*-
 *  Mathlib : A C Library of Special Functions
 *  Copyright (C) 1998-2013  The R Core Team
 *  Copyright (C) 2004       The R Foundation
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation; either version 2.1 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this program; if not, a copy is available at
 *  http://www.r-project.org/Licenses/
 *

 * Rmath.h  should contain ALL headers from R's C code in `src/nmath'
   -------  such that ``the Math library'' can be used by simply

   ``#include <Rmath.h> ''

   and nothing else.

   It is part of the API and supports 'standalone Rmath'.

*/
#ifndef RMATH_H
#define RMATH_H

/* Note that on some systems we need to include math.h before the
   defines below. */
#ifndef NO_C_HEADERS
# define __STDC_WANT_IEC_60559_TYPES_EXT__ 1
# include <math.h>
#endif

#define R_VERSION_STRING "3.1.1"

	/* Undo SGI Madness */

#ifdef __sgi
# ifdef ftrunc
#  undef ftrunc
# endif
# ifdef qexp
#  undef qexp
# endif
# ifdef qgamma
#  undef qgamma
# endif
#endif


/* ----- The following constants and entry points are part of the R API ---- */

/* 30 Decimal-place constants */
/* Computed with bc -l (scale=32; proper round) */

/* SVID & X/Open Constants */
/* Names from Solaris math.h */

#ifndef M_E
#define M_E		2.718281828459045235360287471353	/* e */
#endif

#ifndef M_LOG2E
#define M_LOG2E		1.442695040888963407359924681002	/* log2(e) */
#endif

#ifndef M_LOG10E
#define M_LOG10E	0.434294481903251827651128918917	/* log10(e) */
#endif

#ifndef M_LN2
#define M_LN2		0.693147180559945309417232121458	/* ln(2) */
#endif

#ifndef M_LN10
#define M_LN10		2.302585092994045684017991454684	/* ln(10) */
#endif

#ifndef M_PI
#define M_PI		3.141592653589793238462643383280	/* pi */
#endif

#ifndef M_2PI
#define M_2PI		6.283185307179586476925286766559	/* 2*pi */
#endif

#ifndef M_PI_2
#define M_PI_2		1.570796326794896619231321691640	/* pi/2 */
#endif

#ifndef M_PI_4
#define M_PI_4		0.785398163397448309615660845820	/* pi/4 */
#endif

#ifndef M_1_PI
#define M_1_PI		0.318309886183790671537767526745	/* 1/pi */
#endif

#ifndef M_2_PI
#define M_2_PI		0.636619772367581343075535053490	/* 2/pi */
#endif

#ifndef M_2_SQRTPI
#define M_2_SQRTPI	1.128379167095512573896158903122	/* 2/sqrt(pi) */
#endif

#ifndef M_SQRT2
#define M_SQRT2		1.414213562373095048801688724210	/* sqrt(2) */
#endif

#ifndef M_SQRT1_2
#define M_SQRT1_2	0.707106781186547524400844362105	/* 1/sqrt(2) */
#endif

/* R-Specific Constants */

#ifndef M_SQRT_3
#define M_SQRT_3	1.732050807568877293527446341506	/* sqrt(3) */
#endif

#ifndef M_SQRT_32
#define M_SQRT_32	5.656854249492380195206754896838	/* sqrt(32) */
#endif

#ifndef M_LOG10_2
#define M_LOG10_2	0.301029995663981195213738894724	/* log10(2) */
#endif

#ifndef M_SQRT_PI
#define M_SQRT_PI	1.772453850905516027298167483341	/* sqrt(pi) */
#endif

#ifndef M_1_SQRT_2PI
#define M_1_SQRT_2PI	0.398942280401432677939946059934	/* 1/sqrt(2pi) */
#endif

#ifndef M_SQRT_2dPI
#define M_SQRT_2dPI	0.797884560802865355879892119869	/* sqrt(2/pi) */
#endif


#ifndef M_LN_2PI
#define M_LN_2PI	1.837877066409345483560659472811	/* log(2*pi) */
#endif

#ifndef M_LN_SQRT_PI
#define M_LN_SQRT_PI	0.572364942924700087071713675677	/* log(sqrt(pi))
								   == log(pi)/2 */
#endif

#ifndef M_LN_SQRT_2PI
#define M_LN_SQRT_2PI	0.918938533204672741780329736406	/* log(sqrt(2*pi))
								 == log(2*pi)/2 */
#endif

#ifndef M_LN_SQRT_PId2
#define M_LN_SQRT_PId2	0.225791352644727432363097614947	/* log(sqrt(pi/2))
								   == log(pi/2)/2 */
#endif


# ifndef R_EXT_BOOLEAN_H_
/* "copy-paste" R_ext/Boolean.h if not already included: */
 #define R_EXT_BOOLEAN_H_
 #undef FALSE
 #undef TRUE
 typedef enum { FALSE = 0, TRUE } Rboolean;
# endif

#define bessel_i	jags_bessel_i
#define bessel_j	jags_bessel_j
#define bessel_k	jags_bessel_k
#define bessel_y	jags_bessel_y
#define bessel_i_ex	jags_bessel_i_ex
#define bessel_j_ex	jags_bessel_j_ex
#define bessel_k_ex	jags_bessel_k_ex
#define bessel_y_ex	jags_bessel_y_ex
#define beta		jags_beta
#define choose		jags_choose
#define dbeta		jags_dbeta
#define dbinom		jags_dbinom
#define dcauchy		jags_dcauchy
#define dchisq		jags_dchisq
#define dexp		jags_dexp
#define dF		jags_dF
#define dgamma		jags_dgamma
#define dgeom		jags_dgeom
#define dhyper		jags_dhyper
#define digamma		jags_digamma
#define dlnorm		jags_dlnorm
#define dlogis		jags_dlogis
#define dnbeta		jags_dnbeta
#define dnbinom		jags_dnbinom
#define dnbinom_mu	jags_dnbinom_mu
#define dnchisq		jags_dnchisq
#define dnf		jags_dnf
#define dnorm4		jags_dnorm4
#define dnt		jags_dnt
#define dpois		jags_dpois
#define dpsifn		jags_dpsifn
#define dsignrank	jags_dsignrank
#define dt		jags_dt
#define dtukey		jags_dtukey
#define dunif		jags_dunif
#define dweibull	jags_dweibull
#define dweibull2	jags_dweibull2
#define dwilcox		jags_dwilcox
#define fmax2		jags_fmax2
#define fmin2		jags_fmin2
#define fprec		jags_fprec
#define fround		jags_fround
#define ftrunc		jags_ftrunc
#define fsign		jags_fsign
#define gammafn		jags_gammafn
#define imax2		jags_imax2
#define imin2		jags_imin2
#define lbeta		jags_lbeta
#define lchoose		jags_lchoose
#define lgammafn	jags_lgammafn
#define lgammafn_sign	jags_lgammafn_sign
#define lgamma1p	jags_lgamma1p
#define log1pmx		jags_log1pmx
#define logspace_add	jags_logspace_add
#define logspace_sub	jags_logspace_sub
#define pbeta		jags_pbeta
#define pbeta_raw	jags_pbeta_raw
#define pbinom		jags_pbinom
#define pcauchy		jags_pcauchy
#define pchisq		jags_pchisq
#define pentagamma	jags_pentagamma
#define pexp		jags_pexp
#define pF		jags_pF
#define pgamma		jags_pgamma
#define pgeom		jags_pgeom
#define phyper		jags_phyper
#define plnorm		jags_plnorm
#define plogis		jags_plogis
#define pnbeta		jags_pnbeta
#define pnbinom		jags_pnbinom
#define pnbinom_mu     	jags_pnbinom_mu
#define pnchisq		jags_pnchisq
#define pnf		jags_pnf
#define pnorm5		jags_pnorm5
#define pnorm_both	jags_pnorm_both
#define pnt		jags_pnt
#define ppois		jags_ppois
#define psignrank	jags_psignrank
#define psigamma	jags_psigamma
#define pt		jags_pt
#define ptukey		jags_ptukey
#define punif		jags_punif
#define pythag		jags_pythag
#define pweibull	jags_pweibull
#define pweibull2	jags_pweibull2
#define pwilcox		jags_pwilcox
#define qbeta		jags_qbeta
#define qbinom		jags_qbinom
#define qcauchy		jags_qcauchy
#define qchisq		jags_qchisq
#define qchisq_appr	jags_qchisq_appr
#define qexp		jags_qexp
#define qF		jags_qF
#define qgamma		jags_qgamma
#define qgeom		jags_qgeom
#define qhyper		jags_qhyper
#define qlnorm		jags_qlnorm
#define qlogis		jags_qlogis
#define qnbeta		jags_qnbeta
#define qnbinom		jags_qnbinom
#define qnbinom_mu     	jags_qnbinom_mu
#define qnchisq		jags_qnchisq
#define qnf		jags_qnf
#define qnorm5		jags_qnorm5
#define qnt		jags_qnt
#define qpois		jags_qpois
#define qsignrank	jags_qsignrank
#define qt		jags_qt
#define qtukey		jags_qtukey
#define qunif		jags_qunif
#define qweibull	jags_qweibull
#define qweibull2	jags_qweibull2
#define qwilcox		jags_qwilcox
#define rbeta		jags_rbeta
#define rbinom		jags_rbinom
#define rcauchy		jags_rcauchy
#define rchisq		jags_rchisq
#define rexp		jags_rexp
#define rF		jags_rF
#define rgamma		jags_rgamma
#define rgeom		jags_rgeom
#define rhyper		jags_rhyper
#define rlnorm		jags_rlnorm
#define rlogis		jags_rlogis
#define rnbeta		jags_rnbeta
#define rnbinom		jags_rnbinom
#define rnchisq		jags_rnchisq
#define rnf		jags_rnf
#define rnorm		jags_rnorm
#define rnt		jags_rnt
#define rpois		jags_rpois
#define rsignrank	jags_rsignrank
#define rt		jags_rt
#define rtukey		jags_rtukey
#define runif		jags_runif
#define rweibull	jags_rweibull
#define rweibull2	jags_rweibull2
#define rwilcox		jags_rwilcox
#define sign		jags_sign
#define tetragamma	jags_tetragamma
#define trigamma	jags_trigamma

#define dnorm dnorm4
#define pnorm pnorm5
#define qnorm qnorm5

#ifdef  __cplusplus
namespace jags {
    struct RNG;
}
typedef jags::RNG JRNG;
extern "C" {
#else
typedef struct JRNG JRNG;
#endif
	/* R's versions with !R_FINITE checks */

double JR_pow(double x, double y);
double JR_pow_di(double, int);

	/* Random Number Generators */

double	norm_rand(JRNG*);
double	unif_rand(JRNG*);
double	exp_rand(JRNG*);

	/* Normal Distribution */

double	dnorm(double, double, double, int);
double	pnorm(double, double, double, int, int);
double	qnorm(double, double, double, int, int);
double	rnorm(double, double, JRNG*);
void	pnorm_both(double, double *, double *, int, int);/* both tails */

	/* Uniform Distribution */

double	dunif(double, double, double, int);
double	punif(double, double, double, int, int);
double	qunif(double, double, double, int, int);
double	runif(double, double, JRNG*);

	/* Gamma Distribution */

double	dgamma(double, double, double, int);
double	pgamma(double, double, double, int, int);
double	qgamma(double, double, double, int, int);
double	rgamma(double, double, JRNG*);

double  log1pmx(double);
double  log1pexp(double); // <-- ../nmath/plogis.c
double  lgamma1p(double);
double  logspace_add(double, double);
double  logspace_sub(double, double);

	/* Beta Distribution */

double	dbeta(double, double, double, int);
double	pbeta(double, double, double, int, int);
double	qbeta(double, double, double, int, int);
double	rbeta(double, double, JRNG*);

	/* Lognormal Distribution */

double	dlnorm(double, double, double, int);
double	plnorm(double, double, double, int, int);
double	qlnorm(double, double, double, int, int);
double	rlnorm(double, double, JRNG*);

	/* Chi-squared Distribution */

double	dchisq(double, double, int);
double	pchisq(double, double, int, int);
double	qchisq(double, double, int, int);
double	rchisq(double, JRNG*);

	/* Non-central Chi-squared Distribution */

double	dnchisq(double, double, double, int);
double	pnchisq(double, double, double, int, int);
double	qnchisq(double, double, double, int, int);
double	rnchisq(double, double, JRNG*);

	/* F Distibution */

double	dF(double, double, double, int);
double	pF(double, double, double, int, int);
double	qF(double, double, double, int, int);
double	rF(double, double, JRNG*);

	/* Student t Distibution */

double	dt(double, double, int);
double	pt(double, double, int, int);
double	qt(double, double, int, int);
double	rt(double, JRNG*);

	/* Binomial Distribution */

double	dbinom(double, double, double, int);
double	pbinom(double, double, double, int, int);
double	qbinom(double, double, double, int, int);
double	rbinom(double, double, JRNG*);

	/* Multnomial Distribution */

void	rmultinom(int, double*, int, int*, JRNG*);

	/* Cauchy Distribution */

double	dcauchy(double, double, double, int);
double	pcauchy(double, double, double, int, int);
double	qcauchy(double, double, double, int, int);
double	rcauchy(double, double, JRNG*);

	/* Exponential Distribution */

double	dexp(double, double, int);
double	pexp(double, double, int, int);
double	qexp(double, double, int, int);
double	rexp(double, JRNG*);

	/* Geometric Distribution */

double	dgeom(double, double, int);
double	pgeom(double, double, int, int);
double	qgeom(double, double, int, int);
double	rgeom(double, JRNG*);

	/* Hypergeometric Distibution */

double	dhyper(double, double, double, double, int);
double	phyper(double, double, double, double, int, int);
double	qhyper(double, double, double, double, int, int);
double	rhyper(double, double, double, JRNG*);

	/* Negative Binomial Distribution */

double	dnbinom(double, double, double, int);
double	pnbinom(double, double, double, int, int);
double	qnbinom(double, double, double, int, int);
double	rnbinom(double, double, JRNG*);

double	dnbinom_mu(double, double, double, int);
double	pnbinom_mu(double, double, double, int, int);
double	qnbinom_mu(double, double, double, int, int);
double	rnbinom_mu(double, double, JRNG*);

	/* Poisson Distribution */

double	dpois(double, double, int);
double	ppois(double, double, int, int);
double	qpois(double, double, int, int);
double	rpois(double, JRNG*);

	/* Weibull Distribution with shape-scale parameterization */

double	dweibull(double, double, double, int);
double	pweibull(double, double, double, int, int);
double	qweibull(double, double, double, int, int);
double	rweibull(double, double, JRNG*);

    	/* Weibull Distribution with shape-rate parameterization */

double	dweibull2(double, double, double, int);
double	pweibull2(double, double, double, int, int);
double	qweibull2(double, double, double, int, int);
double	rweibull2(double, double, JRNG*);

	/* Logistic Distribution */

double	dlogis(double, double, double, int);
double	plogis(double, double, double, int, int);
double	qlogis(double, double, double, int, int);
double	rlogis(double, double, JRNG*);

	/* Non-central Beta Distribution */

double	dnbeta(double, double, double, double, int);
double	pnbeta(double, double, double, double, int, int);
double	qnbeta(double, double, double, double, int, int);
double	rnbeta(double, double, double, JRNG*);

	/* Non-central F Distribution */

double  dnf(double, double, double, double, int);
double	pnf(double, double, double, double, int, int);
double	qnf(double, double, double, double, int, int);

	/* Non-central Student t Distribution */

double	dnt(double, double, double, int);
double	pnt(double, double, double, int, int);
double	qnt(double, double, double, int, int);

	/* Studentized Range Distribution */

double	ptukey(double, double, double, double, int, int);
double	qtukey(double, double, double, double, int, int);

	/* Wilcoxon Rank Sum Distribution */

double dwilcox(double, double, double, int);
double pwilcox(double, double, double, int, int);
double qwilcox(double, double, double, int, int);
double rwilcox(double, double, JRNG*);

	/* Wilcoxon Signed Rank Distribution */

double dsignrank(double, double, int);
double psignrank(double, double, int, int);
double qsignrank(double, double, int, int);
double rsignrank(double, JRNG*);

	/* Gamma and Related Functions */
double	gammafn(double);
double	lgammafn(double);
double	lgammafn_sign(double, int*);
void    dpsifn(double, int, int, int, double*, int*, int*);
double	psigamma(double, double);
double	digamma(double);
double	trigamma(double);
double	tetragamma(double);
double	pentagamma(double);

double	beta(double, double);
double	lbeta(double, double);

double	choose(double, double);
double	lchoose(double, double);

	/* Bessel Functions */

double	bessel_i(double, double, double);
double	bessel_j(double, double);
double	bessel_k(double, double, double);
double	bessel_y(double, double);
double	bessel_i_ex(double, double, double, double *);
double	bessel_j_ex(double, double, double *);
double	bessel_k_ex(double, double, double, double *);
double	bessel_y_ex(double, double, double *);


	/* General Support Functions */

//double 	pythag(double, double);
int	imax2(int, int);
int	imin2(int, int);
double	fmax2(double, double);
double	fmin2(double, double);
double	sign(double);
double	fprec(double, double);
double	fround(double, double);
double	fsign(double, double);
double	ftrunc(double);

double  log1pmx(double); /* Accurate log(1+x) - x, {care for small x} */
double  lgamma1p(double);/* accurate log(gamma(x+1)), small x (0 < x < 0.5) */

/* More accurate cos(pi*x), sin(pi*x), tan(pi*x)

   In future these declarations could clash with system headers if
   someone had already included math.h with
   __STDC_WANT_IEC_60559_TYPES_EXT__ defined.
   We can add a check for that via the value of
   __STDC_IEC_60559_FUNCS__ (>= 201ymmL, exact value not yet known).
*/
double cospi(double);
double sinpi(double);
double tanpi(double);

/* Compute the log of a sum or difference from logs of terms, i.e.,
 *
 *     log (exp (logx) + exp (logy))
 * or  log (exp (logx) - exp (logy))
 *
 * without causing overflows or throwing away too much accuracy:
 */
double  logspace_add(double logx, double logy);
double  logspace_sub(double logx, double logy);


/* ----------------- Private part of the header file ------------------- */

	/* old-R Compatibility */

#ifdef OLD_RMATH_COMPAT
# define snorm	norm_rand
# define sunif	unif_rand
# define sexp	exp_rand
#endif

#if !defined(MATHLIB_PRIVATE_H) /* defined by nmath.h */
/* If isnan is a macro, as C99 specifies, the C++
   math header will undefine it. This happens on OS X */
# ifdef __cplusplus
  int JR_isnancpp(double); /* in mlutils.c */
#  define ISNAN(x)     JR_isnancpp(x)
# else
#  define ISNAN(x)     (isnan(x)!=0)
# endif

# define R_FINITE(x)    JR_finite(x)
int JR_finite(double);

# ifdef _WIN32  /* not Win32 as no config information */
#  ifdef RMATH_DLL
#   define R_EXTERN extern __declspec(dllimport)
#  else
#   define R_EXTERN extern
#  endif
R_EXTERN double NA_REAL;
R_EXTERN double R_PosInf;
R_EXTERN double R_NegInf;
R_EXTERN int N01_kind;
#  undef R_EXTERN
#else
extern int N01_kind;
# endif

#endif /* MATHLIB_PRIVATE_H */

#ifdef  __cplusplus
}
#endif

#endif /* RMATH_H */
