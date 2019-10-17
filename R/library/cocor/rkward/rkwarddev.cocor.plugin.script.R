require(rkwarddev)

local({
  # set the output directory to overwrite the actual plugin
  output.dir <- "~/cocor/" # tempdir()
  overwrite <- TRUE

  about.node <- rk.XML.about(
    name="cocor",
    author=person(given="Birk", family="Diedenhofen", email="mail@birkdiedenhofen.de", role=c("aut","cre")),
    about=list(
      desc="Comparison of two correlations based on either dependent or independent groups.",
      version="1.1-3",
      date="2016-05-28",
      url="http://comparingcorrelations.org",
      license="GPL"
    )
  )

  dependencies.node <- rk.XML.dependencies(
    dependencies=list(
      rkward.min="0.6.0",
      rkward.max="",
      R.min="2.15",
      R.max=""
    )
  )

  var.sel <- rk.XML.varselector("Select data", id.name="vars")
  raw.data.dep.groups.overlap.var.sel <- rk.XML.varselector("Select data", id.name="raw_data_dep_groups_overlap_var_sel")
  raw.data.dep.groups.nonoverlap.var.sel <- rk.XML.varselector("Select data", id.name="raw_data_dep_groups_nonoverlap_var_sel")
  raw.data.indep.groups.var.sel.1 <- rk.XML.varselector("Select data", id.name="raw_data_indep_groups_1_var_sel")
  raw.data.indep.groups.var.sel.2 <- rk.XML.varselector("Select data", id.name="raw_data_indep_groups_2_var_sel")

  data.input <- rk.XML.radio("Data input",
    id.name="data_input",
    options=list(
      "Calculate and compare correlations from raw data"=c(val="raw.data"),
      "Enter correlations manually"=c(val="manual"),
      "Use correlations stored in single variables"=c(val="variable")
    )
  )

  groups <- rk.XML.radio("The two correlations are based on",
    id.name="groups",
    options=list(
      "two independent groups"=c(val="indep"),
      "two dependent groups (e.g., same group)"=c(val="dep")
    )
  )

  correlations <- rk.XML.radio("The two correlations are",
    id.name="correlations",
    options=list(
      "overlapping"=c(val="overlap"),
      "nonoverlapping"=c(val="nonoverlap")
    )
  )
  text.tailed.test <- "Do you want to conduct a one- or two-tailed test?"

  test.hypothesis.indep.groups <- rk.XML.radio(text.tailed.test,
    id.name="test_hypothesis_indep_groups",
    options=list(
      "Two-tailed: r1.jk is not equal to r2.hm"=c(val="two.sided"),
      "One-tailed: r1.jk is greater than r2.hm"=c(val="greater"),
      "One-tailed: r1.jk is less than r2.hm "=c(val="less")
    )
  )

  test.hypothesis.indep.groups.null.value <- rk.XML.radio(text.tailed.test,
    id.name="test_hypothesis_indep_groups_null_value",
    options=list(
      "Two-tailed: the difference between r1.jk and r2.hm is not equal to the defined null value"=c(val="two.sided"),
      "One-tailed: the difference between r1.jk and r2.hm is greater than the defined null value"=c(val="greater"),
      "One-tailed: the difference between r1.jk and r2.hm is less than the defined null value"=c(val="less")
    )
  )

  test.hypothesis.dep.groups.overlap <- rk.XML.radio(text.tailed.test,
    id.name="test_hypothesis_dep_groups_overlap",
    options=list(
      "Two-tailed: r.jk is not equal to r.jh"=c(val="two.sided"),
      "One-tailed: r.jk is greater than r.jh"=c(val="greater"),
      "One-tailed: r.jk is less than r.jh"=c(val="less")
    )
  )

  test.hypothesis.dep.groups.overlap.null.value <- rk.XML.radio(text.tailed.test,
    id.name="test_hypothesis_dep_groups_overlap_null_value",
    options=list(
      "Two-tailed: the difference between r.jk and r.jh is not equal to the defined null value"=c(val="two.sided"),
      "One-tailed: the difference between r.jk and r.jh is greater than the defined null value"=c(val="greater"),
      "One-tailed: the difference between r.jk and r.jh is less than the defined null value"=c(val="less")
    )
  )

  test.hypothesis.dep.groups.nonoverlap <- rk.XML.radio(text.tailed.test,
    id.name="test_hypothesis_dep_groups_nonoverlap",
    options=list(
      "Two-tailed: r.jk is not equal to r.hm"=c(val="two.sided"),
      "One-tailed: r.jk is greater than r.hm"=c(val="greater"),
      "One-tailed: r.jk is less than r.hm"=c(val="less")
    )
  )

  test.hypothesis.dep.groups.nonoverlap.null.value <- rk.XML.radio(text.tailed.test,
    id.name="test_hypothesis_dep_groups_nonoverlap_null_value",
    options=list(
      "Two-tailed: the difference between r.jk and r.hm is not equal to the defined null value"=c(val="two.sided"),
      "One-tailed: the difference between r.jk and r.hm is greater than the defined null value"=c(val="greater"),
      "One-tailed: the difference between r.jk and r.hm is less than the defined null value"=c(val="less")
    )
  )

  alpha <- rk.XML.spinbox("Alpha level", min=0, max=1, id.name="alpha", initial=.05)
  alpha.frame <- rk.XML.frame(alpha, label="Please choose an alpha level:")
  conf.level <- rk.XML.spinbox("Confidence level", min=0, max=1, id.name="conf_int", initial=.95)
  conf.level.frame <- rk.XML.frame(conf.level, label="Please choose a confidence level:")
  null.value <- rk.XML.spinbox("Null value", min=-2, max=2, id.name="null_value", initial=0, precision=2)
  null.value.frame <- rk.XML.frame(rk.XML.text("The null value is the hypothesized difference between the two correlations used for testing the null hypothesis. If the null value is other than 0, only the test by Zou (2007) is available."), null.value, label="Please choose a null value:")

  text.correlations <- "Please provide the correlations you want to compare:"
  text.related.correlation <- rk.XML.text("To assess the significance of the difference between the two dependent correlations, you need to provide the correlation between k and h:<br /><br />")
  text.related.correlations <- rk.XML.text("To assess the significance of the difference between the two dependent correlations, you need to provide additional related correlations:<br /><br />")
  text.group.size <- "Please indicate the size of your sample:"
  text.group.sizes <- "Please indicate the size of your samples:"

  ## raw data input
  raw.data.indep.groups.1 <- rk.XML.varslot("Raw data set 1 (must be a data.frame)", source=raw.data.indep.groups.var.sel.1, classes=c("data.frame"), id.name="raw_data_indep_groups_1")
  raw.data.indep.groups.2 <- rk.XML.varslot("Raw data set 2 (must be a data.frame)", source=raw.data.indep.groups.var.sel.2, classes=c("data.frame"), id.name="raw_data_indep_groups_2")
  raw.data.indep.groups.j <- rk.XML.varslot("Variable j", source=raw.data.indep.groups.var.sel.1, types="number", id.name="raw_data_indep_groups_j")
  raw.data.indep.groups.k <- rk.XML.varslot("Variable k", source=raw.data.indep.groups.var.sel.1, types="number", id.name="raw_data_indep_groups_k")
  raw.data.indep.groups.h <- rk.XML.varslot("Variable h", source=raw.data.indep.groups.var.sel.2, types="number", id.name="raw_data_indep_groups_h")
  raw.data.indep.groups.m <- rk.XML.varslot("Variable m", source=raw.data.indep.groups.var.sel.2, types="number", id.name="raw_data_indep_groups_m")
  raw.data.indep.groups.col.1 <- rk.XML.col(
    rk.XML.text("To compare the correlations j ~ k and h ~ m, please provide a data.frame for each correlations and select columns to specify the variables j, k, h, and m.<br />"),
    raw.data.indep.groups.1.frame <- rk.XML.frame(raw.data.indep.groups.1, raw.data.indep.groups.j, raw.data.indep.groups.k, label="Correlation j ~ k", id.name="raw_data_indep_groups_1_frame"),
    rk.XML.stretch()
  )
  raw.data.indep.groups.col.2 <- rk.XML.col(
    raw.data.indep.groups.2.frame <- rk.XML.frame(raw.data.indep.groups.2, raw.data.indep.groups.h, raw.data.indep.groups.m, label="Correlation h ~ m", id.name="raw_data_indep_groups_2_frame"),
    rk.XML.stretch()
  )

  raw.data.dep.groups.overlap <- rk.XML.varslot("Raw data (must be a data.frame)", source=raw.data.dep.groups.overlap.var.sel, classes=c("data.frame"), id.name="raw_data_dep_groups_overlap")
  raw.data.dep.groups.overlap.j <- rk.XML.varslot("Variable j", source=raw.data.dep.groups.overlap.var.sel, types="number", id.name="raw_data_dep_groups_overlap_j")
  raw.data.dep.groups.overlap.k <- rk.XML.varslot("Variable k", source=raw.data.dep.groups.overlap.var.sel, types="number", id.name="raw_data_dep_groups_overlap_k")
  raw.data.dep.groups.overlap.h <- rk.XML.varslot("Variable h", source=raw.data.dep.groups.overlap.var.sel, types="number", id.name="raw_data_dep_groups_overlap_h")
  raw.data.dep.groups.overlap.col <- rk.XML.col(
    rk.XML.text("To compare the correlations j ~ k and j ~ h, please provide a data.frame and select columns to specify the variables j, k, and h.<br />"),
    raw.data.dep.groups.overlap,
    raw.data.dep.groups.overlap.frame <- rk.XML.frame(raw.data.dep.groups.overlap.j, raw.data.dep.groups.overlap.k, raw.data.dep.groups.overlap.h, label="Correlations j ~ k and j ~ h", id.name="raw_data_dep_groups_overlap_frame"),
    rk.XML.stretch()
  )

  raw.data.dep.groups.nonoverlap <- rk.XML.varslot("Raw data (must be a data.frame)", source=raw.data.dep.groups.nonoverlap.var.sel, classes=c("data.frame"), id.name="raw_data_dep_groups_nonoverlap")
  raw.data.dep.groups.nonoverlap.j <- rk.XML.varslot("Variable j", source=raw.data.dep.groups.nonoverlap.var.sel, types="number", id.name="raw_data_dep_groups_nonoverlap_j")
  raw.data.dep.groups.nonoverlap.k <- rk.XML.varslot("Variable k", source=raw.data.dep.groups.nonoverlap.var.sel, types="number", id.name="raw_data_dep_groups_nonoverlap_k")
  raw.data.dep.groups.nonoverlap.h <- rk.XML.varslot("Variable h", source=raw.data.dep.groups.nonoverlap.var.sel, types="number", id.name="raw_data_dep_groups_nonoverlap_h")
  raw.data.dep.groups.nonoverlap.m <- rk.XML.varslot("Variable m", source=raw.data.dep.groups.nonoverlap.var.sel, types="number", id.name="raw_data_dep_groups_nonoverlap_m")
  raw.data.dep.groups.nonoverlap.col <- rk.XML.col(
    rk.XML.text("To compare the correlations j ~ k and h ~ m, please provide a data.frame and select columns to specify the variables j, k, h, and m.<br />"),
    raw.data.dep.groups.nonoverlap,
    raw.data.dep.groups.nonoverlap.frame.1 <- rk.XML.frame(raw.data.dep.groups.nonoverlap.j, raw.data.dep.groups.nonoverlap.k, label="Correlation j ~ k", id.name="raw_data_dep_groups_nonoverlap_frame"),
    raw.data.dep.groups.nonoverlap.frame.2 <- rk.XML.frame(raw.data.dep.groups.nonoverlap.h, raw.data.dep.groups.nonoverlap.m, label="Correlation h ~ m", id.name="raw_data_dep_groups_nonoverlap_frame"),
    rk.XML.stretch()
  )

  ## manual input
  manual.indep.groups.r1.jk <- rk.XML.spinbox("Correlation r1.jk", min=-1, max=1, id.name="manual_indep_groups_r1_jk")
  manual.indep.groups.r2.hm <- rk.XML.spinbox("Correlation r2.hm", min=-1, max=1, id.name="manual_indep_groups_r2_hm")
  manual.indep.groups.n1 <- rk.XML.spinbox("Group size n1", min=3, real=FALSE, initial=30, id.name="manual_indep_groups_n1")
  manual.indep.groups.n2 <- rk.XML.spinbox("Group size n2", min=3, real=FALSE, initial=30, id.name="manual_indep_groups_n2")
  manual.indep.groups.cor.frame <- rk.XML.frame(manual.indep.groups.r1.jk, manual.indep.groups.r2.hm, label=text.correlations, id.name="manual_indep_groups_cor_frame")
  manual.indep.groups.group.size.frame <- rk.XML.frame(manual.indep.groups.n1, manual.indep.groups.n2, label=text.group.sizes, id.name="manual_indep_groups_group_size_frame")
  manual.indep.groups.frame <- rk.XML.frame(manual.indep.groups.cor.frame, manual.indep.groups.group.size.frame, label="", id.name="manual_indep_groups_frame")

  manual.dep.groups.overlap.r.jk <- rk.XML.spinbox("Correlation j ~ k", min=-1, max=1, id.name="manual_dep_groups_overlap_r_jk")
  manual.dep.groups.overlap.r.jh <- rk.XML.spinbox("Correlation j ~ h", min=-1, max=1, id.name="manual_dep_groups_overlap_r_jh")
  manual.dep.groups.overlap.r.kh <- rk.XML.spinbox("Correlation k ~ h", min=-1, max=1, id.name="manual_dep_groups_overlap_r_kh")
  manual.dep.groups.overlap.n <- rk.XML.spinbox("Group size n", min=3, real=FALSE, initial=30, id.name="manual_dep_groups_overlap_n")
  manual.dep.groups.overlap.cor.frame <- rk.XML.frame(manual.dep.groups.overlap.r.jk, manual.dep.groups.overlap.r.jh, label=text.correlations, id.name="manual_dep_groups_overlap_cor_frame")
  manual.dep.groups.overlap.related.cor.frame <- rk.XML.frame(text.related.correlation, manual.dep.groups.overlap.r.kh, id.name="manual_dep_groups_overlap_related_cor_frame")
  manual.dep.groups.overlap.group.size.frame <- rk.XML.frame(manual.dep.groups.overlap.n, label=text.group.size, id.name="manual_dep_groups_overlap_group_size_frame")
  manual.dep.groups.overlap.frame <- rk.XML.frame(manual.dep.groups.overlap.cor.frame, manual.dep.groups.overlap.related.cor.frame, manual.dep.groups.overlap.group.size.frame, label="", id.name="manual_dep_groups_overlap_frame")

  manual.dep.groups.nonoverlap.r.jk <- rk.XML.spinbox("Correlation j ~ k", min=-1, max=1, id.name="manual_dep_groups_nonoverlap_r_jk")
  manual.dep.groups.nonoverlap.r.hm <- rk.XML.spinbox("Correlation h ~ m", min=-1, max=1, id.name="manual_dep_groups_nonoverlap_r_hm")
  manual.dep.groups.nonoverlap.r.jh <- rk.XML.spinbox("Correlation j ~ h", min=-1, max=1, id.name="manual_dep_groups_nonoverlap_r_jh")
  manual.dep.groups.nonoverlap.r.jm <- rk.XML.spinbox("Correlation j ~ m", min=-1, max=1, id.name="manual_dep_groups_nonoverlap_r_jm")
  manual.dep.groups.nonoverlap.r.kh <- rk.XML.spinbox("Correlation k ~ h", min=-1, max=1, id.name="manual_dep_groups_nonoverlap_r_kh")
  manual.dep.groups.nonoverlap.r.km <- rk.XML.spinbox("Correlation k ~ m", min=-1, max=1, id.name="manual_dep_groups_nonoverlap_r_km")
  manual.dep.groups.nonoverlap.n <- rk.XML.spinbox("Group size n", min=3, real=FALSE, initial=30, id.name="manual_dep_groups_nonoverlap_n")
  manual.dep.groups.nonoverlap.cor.frame <- rk.XML.frame(manual.dep.groups.nonoverlap.r.jk, manual.dep.groups.nonoverlap.r.hm, label=text.correlations, id.name="manual_dep_groups_nonoverlap_cor_frame")
  manual.dep.groups.nonoverlap.related.cor.frame <- rk.XML.frame(text.related.correlations, manual.dep.groups.nonoverlap.r.jh, manual.dep.groups.nonoverlap.r.jm, manual.dep.groups.nonoverlap.r.kh, manual.dep.groups.nonoverlap.r.km, id.name="manual_dep_groups_nonoverlap_related_cor_frame")
  manual.dep.groups.nonoverlap.group.size.frame <- rk.XML.frame(manual.dep.groups.nonoverlap.n, label=text.group.size, id.name="manual_dep_groups_nonoverlap_group_size_frame")
  manual.dep.groups.nonoverlap.frame <- rk.XML.frame(manual.dep.groups.nonoverlap.cor.frame, manual.dep.groups.nonoverlap.related.cor.frame, manual.dep.groups.nonoverlap.group.size.frame, id.name="manual_dep_groups_nonoverlap_frame")

  ## variable input
  variable.indep.groups.r1.jk <- rk.XML.varslot("Correlation r1.jk", source=var.sel, types="number", id.name="variable_indep_groups_r1_jk")
  variable.indep.groups.r2.hm <- rk.XML.varslot("Correlation r2.hm", source=var.sel, types="number", id.name="variable_indep_groups_r2_hm")
  variable.indep.groups.n1 <- rk.XML.varslot("Group size n1", source=var.sel, types="number", id.name="variable_indep_groups_n1")
  variable.indep.groups.n2 <- rk.XML.varslot("Group size n2", source=var.sel, types="number", id.name="variable_indep_groups_n2")
  variable.indep.groups.cor.frame <- rk.XML.frame(variable.indep.groups.r1.jk, variable.indep.groups.r2.hm, label=text.correlations, id.name="variable_indep_groups_cor_frame")
  variable.indep.groups.group.size.frame <- rk.XML.frame(variable.indep.groups.n1, variable.indep.groups.n2, label=text.group.sizes, id.name="variable_indep_groups_group_size_frame")
  variable.indep.groups.frame <- rk.XML.frame(variable.indep.groups.cor.frame, variable.indep.groups.group.size.frame, label="", id.name="variable_indep_groups_frame")

  variable.dep.groups.overlap.r.jk <- rk.XML.varslot("Correlation j ~ k", source=var.sel, types="number", id.name="variable_dep_groups_overlap_r_jk")
  variable.dep.groups.overlap.r.jh <- rk.XML.varslot("Correlation j ~ h", source=var.sel, types="number", id.name="variable_dep_groups_overlap_r_jh")
  variable.dep.groups.overlap.r.kh <- rk.XML.varslot("Correlation k ~ h", source=var.sel, types="number", id.name="variable_dep_groups_overlap_r_kh")
  variable.dep.groups.overlap.n <- rk.XML.varslot("Group size n", source=var.sel, types="number", id.name="variable_dep_groups_overlap_n")
  variable.dep.groups.overlap.cor.frame <- rk.XML.frame(variable.dep.groups.overlap.r.jk, variable.dep.groups.overlap.r.jh, label=text.correlations, id.name="variable_dep_groups_overlap_cor_frame")
  variable.dep.groups.overlap.related.cor.frame <- rk.XML.frame(text.related.correlation, variable.dep.groups.overlap.r.kh, id.name="variable_dep_groups_overlap_related_cor_frame")
  variable.dep.groups.overlap.group.size.frame <- rk.XML.frame(variable.dep.groups.overlap.n, label=text.group.size, id.name="variable_dep_groups_overlap_group_size_frame")
  variable.dep.groups.overlap.frame <- rk.XML.frame(variable.dep.groups.overlap.cor.frame, variable.dep.groups.overlap.related.cor.frame, variable.dep.groups.overlap.group.size.frame, label="", id.name="variable_dep_groups_overlap_frame")

  variable.dep.groups.nonoverlap.r.jk <- rk.XML.varslot("Correlation j ~ k", source=var.sel, types="number", id.name="variable_dep_groups_nonoverlap_r_jk")
  variable.dep.groups.nonoverlap.r.hm <- rk.XML.varslot("Correlation h ~ m", source=var.sel, types="number", id.name="variable_dep_groups_nonoverlap_r_hm")
  variable.dep.groups.nonoverlap.r.jh <- rk.XML.varslot("Correlation j ~ h", source=var.sel, types="number", id.name="variable_dep_groups_nonoverlap_r_jh")
  variable.dep.groups.nonoverlap.r.jm <- rk.XML.varslot("Correlation j ~ m", source=var.sel, types="number", id.name="variable_dep_groups_nonoverlap_r_jm")
  variable.dep.groups.nonoverlap.r.kh <- rk.XML.varslot("Correlation k ~ h", source=var.sel, types="number", id.name="variable_dep_groups_nonoverlap_r_kh")
  variable.dep.groups.nonoverlap.r.km <- rk.XML.varslot("Correlation k ~ m", source=var.sel, types="number", id.name="variable_dep_groups_nonoverlap_r_km")
  variable.dep.groups.nonoverlap.n <- rk.XML.varslot("Group size n", source=var.sel, types="number", id.name="variable_dep_groups_nonoverlap_n")
  variable.dep.groups.nonoverlap.cor.frame <- rk.XML.frame(variable.dep.groups.nonoverlap.r.jk, variable.dep.groups.nonoverlap.r.hm, label=text.correlations, id.name="variable_dep_groups_nonoverlap_cor_frame")
  variable.dep.groups.nonoverlap.related.cor.frame <- rk.XML.frame(text.related.correlations, variable.dep.groups.nonoverlap.r.jh, variable.dep.groups.nonoverlap.r.jm, variable.dep.groups.nonoverlap.r.kh, variable.dep.groups.nonoverlap.r.km, id.name="variable_dep_groups_nonoverlap_related_cor_frame")
  variable.dep.groups.nonoverlap.group.size.frame <- rk.XML.frame(variable.dep.groups.nonoverlap.n, label=text.group.size, id.name="variable_dep_groups_nonoverlap_group_size_frame")
  variable.dep.groups.nonoverlap.frame <- rk.XML.frame(variable.dep.groups.nonoverlap.cor.frame, variable.dep.groups.nonoverlap.related.cor.frame, variable.dep.groups.nonoverlap.group.size.frame, label="", id.name="variable_dep_groups_nonoverlap_frame")

  wizard.correlations.page <- rk.XML.page(
    id.name="wizard_correlations_page",
    rk.XML.text("Are the two correlations overlapping, i.e., do they have one variable in common?"),
    correlations,
    rk.XML.frame(label="Examples",
      rk.XML.text("Overlapping:<br />Correlation 1: age ~ intelligence<br />Correlation 2: age ~ shoe size<br /><br />These are overlapping correlations because the same variable 'age' is part of both correlations.<br /><br />Nonoverlapping:<br />Correlation 1: age ~ intelligence<br />Correlation 2: body mass index ~ shoe size<br /><br />These are nonoverlapping correlations because no variable is part of both correlations.<br /><br /><br />")
    ),
    rk.XML.stretch()
  )

  raw.data.row2 <- rk.XML.row(
    rk.XML.col(raw.data.indep.groups.var.sel.2),
    raw.data.indep.groups.col.2
  )

  manual.and.variable.data.input.col <- rk.XML.col(
    manual.indep.groups.frame, manual.dep.groups.overlap.frame, manual.dep.groups.nonoverlap.frame,
    variable.indep.groups.frame, variable.dep.groups.overlap.frame, variable.dep.groups.nonoverlap.frame,
    rk.XML.stretch()
  )

  wizard <- rk.XML.wizard(
    label="Comparing correlations",
    rk.XML.page(
      rk.XML.text("Are the two correlations based on two independent or on two dependent groups? (If the data were taken from measurements of the same individuals, the groups are dependent.)<br />"),
      groups,
      rk.XML.stretch()
    ),
    wizard.correlations.page,
    rk.XML.page(
      rk.XML.text("Do you want to calculate and compare correlations from raw data, are the correlations already available in single variables, or do you want to type the correlations in manually?"),
      data.input,
      rk.XML.stretch()
    ),
    rk.XML.page(
      rk.XML.col(
        rk.XML.row(
          rk.XML.col(var.sel,raw.data.indep.groups.var.sel.1,raw.data.dep.groups.overlap.var.sel,raw.data.dep.groups.nonoverlap.var.sel),
          raw.data.dep.groups.nonoverlap.col,
          raw.data.dep.groups.overlap.col,
          raw.data.indep.groups.col.1,
          manual.and.variable.data.input.col
        ),
        raw.data.row2
      )
    ),
    rk.XML.page(
      alpha.frame,
      conf.level.frame,
      null.value.frame,
      rk.XML.stretch()
    ),
    rk.XML.page(
      test.hypothesis.indep.groups,
      test.hypothesis.dep.groups.overlap,
      test.hypothesis.dep.groups.nonoverlap,
      test.hypothesis.indep.groups.null.value,
      test.hypothesis.dep.groups.overlap.null.value,
      test.hypothesis.dep.groups.nonoverlap.null.value,
      rk.XML.stretch()
    )
  )

  ## logic
  logic <- rk.XML.logic(
    ## convert single
    raw.data.input.convert <- rk.XML.convert(sources=list(string=data.input), mode=c(equals="raw.data"), id.name="raw_data_input_convert"),
    manual.input.convert <- rk.XML.convert(sources=list(string=data.input), mode=c(equals="manual"), id.name="manual_input_convert"),
    variable.input.convert <- rk.XML.convert(sources=list(string=data.input), mode=c(equals="variable"), id.name="variable_input_convert"),

    indep.groups.convert <- rk.XML.convert(sources=list(string=groups), mode=c(equals="indep"), id.name="indep_groups_convert"),
    dep.groups.convert <- rk.XML.convert(sources=list(string=groups), mode=c(equals="dep"), id.name="dep_groups_convert"),

    overlap.correlations.convert <- rk.XML.convert(sources=list(string=correlations), mode=c(equals="overlap"), id.name="overlap_correlations_convert"),
    nonoverlap.correlations.convert <- rk.XML.convert(sources=list(string=correlations), mode=c(equals="nonoverlap"), id.name="nonoverlap_correlations_convert"),

    raw.data.indep.groups.1.convert <- rk.XML.convert(sources=list(available=raw.data.indep.groups.1), mode=c(notequals=""), id.name="raw_data_indep_groups_1_convert"),
    raw.data.indep.groups.2.convert <- rk.XML.convert(sources=list(available=raw.data.indep.groups.2), mode=c(notequals=""), id.name="raw_data_indep_groups_2_convert"),
    raw.data.dep.groups.overlap.convert <- rk.XML.convert(sources=list(available=raw.data.dep.groups.overlap), mode=c(notequals=""), id.name="raw_data_dep_groups_overlap_convert"),
    raw.data.dep.groups.nonoverlap.convert <- rk.XML.convert(sources=list(available=raw.data.dep.groups.nonoverlap), mode=c(notequals=""), id.name="raw_data_dep_groups_nonoverlap_convert"),

    null.value.is.zero.convert <- rk.XML.convert(sources=list(real=null.value), mode=c(min=-0.001, max=0.001), id.name="null_value_is_zero_convert"),
    null.value.is.greater.than.zero.convert <- rk.XML.convert(sources=list(real=null.value), mode=c(min=0.01, max=2.00), id.name="null_value_is_greater_than_zero_convert"),
    null.value.is.less.than.zero.convert <- rk.XML.convert(sources=list(real=null.value), mode=c(min=-2.00, max=-0.01), id.name="null_value_is_less_than_zero_convert"),
    null.value.is.not.zero.convert <- rk.XML.convert(sources=list(null.value.is.less.than.zero.convert, null.value.is.greater.than.zero.convert), mode=c(or=""), id.name="null_value_is_not_zero_convert"),

    #convert multiple
    manual.or.variable.input.convert <- rk.XML.convert(sources=list(manual.input.convert, variable.input.convert), mode=c(or=""), id.name="manual_or_variable_input_convert"),

    dep.groups.and.overlap.correlations.convert <- rk.XML.convert(sources=list(dep.groups.convert, overlap.correlations.convert), mode=c(and=""), id.name="dep_groups_and_overlap_correlations_convert"),
    dep.groups.and.nonoverlap.correlations.convert <- rk.XML.convert(sources=list(dep.groups.convert, nonoverlap.correlations.convert), mode=c(and=""), id.name="dep_groups_and_nonoverlap_correlations_convert"),

    indep.groups.and.null.value.is.zero.convert <- rk.XML.convert(sources=list(indep.groups.convert, null.value.is.zero.convert), mode=c(and=""), id.name="indep_groups_and_null_value_is_zero_convert"),
    dep.groups.and.overlap.correlations.and.null.value.is.zero.convert <- rk.XML.convert(sources=list(dep.groups.convert, overlap.correlations.convert, null.value.is.zero.convert), mode=c(and=""), id.name="dep_groups_and_overlap_correlations_and_null_value_is_zero_convert"),
    dep.groups.and.nonoverlap.correlations.and.null.value.is.zero.convert <- rk.XML.convert(sources=list(dep.groups.convert, nonoverlap.correlations.convert, null.value.is.zero.convert), mode=c(and=""), id.name="dep_groups_and_nonoverlap_correlations_and_null_value_is_zero_convert"),

    indep.groups.and.null.value.is.not.zero.convert <- rk.XML.convert(sources=list(indep.groups.convert, null.value.is.not.zero.convert), mode=c(and=""), id.name="indep_groups_and_null_value_is_not_zero_convert"),
    dep.groups.and.overlap.correlations.and.null.value.is.not.zero.convert <- rk.XML.convert(sources=list(dep.groups.convert, overlap.correlations.convert, null.value.is.not.zero.convert), mode=c(and=""), id.name="dep_groups_and_overlap_correlations_and_null_value_is_not_zero_convert"),
    dep.groups.and.nonoverlap.correlations.and.null.value.is.not.zero.convert <- rk.XML.convert(sources=list(dep.groups.convert, nonoverlap.correlations.convert, null.value.is.not.zero.convert), mode=c(and=""), id.name="dep_groups_and_nonoverlap_correlations_and_null_value_is_not_zero_convert"),

    raw.data.and.indep.groups.convert <- rk.XML.convert(sources=list(raw.data.input.convert, indep.groups.convert), mode=c(and=""), id.name="raw_data_and_indep_groups_convert"),
    raw.data.and.dep.groups.and.nonoverlap.correlations.convert <- rk.XML.convert(sources=list(raw.data.input.convert, dep.groups.convert, nonoverlap.correlations.convert), mode=c(and=""), id.name="raw_data_and_dep_groups_and_nonoverlap_correlations_convert"),
    raw.data.and.dep.groups.and.overlap.correlations.convert <- rk.XML.convert(sources=list(raw.data.input.convert, dep.groups.convert, overlap.correlations.convert), mode=c(and=""), id.name="raw_data_and_dep_groups_and_overlap_correlations_convert"),

    manual.and.indep.groups.convert <- rk.XML.convert(sources=list(manual.input.convert, indep.groups.convert), mode=c(and=""), id.name="manual_and_indep_groups_convert"),
    manual.and.dep.groups.and.nonoverlap.correlations.convert <- rk.XML.convert(sources=list(manual.input.convert, dep.groups.convert, nonoverlap.correlations.convert), mode=c(and=""), id.name="manual_and_dep_groups_and_nonoverlap_correlations_convert"),
    manual.and.dep.groups.and.overlap.correlations.convert <- rk.XML.convert(sources=list(manual.input.convert, dep.groups.convert, overlap.correlations.convert), mode=c(and=""), id.name="manual_and_dep_groups_and_overlap_correlations_convert"),

    variable.and.indep.groups.convert <- rk.XML.convert(sources=list(variable.input.convert, indep.groups.convert), mode=c(and=""), id.name="variable_and_indep_groups_convert"),
    variable.and.dep.groups.and.nonoverlap.correlations.convert <- rk.XML.convert(sources=list(variable.input.convert, dep.groups.convert, nonoverlap.correlations.convert), mode=c(and=""), id.name="variable_and_dep_groups_and_nonoverlap_correlations_convert"),
    variable.and.dep.groups.and.overlap.correlations.convert <- rk.XML.convert(sources=list(variable.input.convert, dep.groups.convert, overlap.correlations.convert), mode=c(and=""), id.name="variable_and_dep_groups_and_overlap_correlations_convert"),

    ## connect
    rk.XML.connect(governor=manual.or.variable.input.convert, client=manual.and.variable.data.input.col, set="visible"),
    rk.XML.connect(governor=manual.and.indep.groups.convert, client=manual.indep.groups.frame, set="visible"),
    rk.XML.connect(governor=manual.and.dep.groups.and.nonoverlap.correlations.convert, client=manual.dep.groups.nonoverlap.frame, set="visible"),
    rk.XML.connect(governor=manual.and.dep.groups.and.overlap.correlations.convert, client=manual.dep.groups.overlap.frame, set="visible"),

    rk.XML.connect(governor=variable.and.indep.groups.convert, client=variable.indep.groups.frame, set="visible"),
    rk.XML.connect(governor=variable.and.dep.groups.and.nonoverlap.correlations.convert, client=variable.dep.groups.nonoverlap.frame, set="visible"),
    rk.XML.connect(governor=variable.and.dep.groups.and.overlap.correlations.convert, client=variable.dep.groups.overlap.frame, set="visible"),

    rk.XML.connect(governor=indep.groups.and.null.value.is.zero.convert, client=test.hypothesis.indep.groups, set="visible"),
    rk.XML.connect(governor=dep.groups.and.overlap.correlations.and.null.value.is.zero.convert, client=test.hypothesis.dep.groups.overlap, set="visible"),
    rk.XML.connect(governor=dep.groups.and.nonoverlap.correlations.and.null.value.is.zero.convert, client=test.hypothesis.dep.groups.nonoverlap, set="visible"),

    rk.XML.connect(governor=indep.groups.and.null.value.is.not.zero.convert, client=test.hypothesis.indep.groups.null.value, set="visible"),
    rk.XML.connect(governor=dep.groups.and.overlap.correlations.and.null.value.is.not.zero.convert, client=test.hypothesis.dep.groups.overlap.null.value, set="visible"),
    rk.XML.connect(governor=dep.groups.and.nonoverlap.correlations.and.null.value.is.not.zero.convert, client=test.hypothesis.dep.groups.nonoverlap.null.value, set="visible"),

    rk.XML.connect(governor=variable.input.convert, client=var.sel, set="visible"),

    # wizard
    rk.XML.connect(governor=dep.groups.convert, client=wizard.correlations.page, set="visible"),

    rk.XML.connect(governor=raw.data.and.indep.groups.convert, client=raw.data.indep.groups.var.sel.1, set="visible"),
    rk.XML.connect(governor=raw.data.and.indep.groups.convert, client=raw.data.row2, set="visible"),
    rk.XML.connect(governor=raw.data.and.indep.groups.convert, client=raw.data.indep.groups.col.1, set="visible"),
    rk.XML.connect(governor=raw.data.indep.groups.1.convert, client=raw.data.indep.groups.j, set="enabled"),
    rk.XML.connect(governor=raw.data.indep.groups.1.convert, client=raw.data.indep.groups.k, set="enabled"),
    rk.XML.connect(governor=raw.data.indep.groups.2.convert, client=raw.data.indep.groups.h, set="enabled"),
    rk.XML.connect(governor=raw.data.indep.groups.2.convert, client=raw.data.indep.groups.m, set="enabled"),

    rk.XML.connect(governor=raw.data.and.dep.groups.and.overlap.correlations.convert, client=raw.data.dep.groups.overlap.var.sel, set="visible"),
    rk.XML.connect(governor=raw.data.and.dep.groups.and.overlap.correlations.convert, client=raw.data.dep.groups.overlap.col, set="visible"),
    rk.XML.connect(governor=raw.data.dep.groups.overlap.convert, client=raw.data.dep.groups.overlap.j, set="enabled"),
    rk.XML.connect(governor=raw.data.dep.groups.overlap.convert, client=raw.data.dep.groups.overlap.k, set="enabled"),
    rk.XML.connect(governor=raw.data.dep.groups.overlap.convert, client=raw.data.dep.groups.overlap.h, set="enabled"),

    rk.XML.connect(governor=raw.data.and.dep.groups.and.nonoverlap.correlations.convert, client=raw.data.dep.groups.nonoverlap.var.sel, set="visible"),
    rk.XML.connect(governor=raw.data.and.dep.groups.and.nonoverlap.correlations.convert, client=raw.data.dep.groups.nonoverlap.col, set="visible"),
    rk.XML.connect(governor=raw.data.dep.groups.nonoverlap.convert, client=raw.data.dep.groups.nonoverlap.j, set="enabled"),
    rk.XML.connect(governor=raw.data.dep.groups.nonoverlap.convert, client=raw.data.dep.groups.nonoverlap.k, set="enabled"),
    rk.XML.connect(governor=raw.data.dep.groups.nonoverlap.convert, client=raw.data.dep.groups.nonoverlap.h, set="enabled"),
    rk.XML.connect(governor=raw.data.dep.groups.nonoverlap.convert, client=raw.data.dep.groups.nonoverlap.m, set="enabled"),

    # require
    rk.XML.connect(governor=raw.data.and.indep.groups.convert, client=raw.data.indep.groups.1, set="required"),
    rk.XML.connect(governor=raw.data.and.indep.groups.convert, client=raw.data.indep.groups.2, set="required"),
    rk.XML.connect(governor=raw.data.and.indep.groups.convert, client=raw.data.indep.groups.j, set="required"),
    rk.XML.connect(governor=raw.data.and.indep.groups.convert, client=raw.data.indep.groups.k, set="required"),
    rk.XML.connect(governor=raw.data.and.indep.groups.convert, client=raw.data.indep.groups.h, set="required"),
    rk.XML.connect(governor=raw.data.and.indep.groups.convert, client=raw.data.indep.groups.m, set="required"),

    rk.XML.connect(governor=raw.data.and.dep.groups.and.overlap.correlations.convert, client=raw.data.dep.groups.overlap, set="required"),
    rk.XML.connect(governor=raw.data.and.dep.groups.and.overlap.correlations.convert, client=raw.data.dep.groups.overlap.j, set="required"),
    rk.XML.connect(governor=raw.data.and.dep.groups.and.overlap.correlations.convert, client=raw.data.dep.groups.overlap.k, set="required"),
    rk.XML.connect(governor=raw.data.and.dep.groups.and.overlap.correlations.convert, client=raw.data.dep.groups.overlap.h, set="required"),

    rk.XML.connect(governor=raw.data.and.dep.groups.and.nonoverlap.correlations.convert, client=raw.data.dep.groups.nonoverlap, set="required"),
    rk.XML.connect(governor=raw.data.and.dep.groups.and.nonoverlap.correlations.convert, client=raw.data.dep.groups.nonoverlap.j, set="required"),
    rk.XML.connect(governor=raw.data.and.dep.groups.and.nonoverlap.correlations.convert, client=raw.data.dep.groups.nonoverlap.k, set="required"),
    rk.XML.connect(governor=raw.data.and.dep.groups.and.nonoverlap.correlations.convert, client=raw.data.dep.groups.nonoverlap.h, set="required"),
    rk.XML.connect(governor=raw.data.and.dep.groups.and.nonoverlap.correlations.convert, client=raw.data.dep.groups.nonoverlap.m, set="required"),

    rk.XML.connect(governor=variable.and.indep.groups.convert, client=variable.indep.groups.r1.jk, set="required"),
    rk.XML.connect(governor=variable.and.indep.groups.convert, client=variable.indep.groups.n1, set="required"),
    rk.XML.connect(governor=variable.and.indep.groups.convert, client=variable.indep.groups.r2.hm, set="required"),
    rk.XML.connect(governor=variable.and.indep.groups.convert, client=variable.indep.groups.n2, set="required"),

    rk.XML.connect(governor=variable.and.dep.groups.and.overlap.correlations.convert, client=variable.dep.groups.overlap.r.jk, set="required"),
    rk.XML.connect(governor=variable.and.dep.groups.and.overlap.correlations.convert, client=variable.dep.groups.overlap.r.jh, set="required"),
    rk.XML.connect(governor=variable.and.dep.groups.and.overlap.correlations.convert, client=variable.dep.groups.overlap.r.kh, set="required"),
    rk.XML.connect(governor=variable.and.dep.groups.and.overlap.correlations.convert, client=variable.dep.groups.overlap.n, set="required"),

    rk.XML.connect(governor=variable.and.dep.groups.and.nonoverlap.correlations.convert, client=variable.dep.groups.nonoverlap.r.jk, set="required"),
    rk.XML.connect(governor=variable.and.dep.groups.and.nonoverlap.correlations.convert, client=variable.dep.groups.nonoverlap.r.hm, set="required"),
    rk.XML.connect(governor=variable.and.dep.groups.and.nonoverlap.correlations.convert, client=variable.dep.groups.nonoverlap.r.jh, set="required"),
    rk.XML.connect(governor=variable.and.dep.groups.and.nonoverlap.correlations.convert, client=variable.dep.groups.nonoverlap.r.jm, set="required"),
    rk.XML.connect(governor=variable.and.dep.groups.and.nonoverlap.correlations.convert, client=variable.dep.groups.nonoverlap.r.kh, set="required"),
    rk.XML.connect(governor=variable.and.dep.groups.and.nonoverlap.correlations.convert, client=variable.dep.groups.nonoverlap.r.km, set="required"),
    rk.XML.connect(governor=variable.and.dep.groups.and.nonoverlap.correlations.convert, client=variable.dep.groups.nonoverlap.n, set="required"),

    rk.XML.connect(governor="current_object", client=raw.data.indep.groups.1, set="available"),
    rk.XML.connect(governor="current_object", client=raw.data.indep.groups.2, set="available"),
    rk.XML.connect(governor="current_object", client=raw.data.dep.groups.overlap, set="available"),
    rk.XML.connect(governor="current_object", client=raw.data.dep.groups.nonoverlap, set="available"),

    rk.XML.connect(governor=raw.data.indep.groups.1, client=raw.data.indep.groups.var.sel.1, get="available", set="root"),
    rk.XML.connect(governor=raw.data.indep.groups.2, client=raw.data.indep.groups.var.sel.2, get="available", set="root"),
    rk.XML.connect(governor=raw.data.dep.groups.overlap, client=raw.data.dep.groups.overlap.var.sel, get="available", set="root"),
    rk.XML.connect(governor=raw.data.dep.groups.nonoverlap, client=raw.data.dep.groups.nonoverlap.var.sel, get="available", set="root")
  )

  JS.calc <- rk.paste.JS(
    ## raw data input
    jsVar.raw.data.indep.groups.j <- rk.JS.vars(raw.data.indep.groups.j, modifiers="shortname"),
    jsVar.raw.data.indep.groups.k <- rk.JS.vars(raw.data.indep.groups.k, modifiers="shortname"),
    jsVar.raw.data.indep.groups.h <- rk.JS.vars(raw.data.indep.groups.h, modifiers="shortname"),
    jsVar.raw.data.indep.groups.m <- rk.JS.vars(raw.data.indep.groups.m, modifiers="shortname"),
    ite(id(data.input, " == 'raw.data' && ", groups, " == 'indep'"), echo("result <- cocor(~", jsVar.raw.data.indep.groups.j, " + ", jsVar.raw.data.indep.groups.k, " | ", jsVar.raw.data.indep.groups.h, " + ", jsVar.raw.data.indep.groups.m, ", data=list(", raw.data.indep.groups.1, ",", raw.data.indep.groups.2, ")")),

    jsVar.raw.data.dep.groups.overlap.j <- rk.JS.vars(raw.data.dep.groups.overlap.j, modifiers="shortname"),
    jsVar.raw.data.dep.groups.overlap.k <- rk.JS.vars(raw.data.dep.groups.overlap.k, modifiers="shortname"),
    jsVar.raw.data.dep.groups.overlap.h <- rk.JS.vars(raw.data.dep.groups.overlap.h, modifiers="shortname"),
    ite(id(data.input, " == 'raw.data' && ", groups, " == 'dep' && ", correlations, " == 'overlap'"), echo("result <- cocor(~", jsVar.raw.data.dep.groups.overlap.j, " + ", jsVar.raw.data.dep.groups.overlap.k, " | ", jsVar.raw.data.dep.groups.overlap.j, " + ", jsVar.raw.data.dep.groups.overlap.h, ", data=", raw.data.dep.groups.overlap)),

    jsVar.raw.data.dep.groups.nonoverlap.j <- rk.JS.vars(raw.data.dep.groups.nonoverlap.j, modifiers="shortname"),
    jsVar.raw.data.dep.groups.nonoverlap.k <- rk.JS.vars(raw.data.dep.groups.nonoverlap.k, modifiers="shortname"),
    jsVar.raw.data.dep.groups.nonoverlap.h <- rk.JS.vars(raw.data.dep.groups.nonoverlap.h, modifiers="shortname"),
    jsVar.raw.data.dep.groups.nonoverlap.m <- rk.JS.vars(raw.data.dep.groups.nonoverlap.m, modifiers="shortname"),
    ite(id(data.input, " == 'raw.data' && ", groups, " == 'dep' && ", correlations, " == 'nonoverlap'"), echo("result <- cocor(~", jsVar.raw.data.dep.groups.nonoverlap.j, " + ", jsVar.raw.data.dep.groups.nonoverlap.k, " | ", jsVar.raw.data.dep.groups.nonoverlap.h, " + ", jsVar.raw.data.dep.groups.nonoverlap.m, ", data=", raw.data.dep.groups.nonoverlap)),

    ## manual input
    ite(id(data.input, " == 'manual' && ", groups, " == 'indep'"), echo("result <- cocor.indep.groups(r1.jk=", manual.indep.groups.r1.jk, ", n1=", manual.indep.groups.n1, ", r2.hm=", manual.indep.groups.r2.hm, ", n2=", manual.indep.groups.n2)),

    ite(id(data.input, " == 'manual' && ", groups, " == 'dep' && ", correlations, " == 'overlap'"), echo("result <- cocor.dep.groups.overlap(r.jk=", manual.dep.groups.overlap.r.jk, ", r.jh=", manual.dep.groups.overlap.r.jh, ", r.kh=", manual.dep.groups.overlap.r.kh, ", n=", manual.dep.groups.overlap.n)),

    ite(id(data.input, " == 'manual' && ", groups, " == 'dep' && ", correlations, " == 'nonoverlap'"), echo("result <- cocor.dep.groups.nonoverlap(r.jk=", manual.dep.groups.nonoverlap.r.jk, ", r.hm=", manual.dep.groups.nonoverlap.r.hm, ", r.jh=", manual.dep.groups.nonoverlap.r.jh, ", r.jm=", manual.dep.groups.nonoverlap.r.jm, ", r.kh=", manual.dep.groups.nonoverlap.r.kh, ", r.km=", manual.dep.groups.nonoverlap.r.km,", n=", manual.dep.groups.nonoverlap.n)),

    ## variable input
    ite(id(data.input, " == 'variable' && ", groups, " == 'indep'"), echo("result <- cocor.indep.groups(r1.jk=", variable.indep.groups.r1.jk, ", n1=", variable.indep.groups.n1, ", r2.hm=", variable.indep.groups.r2.hm, ", n2=", variable.indep.groups.n2)),

    ite(id(data.input, " == 'variable' && ", groups, " == 'dep' && ", correlations, " == 'overlap'"), echo("result <- cocor.dep.groups.overlap(r.jk=", variable.dep.groups.overlap.r.jk, ", r.jh=", variable.dep.groups.overlap.r.jh, ", r.kh=", variable.dep.groups.overlap.r.kh, ", n=", variable.dep.groups.overlap.n)),

    ite(id(data.input, " == 'variable' && ", groups, " == 'dep' && ", correlations, " == 'nonoverlap'"), echo("result <- cocor.dep.groups.nonoverlap(r.jk=", variable.dep.groups.nonoverlap.r.jk, ", r.hm=", variable.dep.groups.nonoverlap.r.hm, ", r.jh=", variable.dep.groups.nonoverlap.r.jh, ", r.jm=", variable.dep.groups.nonoverlap.r.jm, ", r.kh=", variable.dep.groups.nonoverlap.r.kh, ", r.km=", variable.dep.groups.nonoverlap.r.km,", n=", variable.dep.groups.nonoverlap.n)),

    ite(id(groups, " == 'indep' && ", null.value, " == 0"), echo(", alternative=\"", test.hypothesis.indep.groups, "\"")),
    ite(id(groups, " == 'indep' && ", null.value, " != 0"), echo(", alternative=\"", test.hypothesis.indep.groups.null.value, "\"")),

    ite(id(groups, " == 'dep' && ", correlations, " == 'overlap' && ", null.value, " == 0"), echo(", alternative=\"", test.hypothesis.dep.groups.overlap, "\"")),
    ite(id(groups, " == 'dep' && ", correlations, " == 'overlap' && ", null.value, " != 0"), echo(", alternative=\"", test.hypothesis.dep.groups.overlap.null.value, "\"")),

    ite(id(groups, " == 'dep' && ", correlations, " == 'nonoverlap' && ", null.value, " == 0"), echo(", alternative=\"", test.hypothesis.dep.groups.nonoverlap, "\"")),
    ite(id(groups, " == 'dep' && ", correlations, " == 'nonoverlap' && ", null.value, " != 0"), echo(", alternative=\"", test.hypothesis.dep.groups.nonoverlap.null.value, "\"")),

    ite(id(null.value, " != 0"), echo(", test=\"zou2007\"")),

    echo(", alpha=",  alpha, ", conf.level=", conf.level, ", null.value=", null.value, ")\n"),
    level=2
  )

  JS.print <- rk.paste.JS(echo("rk.print(result)\n"), level=2)

  rkh <- list(
    summary=rk.rkh.summary(text="Compare two correlation coefficients based on either independent or dependent groups (e.g., same group)."),
    sections=list(
      groups=rk.rkh.section(title="Step 1", text="Indicate if the correlations are based on independent or dependent groups."),
      correlations=rk.rkh.section(title="Step 2", text="If the correlation are based on dependent groups, state whether or not the correlations are overlapping and have one variable in common."),
      data.input=rk.rkh.section(title="Step 3", text="Choose whether you want to calculate the correlations from raw data, type in the correlation coefficients manually, or retrieve them from existing variables."),
      data=rk.rkh.section(title="Step 4", text="Enter the data."),
      test.hypothesis.indep.groups1=rk.rkh.section(title="Step 5", text="Select an alpha level and a confidence level. Specify the null value, i.e., the hypothesized difference between the two correlations used for testing the null hypothesis. If the null value is other than 0, only the test by Zou (2007) is available."),
      test.hypothesis.indep.groups2=rk.rkh.section(title="Step 6", text="Choose if the test should be one- or two-sided."),
      code=rk.rkh.section(title="Step 7", text="Copy and paste the generated code to your R script or directly run the code.")
    )
  )

  plugin.dir <<- rk.plugin.skeleton(
    about.node,
    path=output.dir,
    provides=c("logic", "wizard"),
    xml=list(logic=logic, wizard=wizard),
    rkh=rkh,
    js=list(
      require="cocor",
      results.header="\"Comparing correlations\"",
      calculate=JS.calc,
      printout=JS.print
    ),
    pluginmap=list(name="Comparing correlations", hierarchy=list("analysis", "correlation")),
    dependencies=dependencies.node,
    load=TRUE,
#     edit=TRUE,
#     show=TRUE,
    overwrite=overwrite
  )
})
