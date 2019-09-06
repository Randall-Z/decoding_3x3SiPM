clear all;
close all;
addpath('.\src');
%%
t = 30;     %s      Acquire data for 30 seconds
test_num = 52 %文件编号，e.g.1，2，...，2048，...
% test_char = 'D#4_1536_500R'   % 特殊测试编号方式,可根据测试情况约定
test_char = 'D1'                 %测试类型
                                %默认为D100为缺省状态,D16
                                % A：组装前测试，空气耦合
                                % B：组装后测试，光胶耦合
                                % D：批量pico相关板测试
init_node = 1;       % 是否需要初始化节点，如果重新下载固件或者FPAG重新上电后必须初始化节点
node_num = 1;       % 所采用的采集链中节点个数
data_acq_ctr = 1;   % 是否需要采集数据
debug = 0;
turn_table_ctr = 0;
if init_node == 1
    reset = 1; % 如果初始化节点，采集时必须带复位
else
    reset = 0; % 否则不需要复位
end
filename = ['..\raw\matlab_12evtmodule\data_12module_' test_char '_']
f_data_acq(t,[filename num2str(test_num)], init_node, node_num, reset);

% %% 转台通讯设置
% if turn_table_ctr == 1
%     delete(instrfindall);
%     s = serial('COM9');
%     % % Specify connection parameters
%     set(s,'BaudRate',19200,'DataBits',8,'StopBits',1,'Parity','EVEN','Timeout',100);
%     s.terminator = 'CR/LF';
%     fopen(s);
% end
%
% %% 数据采集
% for angle_pos = 1 % 探测器采集角度，模拟16模块系统需要8个采集角度
%     if data_acq_ctr == 1
%         for test_num = data_num % 每个角度采集的文件数
%             angle_pos
%             test_num
%
%             f_data_acq(t,[filename num2str(angle_pos) '_' num2str(test_num)], init_node, node_num, reset);
%             init_node = 0;
%             reset = 0;
%         end
%     end
%
%     % 转台动作
%     if turn_table_ctr == 1
%         angle = 22.50;
%         speed = 8.00;
%         % f_turntable(两位小数角度，两位小数转速，方向)
%         PLC_Rotate = f_turntable(angle,speed,1);  % 顺时针
%         fwrite(s, PLC_Rotate);
%         pause(angle/speed + 10);
%     end
% end
%
% % 转台归位
% if turn_table_ctr == 1
%     angle = 22.50;
%     speed = 8.00;
%     % f_turntable(两位小数角度，两位小数转速，方向)
%     PLC_Rotate = f_turntable(angle,speed,2);  % 顺时针
%     for n = 1:8
%         fwrite(s, PLC_Rotate);
%         pause(angle/speed + 10);
%     end
%
%     fclose(s);
% end