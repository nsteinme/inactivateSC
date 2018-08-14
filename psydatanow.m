function psyCrv = psydatanow(blockFile, date, subject); % get parameters for psychometric curve from block file

%% Getting psychometric data
              load(blockFile);
              uniCon = unique(block.events.contrastRightValues); % list of all contrasts used in block
               
              for i = 1:size(block.events.trialNumValues,2)-1; % loop through each completed trial of session
                             
                   trials(i).rep = block.events.repeatNumValues(i)~=1; % repeat trials identified in logical array
                   trials(i).conDiff = block.events.contrastRightValues(i) - block.events.contrastLeftValues(i);      
                   % returns contrast difference (trial condition)   
              end
             
              uniConDiff = unique([trials.conDiff]); % trial conditions for left and right
              
for ii = 1:size(uniConDiff,2); % for each trial type
r = 0; %rightward response
t = 0; % all responses



for i = 1:size(block.events.trialNumValues,2)-1; % loop through each trial of session

                    if [trials(i).conDiff] == uniConDiff(ii) &&  trials(i).rep~=1 && ... 
                       [block.events.responseValues(i)] == 1;
                        r = r + 1; % trial condition matches, not repeat and chose right
                    end
                    if [trials(i).conDiff] == uniConDiff(ii) &&  trials(i).rep~=1;
                        t = t+1; % trial condition matches and not a repeat
                    end
                        trials(ii).res = r/t; % proportion trials chose right

                    end; % end loop through every trial 
                  
end % end loop through each contrast condition


cr = 0; %correct rightward trial
cl = 0; %correct leftward trial
rt= 0;
lt=0;
for i = 1:size(block.events.trialNumValues,2)-1;
    
                    if [trials(i).conDiff] > 0  &&  trials(i).rep~=1 && ...  %rightward trial, non repeat
                       sign([block.events.responseValues(i)]) == sign([trials(i).conDiff]); % correct
                        cr = cr + 1; 
                    end
                    if [trials(i).conDiff] > 0  &&  trials(i).rep~=1;  %rightward trial, non repeat
                       
                        rt = rt + 1; 
                    end
                    
                    if [trials(i).conDiff] < 0  &&  trials(i).rep~=1 && ...  %leftwardward trial, non repeat
                       sign([block.events.responseValues(i)]) == sign([trials(i).conDiff]); % correct
                        cl = cl + 1; 
                    end
                    
                    if [trials(i).conDiff] < 0  &&  trials(i).rep~=1;  %leftwardward trial, non repeat
                        lt = lt + 1; 
                    end
end % end loop through every trial 

%Right / Left % correct         % should remove 0% contrast trials in
%future
cr = (cr / rt ) * 100;
cr = sprintf('%s   %d','Rightward trials',cr);
cl = (cl / lt ) * 100;
cl = sprintf('%s   %d','Leftward trials',cl);
tc = sprintf('%s   %d','Trial count: ',(size(trials,2)));


%% Psychometric curve
psyCrv = figure;
hold on;
%handle
fh = psyCrv; 
%plot data
scatter(uniConDiff, [trials(1:(size(uniConDiff,2))).res],40, 'MarkerEdgeColor',[0 0 0], 'MarkerFaceColor',[0.5 0.5 0.5], 'LineWidth',1.5);   
%curve plotting
s = polyfit(uniConDiff, [trials(1:(size(uniConDiff,2))).res],5); ss = polyval(s, uniConDiff);
plot(uniConDiff,ss, 'LineWidth',1, 'Color', 'k'); ylim([0 1]);
%guide lines
line([0 0], [0 1], 'LineStyle','--', 'Color', [0.75 0.75 0.75], 'LineWidth', 0.7);
line([-1 1], [0.5 0.5], 'LineStyle','--', 'Color', [0.75 0.75 0.75], 'LineWidth', 0.7);
%axis labels, ticks and formatting
xlabel('Contrast difference', 'FontSize', 14, 'FontName','Consolas'); 
xticks([-1, -0.5, -0.25, 0, 0.25, 0.5, 1]); xticklabels({'-1' '-0.5' '-0.25' '0' '0.25' '0.5' '1'});
ylabel('Proportion rightward responses', 'FontSize', 14, 'FontName','Consolas'); 
yticks([0, 0.5, 1]); yticklabels({'0' '0.5' '1'});
set(gca,'TickLength',[0, 0]);
ax=get(gca,'XAxis'); set(ax, 'FontSize', 14, 'FontName', 'Consolas'); 
ay=get(gca,'YAxis'); set(ay, 'FontSize', 14, 'FontName', 'Consolas'); 
%figure presentation 
lines = findall(fh,'Type','lines');
set(lines, 'LineWidth', 1);
set(fh, 'color', 'white');
%subject, date and trial count info
text(-0.75, 0.95, subject, 'FontSize', 14, 'FontName','Consolas');
text(-0.75, 0.85, date, 'FontSize', 14, 'FontName','Consolas');
text(-0.75, 0.75, tc, 'FontSize', 14, 'FontName','Consolas');
hold off;
              
end