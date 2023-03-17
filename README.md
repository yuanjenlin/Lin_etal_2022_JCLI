# Lin_etal_2023_JCLI
This repository includes the code to setup the Labrador Sea warming simulations and the code to reproduce the results in ***Lin, Yuan-Jen, Brian EJ Rose, and Yen-Ting Hwang. "Mean state AMOC affects AMOC weakening through subsurface warming in the Labrador Sea." Journal of Climate (2023): 1-44.***
## Labrador Sea warming simulations
The simulations are conducted in the National Center for Atmospheric Research Community Earth System Model version 1.2.1 (CESM1.2.1) in which only the ocean component — Parallel Ocean Program version 2 (POP2) is active. 
There are three main steps to run the simulations.

**(1) Control Simulation**

First, run a 300-year "C compset" as the control simulation. Like this: 
```
create_newcase -mach snow -res f19_g16_rx1 -compset C -case C_128cores
```
The simulations in this repository were run in the SNOW cluster at University at Albany, SUNY. Change the machine name `-mach snow` if needed.

**(2) Generate Forcing Files**

See `generate_pt_forcing.ipynb` for generating the potential temperature forcing file. See `generate_tau.ipynb` for generating the timescale used for resotring the potential temperature.

**(3) Six Experimental Simulations. Each Has five Ensembles.**

See `batch_submit_experiments.sh` for submitting 6x5 simulations at once, with each using different potential temperature forcing file or being branched from different year of the control simulation.

## CMIP6 analysis

**(1) AMOC strength evaluation**

See `AMOC_strength.ipynb` for evaluating the AMOC strength in CMIP6 models.

**Yuan-Jen Lin**
[yuanjenlin@gmail.com](mailto:yuanjenlin@gmail.com)
