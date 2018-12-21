# Stata Tables

Code and writing for blogpost about Stata tables

## Blogpost

### Introduction

In general:
- Is the output immediately useful?
- Is the output useful for publication?
- What is the required workflow when you re-run the table?
- How is formatting and rounding handled?
- How is row and column labeling handled?

In Excel:
- Are the stars hardcoded or formatted? (Both have implications for the result of a copy-paste operation.)
- Are the results at full precision in the output file? (If they are, then manual adjustments to rounding can be made later.)

Excel vs TeX:

|Category|Excel|TeX|
|-|-|-|
|Ease of use | Easy | Need to know TeX syntax to do anything |
|Replicability   | Requires copy-pasting   | Fully replicable  |
|Speed   | Instant  | Some setup time  |
|Formatting   | By hand, but can paste updated results if careful  | By code, so harder to set up but easy to recreate on future runs  |

### outreg2

### estout

_estout_, by Ben Jann, has lots of options. You can get it to do basically anything you want! However, it doesn't start out by doing very much.

### xml_tab

*xml_tab*, by Zurab Sajaia and Michael Lokshin, was for many years a good go-to command for exporting regression results to Excel. It has a syntax that could be reasonably minimized to a reasonable set of options to get what was basically a useable table. I

However, due to Office updates, it seems to sometimes create unreadable files for some versions of Microsoft Excel, which is kind of the point. It was a sufficient hack to rename the file to .xls to make the underlying XML readable before, but now this doesn't seem to work on every machine.

### outwrite

_outwrite_, a new command, is an attempt to take the best functionality and defaults from the above commands. The primary purpose was to produce a simple, modern regression table for any set of regressions with minimal syntax. Have a look at the length of the helpfiles to see what I mean. In my Stata viewer window, the help file for *xml_tab* takes 727 lines. _outreg2_ takes 1147 and _estout_ takes 1647 lines. That is a lot of reading to figure out how to put a regression into Excel.

As of this writing, the helpfile for _outwrite_ takes 67 lines.

The second purpose of building _outwrite_ was to provide something that is easy to use with full support for two modern Stata features: interactions & categorical expressions (the i., c., and # operators); and multi-format file output. It can output to four file types – xlsx, xls, csv, and tex. For xlsx, the command uses Stata's built-in _putexcel_ command to create a fully modern file; this is nice (but requires Stata 15).

For the other filetypes, the output is as basic as possible:

-   csv is entirely unformatted. This allows it to work with Git and GitHub so you can compare changes to results in version control.
-   tex is essentially unformatted. There is basic decoration but the table will render immediately in a document with \input{file.tex}.
-   xls is also unformatted. This isn't ideal; but if you don't have Stata 15 it will do. The trick here is to set up a "final" tables xlsx file with the formatting you want, and "Paste Special -> Values" to update the final file. (The stars are hardcoded here so you don't have to worry about that.)

#
It is built on top of the regression-processing engine from _xml_tab_, but unlike the other commands here, it has very few options.

The purpose
#
