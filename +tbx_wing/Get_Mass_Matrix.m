function [M, Q, dQ, qt] = Get_Mass_Matrix(Gen_coord, dGen_coord, ddGen_coord, T)

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

qt = arrayfun(@(ii) symfun(['q' int2str(ii) '(t)'],t),1:numel(names1),'UniformOutput',false);

q = sym(zeros(1,length(names1)));

for i = 1:length(qt)
    q(i) = qt{i};
    assumeAlso(q(i),'real');
end
q = q';

T_s = subs(T,ddQ,diff(q',t,2));
T_s = subs(T_s,dQ,diff(q',t));
T_s = subs(T_s,Q,q');

M = jacobian(diff(jacobian(T_s,diff(q',t)),t),diff(q',t,2));

end 