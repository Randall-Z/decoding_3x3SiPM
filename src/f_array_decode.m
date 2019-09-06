function f_array_decode(eng, max_on, map_size, res_ratio, th_l, th_h)

% eng, enery data of each channel
% max_on, use signals arround the max energy channel to decode
% map_size, flood map size 256, 128, 64
% res_ratio, energy resolution down sample ratio
% th_h, energy window upper limit
% th_l, energy window lower limit

    if max_on == 1
        [~, max_channel] = max(eng,[],2); % 寻找每个事件9个能量值中最大的通道
        eng_sort = eng;
        eng_sort(max_channel == 1,[3,6,9,7,8])=0;
        eng_sort(max_channel == 2,[7,8,9])=0;
        eng_sort(max_channel == 3,[1,4,7,8,9])=0;
        eng_sort(max_channel == 4,[3,6,9])=0;
        eng_sort(max_channel == 6,[1,4,7])=0;
        eng_sort(max_channel == 7,[1,2,3,6,9])=0;
        eng_sort(max_channel == 8,[1,2,3])=0;
        eng_sort(max_channel == 9,[1,2,3,4,7])=0;

        eng = eng_sort;
        clear eng_sort;
    end

    eng_total_per_ch = sum(eng); %每个通道所有事件能量和
    figure;imagesc(reshape(eng_total_per_ch,3,3),[0 max(eng_total_per_ch)]);colormap gray;%//figure1-Randall

    % 画出所有的通道的能谱
    figure;
    for i=0:2
        for j=1:3
            ch_num = i * 3 + j;
            subplot(3,3,i*3+j);
            hist(eng(:,ch_num),0:1:3000);xlim([0 1000]);
            title(num2str(ch_num));
        end
    end
    
    eng = round(eng/res_ratio);
    eng_total = sum(eng,2); % 每次事件总能量
    eng_col_total = [sum(eng(:,1:3:end),2) sum(eng(:,2:3:end),2) sum(eng(:,3:3:end),2)];
    eng_row_total = [sum(eng(:,1:1:3),2) sum(eng(:,4:1:6),2) sum(eng(:,7:1:9),2)];
    figure;hist(eng_total,0:1:5000);xlim([0 3000]);title(['Energy resolution down sample ratio = ' int2str(res_ratio)]);hold on;
    plot([th_l,th_l],[0,2000],'r');text(th_l,2000,int2str(th_l));hold on;
    plot([th_h,th_h],[0,2000],'r');text(th_h,2000,int2str(th_h));

    x_pos = round( (eng_col_total(:,2) + 2 * eng_col_total(:,3)) ./eng_total /2 * map_size);
    y_pos = round( (eng_row_total(:,2) + 2 * eng_row_total(:,3)) ./eng_total /2 * map_size);
    
    data = [eng_total x_pos y_pos];
    
    % 删除超出flood map范围的数据
    data(data(:,2) < 1,:) = [];         % 剔除x_pos小于1的
    data(data(:,2) > map_size,:) = [];  % 剔除x_pos大于map_size的
    data(data(:,3) < 1,:) = [];         % 剔除y_pos小于1的
    data(data(:,3) > map_size,:) = [];  % 剔除y_pos大于map_size的
    
    % 加能量窗筛选数据
    sel_data = data;
    sel_data(sel_data(:,1)<th_l,:) = [];
    sel_data(sel_data(:,1)>th_h,:) = [];
    
    % 生成flood map
    flood_map = zeros(map_size,map_size);
    for i=1:length(sel_data)
        flood_map(sel_data(i,2),sel_data(i,3))=flood_map(sel_data(i,2),sel_data(i,3))+1;
    end
    figure;imagesc(flood_map);colorbar; %colormap gray
end
