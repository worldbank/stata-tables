# Stata Tables

Code and writing for blogpost about Stata tables

## Introduction

Making tables is one of the most common tasks for researchers, yet it is inevitably one of the most frustrating. It is conceptually simple: all you have to do is put numbers and stars in squares! But getting from result to table more often than not turns out to be a pain, and when you come back to it later – in revision, for example – it's altogether too easy to find you have coded yourself into a nasty corner.

Like most coding tasks, how to do it is going to depend on what you need to do. We at DIME Analytics have spent a lot of time thinking about it, and this has turned out to be really useful in planning and executing our workflows. In this post we are going to share our framework for thinking about the task of coding tables, two approaches to solving the problem, and Stata code for getting the job done.

## Two workflows for coding tables

There are lots of reasons to export tables somewhere other than the Stata results window, but they don't all justify the same approach. You might be exploring regression results with various specifications, and not want to read them one-by-one. You might be preparing a report or paper for submission or publication. Your journal might require tables inline in Word. (Really.) Depending on what you are doing _now_ and what you might need to do _in the future_, there are some key questions to think about before implementing any code. Ask yourself:

- Do I need this output to be immediately shareable without postprocessing?
- Do I need this output to be useful for publication, or just for reading/comparing results?
- Do I need to be able to adjust number formatting and rounding later?
- Will I need to adjust table layout and formatting later?
- What will be the required workflow when I re-produce this table?
- What if I alter models, parameters, or other core components?

Different use cases have different answers to these questions, but most will probably fall into one of two broad categories. In the first, you only care about making the information readable now, and you are going to want to adjust the structure of the table repeatedly. You may adjust the models and parameters, rename the rows and columns, delete or add lines; but you will probably not finalize the output for a while. In the second, you will want shareable output, ready for publication, that is not going to need adjustments later. Your models are already set, but you may continue receiving data, which means you will need to recreate lots of updated tables frequently and quickly.

For the first situation, we recommend an approach we call soft-coded tables. This means that the output of the code the information only. This takes a lot less time to set up, since you don't care about the formatting at all -- and formatting is usually the hardest part. Commands that handle soft-coded tables usually respond well to adding models or parameters, and output can be put in non-publishable forms like Excel so you don't have to worry about breaking page layouts to read new results, for example.

Once you are really ready to get publishing, we recommend an approach we call hard-coded tables. This means that the output of the code is the entire table in a publication-ready format: both the information and the formatting of the table are coded. This takes some time to set up, as you have to write all the formatting of the table into the Stata code. It is also less flexible to changes in models or parameters, since these will likely affect your formatting, and even adjusting things like the number of columns can require making precise changes to the code to get it to look just right. However, when your changes _don't_ imply formatting adjustments (such as during ongoing data collection), you'll be very happy that your slides or reports are instantly updated to your new results, especially when you have a lot of outputs.

||Soft-coded|Hard-coded|
|-|-|-|
|Amount of intial coding | Little | Moderate to lots |
|Replicability   | Results replicate but require copying or post-processing  | Fully replicable  |
|Adjustability to new models or parameters | Typically high | Moderate to low |
|Adjustability to frequent new data   | Slow   | Fast  |
|Formatting   | None, but some workflows may enable | Complete  |

The path you take in part depends on where your table is destined to be used. Obviously, if you are expected to compile a report or presentation in LaTeX, your tables should be fully formatted in TeX output. However,

\* Make sure you know whether stars are hardcoded or formatted, as this will affect your workflow. Hardcoded stars are good because they will paste with "values", but bad because they will not allow flexibility on the number of decimal places.

## Hard-coding tables from Stata in LaTeX

Two of the most commonly-used softwares for writing tables, `estout` and `outreg2`, are two of the top three most-downloaded softwares from SSC.

Exporting results to individual `.tex` files for each table and importing them into a master document is the easiest way to create outputs when you are still making changes to the results. The tables only need to be formatted once, and the individual files will be replaced with the latest version of your regressions and data every time you run Stata. The greatest advantage of all this is that you only need to recompile the master document once, without any copy-pasting or opening multiple files to see all the new results at once.

The `estout` package, by Ben Jann, has lots of options. You can get it to do basically anything you want! The default table is pretty simple, and the [documentation]( http://repec.sowi.unibe.ch/stata/estout/) is *huge*, but we've prepared a few go-to examples that solve the most common formatting needs for a LaTeX table. The `esttab` command also allows you to export nicely formatted tables to Word, Excel, csv and HTML, but the options vary from one format to the other.

If you're trying to create a _very_ specific table format, the easiest way to do it in a replicable manner is to write the complete LaTeX code for the table. This means saving any number that should be displayed as locals, and hardcoding the LaTeX code for the table. But instead of writing the number themselves, you just call the locals that were previously saved. `filewrite` allows you to write the LaTeX code in a do-file, then have Stata write the text file with the table, and save it as a `.tex` file. You can find an example of how to use it here.

The two commands above are our go-to solution to exporting tables to LaTeX. However, there are a few other options out there. [`outreg2`](http://repec.org/bocode/o/outreg2.html) also exports tables to `tex` formats, but we've found it harder to use and to find resources than `estout`. [`stata-tex`](https://github.com/paulnov/stata-tex) is another option for custom-tables, but takes some more setting up with Excel and Python. Finally, you can write a whole HTML, word or PDF document using different options for Stata markdown, entirely within Stata. Discussing these options would take yet another blog post, but you can check out the [dynamic documents](https://www.stata.com/new-in-stata/markdown/) and [texdoc](http://repec.sowi.unibe.ch/stata/texdoc/) documentation for more information.

## Soft-coding tables from Stata with Excel

Both `estout` and `outreg2` also write to Excel formats, as does `xml_tab` by Zurab Sajaia and Michael Lokshin. However, for many years it was not straightforward to print information into Excel, and each of these softwares dealt with interoperability issues in different ways. `outreg2`, for example, writes the literal contents of the cell, including the stars (such as "0.190\*\*\*" or "1.34e-07\*\*"), and by default applies significant figure standardization rather than decimal place standardization to ensure that there is meaningful content in every cell. `estout` operates similarly. `xml_tab` developed the innovation of using Excel formatting rules to print the full precise values into cells and implement rounding and stars natively, and was for many years a good go-to command for exporting regression results to Excel. However, out-of-date export engines conventions mean that these softwares are sometimes incompatible with modern filetypes (namely XLSX) and this can occasionally cause problems.

`outwrite`, a new command available on SSC, attempts to take the best functionality and defaults from the above commands. The purpose of `outwrite` is to provide full support for two modern Stata features: interactions/categorical expressions (`i.`, `c.`, and `#`) and modern XLSX file output. It is built on top of the regression processing engine from `xml_tab` but uses the new `putexcel` features for output. Unlike the other commands, `outwrite` is also written to have "minimal syntax" -- it is specifically designed to make soft-coded table and therefore has almost no extensive formatting available. In a Stata viewer window, the help file for `xml_tab` takes 727 lines. `outreg2` takes 1147 and `estout` takes 1647 lines. As of this writing, the helpfile for `outwrite` takes 67 lines. (This may not be enough – install the current version of the software and let us know!) `outwrite` will soon also support minimal output to TeX files simply by changing the file extension, but this is accidentally broken in the first SSC version (sorry!).

`outwrite` mimics `xml_tab` in many respects, including using Excel formatting rules to print the full precise values into cells and implement rounding and stars natively. Any workflow needs to account for this: you can adjust the global  a

#
