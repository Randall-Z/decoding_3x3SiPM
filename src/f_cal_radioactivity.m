function [act_present] = f_cal_radioactivity( tim_start,tim_end,act_ini,Radioactive_element)
%f_cal_radioactivity ͨ����ֹʱ�䡢��ʼ��ȼ��㵱ǰ�����Ի��
%   �˴���ʾ��ϸ˵��
%%  User's Manual
% Date:2019/06/19
% Auther:Randall
% Editor:--
% Application:Calculating current radioactivity by start-stop time and initial activity
%%  end
%% example
% Radioactive_element = 'Na';
% tim_start='2018/10/1 8:01:00';
% tim_end='2019/6/17 21:01:01';
% act_ini = 26.6;%uCi
t1 = datevec(tim_start,'yyyy/mm/dd HH:MM:SS');
t2 = datevec(tim_end,'yyyy/mm/dd HH:MM:SS');
delta_t = etime(t1,t2)/3600;
%% ��minΪ��λ,���÷�����Ԫ�ذ�˥�����£�
%t = ����ʱ��/��˥�ڣ�N0/N=��1/2��**t
%����Ծ���Ϊ��λ
t_F18_half = 109.771;
t_Na22_half = 2.6019*365*24;
switch Radioactive_element
    case 'Na'
        t = delta_t/t_Na22_half;
    case 'F'
        t = delta_t/t_F18_half;
    otherwise
        disp('ERROR!Please check Radioactive_element!')
        t = [];
end
%% ERROR!
if delta_t>0 
    disp('ERROR!Please check time input!')
    t = [];
end
%% ���
act_present = exp(log(act_ini) - log(0.5)*t);
end

