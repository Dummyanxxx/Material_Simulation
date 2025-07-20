# Run Quantum ESPRESSO
mpirun -np 4 pw.x < /mgpfs/home/yfadhilah/bulk/o1c/bands/scf.in > /mgpfs/home/yfadhilah/bulk/o1c/bands/scf.out
mpirun -np 4 pw.x < /mgpfs/home/yfadhilah/bulk/o1c/bands/nscf.in > /mgpfs/home/yfadhilah/bulk/o1c/bands/nscf.out
mpirun -np 4 bands.x < /mgpfs/home/yfadhilah/bulk/o1c/bands/bands.in > /mgpfs/home/yfadhilah/bulk/o1c/bands/bands.out
mpirun -np 4 pw.x < /mgpfs/home/yfadhilah/bulk/o1c/bands/nscfd.in > /mgpfs/home/yfadhilah/bulk/o1c/bands/nscfd.out
mpirun -np 4 dos.x < /mgpfs/home/yfadhilah/bulk/o1c/bands/dos.in > /mgpfs/home/yfadhilah/bulk/o1c/bands/dos.out
