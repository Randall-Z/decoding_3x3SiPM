clear all;
close all;
addpath('.\src');
%���ļ�
% eng�����и�ʽ eng1 eng2 eng3 ... eng9 evt_num
%%
test_num = 890 %�ļ���ţ�e.g.1��2��...��2048��...
% test_char = 'D#4_1536_500R'   % ������Ա�ŷ�ʽ,�ɸ��ݲ������Լ��
test_char = 'A'                 % ��������
% Ĭ��ΪD100Ϊȱʡ״̬,D16
% A����װǰ���ԣ��������
% B����װ����ԣ��⽺���
Board = test_num                    % ��·���ţ����޸�//Randall
%% ʹ�ò���
if exist('num_in','var')
    test_num = num_in;
end
if exist('char_in','var')
    test_char = char_in
end
%%
filename = ['K:\Randall_temp\pico_tim_board_test20181221\pico_tim_board_test\decoding_test\data\raw\subblock_decode_test_' test_char '_' num2str(test_num) '_eng'];
% filename = ['..\raw\matlab_12evtmodule\data_12module_' test_char '_' num2str(test_num) '_eng'];
load([filename '.mat']);
eng(:,1:9) = round(eng(:,1:9)/2);
%���������㷨������
[max_eng max_channel] = max(eng(:,1:9),[],2);
eng_sort = eng;
eng_sort(max_channel == 1,[3,6,9,7,8])=0;
eng_sort(max_channel == 2,[7,8,9])=0;
eng_sort(max_channel == 3,[1,4,7,8,9])=0;
eng_sort(max_channel == 4,[3,6,9])=0;
eng_sort(max_channel == 6,[1,4,7])=0;
eng_sort(max_channel == 7,[1,2,3,6,9])=0;
eng_sort(max_channel == 8,[1,2,3])=0;
eng_sort(max_channel == 9,[1,2,3,4,7])=0;
eng = eng_sort;

