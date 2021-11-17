<!-- vim: set fdm=marker tw=80: -->

# Intro

A script that generates and executes gnuplot commands for plotting audio
spectrum.

The main motivation was to get something better looking than Audacity spectrum.
Fortunately Audacity provides the option to export spectrum data and that's what
the script is plotting.

The simplest invocation is:

%autogen-spectrum

![the simples invocation](examples/spectrum.png)

This produces "spectrum.png" file with a plot of data from "spectrum.txt" file.
The plot axes are labelled "Hz" and "dBFS" (the defaults) and the plot line is
labelled "foo".

The data exported by Audacity is in the following format:

    frequency_1 magnitude_in_db_1
    frequency_2 magnitude_in_db_2
    ...

The script can accept files with more sets of data:

    frequency_1 magnitude_A_in_db_1 magnitude_B_in_db_1 ...
    frequency_2 magnitude_A_in_db_2 magnitude_B_in_db_1 ...
    ...

The "2 foo" part of the invocation above simply says to use the second column and
label it "foo".

# Command line options

Here's the full help:

%usage

## Defaults

* output: same as input with the extension replaced by "png"
* size: 1200x600 px
* x axis label: Hz
* y axis label: dBFS
* x axis range: 10 to 30k
* y axis range: -120 to 0

When `--linear` switch is used and `--xrange` is not specified then x axis range
changes to 0 to 23k.

# Examples

## Linear frequency scale

%autogen-linear

![example linear](examples/spectrum.linear.png)

## Axes range

%autogen-hires

![example hires](examples/spectrum.hires.png)

## Compact mode

A title and labels are normally positioned outside the graph area:

%autogen-compact-off

![example compact off](examples/compact_off.png)

With compact mode they are moved into the graph area. With the same image size
the graph area gets bigger:

%autogen-compact-on

![example compact on](examples/compact_on.png)

## Conversion to dBFS

If the FFT data is in absolute values:

%autogen-absolute

![example absolute values](examples/absolute.png)

it can be converted for display to dBFS with `--to-db` switch:

%autogen-to-db

![example to db](examples/absolute_to_db.png)

If required, the reference level (1 by default) can be changed too:

%autogen-db-ref

![example db ref](examples/absolute_db_ref.png)

## Multiple signals

%autogen-signals

![example multiple signals](examples/signals.png)

# Just gnuplot commands

It is possible to output just gnuplot commands, without calling gnuplot itself.
This allows to apply some custom modifications if necessary:

%gnuplot-commands

# Special characters in the title and labels

Quoting is used to remove the special meaning of certain characters. See bash
manual, [QUOTING](https://man7.org/linux/man-pages/man1/bash.1.html#QUOTING)
section.

The texts in the generated gnuplot commands are double-quoted. In order to
display characters like `"`, `\` and `` ` ``, that characters need to be quoted
with `\`:

    set title "foo \" bar"
    set xlabel "foo \\ bar"
    set ylable "foo \` bar"

Because the shell that is used to call `plot_spectrum` (e.g. `bash`) does its
own quote removal, this has to be accounted for:

    ]$ plot_spectrum ... --title 'foo \" bar'
    ]$ plot_spectrum ... --title "foo \\\" bar"

## Quotes

`"` characters inside `'` still need to be quoted with `\` in order for gnuplot
to "see" them:

%autogen-quotes1

![example quotes1](examples/quotes1.png)

The drawback of enclosing with `'` is that then this character cannot
be used in the text. The only option is enclosing with `"`:

%autogen-quotes2

![example quotes2](examples/quotes2.png)

## Command substitution

gnuplot is using `` ` `` for command substitution:

%autogen-substitution

![example command substitution](examples/command_substitution.png)

## Enhanced text

gnuplot's [enhanced
text](http://www.bersch.net/gnuplot-doc/enhanced-text-mode.html) is left
enabled. The characters with special meaning are: `~`, `@`, `^`, `&`, `_`, `{`
and `}`.  In order to remove the special meaning from those characters, they
need to be quoted with double `\`, for example:

    set title "foo\\@bar"

The usual quote removal, done by gnuplot for all texts, transforms `\\` to `\`
and then the enhanced text processor sees `\@` and removes the special meaning
from `@`.

%autogen-enhanced

![example enhanced text](examples/enhanced_text.png)

### Backslash

The consequence of the way gnuplot is processing enhanced text (or maybe it's a
[bug](https://sourceforge.net/p/gnuplot/bugs/1799/)) is that to display `\`
in a plain text, it needs to be quoted with `\`, so two `\` in total:

%autogen-backslash1

![example backslash1](examples/backslash1.png)

but to display it in the enhanced text, four `\` have to be used in total:

%autogen-backslash2

![example backslash2](examples/backslash2.png)

