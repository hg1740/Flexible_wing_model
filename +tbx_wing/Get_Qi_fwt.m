function Q_FWTL = Get_Qi_fwt(Gen_coord, dGen_coord, Disp_wing, dDisp_wing, Bend_wing_elastic, Twist_wing_elastic)

syms x ro c0 k a lambda Ln alpha0 la laf Lmda Sfwt U real

cx = c0 - k*x;

% alpha introduced by bending-twist coupling
x1 = x + cx*sin(lambda);
d1 = subs(Bend_wing_elastic.L, x, x1);

alpha_bL = subs((d1 - Bend_wing_elastic.L)/cx, x, Ln);

% lift on the FWTs
dz_hL = subs(dDisp_wing.L, [x,sym('h')], [Ln, 0]); % hinge heave speed.
z_hL = subs(Disp_wing.L, [x,sym('h')], [Ln, 0]);   % hinge position in height Z.

% angle of attack caused by wing twisting 
alpha_fwt_rootL = subs(Twist_wing_elastic.L*cos(lambda), x, Ln);

% effective angle of attack on FWT
alpha_fwtL = -sin(deg2rad(Lmda))*tan(Gen_coord.YfL1) - dGen_coord.dYfL1*laf/U + dz_hL/U + alpha_fwt_rootL - alpha_bL + alpha0;

L_fwtL = 0.5*ro*U^2*Sfwt*alpha_fwtL*a;

% position of FWT
xh = la - Ln*tan(lambda);
r_hingeL = [xh; Ln;  z_hL];

R = @(x)[1 0 0; 0 cos(x) -sin(x); 0 sin(x) cos(x)];
r_fwtL = r_hingeL + R(-Gen_coord.YfL1)*[0;laf;0];

% Convert to general force: lift on the left FWT
GC_name = fieldnames(Gen_coord);
N = numel(GC_name);

Q_FWTL = sym(zeros(N,1));

for i = 1 : N
    F_fwtL = R(-Gen_coord.YfL1)*[0,0,-L_fwtL]';
    Q_FWTL(i) = dot(F_fwtL,  diff(r_fwtL, Gen_coord.(GC_name{i})));
end

end