/*******************************************************************************
	
	LaTeX TABLE NOTES HANDLING DEMO DO-FILE
	
	How to use this do-file:
	1. Add the folder path to the root repository folder where indicated
	2. Run the do-file to make it's working
	3. Open "stata-tables/outputs/esttab.tex" and compile the file to see the 
	   tables created
	4. Edit this do-file, run it and re-compile the LaTeX file to explore the 
	   different options
		
--------------------------------------------------------------------------------
	
	For complete documentation, visit http://repec.sowi.unibe.ch/stata/estout/
	
	Written by: 	Luiza Andrade [lcardoso@worldbank.org]
	Last updated:	May 2020
	
*******************************************************************************/

// Prepare data ****************************************************************
	
	local controls		headroom trunk length
	local output		"../outputs/Raw"										// <------------------- Replace ".." with the repository's root folder
	
	sysuse auto, clear
	
	split make, gen(make_)
	encode make_1, gen(brand)

	lab var foreign "Car type (1 = foreign)"

// Run regressions *************************************************************

	reg 	price foreign		
	eststo nocontrols
	estadd local controls 	"No"
	estadd local fe 		"No"
	
	reg 	price foreign `controls'
	eststo controls
	estadd local controls	"Yes"
	estadd local fe 		"No"
	
	reg 	price foreign mpg `controls'
	eststo mpg
	estadd local controls	"Yes"
	estadd local fe 		"No"
	
	areg 	price foreign `controls', a(brand)
	eststo fixedeffects
	estadd local controls	"Yes"
	estadd local fe 		"Yes"
	
// Adjusting wide notes ********************************************************
	
	
	// This note is too wide
	esttab 	nocontrols controls mpg fixedeffects 								/// Export for regressions
			using "`output'/t8_longnote.tex", 									/// Saving to tbl_longnote.tex
			scalars("controls Model controls" "fe Make fixed effects")			/// Adding two lines to bottom of table
			keep(foreign mpg _cons) 											/// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							/// Layout options
			addnotes("\lipsum[1]")												// Adding a paragraph of lipsum
	
	// Fixing note width with threeparttable
	esttab nocontrols controls fixedeffects                                 	/// Export three regressions
			using "`output'/t9_threeparttable.tex",                            	/// Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			/// Adding two lines to bottom of table
			keep(foreign _cons) 												/// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							/// Layout options
			postfoot("\hline\hline \end{tabular}} \begin{tablenotes} \footnotesize \item \lipsum[1] \end{tablenotes}")    // Input LaTeX code for closing table
			
	
	// Adjusting note width without threeparttable by trial-and-error
	local	notewidth	.8 	// Try different values for note width until it looks right
	
	esttab nocontrols controls fixedeffects                                 	/// Export three regressions
			using "`output'/t10_unfittednote.tex",                             	/// Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			/// Adding two lines to bottom of table
			keep(foreign _cons) 												/// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							/// Layout options
			postfoot("\hline\hline \multicolumn{4}{@{}p{`notewidth'\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")    // Input LaTeX code for closing table
		
	
// Adjusting narrow notes ******************************************************

	// Narrow note without threeparttable
	esttab nocontrols controls fixedeffects nocontrols controls fixedeffects   	/// Export six regressions
			using "`output'/t11_narrownote.tex",                              	/// Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			/// Adding two lines to bottom of table
			keep(foreign _cons) 												/// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							/// Layout options
			postfoot("\hline\hline \multicolumn{7}{@{}p{\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")    // Input LaTeX code for closing table

	// Adjusting note width with threeparttable
	esttab 	nocontrols controls fixedeffects nocontrols controls fixedeffects   /// Export six regressions
			using "`output'/t12_narrow3parttable.tex",                         	/// Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			/// Adding two lines to bottom of table
			keep(foreign _cons) 												/// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							/// Layout options
			postfoot("\hline\hline \end{tabular}} \begin{tablenotes} \footnotesize \item \lipsum[1] \end{tablenotes}")    // Input LaTeX code for closing table

	// Adjusting note width without threeparttable by trial-and-error
	local	notewidth	1.3 	// Try different values for note width until it looks right	
	esttab 	nocontrols controls fixedeffects nocontrols controls fixedeffects   /// Export six regressions
			using "`output'/t13_manualnarrow.tex",                             	/// Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			/// Adding two lines to bottom of table
			keep(foreign _cons) 												/// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							/// Layout options
			postfoot("\hline\hline \multicolumn{7}{@{}p{`notewidth'\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")    // Input LaTeX code for closing table

		
********************************************************************** That's it!
