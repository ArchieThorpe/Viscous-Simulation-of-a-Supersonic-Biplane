// Archie Thorpe - gwmc82@durham.ac.uk - archiethorpe@aol.com
// This 2D hybrid structured/unstructured mesh made by adapting files provided by:
// https://github.com/tbellosta/CFD2020/tree/master/DIAMOND
// https://github.com/Tjcross31/OPTIMISATION-OF-BIPLANECONFIGURATIONS-FOR-SUPERSONICFLIGHT


R = 3;
c = 1;
tu = 0.05;
tl = 0.05;

meshfarfield = 4;

meshouteruf = 0.1;
meshouterur = 0.1;
meshinneru  = 0.1;

meshinnerl  = 0.1;
meshouterlf = 0.1;
meshouterlr = 0.1;

H = 0.505;
meshfactor = 0.025;
hl = H/2-tl;

stag = 0;
scale = 1;
maxthicc = 0.5*c;

delta = 0.010;     // BL thickness
cap   = 0.1;     // apex blunt size

// ======================================================
// POINTS
// ======================================================

Point(1)={0,0,0,meshfarfield};
Point(2)={R,0,0,meshfarfield};
Point(3)={0,R,0,meshfarfield};
Point(4)={-R,0,0,meshfarfield};
Point(5)={0,-R,0,meshfarfield};

// upper foil
Point(6)={-c/2,H/2,0,meshouteruf};
Point(7)={0,H/2-tu,0,meshinneru};
Point(8)={ c/2,H/2,0,meshouterur};

// lower foil
Point(9) ={ -c/2,-H/2,0,meshouterlf};
Point(10)={ 0,-hl,0,meshinnerl};
Point(11)={ c/2,-H/2,0,meshouterlr};

// ======================================================
// FARFIELD
// ======================================================

Circle(1)={2,1,3};
Circle(2)={3,1,4};
Circle(3)={4,1,5};
Circle(4)={5,1,2};

// ======================================================
// WALL LINES (ORIGINAL)
// ======================================================

Line(5)={6,7};
Line(6)={7,8};
Line(7)={8,6};

Line(8)={9,10};
Line(9)={10,11};
Line(10)={11,9};

// ======================================================
// RESOLUTION
// ======================================================

inner_r = 0.8;
innerres = Round((1631.2*(H^4))-(3482.9*(H^3))+(2823.2*(H^2))-(1092.7*H)+229.5);

resInner = 1*innerres;
resOuter = 2*innerres;

Transfinite Line{5,6,8,9}=resInner Using Bump inner_r;
Transfinite Line{7,10}=resOuter Using Bump inner_r;

// ======================================================
// NORMALS
// ======================================================

den = Sqrt(0.05^2+0.5^2);

nx67=-0.05/den; ny67=-0.5/den;
nx78= 0.05/den; ny78=-0.5/den;
nx86=0; ny86=1;

nx910=-0.05/den; ny910=0.5/den;
nx1011=0.05/den; ny1011=0.5/den;
nx119=0; ny119=-1;

// ======================================================
// OFFSET POINT
// ======================================================

//extension to better capture stagnation points
ext = 0.04;

Point(16)={-c/2+delta*nx67-ext, H/2+delta*ny67,0,meshinneru}; //upper leading edge bottom
Point(17)={0+delta*nx67, H/2-tu+delta*ny67,0,meshinneru};

Point(18)={0+delta*nx78, H/2-tu+delta*ny78,0,meshinneru};
Point(19)={c/2+delta*nx78+ext, H/2+delta*ny78,0,meshinneru}; //upper trailing edge bottom

Point(20)={c/2+ext, H/2+delta,0,meshinneru}; //upper trailing edge top
Point(21)={-c/2-ext, H/2+delta,0,meshinneru}; //upper leading edge top

Point(32)={-c/2+delta*nx910-ext,-H/2+delta*ny910,0,meshinnerl}; //lower leading edge top
Point(33)={0+delta*nx910,-hl+delta*ny910,0,meshinnerl};

Point(34)={0+delta*nx1011,-hl+delta*ny1011,0,meshinnerl};
Point(35)={c/2+delta*nx1011+ext,-H/2+delta*ny1011,0,meshinnerl}; //lower trailing edge top

