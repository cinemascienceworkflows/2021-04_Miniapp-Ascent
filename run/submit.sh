#!/bin/bash

#BSUB -J <pantheon_workflow_jid> 
#BSUB -nnodes 2
#BSUB -P <compute_allocation> 
#BSUB -W 00:10

module load gcc/6.4.0

jsrun -n2 <pantheon_run_dir>/cloverleaf3d_par
