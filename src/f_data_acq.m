function [ ] = data_acq(t, filename, init_node, node_num, reset)
% data_acq �ɼ�����
%   t �ɼ�ʱ�䣬��λs
%   init_node = 1 ��ʼ���ڵ㣻init_node = 0 ����ʼ���ڵ�
%   node_num �ڵ���Ŀ
%   reset �ɼ�ʱ�Ƿ�Ҫ��λϵͳ

%     op = '..\.\sw\dist\picopet\picopet.exe';
%     op = 'D:\PicoPET\test\pico_tim_board_test\host\sw\dist\picopet\picopet.exe'; %��Ҫ��Ϊ���·��
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
            system([op ' -c 0x0002 ' trgt ' 0x0000020' dec2hex(node_num - 1)]);%�������һ���ڵ������
            pause(5);
            % ��ʱ2s
            % pin���һ����ӣ�pin�ɹ������ʼ���ɹ�
            system([op ' -c 0x0001 ' trgt ' 0x00000000']);
            system([op ' -c 0x0001 ' trgt ' 0x00000000']);
            system([op ' -c 0x0001 ' trgt ' 0x00000000']);
            system([op ' -c 0x0001 ' trgt ' 0x00000000']);
            system([op ' -c 0x0001 ' trgt ' 0x00000000']);
        end
    end
    % ��ʼ�ɼ�
    system([op ' -a ' num2str(t) ' ' num2str(reset) ' -o ' filename '.dat']);
end

