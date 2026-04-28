Pseudo-transient viscous simulation (wall functions used) at Mach 1.7 for a 2D biplane with zero stagger and zero angle of attack.

This case is setup and ready-to-run.

- To run this case in its current state: $ foamRun -solver shockFluid

To run this case in parallel (4 cores given as an example, ensure this matches numberOfSubdomains in system/decomposeParDict):
$ decomposePar
$ mpirun -np 4 foamRun -solver shockFluid -parallel
$ reconstructPar

- If edits to the .geo are made, save the .geo and run the following commands:
$ gmsh stag0.geo -3 -format msh2 -o stag0.msh
$ gmshToFoam sta0.msh
$ nano constant/polyMesh/boundary
(edit the patches here - ensure that for a 2D simulation, front and back are set to empty)
$ checkMesh (optional)
$ foamRun -solver shockFluid

- yPlus can be calculated using the following:
$ foamPostProcess -func yPlus -latestTime -solver shockFluid