%%
for evt_num=0 %�����б��Ϊ0-11����ӦӲ��#1-#12���������ͨ�������Ӧ�޸�//Randall
    CH = evt_num + 1;
    str = strcat('PicoHub Board��CH',num2str(CH),' is ready');
    disp(str)
    index=(eng(:,10)==evt_num);
    %     %���ÿ���¼������ܺ�
    evt_data = eng(index,1:end-1);
    %     evt_data = eng(:,1:end-1);
    eng_total = sum(evt_data,2);
    %ÿ��ͨ�������¼����������ܺ�
    temp=sum(evt_data);
    %     figure;imagesc(reshape(temp,3,3),[0 max(temp)])
    %     colormap gray;%//figure1-Randall
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Step1: display energy spectra
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %����λ�ù�ϵ����������ͨ�������Ե������¼�����hist
    figure;%//figure2-Randall
    temp_test=[1 2 3];
    SiPM_arry_index_test=[temp_test;temp_test+3;temp_test+6];
    for i=1:3
        for j=1:3
            subplot(3,3,(i-1)*3+j);
            temp_index_test=SiPM_arry_index_test(i,j);
            hist(eng(index,temp_index_test),0:1:3000);xlim([0 1000]);
            title(num2str(temp_index_test));
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Step2: Analyze array1, Method 1: center of gravity flood map (global, SiPM 3mm)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %������Ʋ���
    flood_size=256; %64; %128;
    sampling_precision_ratio=1; %8;
    %��������ѡ��
    temp=[1 2 3];
    SiPM_arry_index=[temp;temp+3;temp+6];
    %������������������
    eng_round=round(eng(index,:)/sampling_precision_ratio);
    %ÿ���¼���������ʼ������
    array_total_eng=zeros(length(eng_round),1);
    %ÿ���¼����и�����������ʼ������
    array_eng_Col=zeros(length(eng_round),3);
    array_eng_Row=zeros(length(eng_round),3);
    %��������ÿ���¼�ÿ��������
    for i=1:3
        for j=1:3
            temp_index=SiPM_arry_index(i,j);
            array_eng_Col(:,i)=array_eng_Col(:,i)+eng_round(:,temp_index);
        end
    end
    %��������ÿ���¼�ÿ��������
    for i=1:3
        for j=1:3
            temp_index=SiPM_arry_index(j,i);
            array_eng_Row(:,i)=array_eng_Row(:,i)+eng_round(:,temp_index);
        end
    end
    %���������ܺ�������¼�������
    array_total_eng= array_eng_Col(:,1) + ...
        array_eng_Col(:,2) + ...
        array_eng_Col(:,3);
    %     figure;hist(array_total_eng,0:1:5000);xlim([100 1000]);title('30v');hold on%//figure3-Randall
    
    %���ķ��������꣨x���꣩
    x_pos=round((array_eng_Col(:,2)+ ...
        2*array_eng_Col(:,3) ...
        )./array_total_eng/2*flood_size);
    %���ķ��������꣨y���꣩
    y_pos=round((array_eng_Row(:,2)+ ...
        2*array_eng_Row(:,3) ...
        )./array_total_eng/2*flood_size);
    %% Plan A
    %     x_peak = mode(array_total_eng);
    %     flood_map =zeros(flood_size,flood_size);
    %     offset_l = x_peak * 0.437;
    %     offset_h = x_peak * 0.174;
    %     %     array_total_eng = array_total_eng_new';
    %     flood_map=zeros(flood_size,flood_size);
    %     %����������modify the energy window here
    %     Energy_cut_low= x_peak - offset_l; %1510; %1230; %880; %690;
    %     plot([Energy_cut_low,Energy_cut_low],[0,2000],'r'); text(Energy_cut_low,1600,int2str(Energy_cut_low));hold on
    %     Energy_cut_high= x_peak + offset_h; %1880; %1520; %1270; %980;
    %     plot([Energy_cut_high,Energy_cut_high],[0,2000],'r'); text(Energy_cut_high,1600,int2str(Energy_cut_high));
    %% Plan B
    x_peak = mode(array_total_eng);
    flood_map =zeros(flood_size,flood_size);
    offset_l = 80;
    offset_h = 80;
    %     array_total_eng = array_total_eng_new';
    flood_map=zeros(flood_size,flood_size);
    %����������modify the energy window here
    Energy_cut_low= x_peak - offset_l; %1510; %1230; %880; %690;
    %     plot([Energy_cut_low,Energy_cut_low],[0,2000],'r'); text(Energy_cut_low,1600,int2str(Energy_cut_low));hold on
    Energy_cut_high= x_peak + offset_h; %1880; %1520; %1270; %980;
    %     plot([Energy_cut_high,Energy_cut_high],[0,2000],'r'); text(Energy_cut_high,1600,int2str(Energy_cut_high));
    %% Plan C
    
    %     flood_map=zeros(flood_size,flood_size);
    %     %����������modify the energy window here
    %     Energy_cut_low=240/2; %1510; %1230; %880; %690;
    %     plot([Energy_cut_low,Energy_cut_low],[0,2000],'r'); text(Energy_cut_low,1600,int2str(Energy_cut_low));hold on
    %     Energy_cut_high=340/2; %1880; %1520; %1270; %980;
    %     plot([Energy_cut_high,Energy_cut_high],[0,2000],'r'); text(Energy_cut_high,1600,int2str(Energy_cut_high));
    %     filename_fig1=[filename '.fig'];
    %     filename_jpg1=[filename '.jpg'];
    %     saveas(fig1,filename_fig1);
    %     saveas(fig1,filename_jpg1);
    % ���������������ݷֲ���floodmap
    for i=1:length(array_total_eng)
        if x_pos(i)>0 && x_pos(i)<flood_size && y_pos(i)>0 && y_pos(i)<flood_size ...
                && array_total_eng(i)*sampling_precision_ratio>Energy_cut_low ...
                && array_total_eng(i)*sampling_precision_ratio <Energy_cut_high
            flood_map(x_pos(i),y_pos(i))=flood_map(x_pos(i),y_pos(i))+1;
        end
    end
    %     fig2=figure;imagesc(flood_map);colorbar; %colormap gray//figure4-Randall
    %����floodmap
    %     filename_fig2=[filename '_Map1_' num2str(flood_size) '_R' num2str(sampling_precision_ratio) '.fig'];
    %     filename_jpg2=[filename '_Map1_' num2str(flood_size) '_R' num2str(sampling_precision_ratio) '.jpg'];
    %     saveas(fig2,filename_fig2);
    %     saveas(fig2,filename_jpg2);
    % close all;
    %% PLANA   ���Զ��ָ���㷨�����ظ�˹���,6����
    % M   - number of gaussians which are assumed to compose the distribution
    % Mȡֵ��10-15�ȽϺ��ʣ����߻���;������һ���̶ȵ�����
    % M�ڴ˴�ȡ10��
    % x---���ߣ�������������y--���ߣ�������������
    % ��������Զ��ָ���ʵģ������м�ƫ����΢��
    % ���ʵ�����Էָ������ʵ�����ø����ܵķָ��
    %     [u_x,sig_x,t_x,iter_x] = fit_mix_gaussian(x_pos,10);
    %     [u_y,sig_y,t_y,iter_y] = fit_mix_gaussian(y_pos,10);
    %     x_a = 0.5*(u_x(1)+u_x(2))-5;
    %     x_a = 0.5*(u_x(1)+u_x(2))-22;
    %     x_b = 0.5*(u_x(5)+u_x(6));
    %     x_c = 0.5*(u_x(9)+u_x(10))+19;
    %     y_a = 0.5*(u_y(1)+u_y(2))-23;
    %     y_b = 0.5*(u_y(5)+u_y(6))-1;
    %     y_c = 0.5*(u_y(9)+u_y(10))+19;
    %     x_edge = [0,x_a,85,x_b,171,x_c,256];
    %     y_edge = [0,y_a,85,x_b,171,y_c,256];
    %% PLANB    Ӳ���뷽��
