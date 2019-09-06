function [ ] = data_acq(t, filename, init_node, node_num, reset)
% data_acq 采集数据
%   t 采集时间，单位s
%   init_node = 1 初始化节点；init_node = 0 不初始化节点
%   node_num 节点数目
%   reset 采集时是否要复位系统

%     op = '..\.\sw\dist\picopet\picopet.exe';
%     op = 'D:\PicoPET\test\pico_tim_board_test\host\sw\dist\picopet\picopet.exe'; %需要改为相对路径
%     op = '..\..\sw\dist\picopet\picopet.exe';
    op = 'D:\PicoPET\test\pico_tim_board_test\host\sw\dist\picopet\picopet.exe';
    trgt = '0x0000';
    
    %pin
    system([op ' -c 0x0001 ' trgt ' 0x00000000']);
    system([op ' -c 0x0001 ' trgt ' 0x00000000']);
    system([op ' -c 0x0001 ' trgt ' 0x00000000']);
    system([op ' -c 0x0001 ' trgt ' 0x00000000']);
    system([op ' -c 0x0001 ' trgt ' 0x00000000']);
    
    if init_node == true
        if node_num == 1
            % Node ID: 0x00 Node Type: 0x00
            system([op ' -c 0x0002 ' trgt ' 0x00000100']);
        end
        if node_num > 1
            trgt = '0xC000';
            system([op ' -c 0x0002 ' trgt ' 0x00000000']);
            pause(10);
            trgt = ['0x' dec2hex(node_num - 1)];
            system([op ' -c 0x0002 ' trgt ' 0x0000020' dec2hex(node_num - 1)]);%配置最后一个节点的类型
            pause(5);
            % 延时2s
            % pin最后一块板子，pin成功代表初始化成功
            system([op ' -c 0x0001 ' trgt ' 0x00000000']);
            system([op ' -c 0x0001 ' trgt ' 0x00000000']);
            system([op ' -c 0x0001 ' trgt ' 0x00000000']);
            system([op ' -c 0x0001 ' trgt ' 0x00000000']);
            system([op ' -c 0x0001 ' trgt ' 0x00000000']);
        end
    end
    % 开始采集
    system([op ' -a ' num2str(t) ' ' num2str(reset) ' -o ' filename '.dat']);
end

