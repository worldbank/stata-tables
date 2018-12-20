
foreach package in xml_tab estout outreg outreg2 mktab outtex est2tex {
	ssc install `package' , replace
}

net install sg73 , from(http://www.stata.com/stb/stb40) // modltbl
