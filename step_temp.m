clear all;
close all;

% t = 20;
% filename = 'D:\PicoPET\fw_debug\host\host\raw\matlab_rotary\data_2module_20s_1120_board1and9_coincidence_data';
% for board_num = 1
%     load([filename '.mat']);
%     delta_t = couple_data(:,3) - couple_data(:,15);
%     figure;
%     for i = [1 4 7 10]
%         for j= [1 4 7 10]
%             module_delta_t = delta_t(couple_data(:,2)==i & couple_data(:,14)==j);
%             if length(module_delta_t) >= 1
%                 subplot(4,4,(i-2)/3*4+(j+1)/3);hist(module_delta_t,min(module_delta_t):20:max(module_delta_t));...
%                 xlim([min(module_delta_t)*2 max(module_delta_t)*2]);...
%                 title([num2str(board_num) 'and' num2str(board_num+8) '-' num2str(i) 'and' num2str(j)]);
%             end
%         end
%     end
% end

% for board_num = 1  %% 1-8
%     disp('confirm');
%     for test_num = 1
%         test_num
%         filename = 'D:\PicoPET\fw_debug\host\host\raw\matlab_12evtmodule\data_12module_20s_15_LOR_data';
%         load([filename '.mat']);
%         delta_t = LOR_data(:,4) - LOR_data(:,8);
%         figure;
%         for i = [1 4 7 10]
%             for j= [1 4 7 10]
%                 module_delta_t = delta_t(LOR_data(:,2)==i & LOR_data(:,6)==j);
%                 if length(module_delta_t) >= 1
%                     subplot(4,4,(i-1)/3*4+(j+2)/3);hist(module_delta_t,min(module_delta_t):10:max(module_delta_t));...
%                 xlim([min(module_delta_t)*2 max(module_delta_t)*2]);...
%                 title([num2str(board_num) 'and' num2str(board_num+8) '-' num2str(i) 'and' num2str(j)]);
%                 end
%             end
%         end
%     end
% end


filename = 'D:\PicoPET\fw_debug\host\host\raw\matlab_12evtmodule\data_12module_20s_15_LOR_data';
load([filename '.mat']);
module_LOR_data = LOR_data(LOR_data(:,2)==7 & LOR_data(:,6)==7,:);
figure;
crystal_LOR_data = module_LOR_data((module_LOR_data(:,3)==14 | module_LOR_data(:,3)==15 | module_LOR_data(:,3)==20 | module_LOR_data(:,3)==21) &...
    (module_LOR_data(:,7)==14 | module_LOR_data(:,7)==15 | module_LOR_data(:,7)==20 | module_LOR_data(:,7)==21),:);
delta_t = crystal_LOR_data(:,4) - crystal_LOR_data(:,8);
hist(delta_t,min(delta_t):20:max(delta_t));

        
% 
% for board_num = 1  %% 1-8
%     disp('confirm');
%     for test_num = 1
%         test_num
%         filename = 'D:\PicoPET\fw_debug\host\host\raw\matlab_rotary\data_2module_20s_2_board1and9_coincidence_data';
%         load([filename '.mat']);
%         delta_t = couple_data(:,3) - couple_data(:,15);
%         figure;
%         for i = [2 5 8 11]
%             for j= [2 5 8 11]
%                 module_delta_t = delta_t(couple_data(:,2)==i & couple_data(:,14)==j);
%                 subplot(4,4,(i-2)/3*4+(j+1)/3);hist(module_delta_t,min(module_delta_t):10:max(module_delta_t));...
%                 xlim([min(module_delta_t)*2 max(module_delta_t)*2]);...
%                 title([num2str(board_num) 'and' num2str(board_num+8) '-' num2str(i) 'and' num2str(j)]);
%             end
%         end
%     end
% end


%%数据量太少
%%14w符合事件，按模块划分，均匀的话对角线符合事件小于3w，再按照晶体划分，也是对角线分布的话，最多每个晶体上小于600个事件。
% load(['D:\PicoPET\fw_debug\host\host\raw\data_16module_3000s_board_LOR_data.mat']);
% for i = 0:3
%     figure;
%     module_LOR_data = LOR_data(LOR_data(:,2)==i & LOR_data(:,6)==i,:);
%     for crystal_num0 = 0:5
%         for crystal_num1 = 1:6
%             crystal_LOR_data = module_LOR_data(module_LOR_data(:,3)==crystal_num0*6+crystal_num1 & module_LOR_data(:,7)==crystal_num0*6+6-crystal_num1,:);
%             crystal_delta_t = crystal_LOR_data(:,4) - crystal_LOR_data(:,8);
%             if length(crystal_delta_t) > 1 
%                 subplot(10,10,(crystal_num0-26)*10+crystal_num1-25);hist(crystal_delta_t,min(crystal_delta_t):1:max(crystal_delta_t));...
%                 xlim([min(crystal_delta_t)*2 max(crystal_delta_t)*2]);...
%                 title([num2str(i) 'and' num2str(j) '-' num2str(crystal_num0+1) 'and' num2str(crystal_num1+1)]);
%             end
%         end
%     end
% end


% c1 = zeros(512,512);
% for i = 1:4
%     h1=open(['double_' num2str(i) '.fig']);
%     a1=get(h1);
%     b1=a1.CurrentAxes.Children.CData;
%     c1 = c1 + b1;
% end
%  figure;imagesc(c1)



% clear all;
% LOR_data_box=[];
% load('D:\PicoPET\fw_debug\host\host\raw\data_16module_3000s_board_LOR_data.mat');
% for i = [2 5 8 11]
%     LOR_data_1 = LOR_data(LOR_data(:,2)==i & LOR_data(:,6)==i,:);
%     LOR_data_box = [LOR_data_box; LOR_data_1];
% end
% LOR_data = LOR_data_box;
% save('data_16module_3000s_board_LOR_data.mat','LOR_data');




