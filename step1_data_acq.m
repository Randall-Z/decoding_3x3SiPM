clear all;
close all;
addpath('.\src');
%%
t = 30;     %s      Acquire data for 30 seconds
test_num = 52 %�ļ���ţ�e.g.1��2��...��2048��...
% test_char = 'D#4_1536_500R'   % ������Ա�ŷ�ʽ,�ɸ��ݲ������Լ��
test_char = 'D1'                 %��������
                                %Ĭ��ΪD100Ϊȱʡ״̬,D16
                                % A����װǰ���ԣ��������
                                % B����װ����ԣ��⽺���
                                % D������pico��ذ����
init_node = 1;       % �Ƿ���Ҫ��ʼ���ڵ㣬����������ع̼�����FPAG�����ϵ������ʼ���ڵ�
node_num = 1;       % �����õĲɼ����нڵ����
data_acq_ctr = 1;   % �Ƿ���Ҫ�ɼ�����
debug = 0;
turn_table_ctr = 0;
if init_node == 1
    reset = 1; % �����ʼ���ڵ㣬�ɼ�ʱ�������λ
else
    reset = 0; % ������Ҫ��λ
end
filename = ['..\raw\matlab_12evtmodule\data_12module_' test_char '_']
f_data_acq(t,[filename num2str(test_num)], init_node, node_num, reset);

% %% ת̨ͨѶ����
% if turn_table_ctr == 1
%     delete(instrfindall);
%     s = serial('COM9');
%     % % Specify connection parameters
%     set(s,'BaudRate',19200,'DataBits',8,'StopBits',1,'Parity','EVEN','Timeout',100);
%     s.terminator = 'CR/LF';
%     fopen(s);
% end
%
% %% ���ݲɼ�
% for angle_pos = 1 % ̽�����ɼ��Ƕȣ�ģ��16ģ��ϵͳ��Ҫ8���ɼ��Ƕ�
%     if data_acq_ctr == 1
%         for test_num = data_num % ÿ���ǶȲɼ����ļ���
%             angle_pos
%             test_num
%
%             f_data_acq(t,[filename num2str(angle_pos) '_' num2str(test_num)], init_node, node_num, reset);
%             init_node = 0;
%             reset = 0;
%         end
%     end
%
%     % ת̨����
%     if turn_table_ctr == 1
%         angle = 22.50;
%         speed = 8.00;
%         % f_turntable(��λС���Ƕȣ���λС��ת�٣�����)
%         PLC_Rotate = f_turntable(angle,speed,1);  % ˳ʱ��
%         fwrite(s, PLC_Rotate);
%         pause(angle/speed + 10);
%     end
% end
%
% % ת̨��λ
% if turn_table_ctr == 1
%     angle = 22.50;
%     speed = 8.00;
%     % f_turntable(��λС���Ƕȣ���λС��ת�٣�����)
%     PLC_Rotate = f_turntable(angle,speed,2);  % ˳ʱ��
%     for n = 1:8
%         fwrite(s, PLC_Rotate);
%         pause(angle/speed + 10);
%     end
%
%     fclose(s);
% end