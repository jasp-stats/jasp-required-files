// this code was generated using the rkwarddev package.
//perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(){
	// add requirements etc. here
	echo("require(cocor)\n");
}

function calculate(){
	// read in variables from dialog
	var groups = getValue("groups");
	var correlations = getValue("correlations");
	var dataInput = getValue("data_input");
	var rawDataDepGroupsNonoverlap = getValue("raw_data_dep_groups_nonoverlap");
	var rawDataDepGroupsNonoverlapJ = getValue("raw_data_dep_groups_nonoverlap_j");
	var rawDataDepGroupsNonoverlapK = getValue("raw_data_dep_groups_nonoverlap_k");
	var rawDataDepGroupsNonoverlapH = getValue("raw_data_dep_groups_nonoverlap_h");
	var rawDataDepGroupsNonoverlapM = getValue("raw_data_dep_groups_nonoverlap_m");
	var rawDataDepGroupsOverlap = getValue("raw_data_dep_groups_overlap");
	var rawDataDepGroupsOverlapJ = getValue("raw_data_dep_groups_overlap_j");
	var rawDataDepGroupsOverlapK = getValue("raw_data_dep_groups_overlap_k");
	var rawDataDepGroupsOverlapH = getValue("raw_data_dep_groups_overlap_h");
	var rawDataIndepGroups1 = getValue("raw_data_indep_groups_1");
	var rawDataIndepGroupsJ = getValue("raw_data_indep_groups_j");
	var rawDataIndepGroupsK = getValue("raw_data_indep_groups_k");
	var manualIndepGroupsR1Jk = getValue("manual_indep_groups_r1_jk");
	var manualIndepGroupsR2Hm = getValue("manual_indep_groups_r2_hm");
	var manualIndepGroupsN1 = getValue("manual_indep_groups_n1");
	var manualIndepGroupsN2 = getValue("manual_indep_groups_n2");
	var manualDepGroupsOverlapRJk = getValue("manual_dep_groups_overlap_r_jk");
	var manualDepGroupsOverlapRJh = getValue("manual_dep_groups_overlap_r_jh");
	var manualDepGroupsOverlapRKh = getValue("manual_dep_groups_overlap_r_kh");
	var manualDepGroupsOverlapN = getValue("manual_dep_groups_overlap_n");
	var manualDepGroupsNonoverlapRJk = getValue("manual_dep_groups_nonoverlap_r_jk");
	var manualDepGroupsNonoverlapRHm = getValue("manual_dep_groups_nonoverlap_r_hm");
	var manualDepGroupsNonoverlapRJh = getValue("manual_dep_groups_nonoverlap_r_jh");
	var manualDepGroupsNonoverlapRJm = getValue("manual_dep_groups_nonoverlap_r_jm");
	var manualDepGroupsNonoverlapRKh = getValue("manual_dep_groups_nonoverlap_r_kh");
	var manualDepGroupsNonoverlapRKm = getValue("manual_dep_groups_nonoverlap_r_km");
	var manualDepGroupsNonoverlapN = getValue("manual_dep_groups_nonoverlap_n");
	var variableIndepGroupsR1Jk = getValue("variable_indep_groups_r1_jk");
	var variableIndepGroupsR2Hm = getValue("variable_indep_groups_r2_hm");
	var variableIndepGroupsN1 = getValue("variable_indep_groups_n1");
	var variableIndepGroupsN2 = getValue("variable_indep_groups_n2");
	var variableDepGroupsOverlapRJk = getValue("variable_dep_groups_overlap_r_jk");
	var variableDepGroupsOverlapRJh = getValue("variable_dep_groups_overlap_r_jh");
	var variableDepGroupsOverlapRKh = getValue("variable_dep_groups_overlap_r_kh");
	var variableDepGroupsOverlapN = getValue("variable_dep_groups_overlap_n");
	var variableDepGroupsNonoverlapRJk = getValue("variable_dep_groups_nonoverlap_r_jk");
	var variableDepGroupsNonoverlapRHm = getValue("variable_dep_groups_nonoverlap_r_hm");
	var variableDepGroupsNonoverlapRJh = getValue("variable_dep_groups_nonoverlap_r_jh");
	var variableDepGroupsNonoverlapRJm = getValue("variable_dep_groups_nonoverlap_r_jm");
	var variableDepGroupsNonoverlapRKh = getValue("variable_dep_groups_nonoverlap_r_kh");
	var variableDepGroupsNonoverlapRKm = getValue("variable_dep_groups_nonoverlap_r_km");
	var variableDepGroupsNonoverlapN = getValue("variable_dep_groups_nonoverlap_n");
	var rawDataIndepGroups2 = getValue("raw_data_indep_groups_2");
	var rawDataIndepGroupsH = getValue("raw_data_indep_groups_h");
	var rawDataIndepGroupsM = getValue("raw_data_indep_groups_m");
	var alpha = getValue("alpha");
	var confInt = getValue("conf_int");
	var nullValue = getValue("null_value");
	var testHypothesisIndepGroups = getValue("test_hypothesis_indep_groups");
	var testHypothesisDepGroupsOverlap = getValue("test_hypothesis_dep_groups_overlap");
	var testHypothesisDepGroupsNonoverlap = getValue("test_hypothesis_dep_groups_nonoverlap");
	var testHypothesisIndepGroupsNullValue = getValue("test_hypothesis_indep_groups_null_value");
	var testHypothesisDepGroupsOverlapNullValue = getValue("test_hypothesis_dep_groups_overlap_null_value");
	var testHypothesisDepGroupsNonoverlapNullValue = getValue("test_hypothesis_dep_groups_nonoverlap_null_value");

	// the R code to be evaluated
	var rawDataIndepGroupsJShortname = getValue("raw_data_indep_groups_j.shortname");
	var rawDataIndepGroupsKShortname = getValue("raw_data_indep_groups_k.shortname");
	var rawDataIndepGroupsHShortname = getValue("raw_data_indep_groups_h.shortname");
	var rawDataIndepGroupsMShortname = getValue("raw_data_indep_groups_m.shortname");
	if(dataInput == 'raw.data' && groups == 'indep') {
		echo("result <- cocor(~" + rawDataIndepGroupsJShortname + " + " + rawDataIndepGroupsKShortname + " | " + rawDataIndepGroupsHShortname + " + " + rawDataIndepGroupsMShortname + ", data=list(" + rawDataIndepGroups1 + "," + rawDataIndepGroups2 + ")");
	}
	var rawDataDepGroupsOverlapJShortname = getValue("raw_data_dep_groups_overlap_j.shortname");
	var rawDataDepGroupsOverlapKShortname = getValue("raw_data_dep_groups_overlap_k.shortname");
	var rawDataDepGroupsOverlapHShortname = getValue("raw_data_dep_groups_overlap_h.shortname");
	if(dataInput == 'raw.data' && groups == 'dep' && correlations == 'overlap') {
		echo("result <- cocor(~" + rawDataDepGroupsOverlapJShortname + " + " + rawDataDepGroupsOverlapKShortname + " | " + rawDataDepGroupsOverlapJShortname + " + " + rawDataDepGroupsOverlapHShortname + ", data=" + rawDataDepGroupsOverlap);
	}
	var rawDataDepGroupsNonoverlapJShortname = getValue("raw_data_dep_groups_nonoverlap_j.shortname");
	var rawDataDepGroupsNonoverlapKShortname = getValue("raw_data_dep_groups_nonoverlap_k.shortname");
	var rawDataDepGroupsNonoverlapHShortname = getValue("raw_data_dep_groups_nonoverlap_h.shortname");
	var rawDataDepGroupsNonoverlapMShortname = getValue("raw_data_dep_groups_nonoverlap_m.shortname");
	if(dataInput == 'raw.data' && groups == 'dep' && correlations == 'nonoverlap') {
		echo("result <- cocor(~" + rawDataDepGroupsNonoverlapJShortname + " + " + rawDataDepGroupsNonoverlapKShortname + " | " + rawDataDepGroupsNonoverlapHShortname + " + " + rawDataDepGroupsNonoverlapMShortname + ", data=" + rawDataDepGroupsNonoverlap);
	}
	if(dataInput == 'manual' && groups == 'indep') {
		echo("result <- cocor.indep.groups(r1.jk=" + manualIndepGroupsR1Jk + ", n1=" + manualIndepGroupsN1 + ", r2.hm=" + manualIndepGroupsR2Hm + ", n2=" + manualIndepGroupsN2);
	}
	if(dataInput == 'manual' && groups == 'dep' && correlations == 'overlap') {
		echo("result <- cocor.dep.groups.overlap(r.jk=" + manualDepGroupsOverlapRJk + ", r.jh=" + manualDepGroupsOverlapRJh + ", r.kh=" + manualDepGroupsOverlapRKh + ", n=" + manualDepGroupsOverlapN);
	}
	if(dataInput == 'manual' && groups == 'dep' && correlations == 'nonoverlap') {
		echo("result <- cocor.dep.groups.nonoverlap(r.jk=" + manualDepGroupsNonoverlapRJk + ", r.hm=" + manualDepGroupsNonoverlapRHm + ", r.jh=" + manualDepGroupsNonoverlapRJh + ", r.jm=" + manualDepGroupsNonoverlapRJm + ", r.kh=" + manualDepGroupsNonoverlapRKh + ", r.km=" + manualDepGroupsNonoverlapRKm + ", n=" + manualDepGroupsNonoverlapN);
	}
	if(dataInput == 'variable' && groups == 'indep') {
		echo("result <- cocor.indep.groups(r1.jk=" + variableIndepGroupsR1Jk + ", n1=" + variableIndepGroupsN1 + ", r2.hm=" + variableIndepGroupsR2Hm + ", n2=" + variableIndepGroupsN2);
	}
	if(dataInput == 'variable' && groups == 'dep' && correlations == 'overlap') {
		echo("result <- cocor.dep.groups.overlap(r.jk=" + variableDepGroupsOverlapRJk + ", r.jh=" + variableDepGroupsOverlapRJh + ", r.kh=" + variableDepGroupsOverlapRKh + ", n=" + variableDepGroupsOverlapN);
	}
	if(dataInput == 'variable' && groups == 'dep' && correlations == 'nonoverlap') {
		echo("result <- cocor.dep.groups.nonoverlap(r.jk=" + variableDepGroupsNonoverlapRJk + ", r.hm=" + variableDepGroupsNonoverlapRHm + ", r.jh=" + variableDepGroupsNonoverlapRJh + ", r.jm=" + variableDepGroupsNonoverlapRJm + ", r.kh=" + variableDepGroupsNonoverlapRKh + ", r.km=" + variableDepGroupsNonoverlapRKm + ", n=" + variableDepGroupsNonoverlapN);
	}
	if(groups == 'indep' && nullValue == 0) {
		echo(", alternative=\"" + testHypothesisIndepGroups + "\"");
	}
	if(groups == 'indep' && nullValue != 0) {
		echo(", alternative=\"" + testHypothesisIndepGroupsNullValue + "\"");
	}
	if(groups == 'dep' && correlations == 'overlap' && nullValue == 0) {
		echo(", alternative=\"" + testHypothesisDepGroupsOverlap + "\"");
	}
	if(groups == 'dep' && correlations == 'overlap' && nullValue != 0) {
		echo(", alternative=\"" + testHypothesisDepGroupsOverlapNullValue + "\"");
	}
	if(groups == 'dep' && correlations == 'nonoverlap' && nullValue == 0) {
		echo(", alternative=\"" + testHypothesisDepGroupsNonoverlap + "\"");
	}
	if(groups == 'dep' && correlations == 'nonoverlap' && nullValue != 0) {
		echo(", alternative=\"" + testHypothesisDepGroupsNonoverlapNullValue + "\"");
	}
	if(nullValue != 0) {
		echo(", test=\"zou2007\"");
	}
	echo(", alpha=" + alpha + ", conf.level=" + confInt + ", null.value=" + nullValue + ")\n");
}

function printout(){
	// printout the results
	echo("rk.header(\"Comparing correlations\")\n");

	echo("rk.print(result)\n");

}

