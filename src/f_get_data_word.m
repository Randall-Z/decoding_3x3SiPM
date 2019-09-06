function [ data ] = f_get_data_word(valid_data, c_pkg_nums, debug)
%get_data_word 将一条数据排在一行
%   此处显示详细说明
    [m n] = size(valid_data);
    data = zeros(m/c_pkg_nums, (n-2)*c_pkg_nums + 2);
    data(:,c_pkg_nums*4+1:c_pkg_nums*4+2) = valid_data(1:c_pkg_nums:end,5:6); % 复制列车号和车厢号
    for i = 1:c_pkg_nums
        data(:,(i-1)*4+1 : i*4) = valid_data(i:c_pkg_nums:end,1:4); %复制数据
    end
end

