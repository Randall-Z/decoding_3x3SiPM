function [ data ] = f_get_data_word(valid_data, c_pkg_nums, debug)
%get_data_word ��һ����������һ��
%   �˴���ʾ��ϸ˵��
    [m n] = size(valid_data);
    data = zeros(m/c_pkg_nums, (n-2)*c_pkg_nums + 2);
    data(:,c_pkg_nums*4+1:c_pkg_nums*4+2) = valid_data(1:c_pkg_nums:end,5:6); % �����г��źͳ����
    for i = 1:c_pkg_nums
        data(:,(i-1)*4+1 : i*4) = valid_data(i:c_pkg_nums:end,1:4); %��������
    end
end

