function [ data ] = f_get_valid_data(train_data, c_train_len, c_coach_len, c_pkg_nums, debug)
%UNTITLED5 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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
    data = [train_data, train_num_ls]; % ���г����ݵ�ÿһ�к�������г���

    delete_index = [train_head_index,train_head_index+1,train_head_index+c_train_len-2,train_head_index+c_train_len-1];
    delete_index = delete_index';
    delete_index = delete_index(:);
    data(delete_index,:) = []; % ɾ����ͷ��β

    coach_index = c_coach_len:c_coach_len:length(data);
    coach_num = data(coach_index,3);
    if debug == 1
        diff_coach_num = diff(coach_num);
        figure;plot(diff_coach_num);
        find(diff_coach_num ~= 1 & diff_coach_num ~= -15)
    end
    
    coach_num_ls = repmat(coach_num, 1, c_coach_len)';
    coach_num_ls = coach_num_ls(:);
    data = [data, coach_num_ls]; % ���г����ݵ�ÿһ�к�����ϳ����
    
    pager_cnt = data(c_coach_len :c_coach_len : end,2);
    pager_cnt(rem(pager_cnt/c_pkg_nums,1)~=0) = 0; % �޳���Ч���ݲ������¼��ֳ�������

    pager_cnt_ls = repmat(pager_cnt, 1, c_coach_len)';
    pager_cnt_ls = pager_cnt_ls(:);

    data(pager_cnt_ls==0,:) = []; % ɾ�����пճ���
    coach_index = c_coach_len:c_coach_len:length(data);
    data(coach_index,:) = []; % ɾ����ͷ��β

    index = 1:c_pkg_nums:length(data);
    index = index';
    
    delete_flag = zeros(length(data)/c_pkg_nums,1); % һ���ж�һ�����¼����ݳ����Ƿ�Ϊ�ճ�����
    for i = 1:c_pkg_nums
        p1 = find(sum(data(index+i-1,2:4) == [128 128 128],2) == 3); % ��2��4��ȫΪ128����
        delete_flag(p1) = delete_flag(p1) + 1; % ��������ۼ��������ճ����ݵ��ۼ�ֵ��Ϊc_pkg_nums
    end
    delete_flag = repmat(delete_flag,1,c_pkg_nums)';
    
    delete_flag = delete_flag(:);
    data(delete_flag == c_pkg_nums,:)=[]; % �޳������ݣ���ɾ�����������c_pkg_nums���У�
end

