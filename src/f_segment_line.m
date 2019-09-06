function [div] = f_segment_line(debug,data_pos,pos_1,pos_2,pos_3,pos_4)
%f_segment_line 提取阵列分割线
%   此处显示详细说明
%%  User's Manual
% Final Date:2019/06/14
% Auther:Randall
% Editor:--
% Application:6x6 crystal decodes 3x3 SiPM,calculate the segmentation lines of arrays
%%  end
if debug == 0                                   %默认状态，data_pos为257x3矩阵,值为0-256
    for i = 0:1:256
        pos_row(i+1) = i;
        pos_col = pos_row';
        data_pos_temp = [data_pos;pos_col];
    end
end
pos = [pos_1,pos_2,pos_3,pos_4];
l_temp = [];%1x6
div = [];%1x3
pos_in_order = tabulate(data_pos_temp);         %column 1-3:值，频次，占比
short_diff = [pos_1-pos_1,pos_2-pos_1,pos_3-pos_1];
%% 计算分割线
for i = 1:3
    %% 第一轮筛选
    index_extremum_tmp = find(pos_in_order(pos(i)+1:pos(i+1)+1,2) == max(pos_in_order(pos(i)+1:pos(i+1)+1,2)));
    if length(index_extremum_tmp) <= 0
        disp('ERROR!Please check your data!')
    elseif length(index_extremum_tmp) < 2
        index_extremum = index_extremum_tmp;
    else
        index_extremum = round(mean(index_extremum_tmp));
    end
    index_pos(2*i-1) = index_extremum + short_diff(i);
    l_temp(2*i-1) = pos_in_order(index_pos(2*i-1),1);
    index_0 = find(pos_in_order(pos(i)+1:pos(i+1)+1,1)>l_temp(2*i-1)-5 & pos_in_order(pos(i)+1:pos(i+1)+1,1)<l_temp(2*i-1)+5 ...
        & pos_in_order(pos(i)+1:pos(i+1)+1,1)>=0 & pos_in_order(pos(i)+1:pos(i+1)+1,1)<=256)+short_diff(i);
    pos_in_order(index_0,2) = 0;
    %% 删除后重选
    index_extremum_tmp = find(pos_in_order(pos(i)+1:pos(i+1)+1,2) == max(pos_in_order(pos(i)+1:pos(i+1)+1,2)));
    if length(index_extremum_tmp) <= 0
        disp('ERROR!Please check your data!')
    elseif length(index_extremum_tmp) < 2
        index_extremum = index_extremum_tmp;
    else
        index_extremum = round(mean(index_extremum_tmp));
    end
    index_pos(2*i) = index_extremum + short_diff(i);
    l_temp(2*i) = pos_in_order(index_pos(2*i),1);
    %% 计算、存储
    div(i) = 0.5*(l_temp(2*i-1) + l_temp(2*i));
end
end

