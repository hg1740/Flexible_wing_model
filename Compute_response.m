% Import Param template
Param = Sample_setting;

%% assign variables
ro = Param.Air.density;
g = 9.81;

Cm = Param.Wing.CM;             
a = Param.Wing.Lift_slope;
alpha0 = Param.Wing.Set_angle;
c0 = Param.Wing.Root_chord;
Ln = Param.Wing.Inner_span;
k = Param.Wing.Taper_rate;
Rho = Param.Wing.density;
lambda = Param.Wing.Swept_angle;
EI = Param.Wing.Bending_stiffness;
GJ = Param.Wing.Torsional_stiffness;
Mt = Param.Wing.M_dtheta;

Ihh = Param.FWT.Moment_inertia;
Lmda = Param.FWT.Flare_angle;
Sfwt = Param.FWT.Area;
kL = Param.FWT.Hinge_stiffness_left;
laf = Param.FWT.cg_arm;
m_fwt = Param.FWT.Wingtip_mass;
mf = Param.FWT.Wingtip_mass;

%% Trim model
acc_trim = subs(ddQ, [Q,dQ], yq);

Numofstate = length(Q);

% x(1): qb1
% x(2): qb2
% x(3): qb3
% x(4): qt1
% x(5): qt2
% x(6): thetaf

exp_strx = ['[Xq[kk] $ kk = 1..',num2str(Numofstate),']'];
xq       = evalin(symengine,exp_strx);

trim_acc_sim = subs(acc_trim, yq, [xq(1:Numofstate), zeros(1,Numofstate)]);


matlabFunction(trim_acc_sim,...
                    'file',     'Flexible_wing_trim_example',...
                    'vars',   [{'t','Xq'},...
                    'Cm', 'EI', 'GJ', 'Ihh', 'Lmda', 'Ln', 'Rho', 'Sfwt', 'U', 'a', 'alpha0', 'c0', 'g', 'k', 'kL', 'laf', 'lambda', 'm_fwt', 'mf', 'ro'],...
                    'outputs', {'dotY'});


% 1: qb1 2: qb2 3: qb3 4: qt1 5: qt2 6: thetaf 

U = 230;                % wind speed
alpha0 = deg2rad(2);    % wing initial setting angle

Fx = @(x) Flexible_wing_trim_example(0,x(1:Numofstate),Cm,EI,GJ,Ihh,Lmda,Ln,Rho,Sfwt,U,a,alpha0,c0,g,k,kL,laf,lambda,m_fwt,mf,ro);

options = optimoptions('fsolve','Display','iter','TolFun',1e-30,'TolX',1e-30, 'MaxFunctionEvaluations',1e6, 'MaxIterations', 1e6);

x0 = zeros(1, Numofstate);
x = fsolve(Fx,x0, options);

%% Compute response 

T1 = 0 :0.001: 5;
ode_options = odeset('RelTol' , 1e-4 ,'AbsTol' , 1e-6) ; % ODE options

X0 = zeros(12,1);

% Subsitute trimed status
X0(1:Numofstate) = x;

[t1, YY] = ode45(@Flexible_wing_model_example, T1, X0, ode_options, Cm,EI,GJ,Ihh,Lmda,Ln,Mt,Rho,Sfwt,a,alpha0,c0,g,k,kL,laf,lambda,m_fwt,mf,ro,U);

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

