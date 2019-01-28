// Use each of the packages to create a basic regression table with different features

	global out_raw "C:\Users\WB501238\Documents\GitHub\stata-tables\outputs\Raw"
	
	sysuse census.dta, clear

// Run regressions ********************************

	// Regression 1: nothing interesting
	reg death marriage pop
	
	est sto reg1
	estadd local region	"No"

	// Regression 2: a different regression
	reg death popurban
	
	est sto reg2
	estadd local region "No"

	// Regression 3: indicator expansion
	reg divorce marriage pop
	
	est sto reg3
	estadd local region "No"

	// Regression 4: interaction
	reg divorce marriage pop i.region
	
	est sto reg4
	estadd local region 	"Yes"

// Export tables ********************************

	global regressions reg1 reg2 reg3 reg4
	
	*---------------------------------------------------------------------------
	* The simplest esttab tables will not compile for these regressions. This is
	* due to the occurrence of the special character # on categorical variables
	*---------------------------------------------------------------------------
	esttab ${regressions} using "${out_raw}/esttab_basic.tex", ///
		replace

	*---------------------------------------------------------------------------
	* The issue above can be solved by displaying variable labels instead of 
	* variables names with the 'label' option
	*---------------------------------------------------------------------------
	esttab ${regressions} using "${out_raw}/esttab_label.tex", ///
		label	///	Add variable labels
		replace	
		
	*---------------------------------------------------------------------------
	* The option 'drop' allows you to remove variables from the final table.
	* Use variable names to list all variables to be removed. If you want to 
	* remove specific categories within a categorical variables, type
	* 'mat list r(table)' to see how Stata refers to each category (on the 
	* column names)
	* Option 'keep' would do the opposite, keeping only listed variables.
	* Option 'order' allows you to specify the order or the rows.
	*---------------------------------------------------------------------------
	esttab ${regressions} using "${out_raw}/esttab_scalar.tex", ///
		drop(*.region) 							///	Ommit region coefficients from table
		scalars("region Region fixed effects")  /// Add row indicating their presence instead
		label ///
		replace	
	
	*---------------------------------------------------------------------------
	* Add custom model titles and table notes
	*---------------------------------------------------------------------------
	esttab ${regressions} using "${out_raw}/esttab_titles.tex", ///
		mtitles("Title 1" "Title 2" "Title 3" "Title 4") 		/// Just list titles here
		addnotes("Add a note here." "Other custom note here.")  /// Each note will be shown in one line
		drop(*.region*) ///																
		scalars("region Region fixed effects") /// 
		label ///
		replace
	
	*---------------------------------------------------------------------------
	* Add custom table header. This requires hardcoding the LaTeX header, i.e.,
	* including the beginning of the tabular object and all formatting. This can
	* also be done with the option 'mgroups()'
	*---------------------------------------------------------------------------
	esttab ${regressions} using "${out_raw}/esttab_header.tex", ///
		prehead("\begin{tabular}{l*{4}{c}} \hline\hline & \multicolumn{4}{c}{\textit{Dependent variable:}} \\ & \multicolumn{2}{c}{Number of deaths} & \multicolumn{2}{c}{Number of divorces} \\ \cmidrule(lr){2-3} \cmidrule(lr){4-5} ") ///
		nomtitles 		/// Drop automatic titles, since we're customizing them
		drop(*.region*) ///																
		scalars("region Region fixed effects") /// 
		label ///
		replace
		
	*---------------------------------------------------------------------------
	* Create a two-panel table. This is done using the option 'refcat()' to add
	* a line before the first regression variable, and hardcoding the LaTeX
	* text and formatting. Both panels are created as 'fragment', which means
	* Stata won't add the lines to begin and end the tabular object
	*---------------------------------------------------------------------------
	* Top panel
	esttab reg1 reg2 using "${out_raw}/esttab_panel.tex", 												 /// Will have only the first two regressions
		refcat(marriage "\\ \multicolumn{3}{c}{\textbf{Panel A: Number of deaths}} \\[-1ex]  ", nolabel) /// This is the panel title
		prehead("\begin{tabular}{l*{2}{c}} \hline\hline" ) 												 /// Stata won't begin or end the tabular, so that needs to be done manually
		fragment 																						 ///
		nomtitles noobs 																				 /// Remove model titles and number of observations for top panel
		label																							 ///
		replace	

	* Bottom panel
	esttab reg3 reg4 using "${out_raw}/esttab_panel.tex", ///
		refcat(marriage "\\ \multicolumn{3}{c}{\textbf{Panel B: Number of divorces}} \\[-1ex]  ", nolabel) 						/// Will have only the last two regressions
		fragment 																												///
		append																													/// Appending bottom panel to top panel instead of replacing
		nomtitles nonumbers nolines 																							/// Also not printing lines for better formatting
		prefoot("\hline") ///																									/// Adding one line manually, since we removed automatic lines
		postfoot("\hline\hline \end{tabular} \begin{tablenotes} \footnotesize \item Add notes manually here. \end{tablenotes}") /// Notes are not automatically printed to fragment tables
		drop(*.region*) 																										///																
		label
		
