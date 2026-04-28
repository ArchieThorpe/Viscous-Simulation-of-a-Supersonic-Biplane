Accelerating simulation between Mach 1.3 and Mach 2.5 for a biplane with zero stagger and zero angle of attack.

This case is setup and ready-to-run.

- To run this case in its current state: $ foamRun -solver shockFluid

- If edits to the .geo are made, save the .geo and run the following commands:
$ gmsh stag0.geo -3 -format msh2 -o stag0.msh
$ gmshToFoam sta0.msh
$ nano constant/polyMesh/boundary
(edit the patches here - ensure that for a 2D simulation, front and back are set to empty)
$ checkMesh (optional)
$ foamRun -solver shockFluid