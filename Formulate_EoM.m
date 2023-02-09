%% Setting 
Numb=3; % Number of shapes for wing bending (Max: 3)
Numt=2; % Number of shapes for wing torsion (Max: 3)

Numstrips = 20; % Number of strips used on the wing

%% Generate shapes
Shapes = tbx_wing.Define_Wing_Shapes(Numb, Numt);

%% Generate general coords 
[Gen_coord, dGen_coord, ddGen_coord] = tbx_wing.Set_qs(Numb, Numt);

%% set wing displacement
[Disp_wing_flexible, dDisp_wing_flexible] = tbx_wing.Get_Wing_Displacement(Shapes, Gen_coord, dGen_coord);

[Twist_wing_elastic, Bend_wing_elastic, Disp_wing, Disp_wing_elastic, dTwist_wing_elastic, dBend_wing_elastic, dDisp_wing, dDisp_wing_elastic] = tbx_wing.Displacement_collector(Disp_wing_flexible, dDisp_wing_flexible);

%% Determine kinetic energy 

% Inner wing
T_main_wing = tbx_wing.Get_Kinetic_Energy_Wing(dDisp_wing_elastic);  

% FWT
T_FWT = tbx_wing.Get_Kinetic_Energy_FWT(dGen_coord, dDisp_wing_elastic);

T = T_main_wing + T_FWT;

%% Determine potential energy 

% Inner wing
E_main_wing = tbx_wing.Get_Potential_Wing(Bend_wing_elastic, Twist_wing_elastic);

% FWT
E_FWT = tbx_wing.Get_Potential_FWT(Gen_coord, Bend_wing_elastic);

E = E_main_wing + E_FWT;

%% General force Q 

Q_wing = tbx_wing.Get_Qi_wing(Gen_coord, Disp_wing, dDisp_wing, Bend_wing_elastic, Twist_wing_elastic, dTwist_wing_elastic, Numstrips);

Q_FWT = tbx_wing.Get_Qi_fwt(Gen_coord, dGen_coord, Disp_wing, dDisp_wing, Bend_wing_elastic, Twist_wing_elastic);

Qi = Q_wing + Q_FWT;


%% Get mass matrix
[M, Q, dQ, qt] = tbx_wing.Get_Mass_Matrix(Gen_coord, dGen_coord, ddGen_coord, T);

%% Get stiffness matrix
[K, ~] = tbx_wing.Get_Stiffness_Matrix(Gen_coord, dGen_coord, ddGen_coord, E);

%% formulate EoM
Kq = subs(K, qt, Q);
ddQ =  M\(-Kq' + Qi);

% sub in place holders
names = fieldnames(Gen_coord);

Xs = sym('Xs',[1,length(Q)*2]);

exp_str = ['[Yq[kk] $ kk = 1..',num2str(2*length(Q)),']'];
yq       = evalin(symengine,exp_str);

for i = 1: length(yq)

assumeAlso(yq(i),'real');

end

% sub in state vector
acc = subs([yq(length(Q)+1:end)'; ddQ], [Q,dQ], yq);

matlabFunction(acc,...
                    'file',     'Flexible_wing_model_example',...
                    'vars',   [{'t','Yq'},...
                    'Cm', 'EI', 'GJ', 'Ihh', 'Lmda', 'Ln', 'Mt', 'Rho', 'Sfwt', 'a', 'alpha0', 'c0', 'g', 'k', 'kL', 'laf', 'lambda', 'm_fwt', 'mf', 'ro', 'U'],...
                    'outputs', {'dotY'});


