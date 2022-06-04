#!/bin/sh
set -x
# ------------------------------------------------------------------------ #
for zc_value in 0250 0500 0750 1000 1250 1500
do

for branch_year in 0271 0276 0281 0286 0291
do

cname=C_LBD_ZC${zc_value}_D0500_A01_GLOB10Y_LBD5D_Y${branch_year}

nyr=10
ryr=10
ntask=128
rpointer_origin_year=0301

forcing_path=/network/rit/lab/roselab_rit/ylin/input_made/
forcing_pt_file=TEMP_LBD_ZC${zc_value}_D0500_A01_C_128cores_Y${branch_year}.nc
forcing_tau_file=TAU_GLOB10Y_LBD5D.nc
# ------------------------------------------------------------------------ #

cd '/network/rit/home/yl528729/cesm1_2_1'
/network/rit/lab/roselab_rit/cesm/cesm1_2_1/scripts/create_newcase -mach snow -res f19_g16_rx1 -compset C -case ${cname}

cd '/network/rit/home/yl528729/cesm1_2_1/'${cname}
./xmlchange RUN_TYPE=branch
./xmlchange RUN_REFCASE=C_128cores
./xmlchange RUN_REFDATE=${branch_year}-01-01
./xmlchange DOUT_S=FALSE
./xmlchange STOP_OPTION=nyears
./xmlchange STOP_N=${nyr}
./xmlchange REST_N=${ryr}

./xmlchange NTASKS_ATM=${ntask}
./xmlchange NTASKS_LND=${ntask}
./xmlchange NTASKS_ICE=${ntask}
./xmlchange NTASKS_OCN=${ntask}
./xmlchange NTASKS_CPL=${ntask}
./xmlchange NTASKS_GLC=${ntask}
./xmlchange NTASKS_ROF=${ntask}
./xmlchange NTASKS_WAV=${ntask}
./xmlchange TOTALPES=${ntask}

./cesm_setup

cat << EOF >> user_nl_pop2
pt_interior_data_renorm&forcing_pt_interior_nml = 1.
pt_interior_data_type&forcing_pt_interior_nml = 'monthly-calendar'
pt_interior_file_fmt&forcing_pt_interior_nml = 'nc'
pt_interior_filename&forcing_pt_interior_nml = '${forcing_path}${forcing_pt_file}'
pt_interior_restore_file_fmt&forcing_pt_interior_nml = 'nc'
pt_interior_restore_filename&forcing_pt_interior_nml = '${forcing_path}${forcing_tau_file}'
pt_interior_variable_restore&forcing_pt_interior_nml = .true.
EOF

sed -i "s/--ntasks=128/--ntasks-per-node=32/g" ${cname}.run
sed -i "s/--mem=MaxMemPerNode/--mem-per-cpu=3584M/g" ${cname}.run
sed -i "s/mpirun/mpirun -mca btl ^openib -mca pml ucx/g" ${cname}.run

cp -p /data/rose_scr/yl528729/cesmruns/C_128cores/run/*.r*.${branch_year}* /data/rose_scr/yl528729/cesmruns/${cname}/run/
cp -p /data/rose_scr/yl528729/cesmruns/C_128cores/run/*rpointer* /data/rose_scr/yl528729/cesmruns/${cname}/run/

cd '/data/rose_scr/yl528729/cesmruns/'${cname}'/run/'
sed -i "s/${rpointer_origin_year}-01-01/${branch_year}-01-01/g" rpointer.atm
sed -i "s/${rpointer_origin_year}-01-01/${branch_year}-01-01/g" rpointer.drv
sed -i "s/${rpointer_origin_year}-01-01/${branch_year}-01-01/g" rpointer.ice
sed -i "s/${rpointer_origin_year}-01-01/${branch_year}-01-01/g" rpointer.ocn.ovf
sed -i "s/${rpointer_origin_year}-01-01/${branch_year}-01-01/g" rpointer.ocn.restart
sed -i "s/${rpointer_origin_year}-01-01/${branch_year}-01-01/g" rpointer.rof

cd '/network/rit/home/yl528729/cesm1_2_1/'${cname}
srun -p snow $(pwd)/${cname}.build

./${cname}.submit

done
done
