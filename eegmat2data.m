%% Converts EEG Mat-Files to EEG Data (Contains Multimedia and Baseline Parts) | 10:24 P.M. Mon, Jan 04, 2021
%% Initialization
clear all;
close all;
clc;

eegmat_path  = 'C:/Users/Amir/Desktop/Ardakani/data/'; % set the full path of eegmat folder 
eegdata_path = 'C:/Users/Amir/Desktop/Ardakani/data/extracted/'; % set the full path of eegdata folder

eegmat_regex = fullfile(eegmat_path,'*.mat'); % regex for dir eegmat files
eegmat_files = dir(eegmat_regex);
nfiles = length(eegmat_files); % number of eegraw files

trial_dur = 5120; % duration of multimedia part (L11: 342s,L6: 290s)
baseline_dur   = 30720;   % duration of baseline part (8s)
base_and_eeg_dur = 7680;
%% Trigger Detection and Extracting Data (Baseline + Multimedia)
tic
for i = 1:nfiles
    
    % detects trigger point: j index
    load(fullfile(eegmat_path,eegmat_files(i).name)); % load eegmat files
    eegmat = squeeze(data)';
    events = eegmat(:,end); % extract eventlog (last column of eegmat)
 
        thr1 = 1.5;
        thr2 = 2.5;
    for j = 1:length(events)
        if events(j) > thr1 && events(j) < thr2
            events(j) = 1;
        else
            events(j) = 0;
        end
    end
    
    
    trigger_coutner =1;
    for j = 2:length(events)
        if events(j) == 1 && events(j-1)==0
            trigger(trigger_coutner) = j;
            trigger_coutner = trigger_coutner+1;
        end
    end

   eegdata = [];
   for condition_i = 1:9
       eegdata = [eegdata; eegmat(trigger(condition_i):trigger(condition_i)+base_and_eeg_dur-1,1:end-3)];
   end
   eegdata = [eegdata; eegmat(trigger(end):trigger(end)+base_and_eeg_dur-1,1:end-3)];
   
    
    

    % extracts and saves eegdata
    
    %eegdata = [eegdata ; 
    eegdata_name = fullfile(eegdata_path,replace(eegmat_files(i).name,...
        'eegmat','eegdata'));
    save(eegdata_name,'eegdata');
    i
end
toc