%         x_a = 8.0051;
%         x_b = 128.3069;
%         x_c = 244.7712;
%         y_a = 8.4826;
%         y_b = 124.9164;
%         y_c = 246.7566;
%     x_edge = [0,x_a,85,x_b,171,x_c,256];
%     y_edge = [0,y_a,85,x_b,171,y_c,256];
    %% PLANC    �������ֱ�߷���
    debug = 0;
    div_x = f_segment_line(debug,x_pos,0,85,171,256);   
    div_y = f_segment_line(debug,y_pos,0,85,171,256);
        x_a = div_x(1);
        x_b = div_x(2);
        x_c = div_x(3);
        y_a = div_y(1);
        y_b = div_y(2);
        y_c = div_y(3);
    x_edge = [0,x_a,85,x_b,171,x_c,256];
    y_edge = [0,y_a,85,x_b,171,y_c,256];
    %% �ָ�Ϊ36��block��flood map
    for i=1:length(array_total_eng)
        if x_pos(i)>0 && x_pos(i)<flood_size && y_pos(i)>0 && y_pos(i)<flood_size ...
                && array_total_eng(i)*sampling_precision_ratio>Energy_cut_low ...
                && array_total_eng(i)*sampling_precision_ratio <Energy_cut_high
            flood_map(x_pos(i),y_pos(i))=flood_map(x_pos(i),y_pos(i))+1;
        end
    end
    fig2=figure;imagesc(flood_map);colorbar; %colormap gray
    hold on; x= 1:256;  y = y_edge(2)*ones(256,1);plot(x,y,'w')
    hold on; x= 1:256;  y = y_edge(4)*ones(256,1);plot(x,y,'w')
    hold on; x= 1:256;  y = y_edge(6)*ones(256,1);plot(x,y,'w')
    hold on; y= 1:256;  x = x_edge(2)*ones(256,1);plot(x,y,'w')
    hold on; y= 1:256;  x = x_edge(4)*ones(256,1);plot(x,y,'w')
    hold on; y= 1:256;  x = x_edge(6)*ones(256,1);plot(x,y,'w')
    str_title = strcat('Board:',num2str(Board),'  CH:',num2str(CH));
    title(str_title);
    %     %% ����ÿ��block������ͼ
    %     clear i;
    %     index_pos = [];
    %     figure;
    %     for i = 1:6
    %         for j = 1:6
    %             k = 6*(i-1)+j
    %             index_pos = find(x_pos > x_edge(i) & x_pos < x_edge(i+1) & y_pos > y_edge(j) & y_pos < y_edge(j+1));
    %             block = array_total_eng(index_pos);
    %             subplot(6,6,k);hist(block,0:1:3000);xlim([0 1000]);title(num2str(k));hold on
    %         end
    %     end
    %% ��¼�ֽ��ߵ�excel
    excel_path = strcat('..\raw\matlab_12evtmodule\Board','_test_data.xlsx');
    excel_title = {'Board','CH','x_a','x_b','x_c','y_a','y_b','y_c'};
    line_segment = [Board,CH,x_a,x_b,x_c,y_a,y_b,y_c]
%     xlswrite(excel_path,excel_title,['Board',int2str(Board)],'A1');
%     xlswrite(excel_path,line_segment,['Board',int2str(Board)],['A',int2str(CH+1)]);
end
