function [Gen_coord, dGen_coord, ddGen_coord] = Set_qs(Numb, Numt)

% syms qbL1 qbL2 qbL3 qtL1 qtL2 dqbL1 dqbL2 dqbL3 dqtL1 dqtL2 thetafL dthetafL ddqbL1 ddqbL2 ddqbL3 ddqtL1 ddqtL2 ddthetafL real

%% GC

qb = arrayfun(@(ii) sym(['qbL' int2str(ii)]),1:Numb,'UniformOutput',false);
dqb = arrayfun(@(ii) sym(['dqbL' int2str(ii)]),1:Numb,'UniformOutput',false);
ddqb = arrayfun(@(ii) sym(['ddqbL' int2str(ii)]),1:Numb,'UniformOutput',false);

qt = arrayfun(@(ii) sym(['qtL' int2str(ii)]),1:Numt,'UniformOutput',false);
dqt = arrayfun(@(ii) sym(['dqtL' int2str(ii)]),1:Numt,'UniformOutput',false);
ddqt = arrayfun(@(ii) sym(['ddqtL' int2str(ii)]),1:Numt,'UniformOutput',false);

% Bending Gencoords
for i = 1:Numb
    Gen_coord.(['YbL', num2str(i)])=qb{i};
    dGen_coord.(['dYbL', num2str(i)])=dqb{i};
    ddGen_coord.(['ddYbL', num2str(i)])=ddqb{i};

    assumeAlso(qb{i},'real');
    assumeAlso(dqb{i},'real');
    assumeAlso(ddqb{i},'real');

end

% Torsional Gencoords
for i = 1:Numt

    Gen_coord.(['YtL', num2str(i)])=qt{i};
    dGen_coord.(['dYtL', num2str(i)])=dqt{i};
    ddGen_coord.(['ddYtL', num2str(i)])=ddqt{i};

    assumeAlso(qt{i},'real');
    assumeAlso(dqt{i},'real');
    assumeAlso(ddqt{i},'real');

end

% FWT Gencoords
Gen_coord.YfL1=sym('thetafL');
dGen_coord.dYfL1=sym('dthetafL');
ddGen_coord.ddYfL1=sym('ddthetafL');

% Gen_coord.YbL1=qbL1;
% Gen_coord.YbL2=qbL2;
% Gen_coord.YbL3=qbL3;
% Gen_coord.YtL1=qtL1;
% Gen_coord.YtL2=qtL2;
% Gen_coord.YfL1=thetafL;

% %% dGC
% dGen_coord.dYbL1=dqbL1;
% dGen_coord.dYbL2=dqbL2;
% dGen_coord.dYbL3=dqbL3;
% dGen_coord.dYtL1=dqtL1;
% dGen_coord.dYtL2=dqtL2;
% dGen_coord.dYfL1=dthetafL;
% 
% %% ddGC
% ddGen_coord.ddYbL1=ddqbL1;
% ddGen_coord.ddYbL2=ddqbL2;
% ddGen_coord.ddYbL3=ddqbL3;
% ddGen_coord.ddYtL1=ddqtL1;
% ddGen_coord.ddYtL2=ddqtL2;
% ddGen_coord.ddYfL1=ddthetafL;

end