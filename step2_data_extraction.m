%%
% do data acquisition first with "data_acq.m"
%%
clear all;
close all;
addpath('.\src');
disp('step2 begin');
t = 30; %s                              % Acquire data for 10 seconds
test_num = 52 %文件编号，e.g.1，2，...，2048，...
% test_char = 'D#4_1536_500R'   % 特殊测试编号方式,可根据测试情况约定
test_char = 'D1'                 %测试类型
                                %默认为D100为缺省状态,D16
                                % A：组装前测试，空气耦合
                                % B：组装后测试，光胶耦合
sng_data_sum=[];
for angle_pos = 1  %% 1-8
    angle_pos 
    for test_num = test_num
        test_num
        filename = ['..\raw\matlab_12evtmodule\data_12module_' test_char '_'];
        %% 列车数据格式定义
        c_pkg_nums = 4;   
        c_coach_num = 6;
        c_coach_len = 17;
        c_train_len = c_coach_num * c_coach_len + 4; 
        %% 提取有效数据字()
        debug = 0;
        data = f_getdata([filename num2str(test_num)]);
        train_data = f_get_complet_train_data(data,c_train_len, debug);
        % clear data;
        valid_data = f_get_valid_data(train_data, c_train_len, c_coach_len, c_pkg_nums, debug);
        %clear train_data;
        data_word = f_get_data_word(valid_data, c_pkg_nums);
        %clear valid_data;
        %% 模块数据提取
        for sel_board_num = 0
            sel_board_data = data_word(data_word(:,c_pkg_nums*4+2) == sel_board_num,:);
            %% 以上程序与事件数据具体格式无关
            %% 以下程序与事件数据具体格式有关
            data_1 = sel_board_data(:,1:4);
            data_2 = sel_board_data(:,5:8);
            data_3 = sel_board_data(:,9:12);
            data_4 = sel_board_data(:,13:16);

            data_1_bin = dec2bin((data_1(:,4)*256*256*256 + data_1(:,3)*256*256 + data_1(:,2)*256 + data_1(:,1)),32);
            data_2_bin = dec2bin((data_2(:,4)*256*256*256 + data_2(:,3)*256*256 + data_2(:,2)*256 + data_2(:,1)),32);
            data_3_bin = dec2bin((data_3(:,4)*256*256*256 + data_3(:,3)*256*256 + data_3(:,2)*256 + data_3(:,1)),32);
            data_4_bin = dec2bin((data_4(:,4)*256*256*256 + data_4(:,3)*256*256 + data_4(:,2)*256 + data_4(:,1)),32);
            clear data_1 data_2 ;
            %%
            %     eng_data = bin2dec(data_1_bin(:,17:32));
            %     eng_data_ch4 = bin2dec(data_3_bin(:,5:16));
            %     tdc_data_l = bin2dec(data_2_bin(:,5:16));
            %     tdc_data_h0 = bin2dec(data_4_bin(:,1:16));
            %     tdc_data_h1 = bin2dec(data_2_bin(:,17:32));
            %     tdc_data = bin2dec(data_4_bin(:,17:32)) * 2500 + bin2dec(data_3_bin(:,17:28));
            %     evt_num =  bin2dec(data_1_bin(:,11:16));

            eng = zeros(length(sel_board_data),9);
            eng(:,1) = bin2dec(data_1_bin(:,23:32));
            eng(:,2) = bin2dec(data_1_bin(:,13:22));
            eng(:,3) = bin2dec(data_1_bin(:,3:12));
            eng(:,4) = bin2dec(data_2_bin(:,23:32));
            eng(:,5) = bin2dec(data_2_bin(:,13:22));
            eng(:,6) = bin2dec(data_2_bin(:,3:12));
            eng(:,7) = bin2dec(data_3_bin(:,23:32));
            eng(:,8) = bin2dec(data_3_bin(:,13:22));
            eng(:,9) = bin2dec(data_3_bin(:,3:12));
            evt_num  = bin2dec(data_1_bin(:,1:2)) + bin2dec(data_2_bin(:,1:2)) * 4;
            eng(:,10)= evt_num;
            tdc_data = bin2dec(data_4_bin(:,1:22)) * 2500 + bin2dec(data_4_bin(:,23:32)) * 4;
            %     tdc_data = bin2dec(data_4_bin(:,2:17)) * 2500 + bin2dec(data_4_bin(:,18:29));
            
           
            %%
            
            
%             tdc_data = bin2dec(data_2_bin(:,5:6)) * 2^20 * 2500 + bin2dec(data_1_bin(:,3:22)) * 2500 + bin2dec(data_1_bin(:,23:32)) * 4;
%             crystal_num = bin2dec(data_2_bin(:,27:32));
%             evt_num = bin2dec(data_2_bin(:,23:26));
%             total_eng = bin2dec(data_2_bin(:,7:22));
%             sng_data = [evt_num crystal_num tdc_data total_eng]; % SubBlock号, 时间, 能量
            
%             pos_x = bin2dec(data_1_bin(:,25:32));
%             pos_y = bin2dec(data_2_bin(:,25:32));
%             pos = [pos_x pos_y];
            
            
%             save([filename num2str(test_num) '_board' num2str(sel_board_num) '_sng_data.mat'],'sng_data');
            save([filename num2str(test_num) '_eng.mat'],'eng');
            delete([filename num2str(test_num) '.dat']);
%             figure;
%             for i=0:11
%                 subplot(3,4,i+1);hist(sng_data(sng_data(:,1)==i,4),0:1:5000);title(num2str(i));
%             end
%             figure;
%             for i=0:11
%                 tdc = sng_data(sng_data(:,1)==i,3);
%                 subplot(3,4,i+1);plot(tdc(1:5000));title(num2str(i));
%                 clear tdc;
%             end
        end
        
    end
end

%% 
% pause(5);
% step3_Renumber

% plot(pos(:,1),pos(:,2));