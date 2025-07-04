#!/bin/bash
#SBATCH --job-name=ecut 	                 # Job name (sesuaikan sesuai kebutuhan)
#SBATCH --partition=short                    # Pilih partisi: short | medium-small | medium-large | long | very-long
#SBATCH --ntasks=64                          # Jumlah total proses MPI
#SBATCH --nodes=1                            # Maksimum jumlah node yang digunakan
#SBATCH --ntasks-per-node=64                 # Jumlah proses per node
#SBATCH --mem=64G                            # Memori per node
#SBATCH --time=01-00:00                      # Waktu maksimum eksekusi (hh:mm:ss)
#SBATCH --output=ecut.log                	 # Log output dan error (berdasarkan Job ID)

# Informasi dasar tentang job
echo "Date              = $(date)"
echo "Hostname          = $(hostname -s)"
echo "Working Directory = $(pwd)"
echo ""
echo "Number of Nodes Allocated      = $SLURM_JOB_NUM_NODES"
echo "Number of Tasks Allocated      = $SLURM_NTASKS"
echo "Number of Cores/Task Allocated = $SLURM_CPUS_PER_TASK"

# Load module MPI dan Quantum ESPRESSO
module load openmpi4/4.1.4
module load materials/qe/7.2-openmpi 

# Convergence test of cut-off energy.
# Set a variable ecut from 40 to 150 Ry.
for ecut in 40 50 60 70 80 90 100 \
  110 120 130 140 150 ; do
# Make input file for the SCF calculation.
# ecutwfc is assigned by variable ecut.
cat > ecut.$ecut.in << EOF
&CONTROL
calculation     = 'scf'
pseudo_dir   	= '../../pseudo/'
outdir          = '../tmp'
prefix          = 'ecut'
nstep 		= 500
/
&SYSTEM
ibrav           = 0
nat             = 48
ntyp            = 2
occupations 	= 'smearing'
smearing	= 'gauss'
degauss     	= 0.02
ecutwfc         = ${ecut}
/
&ELECTRONS
mixing_beta     = 0.4
conv_thr        = 1.0d-6
electron_maxstep = 500
/
ATOMIC_SPECIES
Ti   47.86700  Ti.pbe-spn-kjpaw_psl.1.0.0.UPF
O    15.99940  O.pbe-n-kjpaw_psl.1.0.0.UPF

K_POINTS (automatic)
3 3 3 0 0 0

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
# Menjalankan perhitungan SCF Quantum ESPRESSO
mpirun -np $SLURM_NTASKS pw.x < /mgpfs/home/yfadhilah/bulk/b1/ecut/ecut.$ecut.in > /mgpfs/home/yfadhilah/bulk/b1/ecut/ecut.$ecut.out

# Write cut-off and total energies in calc-ecut.dat.
awk '/!/ {printf"%d %s\n",'$ecut',$5}' ecut.$ecut.out >> calc-ecut.dat
# End of for loop
done

echo "Finish            = $(date)"
