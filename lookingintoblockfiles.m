%% Build list of training block files for subject

%Mouse name 
subject = 'SS102';


% List of training sessions for subject
root = fullfile('\\zubjects\Subjects\', subject); % subject
cd(root);
subDir = dir; % Subject directory, folders listed by date subject trained 
subDir = subDir(~ismember({subDir.name}, {'.', '..', 'TrainingImages'}));   % directory of behavioural data only
isFolder = [subDir.isdir]; % array indentifying folders and files in subject directory
subDir(~isFolder) = []; % remove loose files

% Collect block files from subfolders
 for i = 1:size(subDir,1) % loop through subject directory

     ses = fullfile(root, subDir(i).name); % get name for date subfolder
     cd(ses); % access date subfolder
     dateDir = dir; % date directory
     dateDir = dateDir(~ismember({dateDir.name}, {'.', '..'}));   % remove these folders (that Matlab uses for navigation??)
     
     isFolder = [dateDir.isdir]; % array indentifying folders and files
     dateDir(~isFolder) = []; % remove loose files
     
    for ii = 1:size(dateDir,1) % loop through date directory (for multiple sessions on same date)
        
         sesDir = fullfile(ses, dateDir(ii).name);    % get name for session subfolder
         cd(sesDir); % access session subfolder
         sesDir = dir; % session directory
         
          for iii = 1:size(sesDir,1) % loop through session directory
          
              if  contains(sesDir(iii).name, 'Block'); % if session contains 'Block'
                  subBlocks(i).session = fullfile(ses, dateDir(ii).name, sesDir(iii).name); % get the block filename and store in subBlocks struct
                  subBlocks(i).date = sprintf(subDir(i).name);     % save date of training session to use as image name later
                  %this will overwrite multiple sessions on same day?
                  
              end % end search for block files
              
          end % end session directory loop
    end % end date directory loop
 end % end subject directory loop

%% Make psychometric curves for new sessions

% Make folder for storing images or find out what it contains
cd(root); % back to subject folder

if  ~exist('TrainingImages', 'dir'); % TrainingImages folder does not exist
    mkdir TrainingImages; % make it
end

figs = fullfile(root, 'TrainingImages'); % get name for images subfolder
cd(figs); % access images subfolder
figsDir = dir; % Training Images directory
figsDir = figsDir(~ismember({figsDir.name}, {'.', '..'}));   % remove these folders (that Matlab uses for navigation??)

%These loops indentify which sessions still need figures made, by saving
%placeholders into subBlocks.fig, which are swapped to session date (figure
%name) if the figure exists already
     
 for i = 1:size(subBlocks,2); % for each session
     
      subBlocks(i).fig = i;  % save 'i' as placeholder field in subBlocks

       % Identify sessions left to be analysed
       if  size(subBlocks,2) ~= size(figsDir,1); % not all training sessions have been analysed

           for ii = (size(figsDir,1)+1) : ( size(subBlocks,2)); % size of figsDir (which will smaller), +1 to account for first of missing sessions
                                                                             % to size of subDir (fully updated, larger)

               subBlocks(ii).fig = ii; %placeholders for session yet to be analysed
           end
       end

       % Don't re-analyse sessions
       if size(figsDir,1)>0; % some sessions already analysed and figures made

           for  ii = 1:size(figsDir,1); % for each figure already made

                if    contains([figsDir(ii).name], [subBlocks(ii).date]); % image for date exists

                      subBlocks(ii).fig = subBlocks(ii).date; % subBlocks.fig changed to date to mark image made already and remove placeholder
                end
           end
       end

       % Make figures for neglected sessions   
       if ~contains((num2str(subBlocks(i).fig)), (sprintf(subBlocks(i).date))); % placeholder in subBlocks.fig still exists (session not analysed)
                                  
                    figure(i) = psydatanow(subBlocks(i).session, subBlocks(i).date, subject); % analyse session 
                 
                  saveas(figure(i),(sprintf(subBlocks(i).date)), 'jpeg'); % save figure as training session date in TrainingImages on zubjects
                  saveas(figure(i), fullfile('\\basket\data\hamish\Training Images\', subject, (sprintf(subBlocks(i).date))), 'jpeg');
                  % save figure as training session date in TrainingImages
                  % on \\basket

                  
                  
       end % end figure making loop
              
 end % end loop through block files