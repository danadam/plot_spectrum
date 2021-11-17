#!/usr/bin/env bash
set -euo pipefail

readme_in="README.in.md"
code_in="examples/run.sh"
readme_out="README.md"

escape_bs()
{
    echo "${1}" | sed 's_\\_\\\\_g'
}
format()
{
    echo "${1}" | sed -e '1 s/^/]$ /' -e '/^$/ ! s/^/    /'
}

cp "${readme_in}" "${readme_out}"
while read -r marker; do
#for marker in $(grep "%autogen-" "${readme_in}"); do
    echo "Found marker |${marker}|"
    snippet="$(
        sed -ne \
            "/^#${marker}$/,/^$/ {
                /${marker}/ n
                p
            }" \
            "${code_in}"
    )"
    snippet="$(escape_bs "${snippet}")"
    snippet="$(format "${snippet}")"
    echo "Replacing with |${snippet}|"
    awk -v VAR="${snippet}" "/^${marker}$/"' { print VAR; next } { print $0 } ' "${readme_out}" | sponge "${readme_out}"
done < <(grep "%autogen-" "${readme_in}")

usage_output="$(echo plot_spectrum --help; plot_spectrum --help)"
usage_output="$(format "${usage_output}")"
awk -v VAR="${usage_output}" "/^%usage$/"' { print VAR; next } { print $0 } ' "${readme_out}" | sponge "${readme_out}"

gnuplot_commands="$(
echo "plot_spectrum -i spectrum.txt --gp-commands 2 foo > out.gp"
echo "]$ cat out.gp"
cd examples; plot_spectrum -i spectrum.txt -f --gp-commands 2 foo | head -n3
echo "..."
echo "]$ gnuplot out.gp"
)"
gnuplot_commands="$(format "${gnuplot_commands}")"
awk -v VAR="${gnuplot_commands}" "/^%gnuplot-commands$/"' { print VAR; next } { print $0 } ' "${readme_out}" | sponge "${readme_out}"
