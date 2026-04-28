// Archie Thorpe - gwmc82@durham.ac.uk - archiethorpe@aol.com
// 2D structured mesh for a 10% thickness-chord diamond aerofoil

SetFactory("Built-in");

// ---------------- Parameters ----------------
chord = 1.0;
alpha = 11.4212 * Pi/180;
theta = alpha/2;
R     = 3.0;
h1    = 1e-4;

nSide = 80;
nBL   = 2;
nRad  = 70;
gRad  = 1.08;

xc = chord/2;
yc = 0;

// ---------------- Diamond -------------------
t2 = (chord/2)*Tan(theta);

p1 = newp; Point(p1) = {0,   0,   0};
p2 = newp; Point(p2) = {0.5, t2,  0};
p3 = newp; Point(p3) = {1,   0,   0};
p4 = newp; Point(p4) = {0.5,-t2,  0};

l1 = newl; Line(l1) = {p1,p2};
l2 = newl; Line(l2) = {p2,p3};
l3 = newl; Line(l3) = {p3,p4};
l4 = newl; Line(l4) = {p4,p1};

// -------- Offset diamond (exact BL control) --------
sBL = (t2 + h1)/t2;

q1 = newp; Point(q1) = {xc + sBL*(0-xc),   0, 0};
q2 = newp; Point(q2) = {0.5,  sBL*t2, 0};
q3 = newp; Point(q3) = {xc + sBL*(1-xc),   0, 0};
q4 = newp; Point(q4) = {0.5, -sBL*t2, 0};

k1 = newl; Line(k1) = {q1,q2};
k2 = newl; Line(k2) = {q2,q3};
k3 = newl; Line(k3) = {q3,q4};
k4 = newl; Line(k4) = {q4,q1};

r1 = newl; Line(r1) = {p1,q1};
r2 = newl; Line(r2) = {p2,q2};
r3 = newl; Line(r3) = {p3,q3};
r4 = newl; Line(r4) = {p4,q4};

// ---------------- Farfield points aligned radially ----------------
pc = newp; Point(pc) = {xc,yc,0};

f1 = newp; Point(f1) = {xc - R, yc, 0};
f2 = newp; Point(f2) = {xc, yc + R, 0};
f3 = newp; Point(f3) = {xc + R, yc, 0};
f4 = newp; Point(f4) = {xc, yc - R, 0};

c12 = newl; Circle(c12) = {f1,pc,f2};
c23 = newl; Circle(c23) = {f2,pc,f3};
c34 = newl; Circle(c34) = {f3,pc,f4};
c41 = newl; Circle(c41) = {f4,pc,f1};

R1 = newl; Line(R1) = {q1,f1};
R2 = newl; Line(R2) = {q2,f2};
R3 = newl; Line(R3) = {q3,f3};
R4 = newl; Line(R4) = {q4,f4};

// ---------------- Surfaces ------------------
// Boundary layer ring
Line Loop(11) = {l1, r2, -k1, -r1};
Plane Surface(21) = {11};

Line Loop(12) = {l2, r3, -k2, -r2};
Plane Surface(22) = {12};

Line Loop(13) = {l3, r4, -k3, -r3};
Plane Surface(23) = {13};

Line Loop(14) = {l4, r1, -k4, -r4};
Plane Surface(24) = {14};

// Outer blocks (now VALID)
Line Loop(15) = {k1, R2, -c12, -R1};
Plane Surface(25) = {15};

Line Loop(16) = {k2, R3, -c23, -R2};
Plane Surface(26) = {16};

Line Loop(17) = {k3, R4, -c34, -R3};
Plane Surface(27) = {17};

Line Loop(18) = {k4, R1, -c41, -R4};
Plane Surface(28) = {18};

// ---------------- Transfinite ----------------
Transfinite Line {l1,l2,l3,l4,k1,k2,k3,k4} = nSide+1;
Transfinite Line {r1,r2,r3,r4} = nBL;
Transfinite Line {R1,R2,R3,R4} = nRad+1 Using Progression gRad;
Transfinite Line {c12,c23,c34,c41} = nSide+1;

Transfinite Surface "*";
Recombine Surface "*";

// ---------------- Physicals -----------------
//Physical Curve("aerofoil") = {l1,l2,l3,l4};
//Physical Curve("farfield") = {c12,c23,c34,c41};
//Physical Surface("fluid") = {21,22,23,24,25,26,27,28};
//Physical Volume("internal") = {1};	//added


// ---------------- Extrusion to 3D ----------------
Extrude {0, 0, 1} {
  Surface{21,22,23,24,25,26,27,28};
  Layers{1};
  Recombine;
}

// ---------------- Physicals (3D) ----------------
Physical Volume("fluid") = {1,2,3,4,5,6,7,8,9,10,11,12,13};

Physical Surface("inlet") = {133, 199};
Physical Surface("outlet") = {155, 177};
//Physical Surface("aerofoil") = {50, 72, 94, 116};
Physical Surface("aerofoil") = {21, 22, 23, 24, 37, 41, 45, 49, 50, 59, 63, 67, 72, 81, 85, 89, 94, 103, 111, 116};

Physical Surface("front") = {138, 204, 182, 160};
Physical Surface("back") = {25, 26, 27, 28};

Mesh 3;
