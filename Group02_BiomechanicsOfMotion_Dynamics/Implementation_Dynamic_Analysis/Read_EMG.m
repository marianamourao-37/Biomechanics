% Function to read the EMG data
clear all;
close all;
clc;
    
%select one file 
[EMG_file,~] = uigetfile('*.tsv','Choose the movement you want to analyse, regarding rm data');

index = strfind(EMG_file, '_');
RMS_file = [EMG_file(1:index(2)),'RMS.tsv'];

EMG_data = dlmread(EMG_file, '', 1, 0);
RMS_data = dlmread(RMS_file, '', 1, 0);

if contains(EMG_file, 'Climber')
    mov = 'Mountain Climber';
else
    mov = 'Gait';
end

Muscle = ["Gastrocnemius Medialis", "Tibialis Anterior", "Rectus Femoris", "Biceps Femoris"];

if strcmp(mov,'Gait')
    
    Time = EMG_data(:,1);
    EMG = EMG_data(:,2:5)*10^6;
    RMS = RMS_data(:,2:5)*10^6;
    
    motion_percentage = (Time - Time(1,1))/(Time(end,1)-Time(1,1)) * 100;
    
    option=input('You want to analyse the EMG, RMS or Normalized_EMG_RMS data?','s');
    %you can select if you want to analyse the EMG data without normalization,
    %the RMS data, also without normalization or the plots regarding both data
    %normalized.
   
    if strcmp(option,'RMS')
      % Plot RMS
      figure();
      for i = 1:4        
            subplot(2,2,i)
            plot(motion_percentage,RMS(:,i))
            title(Muscle(i));
            xlabel('% of Motion')
            ylabel('RMS')
      end
         
    elseif strcmp(option,'EMG')
        figure();
        % Plot Raw EMG
        for i = 1:4
            subplot(2,2,i)
            plot(motion_percentage,EMG(:,i))
            title(Muscle(i));  
            xlabel('% of Motion')
            ylabel('EMG') 
        end
        
    else
        % Normalization
        muscle_means = mean(RMS);
        normalized_RMS = RMS./muscle_means * 100;
        
        ylims = [0 400;0 300; 0 400;0 500];
        %Plots after normalization
        figure();
        for i = 1:4
            subplot(2,2,i)
            plot(motion_percentage,normalized_RMS(:,i))
            title(Muscle(i))
            xlabel('% of Motion')
            ylabel('Normalized RMS (%)')
            legend(['Mean(uV)=',num2str(muscle_means(i))]);
            ylim(ylims(i,:))
        end
    end
