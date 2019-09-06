%% ·ûºÏ´¦Àí
clear all;
close all;
disp('step5 begin');
t = 20;
data_num = 11:15;
load('fix_shift_final.mat');

%% energy window select
offset_l = 350;
offset_h = 650;
for board_num = [1 9]  %% 1-8
    disp('energy window select');
    for test_num = data_num
        test_num
        filename =['..\raw\matlab_12evtmodule\data_12module_' num2str(t) 's_' num2str(test_num) '_board'];
        load([filename  num2str(board_num) '_Renumber_data.mat']);
        %% energy window

        eng_total = sum(sng_data(:,4:12),2);
        [loc_511kev,max_count] = mode(eng_total);
        eng_total = eng_total*511./loc_511kev;
        index_eng_window = find(eng_total > offset_l & eng_total < offset_h );
        sng_data =sng_data(index_eng_window,:);
        save([filename num2str(board_num) '_Renumber_data.mat'],'sng_data');
        clear index_eng_window sng_data;
    end
end

%% coarse time correct
for board_num = [1 9]  %% 1-16 
    disp('coarse time correct');
    for test_num = data_num
        test_num
        filename =['..\raw\matlab_12evtmodule\data_12module_' num2str(t) 's_' num2str(test_num) '_board'];
        %% read data of board0
        load([filename  num2str(board_num) '_Renumber_data.mat']);
        if board_num < 8 
            save([filename num2str(board_num) '_TDCcorrect_data.mat'],'sng_data');
        else
            sng_data(:,3) = sng_data(:,3) + fix_shift_final;
            save([filename num2str(board_num) '_TDCcorrect_data.mat'],'sng_data');
        end
        clear sng_data;
    end
end

%% coincidence serch
for board_num = 1  %% 1-8
    disp('coincidence serch');
    for test_num = data_num
        test_num
        filename =['..\raw\matlab_12evtmodule\data_12module_' num2str(t) 's_' num2str(test_num) '_board'];
        %% read data of board0
        load([filename num2str(board_num+8) '_TDCcorrect_data.mat']);
        sng_data0 = sng_data;
        data_board0 = sng_data(:,1:3);
        clear sng_data;
        %% read data of board1
        load([filename  num2str(board_num) '_TDCcorrect_data.mat']);
        sng_data1 = sng_data;
        data_board1 = sng_data(:,1:3);
        clear sng_data;

        if length(data_board1) < length(data_board0) 
            len = length(data_board1(:,3)); 
            data1 = data_board1;
            data2 = data_board0;

        else
            len = length(data_board0(:,3));
            data1 = data_board0;
            data2 = data_board1;
        end
    %     clear data_board0 data_board1;
        search_interval = 10000;
        tdc_window = 5000;
        data2 = [ones(search_interval,3)*(-10^10); data2 ; zeros(len+search_interval-length(data2),3)];
        couple_index = [];
        for i = 1 : len
            [delta,index] = min(abs(data2(i:i+2*search_interval,3) - data1(i,3)));
            if delta < tdc_window
                couple_index = [couple_index; i index+i-search_interval-1];
            end
        end
        if length(data_board1) < length(data_board0)
            couple_data = [sng_data1(couple_index(:,1),:) sng_data0(couple_index(:,2),:)];
        else
            couple_data = [sng_data0(couple_index(:,1),:) sng_data1(couple_index(:,2),:)];
        end
        save([filename num2str(board_num) 'and' num2str(board_num+8) '_coincidence_data.mat'],'couple_data');
        clear couple_data data1 data2;
    end
end

%% calculate small delay
pres_delay_box=[];
disp('calculate small delay');
for board_num = 1  %% 1-8
    for test_num = data_num
        test_num
        filename =['..\raw\matlab_12evtmodule\data_12module_' num2str(t) 's_' num2str(test_num) '_board'];
        load([filename num2str(board_num) 'and' num2str(board_num+8) '_coincidence_data.mat']);
        delta_t = couple_data(:,3) - couple_data(:,15);
        [pres_delay, pos] = mode(delta_t);
        pres_delay_box = [pres_delay_box pres_delay];
    end
end
diff_delay = diff(sort(pres_delay_box));
pres_delay = mean(pres_delay_box(abs(diff_delay)<tdc_window/20));

for board_num = 1  %% 1-8
    for test_num = data_num
        test_num
        filename =['..\raw\matlab_12evtmodule\data_12module_' num2str(t) 's_' num2str(test_num) '_board'];
        load([filename num2str(board_num) 'and' num2str(board_num+8) '_coincidence_data.mat']);
        couple_data(:,15) = couple_data(:,15) + pres_delay;
        save([filename num2str(board_num) 'and' num2str(board_num+8) '_coincidence_data.mat'],'couple_data');
    end
end

%% confirm

%%
pause(5);
% step6_Decode_merge