Point(36)={c/2+ext,-H/2-delta,0,meshinnerl}; //lower trailing edge bottom
Point(37)={-c/2-ext,-H/2-delta,0,meshinnerl}; //lower leading edge bottom

// ======================================================
// OFFSET LOOPS
// ======================================================

Line(20)={16,17};
Line(21)={17,18};
Line(22)={18,19};
Line(23)={19,20};
Line(24)={20,21};
Line(25)={21,16};

Line(32)={32,33};
Line(33)={33,34};
Line(34)={34,35};
Line(35)={35,36};
Line(36)={36,37};
Line(37)={37,32};

// ======================================================
// BL CONNECTORS
// ======================================================

Line(26)={6,16};
Line(27)={7,17};
Line(28)={7,18};
Line(29)={8,19};
Line(30)={8,20};
Line(31)={6,21};

Line(38)={9,32};
Line(39)={10,33};
Line(40)={10,34};
Line(41)={11,35};
Line(42)={11,36};
Line(43)={9,37};

// ======================================================
// TRANSFINITE
// ======================================================

rBl = 1.3; //boundary layer growth ratio
tr = 30; // number of transfinite lines in boundary layer strip (ncells = tr-1)

Transfinite Line{20,22,32,34}=resInner Using Bump inner_r;
Transfinite Line{24,36}=resOuter Using Bump inner_r;

Transfinite Line{21,23,25,33,35,37}=2;

//apexes
Transfinite Line{27,28,39,40}=tr Using Progression rBl;

//LE and TE stag points
Transfinite Line{26,29,30,31,38,41,42,43}=tr Using Progression rBl;

// ======================================================
// LOOPS
// ======================================================

Line Loop(1)={1,2,3,4};
Line Loop(2)={20,21,22,23,24,25};
Line Loop(3)={32,33,34,35,36,37};

// ======================================================
// BL SURFACES (QUADS)
// ======================================================

Line Loop(30)={5,27,-20,-26}; Plane Surface(30)={30};
Line Loop(31)={6,29,-22,-28}; Plane Surface(31)={31};
Line Loop(32)={7,31,-24,-30}; Plane Surface(32)={32};

Line Loop(33)={8,39,-32,-38}; Plane Surface(33)={33};
Line Loop(34)={9,41,-34,-40}; Plane Surface(34)={34};
Line Loop(35)={10,43,-36,-42}; Plane Surface(35)={35};

// ======================================================
// SMALL CORNER TRIANGLES (STABLE)
// ======================================================

Line Loop(40)={27,21,-28}; Plane Surface(40)={40};
Line Loop(41)={29,23,-30}; Plane Surface(41)={41};
Line Loop(42)={31,25,-26}; Plane Surface(42)={42};

Line Loop(43)={39,33,-40}; Plane Surface(43)={43};
Line Loop(44)={41,35,-42}; Plane Surface(44)={44};
Line Loop(45)={43,37,-38}; Plane Surface(45)={45};

Transfinite Surface{30,31,32,33,34,35};
Recombine Surface{30,31,32,33,34,35};

// ======================================================
// MAIN SURFACE
// ======================================================

Plane Surface(1)={1,2,3};
//Plane Surface(1)={1,30,31,32,33,34,35,40,41,42,43,44,45};

// ======================================================
// EXTRUDE
// ======================================================

Extrude {0,0,1}{
  Surface{1,30,31,32,33,34,35,40,41,42,43,44,45};
  Layers{1};
  Recombine;
}

Physical Volume("internal") =
{
  1,2,3,4,5,6,7,8,9,10,11,12,13
};

Physical Surface("upperairfoil") = {158, 136, 180};
Physical Surface("lowerairfoil") = {246, 202, 224};

//Physical Surface("front") = {127};
//Physical Surface("back") = {1};

eps = 1e-9;

// All faces on z = 0 plane
Physical Surface("front") =
  Surface In BoundingBox{-1e9, -1e9, -eps,  1e9,  1e9,  eps};

// All faces on z = 1 plane
Physical Surface("back")  =
  Surface In BoundingBox{-1e9, -1e9, 1-eps, 1e9,  1e9,  1+eps};

Physical Surface("inlet") = {70, 74};
Physical Surface("outlet") = {66, 78};


Mesh.Algorithm=2;
Mesh.Algorithm3D=1;
Mesh.CharacteristicLengthFactor=meshfactor;