function T_FWTL = Get_Kinetic_Energy_FWT(dGen_coord, Elastic_dZ)

syms m_fwt x h  Ihh Ln real

% left - FWT
U_FWTL_rigid = subs(Elastic_dZ.L, [x,h], [Ln, 0.5]);

% KE for heave 
T_FWTL_rigid = 0.5*m_fwt*U_FWTL_rigid^2;  

% KE for folding 
T_FWTL_folding = 0.5*Ihh*dGen_coord.dYfL1^2;

% Add up
T_FWTL = T_FWTL_rigid + T_FWTL_folding;

end