% Exemple found in the wiki

%% configuration
temperature = TempSensor;
source = Source;
load = Load;

V = 10;
I = 2;
RL = 0.1:0.1:15; % Array of all the resistance to be used : from 0.1 to 15 ohms with an increment of 0.1
done = false; % A bool that will be only true if all the experiments are done
data = []; % Array with all the data needed

%% Initialization
setSource(source,V,I); % Set the source voltage and current
setLoad(load,RL(1)); % Set to the first value of R
on(source); % Open the source
on(load); % Open the load
loop_count = 0;
RL_index = 1;

%% Main loop
while done == false
  tic; %Time counter
  T_0 = getTemp(temperature);
  [dT_0,T_h,T_c] = getDT(temperature);
  plotTemp(temperature);

  if state(temperature);
    [pl,vl,il] = getPower(load);
    data = [data; T_0 dT_0 T_h T_c RL(RL_index) pl vl il];
    RL_index = RL_index +1;
    if RL_index > size(RL,2)
      done = true;
    else
      setLoad(load,RL(RL_index));
    end
  end
  loop_count = loop_count +1;
   pause(10 - toc);
end

off(source);
off(load);

%% Data to xls
filename = ['nameOfExp-' datestr(now,'ddmmyyHHMM')];
xlswrite(filename,{'T1','T2','T3','T4','T5','T6','T7','T8','DT','T_h','T_c','Load','Load power','Load voltage','Load current'});
xlswrite(filename,data,1,'A2');
