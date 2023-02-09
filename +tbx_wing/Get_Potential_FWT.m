function E = Get_Potential_FWT(Gen_coord, Elastic_Zb)

syms Ln x laf mf g kL real

% Left FWT 
z_hL = subs(Elastic_Zb.L, x, Ln);
E_FWTL = -mf*g*(-laf*sin(Gen_coord.YfL1) + z_hL) + 0.5*kL*Gen_coord.YfL1^2;

E = E_FWTL;

end