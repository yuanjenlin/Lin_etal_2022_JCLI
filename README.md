# Lin_etal_2022_JCLI
This repository includes the code to setup the Labrador Sea warming simulations and the code to reproduce the results in ___"Lin et al (2022) Mean state AMOC affects AMOC weakening through subsurface warming in the Labrador Sea"___.
## Labrador Sea warming simulations
The simulations are conducted in the National Center for Atmospheric Research Community Earth System Model version 1.2.1 (CESM1.2.1) in which only the ocean component — Parallel Ocean Program version 2 (POP2) is active. 
There are three main steps to run the simulations.

1. Control Simulation \
First, run a 300-year "C compset" as the control simulation. Like this: 
```
create_newcase -mach snow -res f19_g16_rx1 -compset C -case C_128cores
```
The simulations in this repository were run in the SNOW cluster at University at Albany, SUNY. Change the machine name `-mach snow` and/or case name `-case C_128cores` if needed.
2. Generate Forcing Files \
See `generate_pt_forcing.ipynb` for generating the potential temperature forcing file. See `generate_tau.ipynb` for generating the timescale used for resotring the potential temperature.
3. 6 Experimental Simulations. Each Has 5 Ensembles. \
See `batch_submit_experiments.sh` for submitting 6x5 simulations at once, with each using different potential temperature forcing file or being branched from different year of the control simulation.

__Yuan-Jen Lin__ \
[yuanjenlin@gmail.com](mailto:yuanjenlin@gmail.com)