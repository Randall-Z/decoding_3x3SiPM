function [ data ] = f_get_valid_data(train_data, c_train_len, c_coach_len, c_pkg_nums, debug)
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
    train_head_index = 1:c_train_len:length(train_data);
    train_head_index = train_head_index';
    train_num = train_data(train_head_index,2);

    if debug == 1
        diff_train_num = diff(train_num);
        figure;plot(diff_train_num);
        find(diff_train_num ~= 1 & diff_train_num ~= -255)
    end
    
    train_num_ls = repmat(train_num, 1, c_train_len)';
    train_num_ls = train_num_ls(:);
    data = [train_data, train_num_ls]; % 在列车数据的每一行后面加上列车号

    delete_index = [train_head_index,train_head_index+1,train_head_index+c_train_len-2,train_head_index+c_train_len-1];
    delete_index = delete_index';
    delete_index = delete_index(:);
    data(delete_index,:) = []; % 删除车头车尾

    coach_index = c_coach_len:c_coach_len:length(data);
    coach_num = data(coach_index,3);
    if debug == 1
        diff_coach_num = diff(coach_num);
        figure;plot(diff_coach_num);
        find(diff_coach_num ~= 1 & diff_coach_num ~= -15)
    end
    
    coach_num_ls = repmat(coach_num, 1, c_coach_len)';
    coach_num_ls = coach_num_ls(:);
    data = [data, coach_num_ls]; % 在列车数据的每一行后面加上车厢号
    
    pager_cnt = data(c_coach_len :c_coach_len : end,2);
    pager_cnt(rem(pager_cnt/c_pkg_nums,1)~=0) = 0; % 剔除有效数据不是整事件字长的索引

    pager_cnt_ls = repmat(pager_cnt, 1, c_coach_len)';
    pager_cnt_ls = pager_cnt_ls(:);

    data(pager_cnt_ls==0,:) = []; % 删除所有空车厢
    coach_index = c_coach_len:c_coach_len:length(data);
    data(coach_index,:) = []; % 删除车头车尾

    index = 1:c_pkg_nums:length(data);
    index = index';
    
    delete_flag = zeros(length(data)/c_pkg_nums,1); % 一次判断一整个事件数据长度是否为空车数据
    for i = 1:c_pkg_nums
        p1 = find(sum(data(index+i-1,2:4) == [128 128 128],2) == 3); % 找2到4列全为128的行
        delete_flag(p1) = delete_flag(p1) + 1; % 将标记数累加起来，空车数据的累加值将为c_pkg_nums
    end
    delete_flag = repmat(delete_flag,1,c_pkg_nums)';
    
    delete_flag = delete_flag(:);
    data(delete_flag == c_pkg_nums,:)=[]; % 剔除空数据（即删除标记数等于c_pkg_nums的行）
end

