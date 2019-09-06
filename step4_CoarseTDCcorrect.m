clear all;
close all;
%% 延时方向： board-board
%% 1 - 9        0 - 1
%% 2 - 10       1 - 0
%% 3 - 11       1 - 0
%% 4 - 12       1 - 0
%% 5 - 13       1 - 0
%% 6 - 14       1 - 0
%% 7 - 15       1 - 0
%% 8 - 16       1 - 0
disp('step4 begin');
t = 20;
data_num = 11:15;
fix_shift_box = [];
for board_num = 1   %% 1-8
    for test_num = data_num
        test_num
        filename =['..\raw\matlab_12evtmodule\data_12module_' num2str(t) 's_' num2str(test_num) '_board'];
        %% read data of board0
        load([filename  num2str(board_num+8) '_Renumber_data.mat']);
        data_board0 = sng_data(:,1:3);
        clear sng_data;
        %% read data of board1
        load([filename num2str(board_num) '_Renumber_data.mat']);
        data_board1 = sng_data(:,1:3);

        %% sort tdc data of board0
        index = find(diff(data_board0(:,3))<= -2^20);
        circle = zeros(length(data_board0),1);
        for i = 1 : length(index)
            if i == length(index)
                circle(index(i)+1:end) = i * 2500 * 2^22;
            else
                circle(index(i)+1:index(i+1)) = i * 2500 * 2^22;
            end
        end
        tdc_sort0 = circle + data_board0(:,3);
        data_board0(:,3) = tdc_sort0;
        clear circle index tdc_sort0;
        % figure;plot(data_board0(:,4));

        %% sort tdc data of board1
        index = find(diff(data_board1(:,3))<= -2^30);
        circle = zeros(length(data_board1),1);
        for i = 1 : length(index)
            if i == length(index)
                circle(index(i)+1:end) = i * 2500 * 2^22;
            else
                circle(index(i)+1:index(i+1)) = i * 2500 * 2^22;
            end
        end
        tdc_sort1 = circle + data_board1(:,3);
        data_board1(:,3) = tdc_sort1;
        clear circle index tdc_sort1;
        % figure;plot(data_board1(:,4));

        %% search delay
        if length(data_board1(:,3)) < length(data_board0(:,3)) 
            len = length(data_board1(:,3)); 
        else
            len = length(data_board0(:,3));
        end

        evt_interval = (max(data_board1(:,3)) - min(data_board1(:,3)))/len;
        fix_shift = data_board1(1,3) - data_board0(1,3);
        search_len = 2000;
        search_start = -evt_interval * 30000;
        search_end = evt_interval * 30000;
        search_interval = evt_interval * 30;
        clear len evt_interval;

        while search_interval > 60    % 可以调整找粗时间校准的精度
            coincnt_all=[];
            for time_shift = search_start : search_interval : search_end
                tdc_temp = data_board1(1:search_len,3) - time_shift - fix_shift;
                coincnt=0;
                for i = 1 : search_len
                    tdc_diff = abs(tdc_temp - data_board0(i,3));
                    count = sum(tdc_diff < search_interval);
                    coincnt = coincnt + count;
                end
                coincnt_all = [coincnt_all coincnt];
            end
            clear coincnt tdc_diff tdc_temp count;
            %% correct fix_shift
            [time_shift_search,index_search] = max(coincnt_all);
            time_shift = [search_start : search_interval : search_end];
            fix_shift = fix_shift + time_shift(index_search);
            clear coincnt_all time_shift;
            %% correct search critical value
            search_start = -search_interval * 5;
            search_end = search_interval * 5;
            search_interval = search_interval/200;
            
            if fix_shift > 2500*2^22
                fix_shift = fix_shift - 2500*2^22;
            elseif fix_shift < -2500*2^22
                fix_shift = fix_shift + 2500*2^22;
            end
        end
        
        fix_shift_box = [fix_shift_box fix_shift];
%         clear data_board0 data_board1 sng_data fix_shift;
    end
end

%% calculate average fix_shift
shift_interval = search_interval * 1000;

fix_shift_box(fix_shift_box < 0) = fix_shift_box(fix_shift_box < 0) + 2500 * 2^22;
fix_shift_box = sort(fix_shift_box);
diff_shift = diff(fix_shift_box);

index_fix_shift_box = find(abs(diff_shift)<shift_interval);
fix_shift_final = mean(fix_shift_box(abs((fix_shift_box - fix_shift_box(index_fix_shift_box(1))))<shift_interval));
save fix_shift_final;

%% 
pause(5);
% step5_CoincidenceSelect