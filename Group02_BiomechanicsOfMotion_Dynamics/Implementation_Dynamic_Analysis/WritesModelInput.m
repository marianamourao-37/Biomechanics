function WritesModelInput(ModelName)
% this function writes the updated data for the biomechanical model 

% global memory data 
global NBody NRevolute NGround NDriver NFplates Body JntRevolute ...
    JntDriver FPlate Data TotalBodyMass file

% open file 
fid = fopen(ModelName, 'w');

% store the general dimensions of the system 
fprintf(fid, '%d %d %d %d %d\r\n', NBody, NRevolute, NGround, ...
    NDriver, NFplates);

% stores the data for the rigid body information 
for i = 1:NBody 
    fprintf(fid, '%d %f %f %f %f %f 0.0 0.0 0.0 %f %f\r\n', ...
        i,Body(i).r(1,1),Body(i).r(1, 2),Body(i).theta(1), ...
        Body(i).PCoM,Body(i).Length,Body(i).mass, ...
        Body(i).inertia);
end 
% initial velocities of the system are set to 0.0, sendo que se faz isto
% porque in the forward dynamics program, tem se o step de correct initial
% conditions, pelo que apenas se precisa as posições para o newton rapshon
% method, sendo que este metodo encontra as posições consistentes com o
% sistema, sendo que depois atraves da derivação se obtêm as velocidades,
% nao se necessitando de initial velocities, being computed properly in the
% dynamics code 

% stores the data for the revolute joints 
for k = 1:NRevolute 
    % bodies i and j 
    i = JntRevolute(k).i;
    j = JntRevolute(k).j;
    
    fprintf(fid, '%d %d %d %f %f %f %f\r\n', k, i, j, ...
        JntRevolute(k).spi(1) * Body(i).Length, ...
        JntRevolute(k).spi(2) * Body(i).Length, ...
        JntRevolute(k).spj(1) * Body(j).Length, ...
        JntRevolute(k).spj(2) * Body(j).Length);
end 

% stores the data for the driver joints 
for k = 1:NDriver 
    fprintf(fid, '%d %d %d %d %d %d %d\r\n', k, ...
        JntDriver(k).type, JntDriver(k).i, JntDriver(k).coordi, ...
        JntDriver(k).j, JntDriver(k).coordj, ...
        JntDriver(k).filename);
    
    % writes the driving data to the files 
    dlmwrite([file, num2str(JntDriver(k).filename),'.txt'],...
        JntDriver(k).Data, 'delimiter', ' ', 'precision', 16, ...
        'newline', 'pc');
end 

% stores the data regarding the force plates 
for k = 1:NFplates 
    % bodies i and j 
    i = FPlate(k).i;
    j = FPlate(k).j;

    fprintf(fid, '%d %d %d %f %f %f %f %d\r\n', k, i, j, ...
        FPlate(k).spi(1)*Body(i).Length, FPlate(k).spi(2)*Body(i).Length, ...
        FPlate(k).spj(1)*Body(j).Length, FPlate(k).spj(2)*Body(j).Length, ...
        FPlate(k).filename);

    % writes the data to the files
    dlmwrite([file, 'FPlates_', num2str(FPlate(k).filename),'.txt'], ...
        FPlate(k).Data, 'delimiter', ' ', 'precision', 20, 'newline', 'pc');
end

fprintf(fid,'%f %f %f %d\r\n', 0.0, Data.Tstep,Data.Tend);
fprintf(fid,'%f\r\n', TotalBodyMass);
fclose(fid);

if strcmp(file,'mountain_climber')
    template_rh = repmat('%d ', 1, length(Data.indexes_rh)-2);
    template_lh = repmat('%d ', 1, length(Data.indexes_lh));    
    
    cycles_file = fopen('Cycles_MountainClimber.txt', 'w');
    
    fprintf(cycles_file, '%d %d\r\n',Data.indexes_rh(1,1), Data.indexes_rh(end,1)); 
    fprintf(cycles_file,[template_rh(1:end-1),'\r\n'], Data.indexes_rh(2:end-1,1));

    fprintf(cycles_file,template_lh(1:end-1), Data.indexes_lh);
    fclose(cycles_file);
end

dlmwrite(['CuttOffFrequencies_', file,'.txt'], Data.CutOffFrequencies);

% end of function
end 