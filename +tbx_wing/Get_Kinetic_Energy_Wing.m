function T_main = Get_Kinetic_Energy_Wing(Elastic_dZ)

syms Ln x h Rho real

% left wing - inner
Span_range = [0, Ln];

dTL = 0.5*Rho*Elastic_dZ.L^2;
TL_ = int(dTL,  x, Span_range);
T_main = int(TL_,  h, [-0.5, 0.5]);

end