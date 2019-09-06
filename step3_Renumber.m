close all;
clear all;
disp('step3 begin');
t = 20;
data_num = 11:15;
for angle_pos = 1  %% 1-8
    for  test_num = data_num
        test_num
        for board_num = [0 1]
            filename = ['..\raw\matlab_12evtmodule\data_12module_' int2str(t) 's_angle'];
            load([filename num2str(angle_pos) '_' num2str(test_num) '_board' num2str(board_num) '_sng_data.mat']);
            all_one = ones(length(sng_data),1);
            if board_num == 1 
                board = all_one * (10 - angle_pos);
            else
                board = all_one * (18 - angle_pos);
                if board > 16
                    board = board - 16;
                end
            end
            clear all_one;
%             sng_data(sng_data(:,1)==1,1) = 5;
%             sng_data(sng_data(:,1)==2,1) = 8;
%             sng_data(sng_data(:,1)==3,1) = 11;
%             sng_data(sng_data(:,1)==0,1) = 2;
            
%             LOR_data(LOR_data(:,2)==1,2) = 5;
%             LOR_data(LOR_data(:,2)==2,2) = 8;
%             LOR_data(LOR_data(:,2)==3,2) = 11;
%             LOR_data(LOR_data(:,2)==0,2) = 2;
%             LOR_data(LOR_data(:,6)==1,6) = 5;
%             LOR_data(LOR_data(:,6)==2,6) = 8;
%             LOR_data(LOR_data(:,6)==3,6) = 11;
%             LOR_data(LOR_data(:,6)==0,6) = 2;
            
            sng_data = [board sng_data];
            save(['..\raw\matlab_12evtmodule\data_12module_' int2str(t) 's_' num2str(test_num) '_board' num2str(board(1)) '_Renumber_data.mat'],'sng_data');
%             clear sng_data Renumber_data board;
        end
    end
end


%% 
pause(5);
% step4_CoarseTDCcorrect