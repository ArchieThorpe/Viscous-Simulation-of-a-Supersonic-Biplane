Pseudo-transient simulation at Mach 1.7 for a 3D biplane (chord = 1 metre, span = 3 metres) with zero stagger and zero angle of attack.

Due to their large file sizes, the .msh file and the constant/polyMesh directory are both missing. To run this case:
$ gmsh 3D_span3_tip2_25.geo -3 -format msh2 -o 3D_span3_tip2_25.msh
$ gmshToFoam 3D_span3_tip2_25.msh
$ nano constant/polyMesh/boundary
Edit the patches here so they read the following:

/*--------------------------------*- C++ -*----------------------------------*\
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     | Website:  https://openfoam.org
    \\  /    A nd           | Version:  11
     \\/     M anipulation  |
\*---------------------------------------------------------------------------*/
FoamFile
{
    format      ascii;
    class       polyBoundaryMesh;
    location    "constant/polyMesh";
    object      boundary;
}
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

5
(
    wing
    {
        type            patch;
        physicalType    patch;
        nFaces          281366;
        startFace       26483778;
    }
    outlet
    {
        type            patch;
        physicalType    patch;
        nFaces          11824;
        startFace       26765144;
    }
    inlet
    {
        type            patch;
        physicalType    patch;
        nFaces          11824;
        startFace       26776968;
    }
    RootWall
    {
        type            wall;
        physicalType    wall;
        nFaces          39362;
        startFace       26788792;
    }
    FreeEnd
    {
        type            patch;
        physicalType    patch;
        nFaces          6860;
        startFace       26828154;
    }
)

// ************************************************************************* //

$ checkMesh (optional)
$ foamRun -solver shockFluid

To run this case in parallel (128 cores given as an example, ensure this matches numberOfSubdomains in system/decomposeParDict):
$ decomposePar
$ mpirun -np 128 foamRun -solver shockFluid -parallel
$ reconstructPar

- If edits to the .geo are made, save the .geo and run the following commands:
$ gmsh stag0.geo -3 -format msh2 -o stag0.msh
$ gmshToFoam sta0.msh
$ nano constant/polyMesh/boundary
(edit the patches here - ensure that for a 2D simulation, front and back are set to empty)
$ checkMesh (optional)
$ foamRun -solver shockFluid