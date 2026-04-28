// This 3D unstructured mesh made by adapting files provided by:
// https://github.com/tbellosta/CFD2020/tree/master/DIAMOND
// https://github.com/Tjcross31/OPTIMISATION-OF-BIPLANECONFIGURATIONS-FOR-SUPERSONICFLIGHT

SetFactory("OpenCASCADE");

// ================= PARAMETERS =================
R = 3;
c = 1;
tu = 0.05;
tl = 0.05;

H = 0.505;
maxthicc = 0.5*c;

meshFar = 0.10;
meshNear = 0.01;

// spanwise sizes
Lz_domain = 5.25;
Lz_wing   = 3; 

// ================= POINTS =================
// farfield
Point(1) = {0,0,0, meshFar};
Point(2) = { R,0,0, meshFar};
Point(3) = {0, R,0, meshFar};
Point(4) = {-R,0,0, meshFar};
Point(5) = {0,-R,0, meshFar};

// upper airfoil
Point(6) = {-c/2,  H/2, 0, meshNear};
Point(7) = {-c/2+maxthicc, H/2-tu, 0, meshNear};
Point(8) = { c/2,  H/2, 0, meshNear};

// lower airfoil
hl = H/2 - tl;
Point(9)  = {-c/2, -H/2, 0, meshNear};
Point(10) = {-c/2+maxthicc, -hl, 0, meshNear};
Point(11) = { c/2, -H/2, 0, meshNear};

// ================= LINES =================
// farfield
Circle(1) = {2,1,3};
Circle(2) = {3,1,4};
Circle(3) = {4,1,5};
Circle(4) = {5,1,2};

// upper
Line(5) = {6,7};
Line(6) = {7,8};
Line(7) = {8,6};

// lower
Line(8)  = {9,10};
Line(9)  = {10,11};
Line(10) = {11,9};

// ================= LOOPS =================
Line Loop(100) = {1,2,3,4};
Line Loop(200) = {5,6,7};
Line Loop(300) = {8,9,10};

// ================= SURFACES =================
Plane Surface(1000) = {100};   // farfield
Plane Surface(2000) = {200};   // upper wing
Plane Surface(3000) = {300};   // lower wing

// ================= EXTRUDE =================
// domain volume
dom[] = Extrude {0,0,Lz_domain} {
  Surface{1000};
};

// wing solids (start at z=0)
upWing[] = Extrude {0,0,Lz_wing} {
  Surface{2000};
};

loWing[] = Extrude {0,0,Lz_wing} {
  Surface{3000};
};

// ================= BOOLEAN DIFFERENCE =================
fluid[] = BooleanDifference {
  Volume{dom[1]}; Delete;
}{
  Volume{upWing[1], loWing[1]}; Delete;
};

// ================= MESH SIZE FIELD =================
Field[1] = Distance;
Field[1].SurfacesList = {2000,3000};
Field[1].NumPointsPerCurve = 100;

Field[2] = Threshold;
Field[2].InField = 1;
Field[2].SizeMin = 0.03;
Field[2].SizeMax = 0.4;
Field[2].DistMin = 0.1;
Field[2].DistMax = 1.0;

Background Field = 2;

// ================= PHYSICAL GROUPS =================
eps = 1e-6;

// wing surface
Physical Surface("wing") =
  Surface In BoundingBox{-1,-1,0-eps, 1,1,Lz_wing+eps};

// outer farfield
//Physical Surface("farfield") =
  //Surface In BoundingBox{-R-eps,-R-eps,0+eps, R+eps,R+eps,Lz_domain-eps};

// root wall (wing attached here)
Physical Surface("RootWall") =
  Surface In BoundingBox{-R-eps,-R-eps,-eps, R+eps,R+eps,eps};

// free tip side
Physical Surface("FreeEnd") =
  Surface In BoundingBox{-R-eps,-R-eps,Lz_domain-eps, R+eps,R+eps,Lz_domain+eps};

Physical Surface("inlet") = {3016, 3019};
Physical Surface("outlet") = {3014, 3015};

// volume
Physical Volume("internal") = {fluid[0]};

// ================= MESH SETTINGS =================
Mesh.Algorithm = 6;
Mesh.Algorithm3D = 10;

Mesh.CharacteristicLengthFromPoints = 1;
Mesh.CharacteristicLengthFromCurvature = 1;
Mesh.CharacteristicLengthExtendFromBoundary = 1;

Mesh.Optimize = 1;
Mesh.OptimizeNetgen = 1;
