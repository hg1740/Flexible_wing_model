%% Formulate EoM

% wing shapes
Numb=3;
Numt=2;
Shapes = tbx_wing.Define_Wing_Shapes(Numb, Numt);

% G 
[Gen_coord, dGen_coord, ddGen_coord] = tbx_wing.Set_qs(Numb, Numt);

% set disp
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
Numstrips = 20;

Q_wing = tbx_wing.Get_Qi_wing(Gen_coord, Disp_wing, dDisp_wing, Bend_wing_elastic, Twist_wing_elastic, dTwist_wing_elastic, Numstrips);

Q_FWT = tbx_wing.Get_Qi_fwt(Gen_coord, dGen_coord, Disp_wing, dDisp_wing, Bend_wing_elastic, Twist_wing_elastic);

Qi = Q_wing + Q_FWT;

% % Remove redundent general forces
% Qn = tbx.Rm_redundent(Gen_coord, Qi, setting);

% get mass matrix
[M, Q, dQ, qt] = tbx_wing.Get_Mass_Matrix(Gen_coord, dGen_coord, ddGen_coord, T);

% get stiffness matrix
[K, ~] = tbx_wing.Get_Stiffness_Matrix(Gen_coord, dGen_coord, ddGen_coord, E);

% formulate eom
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
                    'Cm', 'EI', 'GJ', 'Ihh', 'Lmda', 'Ln', 'Mt', 'Rho', 'Sfwt', 'a', 'alpha0', 'c0', 'g', 'k', 'kL', 'kR', 'laf', 'lambda', 'm_fwt', 'mf', 'ro', 'U'],...
                    'outputs', {'dotY'});


%% set model varibles
Param.Wing.CM = 0;
Param.Wing.Lift_slope = 5;
Param.Wing.Set_angle = deg2rad(5);
Param.Wing.Root_chord = 5;
Param.Wing.Inner_span = 20;
Param.Wing.Taper_rate = 0;
Param.Wing.Wing_arm = 0.1;
Param.Wing.Swept_angle = deg2rad(0);
Param.Wing.Bending_stiffness = 5e9;
Param.Wing.Torsional_stiffness = 5e8;
Param.Wing.density = 60;
Param.Wing.M_dtheta = -4;

Param.AC.AC_mass = 50000;
Param.AC.Ixx = 1267302;
Param.AC.Iyy = 2441460;
Param.AC.Tail_area= 40;
Param.AC.Tail_lift_slope = 4;
Param.AC.Tail_set_angle = 0;
Param.AC.Elevator_lift_slope= 2;
Param.AC.Tail_arm = 25;
Param.Air.density = 0.42;

Param.FWT.Moment_inertia = 100;
Param.FWT.Flare_angle = 17;
Param.FWT.Area = 20;
Param.FWT.Hinge_stiffness_left = 0;
Param.FWT.Hinge_stiffness_right = 0;
Param.FWT.cg_arm = 0.4;
Param.FWT.Wingtip_mass = 50;

%% Substutude in model parameters
Cm = Param.Wing.CM;
a = Param.Wing.Lift_slope;
alpha0 = Param.Wing.Set_angle;
c0 = Param.Wing.Root_chord;
Ln = Param.Wing.Inner_span;
k = Param.Wing.Taper_rate;
Rho = Param.Wing.density;
lambda = Param.Wing.Swept_angle;
ro = Param.Air.density;

EI = Param.Wing.Bending_stiffness;
GJ = Param.Wing.Torsional_stiffness;

Ihh = Param.FWT.Moment_inertia;
Lmda = Param.FWT.Flare_angle;
Sfwt = Param.FWT.Area;

g = 9.81;
kL = Param.FWT.Hinge_stiffness_left;
kR = Param.FWT.Hinge_stiffness_right;
laf = Param.FWT.cg_arm;
m_fwt = Param.FWT.Wingtip_mass;
mf = Param.FWT.Wingtip_mass;
Mt = Param.Wing.M_dtheta;

%% Trim 

acc_trim = subs(ddQ, [Q,dQ], yq);

