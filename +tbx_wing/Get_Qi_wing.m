function Q_wing = Get_Qi_wing(Gen_coord, Disp_wing, dDisp_wing, Bend_wing_elastic, Twist_wing_elastic, dTwist_wing_elastic, Numstrips)

syms x c0 ro k a Mt Cm alpha0 lambda Ln U real

% Chords along the wingspan 
cx = c0 - k*x;

% alpha introduced by bending
x1 = x + cx*sin(lambda);
d1 = subs(Bend_wing_elastic.L, x, x1);

alpha_bL = (d1 - Bend_wing_elastic.L)/cx;

% lift and moment on the wings per strip
disp_L = subs(dDisp_wing.L, [sym('h'),sym('dqtL1'),sym('dqtL2')], [0, 0, 0]);

dLL = 0.5*ro*U^2*cx*a*(alpha0 + (disp_L)/U + Twist_wing_elastic.L*cos(lambda) - alpha_bL);
dML= dLL*cx*0.15 + 0.5*ro*U^2*Cm*cx^2 + 0.5*ro*U^2*cx^2*(Mt)*cx*dTwist_wing_elastic.L/(4*U);

% position on the wings - linear assumption which considered only z - displacement 
r_wing_Lb = subs(Disp_wing.L, sym('h'), 0);
r_wing_Lt = Twist_wing_elastic.L;


% Convert to general force: lift on left wing
GC_name = fieldnames(Gen_coord);
N = numel(GC_name);

% compute strip width 
xval = linspace(0, Ln, Numstrips);
dx = xval(2) - xval(1);

Q_wingLx = sym(zeros(N,Numstrips));
Q_wingMLx = sym(zeros(N,Numstrips));


for j = 1 : Numstrips

    dLLx = subs(dLL, x, xval(j));
    r_wing_Lbx = subs(r_wing_Lb, x, xval(j));

    dMLx = subs(dML, x, xval(j));
    r_wing_Ltx = subs(r_wing_Lt, x, xval(j));

    for i = 1:N

        Q_wingLx(i,j) = simplify(-dLLx*dx * diff(r_wing_Lbx, Gen_coord.(GC_name{i}))); 
        Q_wingMLx(i,j) = simplify(dMLx*dx * diff(r_wing_Ltx, Gen_coord.(GC_name{i})));
     
    end

end

Q_wingL = sum(Q_wingLx,2);
Q_wingML = sum(Q_wingMLx,2);


% Sum up general forces 
Q_wing = Q_wingML + Q_wingL;


end