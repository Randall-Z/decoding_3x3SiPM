function [PLC_Rotate] = f_turntable(angle,rev,direc)
%UNTITLED7 此处显示有关此函数的摘要
%   此处显示详细说明

% angel为两位小数浮点数
% rev为两位小数浮点数
% direc为1正转，2反转

%% 在靖炜的基础上加上CRC校验的程序
angle_int = dec2hex(floor(angle),2);
angle_dec = dec2hex(rem(angle*100,100),2);

rev_int = dec2hex(floor(rev),2);
rev_dec = dec2hex(rem(rev*100,100),2);

direc = dec2hex(direc,2);

cmd = uint16(hex2dec(['01'; '10'; '01'; '2C'; '00'; '05'; '10'; '00'; angle_int; '00'; angle_dec; '00'; rev_int; '00'; rev_dec; '00'; direc]));

CRC_reg = uint16(hex2dec('ffff'));
for i = 1 : length(cmd)
    a = 0;
    CRC_reg = bitxor(CRC_reg,cmd(i));
    while a < 8
        low_bit = rem(CRC_reg,2);
        CRC_reg = bitshift(CRC_reg,-1);
        a = a + 1;
        if low_bit == 1
            CRC_reg = bitxor(CRC_reg,uint16(hex2dec('a001')));
        end
    end
end
CRC_L = dec2hex(rem(CRC_reg,256),2);
CRC_R = dec2hex(bitshift(CRC_reg,-8),2);

PLC_Rotate = uint8(hex2dec([dec2hex(cmd,2); CRC_L; CRC_R])); 


end

