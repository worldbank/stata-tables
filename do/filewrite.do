********************************************************************************
*				CREATING A CUSTOM TABLE WITH FILE WRITE
********************************************************************************

* ------------------------------------------------------------------------------
* 					Calculate numbers and store as locals
* ------------------------------------------------------------------------------
	
	forvalues round = 4/$fup_rounds {							
		forvalues tmtStatus = 0/1 {
			
			* Count number of households assigned to treatment
			count if tmt_hh == `tmtStatus' & d_listed_fup`round' == 1
			local listed = r(N)
			
			* Count number of household that actually received treatment
			count if tmt_hh == `tmtStatus' & d_listed_fup`round' == 1 & d_surveyed_fup`round' == 1
			local surveyed = r(N)
			
			* Calculate percentages
			scalar rate_fup`round'_g`tmtStatus' 	= (`surveyed'/`listed')*100
			scalar listed_fup`round'_g`tmtStatus' 	= `listed'
			scalar surveyed_fup`round'_g`tmtStatus' = `surveyed'
		}
	}
	
* ------------------------------------------------------------------------------
* 								Export table
* ------------------------------------------------------------------------------

	capture file close sampleTable
	file open 	sampleTable using "$out_desc/filewrite.tex", write replace
	file write 	sampleTable ///
		"\begin{tabular}{lcccccc}" 																																															  _n ///
		"\hline\hline     \\[-1.8ex]" 																																														  _n ///
		"& \multicolumn{2}{c}{Assignment} & \multicolumn{2}{c}{Survey response} & \multicolumn{2}{c}{Rate}       \\" 																										  _n ///
		"\cline{2-7} \\[-1.8ex]" 																																															  _n /// 
		"& \shortstack{Individual\\feedback}    & \shortstack{General\\feedback}    & \shortstack{Individual\\feedback}    & \shortstack{General\\feedback}   & \shortstack{Individual\\feedback}    & \shortstack{General\\feedback} \\" 																																  _n ///
		"\hline \\[-1.8ex]" 																																																  _n ///
		"First feedback round   & " %8.0gc (listed_fup4_g1) " & " %8.0gc (listed_fup4_g0) " & " %8.0gc (surveyed_fup4_g1) " & " %8.0gc (surveyed_fup4_g0) " & " %8.1f (rate_fup4_g1) "\% & " %8.1f (rate_fup4_g0) "\%  \\" _n ///
		"Second feedback round  & " %8.0gc (listed_fup5_g1) " & " %8.0gc (listed_fup5_g0) " & " %8.0gc (surveyed_fup5_g1) " & " %8.0gc (surveyed_fup5_g0) " & " %8.1f (rate_fup5_g1) "\% & " %8.1f (rate_fup5_g0) "\%  \\" _n ///
		"Third feedback round	& " %8.0gc (listed_fup6_g1) " & " %8.0gc (listed_fup6_g0) " & " %8.0gc (surveyed_fup6_g1) " & " %8.0gc (surveyed_fup6_g0) " & " %8.1f (rate_fup6_g1) "\% & " %8.1f (rate_fup6_g0) "\%  \\" _n ///
		"Forth feedback round	& " %8.0gc (listed_fup7_g1) " & " %8.0gc (listed_fup7_g0) " & " %8.0gc (surveyed_fup7_g1) " & " %8.0gc (surveyed_fup7_g0) " & " %8.1f (rate_fup7_g1) "\% & " %8.1f (rate_fup7_g0) "\%  \\" _n ///
		"\hline\hline" 																																																	  	  _n ///
		"\end{tabular}"
	file close 	sampleTable
	
********************************************************************************
* This table is part of "Water When It Counts: Reducing Scarcity through 
* Irrigation Monitoring in Central Mozambique" by Paul Christian, Florence 
* Kondylis, Valerie Mueller, Astrid Zwager and Tobias Siegfried.
* Complete replication files can be found in 
* https://github.com/worldbank/Water-When-It-Counts
********************************************************************************
