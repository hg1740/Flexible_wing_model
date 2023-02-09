function E_innerL = Get_Potential_Wing(Elastic_Zb, Elastic_Rt)

syms Ln x EI GJ real

% wing strain energy caused by bending 
x_range = [0, Ln];
kL = diff(diff(Elastic_Zb.L, x), x);
dEbL = 0.5*EI*kL^2;
EbL = int(dEbL, x, x_range);

% wing strain energy caused by torsion 
ktL = diff(Elastic_Rt.L, x);
dEtL = 0.5*GJ*ktL^2;
EtL = int(dEtL, x, x_range);

E_innerL = EbL + EtL;

end