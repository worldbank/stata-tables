
	global controls		headroom trunk length
	global output		"C:\Users\luiza\Documents\GitHub\stata-tables\outputs\Raw"
	
	sysuse auto, clear
	
	split make, gen(make_)
	encode make_1, gen(brand)

	lab var foreign "Car type (1 = foreign)"
	
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
	
	#delimit ;
	
	esttab 	nocontrols controls mpg fixedeffects 								// Export three regressions
			using "${output}/tbl_longnote.tex", 								// Saving to tbl_longnote.tex
			scalars("controls Model controls" "fe Make fixed effects")			// Adding two lines to bottom of table
			keep(foreign mpg _cons) 											// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							// Layout options
			addnotes("\lipsum[1]")												// Adding a paragraph of lipsum
	;

	esttab nocontrols controls mpg fixedeffects                                 // Export three regressions
			using "${output}/tbl_fittednote.tex",                               // Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			// Adding two lines to bottom of table
			keep(foreign _cons) 												// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							// Layout options
			postfoot("\hline\hline \multicolumn{5}{@{}p{\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")    // Input LaTeX code for closing table
		
	;
	
	esttab nocontrols controls fixedeffects                                 	// Export three regressions
			using "${output}/tbl_unfittednote.tex",                               // Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			// Adding two lines to bottom of table
			keep(foreign _cons) 												// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							// Layout options
			postfoot("\hline\hline \multicolumn{4}{@{}p{\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")    // Input LaTeX code for closing table
		
	;
	
	esttab nocontrols controls fixedeffects nocontrols controls fixedeffects   	// Export three regressions
			using "${output}/tbl_narrownote.tex",                               // Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			// Adding two lines to bottom of table
			keep(foreign _cons) 												// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress							// Layout options
			postfoot("\hline\hline \multicolumn{7}{@{}p{\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")    // Input LaTeX code for closing table
		
	;
		
	esttab nocontrols controls mpg fixedeffects                                                                      	  // Export three regressions
			using "${output}/tbl_fittednote.tex",                                                                     // Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			// Adding two lines to bottom of table
			keep(foreign _cons) 												// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress									// Layout options
			postfoot("\hline\hline \multicolumn{5}{@{}p{\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")    // Input LaTeX code for closing table
			
	;
	
	esttab nocontrols controls mpg                                                                       	  // Export three regressions
			using "${output}/tbl_fittednotenarrow.tex",                                                                     // Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			// Adding two lines to bottom of table
			keep(foreign _cons) 												// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress									// Layout options
			postfoot("\hline\hline \multicolumn{5}{@{}p{\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")    // Input LaTeX code for closing table
			
	;
	
	esttab nocontrols controls mpg                                                                       	  // Export three regressions
			using "${output}/tbl_fittednotewide.tex",                                                                     // Saving to tbl_fittednote.tex
			scalars("controls Model controls" "fe Make fixed effects")			// Adding two lines to bottom of table
			keep(foreign _cons) 												// Don't display fixed effect coefs
			label se nomtitles replace nonotes compress									// Layout options
			postfoot("\hline\hline \multicolumn{5}{@{}p{\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")    // Input LaTeX code for closing table
			
	;
	
	reg d_women_car d_pos_premium ///
			if phase < 3 & d_anyphase2 == 1 & d_nomapping == 0 ///
			[pw = weight], ///
			cluster(user_id)
	
	eststo nocontrols
	
	reg d_women_car d_pos_premium ///
			$situationflex $demographics ///
			if phase < 3 & d_anyphase2 == 1 & d_nomapping == 0 ///
			[pw = weight], ///
			cluster(user_id)
			
	eststo controls
	
	esttab nocontrols controls using "C:\Users\WB501238/Downloads/table3.tex", replace
	
	reg d_women_car d_pos_premium ///
			if phase < 3 & d_anyphase2 == 1 & d_nomapping == 0 ///
			[pw = weight], ///
			cluster(user_id)
	
	eststo nocontrols
	
	reg d_women_car d_pos_premium ///
			$situationflex $demographics ///
			if phase < 3 & d_anyphase2 == 1 & d_nomapping == 0 ///
			[pw = weight], ///
			cluster(user_id)
			
	eststo controls
	
	reg d_women_car d_pos_premium ///
			$situationflex $demographics ///
			i.CI_line ///
			if phase < 3 & d_anyphase2 == 1 & d_nomapping == 0 ///
			[pw = weight], ///
			cluster(user_id)
	eststo fixedeffects
	
	
		
	esttab nocontrols controls fixedeffects using "C:\Users\WB501238/Downloads/table4.tex", replace
	
	esttab nocontrols controls fixedeffects ///
		using "C:\Users\WB501238/Downloads/table5.tex", ///
		keep(d_pos_premium $demographics _cons) ///
		replace
	
	reg d_women_car d_pos_premium ///
			if phase < 3 & d_anyphase2 == 1 & d_nomapping == 0 ///
			[pw = weight], ///
			cluster(user_id)
	
	eststo nocontrols
	
	estadd local quartiles 	"No"
	estadd local fe 		"No"
		
	reg d_women_car d_pos_premium ///
			$riskshort $situationflex $demographics ///
			if phase < 3 & d_anyphase2 == 1 & d_nomapping == 0 ///
			[pw = weight], ///
			cluster(user_id)
			
	eststo controls
	
	estadd local quartiles 	"Yes"
	estadd local fe 		"No"

	
	reg d_women_car d_pos_premium ///
			$riskshort $situationflex $demographics ///
			i.CI_line ///
			if phase < 3 & d_anyphase2 == 1 & d_nomapping == 0 ///
			[pw = weight], ///
			cluster(user_id)
			
	eststo fixedeffects
	
	estadd local quartiles 	"Yes"
	estadd local fe 		"Yes"
	
	esttab nocontrols controls fixedeffects ///
		using "C:\Users\WB501238/Downloads/table6.tex", ///
		scalars("quartiles Quartile controls" "fe Group fixed effects") ///
		keep(d_pos_premium $demographics _cons) ///
		replace
		
	esttab nocontrols controls fixedeffects ///
		using "C:\Users\WB501238/Downloads/table7.tex", ///
		scalars("quartiles Quartile controls" "fe Group fixed effects") ///
		keep(d_pos_premium $demographics _cons) ///
		label se nomtitles ///
		replace
		

	esttab nocontrols controls fixedeffects ///
		using "${output}/tbl_fittednote.tex", ///
		scalars("quartiles Quartile controls" "fe Group fixed effects") ///
		keep(d_pos_premium $demographics _cons) ///
		label se nomtitles replace nonotes ///
		postfoot("\hline\hline \multicolumn{4}{@{}p{\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")
		
	esttab nocontrols controls fixedeffects nocontrols controls fixedeffects ///
		using "C:\Users\WB501238/Downloads/table11.tex", ///
		scalars("quartiles Quartile controls" "fe Group fixed effects") ///
		keep(d_pos_premium $demographics _cons) ///
		label se nomtitles replace nonotes ///
		postfoot("\hline\hline \multicolumn{7}{@{}p{\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")
	
	esttab nocontrols controls fixedeffects nocontrols controls fixedeffects ///
		using "C:\Users\WB501238/Downloads/table12.tex", ///
		scalars("quartiles Quartile controls" "fe Group fixed effects") ///
		keep(d_pos_premium $demographics _cons) ///
		label se nomtitles replace nonotes ///
		postfoot("\hline\hline \multicolumn{7}{@{}p{1.45\textwidth}}{\footnotesize \lipsum[1] }\\ \end{tabular}}")
	
	esttab nocontrols controls fixedeffects ///
		using "C:\Users\WB501238/Downloads/table10.tex", ///
		scalars("quartiles Quartile controls" "fe Group fixed effects") ///
		keep(d_pos_premium $demographics _cons) ///
		label se nomtitles replace nonotes ///
		postfoot("\hline\hline \end{tabular}} \begin{tablenotes} \footnotesize \item \lipsum[1] \end{tablenotes}")
		
	esttab nocontrols controls fixedeffects nocontrols controls fixedeffects ///
		using "C:\Users\WB501238/Downloads/table13.tex", ///
		scalars("quartiles Quartile controls" "fe Group fixed effects") ///
		keep(d_pos_premium $demographics _cons) ///
		label se nomtitles replace nonotes ///
		postfoot("\hline\hline \end{tabular}} \begin{tablenotes} \footnotesize \item \lipsum[1] \end{tablenotes}")

		
	esttab nocontrols controls fixedeffects ///
		using "C:\Users\WB501238/Downloads/table8.tex", ///
		scalars("quartiles Quartile controls" "fe Group fixed effects") ///
		keep(d_pos_premium $demographics _cons) ///
		label se nomtitles replace nonotes ///
		addnotes("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed neque nec lorem tempus commodo id ullamcorper ligula. Curabitur hendrerit facilisis varius. Proin congue scelerisque finibus. Sed dictum molestie mattis. Donec iaculis ex blandit dignissim cursus. Nulla placerat dictum nibh, sit amet rhoncus elit. Morbi maximus posuere nisi eu gravida. Nunc non ex ipsum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Morbi orci diam, cursus id nulla id, fringilla gravida tortor. Nunc tortor diam, dignissim vitae eros eleifend, congue egestas diam. Etiam in odio suscipit, finibus purus sit amet, lacinia orci. Curabitur convallis iaculis enim. Phasellus facilisis diam eget lacinia interdum. Quisque imperdiet nisl eu velit consectetur porttitor.")

	
	esttab nocontrols controls fixedeffects ///
		using "C:\Users\WB501238/Downloads/table8.tex", ///
		scalars("quartiles Quartile controls" "fe Group fixed effects") ///
		keep(d_pos_premium $demographics _cons) ///
		prehead("\begin{tabular}{l*{3}{c}} \hline\hline & \multicolumn{3}{c}{Chose women's car} \\" ) ///
		postfoot("") ///
		star(* .1 ** .05 *** .01) ///
		label se nomtitles ///
		replace
			
	