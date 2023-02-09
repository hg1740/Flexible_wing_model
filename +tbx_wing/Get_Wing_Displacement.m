function [Disp_wing_flexible, dDisp_wing_flexible] = Get_Wing_Displacement(Shapes, Gen_coord, dGen_coord)

syms c0 k x h real

% Elastic displacement 

% Gen_coords
G = fieldnames(Gen_coord);
inbL=contains(G, {'YbL'});
intL=contains(G, {'YtL'});

gc_bendL = G(inbL);
gc_torL = G(intL);

% dGen_coords
dG = fieldnames(dGen_coord);
dgc_bendL = dG(inbL);
dgc_torL = dG(intL);

% Shapes 
S = fieldnames(Shapes);
bs=contains(S, {'s'});
ts=contains(S, {'t'});

phi_b = S(bs);
phi_t = S(ts);

% Formulate displacement equations
bend_term_L = sym(zeros(numel(phi_b),1));
torsion_term_L = sym(zeros(numel(phi_t),1));

dbend_term_L = sym(zeros(numel(phi_b),1));
dtorsion_term_L = sym(zeros(numel(phi_t),1));


for i = 1:numel(gc_bendL)

    bend_term_L(i) = Shapes.(phi_b{i})*Gen_coord.(gc_bendL{i});
    dbend_term_L(i) = Shapes.(phi_b{i})*dGen_coord.(dgc_bendL{i});


end

for j = 1:numel(gc_torL)

    torsion_term_L(j) = Shapes.(phi_t{j})*Gen_coord.(gc_torL{j});
    dtorsion_term_L(j) = Shapes.(phi_t{j})*dGen_coord.(dgc_torL{j});


end

Zb_L = sum(bend_term_L);
Rt_L = sum(torsion_term_L);
Zt_L = Rt_L*(c0 - k*x)*h;

dZb_L = sum(dbend_term_L);
dRt_L = sum(dtorsion_term_L);
dZt_L = dRt_L*(c0 - k*x)*h;

%% Write output

% bending displacement 
Disp_wing_flexible.ZbL = Zb_L;

% twist
Disp_wing_flexible.RtL = Rt_L;

% vertical displacement caused by twisting  
Disp_wing_flexible.ZtL = Zt_L;

% total displacement 
Disp_wing_flexible.ZL = Zb_L - Zt_L;

% bending displacement rate
dDisp_wing_flexible.dZbL = dZb_L;

% twist rate
dDisp_wing_flexible.dRtL = dRt_L;

% vertical displacement rate caused by twisting  
dDisp_wing_flexible.dZtL = dZt_L;

% total displacement rate
dDisp_wing_flexible.ZL = dZb_L - dZt_L;


end 