else
    cycles_file = dlmread('Cycles_MountainClimber.txt');
    line = 1;
    
    diff_tstep = 10;
    nframe_initial = (cycles_file(line,1) - 11)*diff_tstep+1;
    num_cycles = cycles_file(line,2);
    
    cycles(1).complete = [1];
    
    half = zeros(num_cycles,1);
    half(1,1) = (cycles_file(line+1,1) - cycles_file(line,1))*...
        diff_tstep+1;
    
    line = line + 2;
    
    for i = 1:num_cycles
        if i == 1
            cycles(i).complete(end+1) = (cycles_file(line,i)-11)*...
                diff_tstep+1 - nframe_initial;
        else 
            cycles(i).complete = [cycles_file(line,i-1)+1-11,...
                cycles_file(line,i)-11]*diff_tstep+1 - nframe_initial;
            
            half(i,1) = (cycles_file(line-1,i) - (cycles_file(line,i-1)+1))*...
            diff_tstep+1;
        end
        
    end
    
    initial_cycle = 2;
    
    half_cycle = round(mean(half(initial_cycle:end)));
    
    nframe_final = cycles(6).complete(2) + nframe_initial;
    Time = EMG_data(nframe_initial:nframe_final,1);
    EMG = EMG_data(nframe_initial:nframe_final,2:5)*10^6;
    RMS = RMS_data(nframe_initial:nframe_final,2:5)*10^6;
    
    motion_percentage = (Time - Time(1,1))/(Time(end,1)-Time(1,1)) * 100;
    
    diff_cycles = zeros(length(num_cycles));

    for i = initial_cycle:num_cycles 
        diff_cycles(i) = diff(cycles(i).complete);
    end

    [~, index_maxdiff] = max(diff_cycles);

    end_time = diff_cycles(index_maxdiff);
    timecycle = ((0.0:end_time)/(end_time))*100;

    legend_name = ["1??repetition", "2??repetition", "3??repetition", "4??repetition", "5??repetition", "6??repetition"];
    legend_name = legend_name(initial_cycle:end);
    
    option=input('You want to analyse the EMG, RMS or Normalized_EMG_RMS data?','s');
    
    if strcmp(option,'RMS')
        % Plot RMS
        ylabel_name = 'RMS';
        
        for i = 1:4
            title_name = Muscle(i);
            
            figure(1);
            subplot(2,2,i)
            hold on;
            plot(motion_percentage,RMS(:,i));
            
            for j = 1:num_cycles
                xline(motion_percentage(cycles(j).complete(1)),'--');
                xline(motion_percentage(cycles(j).complete(2)),'--');
                xline(motion_percentage(cycles(j).complete(1)+half(j,1)),'--r');
            end
            title(title_name);
            xlabel('% of Motion');
            ylabel(ylabel_name);
            hold off;
            
            figure(2);
            subplot(2,2,i)
            Plot_EMGcycles(timecycle, diff_cycles, RMS(:,i), num_cycles, ...
                cycles, half_cycle, initial_cycle, title_name,ylabel_name);
            
            if i == 4
                legend(legend_name);
                hold off;
            else
                hold off;
            end
        end
        
    elseif strcmp(option,'EMG')
        ylabel_name = 'EMG';
        
        % Plot Raw EMG
        for i = 1:4
            title_name = Muscle(i);
                        
            figure(1);
            subplot(2,2,i)
            hold on;
            plot(motion_percentage,EMG(:,i))
       
            for j = 1:num_cycles
                xline(motion_percentage(cycles(j).complete(1)),'--');
                xline(motion_percentage(cycles(j).complete(2)),'--');
                xline(motion_percentage(cycles(j).complete(1)+half(j,1)),'--r');
            end
            title(title_name);
            xlabel('% of Motion');
            ylabel(ylabel_name);
            hold off;
            
            figure(2);
            subplot(2,2,i)
            Plot_EMGcycles(timecycle, diff_cycles, EMG(:,i), num_cycles, ...
                cycles, half_cycle, initial_cycle, title_name,ylabel_name);
            if i == 4
                legend(legend_name);
                hold off;
            else
                hold off;
            end        
        end
    else       
        muscle_means = mean(RMS);
        normalized_RMS = RMS./muscle_means * 100;
        
        ylabel_name = 'Normalized RMS (%)';
        
        % Plots after normalization
        for i = 1:4
            title_name = Muscle(i);
            
            figure(1);
            subplot(2,2,i)
            hold on;
            plot(motion_percentage,normalized_RMS(:,i))
            legend(['MVC(uV)=',num2str(muscle_means(i))]);
            for j = 1:num_cycles
                xline(motion_percentage(cycles(j).complete(1)),'--',...
                    'HandleVisibility','off');
                xline(motion_percentage(cycles(j).complete(2)),'--',...
                    'HandleVisibility','off');
                xline(motion_percentage(cycles(j).complete(1)+half(j,1)),'--r', ...
                    'HandleVisibility','off');
            end
            title(title_name);
            xlabel('% of Motion');
            ylabel(ylabel_name);
            hold off;
            
            figure(2);
            subplot(2,2,i)
            Plot_EMGcycles(timecycle, diff_cycles, normalized_RMS(:,i), ...
                num_cycles, cycles, half_cycle, initial_cycle, title_name,ylabel_name);
            if i == 4
                legend(legend_name);
                hold off;
            else
                hold off;
            end              
        end
    end
end