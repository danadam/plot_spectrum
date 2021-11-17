#!/usr/bin/env bash
set -euo pipefail

echo "plotting..."

#%autogen-spectrum
plot_spectrum -i spectrum.txt 2 foo

#%autogen-linear
plot_spectrum -i spectrum.txt --size small \
-o spectrum.linear.png --linear 2 foo

## Axes range

#%autogen-hires
plot_spectrum -i spectrum.hires.txt --size small \
--linear --xrange "[10:50000]" 2 foo

## Compact mode

#%autogen-compact-off
plot_spectrum -i two_tones.txt --size small \
-o compact_off.png --title foobar 2 foo

#%autogen-compact-on
plot_spectrum -i two_tones.txt --size small \
-o compact_on.png --compact --title foobar 2 foo

## Conversion to dB

#%autogen-absolute
plot_spectrum -i absolute.txt --size small \
--yrange "[0:1]" --ylabel "Level" 2 foo

#%autogen-to-db
plot_spectrum -i absolute.txt --size small \
-o absolute_to_db.png --to-db 2 foo

#%autogen-db-ref
plot_spectrum -i absolute.txt --size small \
-o absolute_db_ref.png --to-db --db-ref 0.1 -yl dBSomething --yrange '[-100:20]' 2 foo

## Multiple signals

#%autogen-signals
plot_spectrum -i signals.txt --size small \
--title '4096 FFT, Hann window' \
2 signalA \
3 signalB \
4 signalC \
5 signalD \
6 signalE

## Special characters in title and labels

#%autogen-quotes1
plot_spectrum -i two_tones.txt --size small \
-o quotes1.png --title '\"foo\" / bar\nbaz' 2 foo

#%autogen-quotes2
plot_spectrum -i two_tones.txt --size small \
-o quotes2.png --title "\\\"foo\\\" / 'bar'\nbaz" 2 foo

#%autogen-substitution
plot_spectrum -i two_tones.txt --size small \
-o command_substitution.png --title '\`date +%T\` → `date +%T`' 2 foo

#%autogen-enhanced
plot_spectrum -i dither.txt --size small \
-o enhanced_text.png \
2 'x\\^2 → x^2' \
3 'x\\_0 → x_0' \
4 'x\\@\\^2\\_0 → x@^2_0' \
5 'X\\&\\{aaa\\}X → X&{aaa}X' \
6 '\\~a/ → ~a/' \
7 '\\{/Times bar\\} → {/Times bar}'

#%autogen-backslash1
plot_spectrum -i two_tones.txt --size small \
-o backslash1.png \
--title 'A backslash \\ without enhanced text' 2 foo

#%autogen-backslash2
plot_spectrum -i two_tones.txt --size small \
-o backslash2.png \
--title 'A backslash \\\\ with enhanced text (x^2)' 2 foo

echo "pngquant..."
for N in *.png; do
    pngquant -s 1 32 "${N}" -o tmp.png
    mv tmp.png "${N}"
done
