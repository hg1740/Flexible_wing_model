function [Twist_wing_elastic, Bend_wing_elastic, Disp_wing, Disp_wing_elastic, dTwist_wing_elastic, dBend_wing_elastic, dDisp_wing, dDisp_wing_elastic] = Displacement_collector(Disp_wing_flexible, dDisp_wing_flexible)

% tidyup and determine the overall main wing displacements 

    % wing twist 
    Twist_wing_elastic.L = Disp_wing_flexible.RtL;
   
    % wing bend
    Bend_wing_elastic.L = Disp_wing_flexible.ZbL;

    % wing total displacement
    Disp_wing.L = Disp_wing_flexible.ZL;

    % wing total elastic displacement 
    Disp_wing_elastic.L = Disp_wing_flexible.ZL;

    % wing twist rate
    dTwist_wing_elastic.L = dDisp_wing_flexible.dRtL;

    % wing bend rate
    dBend_wing_elastic.L = dDisp_wing_flexible.dZbL;

    % wing displacement rate
    dDisp_wing.L = dDisp_wing_flexible.ZL;

    % wing displacement rate due to elastic deform
    dDisp_wing_elastic.L = dDisp_wing_flexible.ZL;


end 