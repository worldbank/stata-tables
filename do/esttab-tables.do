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

	ssc install estout 
	
// Load the data ***************************************************************

	local output "C:\Users\wb501238\Documents\GitHub\stata-tables\outputs\Raw"												// <------------------- Replace ".." with the repository's root folder
	
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


		
	* Top panel
	esttab s1 s2 using "`output'/t7_esttab_panel.csv", 								 	/// Will have only the first two regressions
		posthead("Panel A: South")  			/// This is the panel header, also hardcoded in LaTeX, and shown under model titles and numbers -- therefore the posthead
		nomtitles nonotes		///																/// Group title replaces model title
		label		///																	///
		replace	

	* Bottom panel
	esttab w1 w2 using "`output'/t7_esttab_panel.csv", ///
		posthead("Panel B: West")		///										/// Panel header: this panel will include only the last two regressions																									///
		append							///																						/// Appending bottom panel to top panel instead of replacing
		nomtitles nonumbers nolines 	///																						/// Also not printing lines for better formatting
		label
		
******************************************************************* Agora acabou!
