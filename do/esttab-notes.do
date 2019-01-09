/*******************************************************************************
	Prepare data
*******************************************************************************/

	global controls		headroom trunk length
	global output		"C:\Users\WB501238\Documents\GitHub\stata-tables\outputs\Raw"
	
	sysuse auto, clear
	
	split make, gen(make_)
	encode make_1, gen(brand)

	lab var foreign "Car type (1 = foreign)"

/*******************************************************************************
	Run regressions
*******************************************************************************/

	reg 	price foreign		
	eststo nocontrols
	estadd local controls 	"No"
	estadd local fe 		"No"
	
	reg 	price foreign $controls
	eststo controls
	estadd local controls	"Yes"
	estadd local fe 		"No"
	
	reg 	price foreign mpg $controls
	eststo mpg
	estadd local controls	"Yes"
	estadd local fe 		"No"
	
	reg 	price foreign mpg $controls i.brand
	eststo fixedeffects
	estadd local controls	"Yes"
	estadd local fe 		"Yes"
	
/*******************************************************************************
	Export tables
*******************************************************************************/

	#delimit ;
	
	
	* This note is too wide
	esttab 	nocontrols controls mpg fixedeffects 								// Export three regressions
			using "${output}/tbl_longnote.tex", 								// Saving to tbl_longnote.tex
			scalars("controls Model controls" "fe Make fixed effects")			// Adding two lines to bottom of table
			keep(foreign mpg _cons) 											// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							// Layout options
			addnotes("\lipsum[1]")												// Adding a paragraph of lipsum
	;
	
	* Fixing note width with threeparttable
	esttab nocontrols controls mpg fixedeffects                                 // Export three regressions
			using "${output}/threeparttable.tex",                               // Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			// Adding two lines to bottom of table
			keep(foreign _cons) 												// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							// Layout options
			postfoot("\hline\hline \end{tabular}} \begin{tablenotes} \footnotesize \item \lipsum[1] \end{tablenotes}")    // Input LaTeX code for closing table
			
	;
	
	* Fixing note width without threeparttable
	esttab nocontrols controls mpg fixedeffects                                 // Export three regressions
			using "${output}/tbl_fittednote.tex",                               // Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			// Adding two lines to bottom of table
			keep(foreign _cons) 												// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							// Layout options
			postfoot("\hline\hline \multicolumn{5}{@{}p{\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")    // Input LaTeX code for closing table
		
	;
	
	* Narrow table without threeparttable
	esttab nocontrols controls fixedeffects                                 	// Export three regressions
			using "${output}/tbl_unfittednote.tex",                               // Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			// Adding two lines to bottom of table
			keep(foreign _cons) 												// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							// Layout options
			postfoot("\hline\hline \multicolumn{4}{@{}p{\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")    // Input LaTeX code for closing table
		
	;
	
	* Wide table without threeparttable
	esttab nocontrols controls fixedeffects nocontrols controls fixedeffects   	// Export three regressions
			using "${output}/tbl_narrownote.tex",                               // Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			// Adding two lines to bottom of table
			keep(foreign _cons) 												// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							// Layout options
			postfoot("\hline\hline \multicolumn{7}{@{}p{\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")    // Input LaTeX code for closing table
		
	;
	
	* Fixing note in wide table without threeparttable
	esttab nocontrols controls fixedeffects nocontrols controls fixedeffects   	// Export three regressions
			using "${output}/tbl_widenote.tex",                                 // Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			// Adding two lines to bottom of table
			keep(foreign _cons) 												// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							// Layout options
			postfoot("\hline\hline \multicolumn{7}{@{}p{1.3\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")    // Input LaTeX code for closing table
		
	;
		
	* Narrow table with three part table
	esttab nocontrols controls mpg                                              // Export three regressions
			using "${output}/tbl_fittednotenarrow.tex",                         // Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			// Adding two lines to bottom of table
			keep(foreign _cons) 												// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							// Layout options
			postfoot("\hline\hline \end{tabular}} \begin{tablenotes} \footnotesize \item \lipsum[1] \end{tablenotes}")    // Input LaTeX code for closing table
			
	;
	
	* Wide table with three part table
	esttab nocontrols controls mpg nocontrols controls mpg                      // Export three regressions
			using "${output}/tbl_fittednotewide.tex",                           // Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			// Adding two lines to bottom of table
			keep(foreign _cons) 												// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							// Layout options
			postfoot("\hline\hline \end{tabular}} \begin{tablenotes} \footnotesize \item \lipsum[1] \end{tablenotes}")    // Input LaTeX code for closing table
			
	;
