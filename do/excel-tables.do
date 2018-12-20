// Use each of the packages to create a basic regression table with different features
set seed 474747
cd "/Users/bbdaniels/GitHub/stata-tables/"
sysuse census.dta , clear

// Run regressions ********************************

	// Regression 1: nothing interesting
	reg divorce marriage pop
		est sto reg1

	// Regression 2: a different regression
	reg medage popurban
		est sto reg2

	// Regression 3: indicator expansion
	reg divorce marriage pop i.region
		est sto reg3

	// Regression 4: interaction
	gen binary = rnormal() > 0
		lab def binary 0 "No" 1 "Yes"
		lab val binary binary
		label var binary "Indicator"

	reg divorce marriage pop i.region#i.binary
		est sto reg4

// Export tables ********************************

	local regressions reg1 reg2 reg3 reg4

	// estout
	estout `regressions' ///
	using "outputs/estout.xls" ///
	, replace

	// xml_tab
	xml_tab `regressions' ///
	, save("outputs/xml_tab.xls") ///
		replace below

	// outwrite
	outwrite `regressions' ///
	using "outputs/outwrite.xlsx" ///
	, replace

// Have a lovely day!