% x(1): qb1
% x(2): qb2
% x(3): qb3
% x(4): qt1
% x(5): qt2
% x(6): thetaf

exp_strx = ['[Xq[kk] $ kk = 1..',num2str(length(Q)),']'];
xq       = evalin(symengine,exp_strx);

trim_acc_sim = subs(acc_trim, yq, [xq(1:length(Q)), zeros(1,length(Q))]);


matlabFunction(trim_acc_sim,...
                    'file',     'Flexible_wing_trim_example',...
                    'vars',   [{'t','Xq'},...
                    'Cm', 'EI', 'GJ', 'Ihh', 'Lmda', 'Ln', 'Rho', 'Sfwt', 'U', 'a', 'alpha0', 'c0', 'g', 'k', 'kL', 'kR', 'laf', 'lambda', 'm_fwt', 'mf', 'ro'],...
                    'outputs', {'dotY'});


% 1: qb1 2: qb2 3: qb3 4: qt1 5: qt2 6: thetaf 
U = 230;
alpha0 = deg2rad(2);
Fx = @(x) Flexible_wing_trim_example(0,x(1:length(Q)),Cm,EI,GJ,Ihh,Lmda,Ln,Rho,Sfwt,U,a,alpha0,c0,g,k,kL,kR,laf,lambda,m_fwt,mf,ro);

options = optimoptions('fsolve','Display','iter','TolFun',1e-30,'TolX',1e-30, 'MaxFunctionEvaluations',1e6, 'MaxIterations', 1e6);

x0 = zeros(1, length(Q));
x = fsolve(Fx,x0, options);


%% Check response 

T1 = 0 :0.001: 5;
ode_options = odeset('RelTol' , 1e-4 ,'AbsTol' , 1e-6) ; % ODE options

X0 = zeros(12,1);

X0(1:6) = x;

% set input varibles 
Cm = Param.Wing.CM;
a = Param.Wing.Lift_slope;
c0 = Param.Wing.Root_chord;
Ln = Param.Wing.Inner_span;
k = Param.Wing.Taper_rate;
Rho = Param.Wing.density;
lambda = Param.Wing.Swept_angle;
ro = Param.Air.density;

EI = Param.Wing.Bending_stiffness;
GJ = Param.Wing.Torsional_stiffness;

Ihh = Param.FWT.Moment_inertia;
Lmda = Param.FWT.Flare_angle;
Sfwt = Param.FWT.Area;

g = 9.81;
kL = Param.FWT.Hinge_stiffness_left;
kR = Param.FWT.Hinge_stiffness_right;
laf = Param.FWT.cg_arm;
m_fwt = Param.FWT.Wingtip_mass;
mf = Param.FWT.Wingtip_mass;
Mt = Param.Wing.M_dtheta;

% alpha0 = alpha0 + 0.1;

[t1, YY] = ode45(@Flexible_wing_model_example, T1, X0, ode_options, Cm,EI,GJ,Ihh,Lmda,Ln,Mt,Rho,Sfwt,a,alpha0,c0,g,k,kL,kR,laf,lambda,m_fwt,mf,ro,U);

% dotY = Flexible_wing_model_example(t,Yq,Cm,EI,GJ,Ihh,Lmda,Ln,Mt,Rho,Sfwt,a,alpha0,c0,g,k,kL,kR,laf,lambda,m_fwt,mf,ro,U)

figure
subplot(3,1,1)
plot(t1, YY(:,1))
xlabel('time')
ylabel('qbL1')

subplot(3,1,2)
plot(t1, YY(:,2))
xlabel('time')
ylabel('qbL2')

subplot(3,1,3)
plot(t1, YY(:,3))
xlabel('time')
ylabel('qbL3')


figure
subplot(2,1,1)
plot(t1, YY(:,4))
xlabel('time')
ylabel('qtL1')

subplot(2,1,2)
plot(t1, YY(:,5))
xlabel('time')
ylabel('qtL2')

figure 
plot(t1, YY(:,6)*57)
xlabel('time')
ylabel('Fold')







