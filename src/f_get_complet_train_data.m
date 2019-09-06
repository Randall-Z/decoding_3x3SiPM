function [ train_data ] = f_get_complet_train_data(data,c_train_len, debug)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
    train_head_8bit = 254;
    %train_end_8bit = 253;
    
    p1 = find(data(:,4) == train_head_8bit);
    p2 = p1 + 1;
    if  max(p2) > length(data)
        p2 = p2(1:end - 1);
    end

    train_head_index = p2((data(p2,4) == train_head_8bit) & (data(p2,1) == 0) & (data(p2,2) == 0) &(data(p2,3) == 0));
    %train_cnt = length(train_head_index);
    train_len = diff(train_head_index);

    if debug == 1
        figure;plot(train_len(1:15000));
        figure;hist(train_len,0:1:1000);xlim([0 1000]);

        train_num = data(train_head_index - 1, 2);
        figure;plot(train_num(1:4096));
    end
    
    complet_train_head_index = train_head_index(train_len == c_train_len) - 1;
    complet_train_cnt = length(complet_train_head_index);

%     train_data = zeros(complet_train_cnt * c_train_len,4);
%     head_index = 1 : c_train_len : c_train_len * complet_train_cnt;
%     head_index = head_index';
    % 提取完整列车的数据，这一步速度很慢
%     for i = 0 : 1 : c_train_len - 1
%         train_data(head_index + i,:) = data(complet_train_head_index + i,:);
%     end
    index = repmat(complet_train_head_index,1,c_train_len); % 将head_index复制c_train_len列
    index = index + repmat(0:1:c_train_len - 1,complet_train_cnt,1);
    index = index';
    index = index(:);
    train_data = data(index,:);  
end

