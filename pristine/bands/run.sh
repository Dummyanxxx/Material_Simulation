# Run Quantum ESPRESSO
mpirun -np 4 pw.x < /mgpfs/home/yfadhilah/bulk/b1/bands/scf.in > /mgpfs/home/yfadhilah/bulk/b1/bands/scf.out
mpirun -np 4 pw.x < /mgpfs/home/yfadhilah/bulk/b1/bands/nscf.in > /mgpfs/home/yfadhilah/bulk/b1/bands/nscf.out
mpirun -np 4 bands.x < /mgpfs/home/yfadhilah/bulk/b1/bands/bands.in > /mgpfs/home/yfadhilah/bulk/b1/bands/bands.out
mpirun -np 4 pw.x < /mgpfs/home/yfadhilah/bulk/b1/bands/nscfd.in > /mgpfs/home/yfadhilah/bulk/b1/bands/nscfd.out
mpirun -np 4 dos.x < /mgpfs/home/yfadhilah/bulk/b1/bands/dos.in > /mgpfs/home/yfadhilah/bulk/b1/bands/dos.out


