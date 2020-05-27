/*******************************************************************************
	
	ESTTAB DEMO DO-FILE
	
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

// Load the data ***************************************************************

	local output "../outputs/Raw"												// <------------------- Replace ".." with the repository's root folder
	
	sysuse census.dta, clear
	xtset region

// Run regressions *************************************************************

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

	// Regression 4: categorical control
	reg divorce marriage pop i.region
	
	est sto reg4
	estadd local region 	"Yes"
	
	// South region only
	reg death marriage if region == 3
	est sto s1
	
	reg death marriage pop if region == 3
	est sto s2
	
	// West region only
	reg death marriage if region == 4
	est sto w1
	
	reg death marriage pop if region == 4
	est sto w2

// Export tables ***************************************************************

	local regressions reg1 reg2 reg3 reg4

	*---------------------------------------------------------------------------
	* The simplest esttab tables will not compile for these regressions. This is
	* due to the occurrence of the special character # on categorical variables
	*---------------------------------------------------------------------------
	esttab `regressions' using "`output'/t1_esttab_basic.tex", ///
		replace

	*---------------------------------------------------------------------------
	* The issue above can be solved by displaying variable labels instead of 
	* variables names with the 'label' option
	*---------------------------------------------------------------------------
	esttab `regressions' using "`output'/t2_esttab_label.tex", ///
		label	///	Add variable labels
		se		/// Display standard errors instead of t-statistics 
		replace	
		
			
	*---------------------------------------------------------------------------
	* Remove omitted variables and levels from regression
	*---------------------------------------------------------------------------
	esttab `regressions' using "`output'/t3_esttab_omitted.tex",				///
		ci 																		/// Show confidence intervals
		noomit nobaselevels														/// Remove variables omitted due to multicollinearity and categorical variables base levels
		refcat(_cons "Omitted category: NE region", nolabel)					/// Add note indicating the omitted region -- refcat() can be used more broadly to add lines before a variable
		addnotes("Add a note here." "Other custom note here.")  				/// Each note will be shown in one line
		label 																	///
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
	esttab `regressions' using "`output'/t4_esttab_scalar.tex", 				///
		ci 																		/// Show confidence intervals
		drop(*.region*)															///	Remove fixed effects estimates from table															
		scalars("region Region controls")  										/// Add row indicating their presence instead
		addnotes("Add a note here." "Other custom note here.")  				/// Each note will be shown in one line
		label 																	///
		replace	
		
	
	*---------------------------------------------------------------------------
	* Add custom model titles and table notes
	*---------------------------------------------------------------------------
	esttab `regressions' using "`output'/t5_esttab_titles.tex", 				///
		mtitles("Title 1" "Title 2" "Title 3" "Title 4") 						/// Just list titles here
		se																		/// Display standard errors instead of t-statistics 
		drop(*.region*) 														///																
		scalars("region Region controls") 										/// 
		addnotes("Add a note here." "Other custom note here.")  				/// Each note will be shown in one line
		label ///
		replace
	
	*---------------------------------------------------------------------------
	* Add custom table header and grouping regressions 
	*---------------------------------------------------------------------------
	esttab `regressions' using "`output'/t6_esttab_header.tex", 				///
		nomtitles 																/// Drop automatic titles, since we're customizing them
		drop(*.region*) 														///																
		scalars("region Region fixed effects") 									/// 
		se																		/// Display standard errors instead of t-statistics 
		label 																	///
		mgroups("Number of deaths" "Number of divorces", 						///	Group titles
				pattern(1 0 1 0) 												/// Which columns are in which group? (1 marks the beginning of a new group
				span prefix(\multicolumn{@span}{c}{) suffix(})   				/// Centralize group titles including both groups
		        erepeat(\cmidrule(lr){@span}))									/// Add line under groups
		replace																	///
		/// The following line hardcodes the table hader in LaTeX:
		prehead("\begin{tabular}{l*{4}{c}} \hline\hline & \multicolumn{4}{c}{\textit{Dependent variable:}} \\")
		
	*---------------------------------------------------------------------------
	* Create a two-panel table. This is done using the option 'prehead' to add
	* a line before the first regression variable, and hardcoding the LaTeX
	* text and formatting. Both panels are created as 'fragment', which means
	* Stata won't add the lines to begin and end the tabular object
	*---------------------------------------------------------------------------
	* Top panel
	esttab s1 s2 using "`output'/t7_esttab_panel.tex", 								 	/// Will have only the first two regressions
		prehead("\begin{tabular}{l*{2}{c}} \hline\hline")								/// Stata won't begin or end the tabular environment when fragment is used, so that needs to be done manually
		posthead("\hline \\ \multicolumn{3}{c}{\textbf{Panel A: South}} \\\\[-1ex]")  			/// This is the panel header, also hardcoded in LaTeX, and shown under model titles and numbers -- therefore the posthead
		fragment 																		///
		mgroups("Number of deaths", 													///	Group titles
				pattern(1 0) 															/// Which columns are in which group? (1 marks the beginning of a new group
				span prefix(\multicolumn{@span}{c}{) suffix(}))							/// Remove model titles and number of observations for top panel
		nomtitles																		/// Group title replaces model title
		label																			///
		replace	

	* Bottom panel
	esttab w1 w2 using "`output'/t7_esttab_panel.tex", ///
		posthead("\hline \\ \multicolumn{3}{c}{\textbf{Panel B: West}} \\\\[-1ex]")												/// Panel header: this panel will include only the last two regressions
		fragment 																												///
		append																													/// Appending bottom panel to top panel instead of replacing
		nomtitles nonumbers nolines 																							/// Also not printing lines for better formatting
		prefoot("\hline") ///																									/// Adding one line manually, since we removed automatic lines
		postfoot("\hline\hline \end{tabular} \begin{tablenotes} \footnotesize \item Add notes manually here. \end{tablenotes}") /// Notes are not automatically printed to fragment tables
		label
		
******************************************************************* Agora acabou!
