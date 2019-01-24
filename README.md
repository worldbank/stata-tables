# Stata Tables

Code and writing for blogpost about Stata tables

## Introduction

Making tables is one of the most common tasks for researchers, yet it is inevitably one of the most frustrating. It is conceptually simple: all you have to do is put numbers and stars in squares! But getting from result to table more often than not turns out to be a massive pain, and when you come back to it later – in revision, for example – it's altogether too easy to find you have coded yourself into a nasty corner.

We at DIME Analytics been making tables for almost a decade, and, well, there is no easy answer. Like most coding tasks, the answer is going to depend on what you need. But we've spent a lot of time thinking about it, and this has turned out to be really useful in planning and executing our workflows. In this post we are going to share (1) our framework for thinking about the task of coding tables; (2) two approaches to solving the problem; and (3) Stata software for getting the job done with outputs in both TeX and Excel.

## Coding for tables

There are lots of reasons you might want to export tables somewhere other than the Stata results window. You might be exploring regression results with various specifications, and not want to read them one-by-one. You might be preparing a report or paper for submission or publication. Depending on what you are doing _now_ and what you might need to do _in the future_, there are **[N]** main dimensions to think about before choosing a workflow. Before writing a single line of code, ask yourself:

- Do I need this output to be immediately shareable without postprocessing?
- Do I need this output to be useful for publication, or just for reading?
- Do I need to be able to adjust number formatting and rounding later?
- Do I need to be able to adjust table layout and formatting later?
- What will be the required workflow when I re-produce this table?
- What if I alter models or parameters?

## Two workflows for coding tables

Depending on your answers to the framework questions, you will probably fall into one of two categories. In the first, you will want shareable output, ready for publication, that is not going to need adjustments later. Your models are already set, but you may continue receiving data, which means you will need to recreate lots of updates tables frequently and quickly. In the second, you will want informative output, that you are going to want to play with the presentation of. You may adjust the models and parameters, rename the rows and columns, delete or add lines; but you will probably not "finalize" the output for a while nor need to update it ultra-frequently.

For the first situation, we recommend an approach we call "hard-coded" tables. This means that the output of the code is the entire table in a _publication-ready_ format (typically LaTeX). This takes more time to set up, as you have to write all the formatting of the table into the Stata code. It is also less flexible to changes in models or parameters, since these will likely affect your formatting. However, when your changes _don't_ imply formatting adjustments (such as during ongoing data collection), you'll be very happy that your slides or reports are instantly updated to your new results, especially when you have a lot of tables.

For the second situation, we recommend an approach we call "soft-coded" tables. This means that the output of the code is a spreadsheet with the _information_ only. This takes a lot less time to set up, since you don't care about the formatting. Commands that handle soft-coded tables usually respond well to adding models or parameters, and since the output tends to be Excel-formatted you don't have to worry about breaking page layouts, for example. On the other hand, if you _do_ have frequent updates or need to produce publication-quality outputs, you have to be very careful about the process by which you do this. (Personally, I maintain a "raw" output file for each table and a "final" combined and formatted Excel file into which re-runs can be copy-pasted, but this is not foolproof!)

||Soft-coded|Hard-coded|
|-|-|-|
|Amount of intial coding | Very little | Moderate to lots |
|Replicability   | Results are available but require copy-pasting or post-processing  | Fully replicable  |
|Adjustability to new models or parameters | Typically high | Typically low |
|Adjustability to frequent new data   | Slower   | Instant  |
|Formatting   | By hand, but can paste updated results (using Paste Special → Values) if careful*  | By code, so harder to set up but easy to recreate on future runs  |

\* Make sure you know whether stars are hardcoded or formatted, as this will affect your workflow. Hardcoded stars are good because they will paste with "values", but bad because they will not allow flexibility on the number of decimal places.


## The software!

### Exporting to LaTeX

Exporting results to individual `.tex` files for each table and importing them into a master document is the easiest way to create outputs when you are still making changes to the results. The tables only need to be formatted once, and the individual files will be replaced with the latest version of your regressions and data every time you run Stata. The greatest advantage of all this is that you only need to recompile the master document once, without any copy-pasting or opening multiple files to see all the new results at once.

#### outreg2

#### estout

`estout`, by Ben Jann, has lots of options. You can get it to do basically anything you want! The default table is pretty simple, and the [documentation]( http://repec.sowi.unibe.ch/stata/estout/) is *huge*, but we've prepared a few go-to examples that solve the most common formatting needs for a LaTeX table.

The `esttab` command also allows you to export nicely formatted tables to Word, Excel, csv and HTML, but the options vary from one format to the other.

#### filewrite

If you're trying to create a _very_ specific table format, the easiest way to do it in a replicable manner is to write the complete LaTeX code for the table. This means saving any number that should be displayed as locals, and hardcoding the LaTeX code for the table. But instead of writing the number themselves, you just call the locals that were previously saved.

`filewrite` allows you to write the LaTeX code in a do-file, then have Stata write the text file with the table, and save it as a `.tex` file. You can find an example of how to use it here.

### Exporting to excel

#### xml_tab

*xml_tab*, by Zurab Sajaia and Michael Lokshin, was for many years a good go-to command for exporting regression results to Excel. It has a syntax that could be reasonably minimized to a reasonable set of options to get what was basically a useable table. I

However, due to Office updates, it seems to sometimes create unreadable files for some versions of Microsoft Excel, which is kind of the point. It was a sufficient hack to rename the file to .xls to make the underlying XML readable before, but now this doesn't seem to work on every machine.

#### outwrite

`outwrite`, a new command available on SSC TODO, is an attempt to take the best functionality and defaults from the above commands for the purpose of creating soft-coded tables. The primary purpose is to produce a simple, modern regression table for any set of regressions with minimal syntax. The secondary purpose of `outwrite` is to provide full support for two modern Stata features: interactions/categorical expressions (`i.`, `c.`, and `#`) and modern file output. It is built on top of the regression processing engine from `xml_tab`.

By "minimal syntax", we mean this: in a Stata viewer window, the help file for `xml_tab` takes 727 lines. `outreg2` takes 1147 and `estout` takes 1647 lines. That is a lot of reading to figure out how to put a regression into Excel. As of this writing, the helpfile for `outwrite` takes 67 lines. (This may not be enough – install the current version of the software and let us know!)

`outwrite` can output to four file types – xlsx, xls, csv, and tex. For xlsx, the command uses Stata's built-in `putexcel` command to create a fully modern file; this requires Stata 15. For the other filetypes, the output is as basic as possible, with support in mind for specific use cases:

-   The csv file is entirely unformatted. This allows it to work with Git and GitHub so you can compare changes to results in version control.
-   The tex file has basic decoration, and the table will render immediately in a document by writing `\input{file.tex}`.
-   The xls file is also unformatted. This isn't ideal; but if you don't have Stata 15 it will do. The idea here is to set up a "final" tables.xlsx file with the formatting you want, and use "Paste Special → Values" to update the final file. (The stars are hardcoded here.)


#
