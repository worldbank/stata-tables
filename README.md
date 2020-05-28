# Commands to export tables

### outreg

### outreg2

### mktab

### outtex

### filewrite

### estout

_estout_, by Ben Jann, has lots of options. You can get it to do basically anything you want!

### stata-tex

### est2tex

### xml_tab

_xml_tab_, by Zurab Sajaia and Michael Lokshin, was for many years a good go-to command for exporting regression results to Excel. It has a syntax that could be reasonably minimized to a reasonable set of options to get what was basically a useable table.

However, _xml_tab_ has fallen a bit out of date. Due to Office updates, it seems to sometimes create unreadable files for some versions of Microsoft Excel, which is kind of the point. It was a sufficient hack to rename the file to .xls to make it readable before, but now this feels onerous.

### outwrite

_outwrite_, a command I have recently written, is my attempt to take the best of the above commands. It is built on top of the regression-processing engine from _xml_tab_, but unlike that and the other commands here, it has very few options.

The purpose of building _outwrite_ was to provide something that is easy to use with full support for two modern Stata features: interactions & categorical expressions (the i., c., and # operators); and multi-format file output. It can output to four file types – xlsx, xls, csv, and tex. For xlsx, the command uses Stata's built-in _putexcel_ command to create a fully modern file; this is nice (but requires Stata 15).

For the other filetypes, the output is as basic as possible:

-   csv is entirely unformatted. This allows it to work with Git and GitHub so you can compare changes to results in version control.
-   tex is essentially unformatted. There is only basic decoration but it will render immediately in another tex file with \input{file.tex}.
-   xls is also unformatted. This isn't ideal; but if you don't have Stata 15 it will do. The trick here is to set up a "final" tables xlsx file with the formatting you want, and "Paste Special -> Values" to update the final file. (The stars are hardcoded here so you don't have to worry about that.)

#
