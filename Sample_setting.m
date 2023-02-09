function Param = Sample_setting

Param.Wing.CM = 0;                          % wing moment coefficient 
Param.Wing.Lift_slope = 5;                  % wing lift slope 
Param.Wing.Set_angle = deg2rad(5);          % wing initial setting angle
Param.Wing.Root_chord = 5;                  % wing root chord
Param.Wing.Inner_span = 20;                 % span of inner wing (root to hinge)
Param.Wing.Taper_rate = 0;                  % taper rate (k) of the wing chord along span is described as c(x) = c0 - kx
Param.Wing.Swept_angle = deg2rad(0);        % wing swept angle
Param.Wing.Bending_stiffness = 5e9;         % wing bending stiffness
Param.Wing.Torsional_stiffness = 5e8;       % wing torsional stiffness
Param.Wing.density = 60;                    % wing density 
Param.Wing.M_dtheta = -4;                   % M theta dot account for effect of unsteady flow 


Param.FWT.Moment_inertia = 100;             % FWT moment of inertia 
Param.FWT.Flare_angle = 17;                 % flare angle deg
Param.FWT.Area = 20;                        % wingtip area m^2
Param.FWT.Hinge_stiffness_left = 0;         % Hinge stiffness
Param.FWT.Hinge_stiffness_right = 0;
Param.FWT.cg_arm = 0.4;                     % grav. arm of the wingtip: penpendicular distance from c.g. of the wingtip to the hinge position
Param.FWT.Wingtip_mass = 50;                % Wingtip mass

Param.Air.density = 0.4;                    % Air density

end 