#!/bin/bash
#SBATCH --job-name=band-pris 	                     # Job name (sesuaikan sesuai kebutuhan)
#SBATCH --partition=short                    # Pilih partisi: short | medium-small | medium-large | long | very-long
#SBATCH --ntasks=64                            # Jumlah total proses MPI
#SBATCH --nodes=1                             # Maksimum jumlah node yang digunakan
#SBATCH --ntasks-per-node=64                   # Jumlah proses per node
#SBATCH --mem=128G                             # Memori per node
#SBATCH --time=01-00:00                        # Waktu maksimum eksekusi (hh:mm:ss)
#SBATCH --output=bands.log                # Log output dan error (berdasarkan Job ID)

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

# Menjalankan perhitungan SCF Quantum ESPRESSO
mpirun -np $SLURM_NTASKS pw.x < /mgpfs/home/yfadhilah/bulk/b1/bands/scf.in > /mgpfs/home/yfadhilah/bulk/b1/bands/scf.out
mpirun -np $SLURM_NTASKS pw.x < /mgpfs/home/yfadhilah/bulk/b1/bands/nscf.in > /mgpfs/home/yfadhilah/bulk/b1/bands/nscf.out
mpirun -np $SLURM_NTASKS bands.x < /mgpfs/home/yfadhilah/bulk/b1/bands/bands.in > /mgpfs/home/yfadhilah/bulk/b1/bands/bands.out
mpirun -np $SLURM_NTASKS pw.x < /mgpfs/home/yfadhilah/bulk/b1/bands/nscfd.in > /mgpfs/home/yfadhilah/bulk/b1/bands/nscfd.out
mpirun -np $SLURM_NTASKS dos.x < /mgpfs/home/yfadhilah/bulk/b1/bands/dos.in > /mgpfs/home/yfadhilah/bulk/b1/bands/dos.out

echo "Finish            = $(date)"

