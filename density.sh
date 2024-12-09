#!/bin/bash

# Crear el archivo .ndx
echo -e "a NC3 PO4\n a GL1 GL2\n a C1A D2A C3A C4A C1B C2B C3B C4B\n q" | gmx make_ndx -f prod.tpr -o density_groups.ndx

# Generar los archivos de densidad
echo 5 | gmx density -s prod.tpr -f prod.xtc -n density_groups.ndx -o dens_headgroups.xvg -d Z
echo 7 | gmx density -s prod.tpr -f prod.xtc -n density_groups.ndx -o dens_chain.xvg -d Z
echo 6 | gmx density -s prod.tpr -f prod.xtc -n density_groups.ndx -o dens_glyc.xvg -d Z
echo 3 | gmx density -s prod.tpr -f prod.xtc -n density_groups.ndx -o dens_water.xvg -d Z

# Crear archivo de script para Gnuplot
cat << EOF > plot_script.gp
set terminal pngcairo size 800,600
set output 'output.png'
set xlabel 'Average coordinate (nm))'
set ylabel 'Density (kg/m^3)'
set title 'Density Analysis'
set key outside

set key at graph 0.95, 0.95 
set key box 
set key font ",12 bold" 
set key width 2 
set key spacing 1.5 

plot 'dens_headgroups.xvg' using 1:2 title 'Headgroups' with lines, \
     'dens_chain.xvg' using 1:2 title 'Chains' with lines, \
     'dens_glyc.xvg' using 1:2 title 'Lipids' with lines, \
     'dens_water.xvg' using 1:2 title 'Water' with lines
EOF


gnuplot plot_script.gp


rm plot_script.gp
