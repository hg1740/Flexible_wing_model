function [K, qt] = Get_Stiffness_Matrix(Gen_coord, dGen_coord, ddGen_coord, E)

syms t real

names1 = fieldnames(Gen_coord);
names2 = fieldnames(dGen_coord);
names3 = fieldnames(ddGen_coord);

Q = sym(zeros(1,length(names1)));
dQ = sym(zeros(1,length(names1)));
ddQ = sym(zeros(1,length(names1)));

for i = 1:length(names1)
    Q(i) = Gen_coord.(names1{i});
    dQ(i) = dGen_coord.(names2{i});
    ddQ(i) = ddGen_coord.(names3{i});
end

qt = arrayfun(@(ii) symfun(['q' int2str(ii) '(t)'],t),1:length(names1),'UniformOutput',false);

q = sym(zeros(1,length(names1)));

for i = 1:length(qt)
    q(i) = qt{i};
    assumeAlso(q(i),'real');
end
q = q';

E_s = subs(E,ddQ,diff(q',t,2));
E_s = subs(E_s,dQ,diff(q',t));
E_s = subs(E_s,Q,q');

K = jacobian(E_s,q');

end 