clear all;
addpath('.\src');
% Radioactive_element = 'F';
Radioactive_element = 'Na';
tim_start='2018/10/1 8:01:00';
tim_end='2019/6/17 21:01:01';
act_ini = 26.6;
act_present = f_cal_radioactivity( tim_start,tim_end,act_ini,Radioactive_element)

