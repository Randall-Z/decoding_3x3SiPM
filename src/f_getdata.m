function [data] = f_getdata(filename)
% getdata �������ļ�ȡ������
    fid=fopen([filename '.dat'],'rb');
    % fid=fopen(['.\data\' filename '.dat'],'rb');
    raw = fread(fid,'uint8');
       fclose(fid);
    raw = raw(4001:end);
    data = reshape(raw,4,length(raw)/4)';
end
