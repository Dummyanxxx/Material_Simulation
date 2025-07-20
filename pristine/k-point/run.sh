# Convergence test of k-points grid.
# Set a variable k-point from 1 to 6.
for k in 1 2 3 4 5 6; do
# Make input file for the SCF calculation.
# k-points grid is assigned by variable n.
cat > kpoint.$k.in << EOF
&CONTROL
calculation     = 'scf'
pseudo_dir      = '../../pseudo/'
outdir          = '../tmp/'
prefix          = 'kpoint'
/
&SYSTEM
ibrav           = 0
nat             = 48
ntyp            = 2
occupations 	= 'smearing'
smearing	= 'gauss'
degauss     	= 0.02
ecutwfc         = 60
/
&ELECTRONS
mixing_beta     = 0.4
conv_thr        = 1.0d-6
/
ATOMIC_SPECIES
Ti   47.86700  Ti.pbe-spn-kjpaw_psl.1.0.0.UPF
O    15.99940  O.pbe-n-kjpaw_psl.1.0.0.UPF

K_POINTS (automatic)
${k} ${k} ${k} 0 0 0

CELL_PARAMETERS {angstrom}
7.604  0.0  0.0
0.0  7.604  0.0
0.0  0.0  9.721

ATOMIC_POSITIONS (angstrom)
Ti      0.000000   0.000000   0.000000
Ti      0.000000   1.901054   2.430253
Ti      1.901054   1.901054   4.860505
Ti      1.901054   0.000000   7.290756
O       0.000000   0.000000   2.006419
O       0.000000   1.901054   4.436695
O       1.901054   1.901054   6.866921
O       1.901054   0.000000   9.297199
O       0.000000   1.901054   0.423811
O       0.000000   0.000000   7.714590
O       1.901054   0.000000   5.284315
O       1.901054   1.901054   2.854089
Ti      0.000000   3.802000   0.000000
Ti      0.000000   5.703054   2.430253
Ti      1.901054   5.703054   4.860505
Ti      1.901054   3.802000   7.290756
O       0.000000   3.802000   2.006419
O       0.000000   5.703054   4.436695
O       1.901054   5.703054   6.866921
O       1.901054   3.802000   9.297199
O       0.000000   5.703054   0.423811
O       0.000000   3.802000   7.714590
O       1.901054   3.802000   5.284315
O       1.901054   5.703054   2.854089
Ti      3.802000   0.000000   0.000000
Ti      3.802000   1.901054   2.430253
Ti      5.703054   1.901054   4.860505
Ti      5.703054   0.000000   7.290756
O       3.802000   0.000000   2.006419
O       3.802000   1.901054   4.436695
O       5.703054   1.901054   6.866921
O       5.703054   0.000000   9.297199
O       3.802000   1.901054   0.423811
O       3.802000   0.000000   7.714590
O       5.703054   0.000000   5.284315
O       5.703054   1.901054   2.854089
Ti      3.802000   3.802000   0.000000
Ti      3.802000   5.703054   2.430253
Ti      5.703054   5.703054   4.860505
Ti      5.703054   3.802000   7.290756
O       3.802000   3.802000   2.006419
O       3.802000   5.703054   4.436695
O       5.703054   5.703054   6.866921
O       5.703054   3.802000   9.297199
O       3.802000   5.703054   0.423811
O       3.802000   3.802000   7.714590
O       5.703054   3.802000   5.284315
O       5.703054   5.703054   2.854089

EOF
# Run SCF calculation Quantum ESPRESSO
mpirun -np 4 pw.x < /mgpfs/home/yfadhilah/bulk/b1/k-point/kpoint.$k.in > /mgpfs/home/yfadhilah/bulk/b1/k-point/kpoint.$k.out

# Write the number of k-points (= k*k*1) and
# the total energy in calc-kpoint.dat
awk '/!/ {printf"%d %s\n",'$k*$k*$k',$5}' kpoint.$k.out >> calc-kpoint.dat
# End of for loop.
done