function ComputeCycles_MC()

global Data

rh = Data.Coordinates(:,22);
rh_floor = min(rh(1:26,1));

lh = Data.Coordinates(:,30);

rh = rh(27:end,1); 
indexes_rh = find(rh <= rh_floor);
not_consecutive_rh = [true; diff(indexes_rh)~=1];
indexes_rh = indexes_rh(not_consecutive_rh)+27;
Data.indexes_rh = [27; indexes_rh; length(indexes_rh)];

lh_floor = max(lh(1:indexes_rh(1)-1,1));
lh = lh(indexes_rh(1)+1:end,1);
indexes_lh = find(lh <= lh_floor);
not_consecutive_lh = [true;diff(indexes_lh)~=1];
Data.indexes_lh = indexes_lh(not_consecutive_lh) + indexes_rh(1)+1;

Data.Coordinates = Data.Coordinates(Data.indexes_rh(1):Data.indexes_lh(end),:);
Data.Tend = Data.Time(Data.indexes_lh(end)) - Data.Time(Data.indexes_rh(1));

end