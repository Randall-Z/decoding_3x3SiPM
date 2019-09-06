clear all
close all
addpath('src');   %增加函数所在路径
%打开文件
disp('step6 begin');
t = 20;
data_num = 11:15;
LOR_data_box = [];
for board_num = 1  %% 1-8
    board_num
%     for test_num = [1:109 111:229 331:975 977:1080]
    for test_num = data_num
        test_num
        filename =['..\raw\matlab_12evtmodule\data_12module_' num2str(t) 's_' num2str(test_num)];
        load([filename '_board' num2str(board_num) 'and' num2str(board_num+8) '_coincidence_data.mat']);
        LOR_data=[];
        for board = 1:2
            if board == 1
                eng(:,1:9) = round(couple_data(:,4:12));
                eng(:,10) = couple_data(:,2);
                decode_couple_data = [couple_data(:,1:2) ones(length(couple_data),1) couple_data(:,3)];
            else
                eng(:,1:9) = round(couple_data(:,16:24));
                eng(:,10) = couple_data(:,14);
                decode_couple_data = [couple_data(:,13:14) ones(length(couple_data),1) couple_data(:,15)];
            end
            %%整理重心算法的数据
            [locs,max_channel] = max(eng(:,1:9),[],2);
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
            clear eng_sort;
        %     %% energy window
        %     offset_l = 350;
        %     offset_h = 650;
        %     
        %     eng_total = sum(eng(:,1:9),2);
        %     [loc_511kev,max_count] = mode(eng_total);
        %     eng_total = eng_total*511./loc_511kev;
        %     index_eng_window = find(eng_total > offset_l & eng_total < offset_h );
        %     eng =eng(index_eng_window,:);
        %     sng_data = sng_data(index_eng_window,:);
        %     clear index_eng_window;

            for evt_num = [1 4 7 10]
                index=(eng(:,10)==evt_num);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Step2: Analyze array1, Method 1: center of gravity flood map (global, SiPM 3mm)
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %解码控制参数
                flood_size=256; %64; %128; %256;
                sampling_precision_ratio=1; %8;
                %解码区域选择
                temp=[1 2 3];
                SiPM_arry_index=[temp;temp+3;temp+6];
                %能量处理？？？？？？
                eng_round=round(eng(index,:)/sampling_precision_ratio);
                %每次事件各行各列总能量初始零向量
                array_eng_Col=zeros(length(eng_round),3);
                array_eng_Row=zeros(length(eng_round),3);
                %解码区域每次事件每列总能量
                for i=1:3
                    for j=1:3
                        temp_index=SiPM_arry_index(i,j);
                        array_eng_Col(:,i)=array_eng_Col(:,i)+eng_round(:,temp_index);
                    end
                end
                %解码区域每次事件每行总能量
                for i=1:3
                    for j=1:3
                        temp_index=SiPM_arry_index(j,i);
                        array_eng_Row(:,i)=array_eng_Row(:,i)+eng_round(:,temp_index);
                    end
                end

                clear eng_round
                %各列能量总和求各次事件总能量
                array_total_eng= array_eng_Col(:,1) + ...
                    array_eng_Col(:,2) + ...
                    array_eng_Col(:,3);
                flood_map=zeros(flood_size,flood_size);

        %         figure; hist(array_total_eng,10000);xlim([0 2500]);ylim([0 7000]);title('30v');hold on %总能谱校准
        %         xlabel('Energy');
        %         ylabel('Events');
        %         title('Total energy spectrum @30V');
        %         grid on;
                %重心法求列坐标（x坐标）
                x_pos=round((array_eng_Col(:,2)+ ...
                    2*array_eng_Col(:,3) ...
                    )./array_total_eng/2*flood_size);
                %重心法求行坐标（y坐标）
                y_pos=round((array_eng_Row(:,2)+ ...
                    2*array_eng_Row(:,3) ...
                    )./array_total_eng/2*flood_size);
                %% 多重高斯拟合,6个峰
                % M   - number of gaussians which are assumed to compose the distribution
                % M取值在10-15比较合适，过高或过低均会造成一定程度的误判
                % M在此处取10
                % 如果遇到自动分割不合适的，可自行加偏移量微调
                % 如果实在难以分割，请重做实验或采用更智能的分割方法
                [u_x,sig_x,t_x,iter_x] = f_fit_mix_gaussian(x_pos,12);
                [u_y,sig_y,t_y,iter_y] = f_fit_mix_gaussian(y_pos,12);
                x_a = 0.5*(u_x(1)+u_x(2));
                x_b = 0.5*(u_x(6)+u_x(7));
                x_c = 0.5*(u_x(11)+u_x(12));
                y_a = 0.5*(u_y(1)+u_y(2));
                y_b = 0.5*(u_y(7)+u_y(6));
                y_c = 0.5*(u_y(11)+u_y(12));
                x_edge = [0,x_a,85,x_b,171,x_c,256];
                y_edge = [0,y_a,85,x_b,171,y_c,256];
    %             % 分割为36个block的flood map
    %             for i=1:length(array_total_eng)
    %                 if x_pos(i)>0 && x_pos(i)<flood_size && y_pos(i)>0 && y_pos(i)<flood_size ...
    %                     flood_map(x_pos(i),y_pos(i))=flood_map(x_pos(i),y_pos(i))+1;
    %                 end
    %             end
                clear array_total_eng array_eng_Row array_eng_Col;
    %             fig2=figure('color','w');
    %             imagesc(flood_map);colorbar; %colormap gray
    %             hold on; x= 1:256;  y = y_edge(2)*ones(256,1);plot(x,y,'w')
    %             hold on; x= 1:256;  y = y_edge(4)*ones(256,1);plot(x,y,'w')
    %             hold on; x= 1:256;  y = y_edge(6)*ones(256,1);plot(x,y,'w')
    %             hold on; y= 1:256;  x = y_edge(2)*ones(256,1);plot(x,y,'w')
    %             hold on; y= 1:256;  x = y_edge(4)*ones(256,1);plot(x,y,'w')
    %             hold on; y= 1:256;  x = y_edge(6)*ones(256,1);plot(x,y,'w')
                crystal_x = sum(x_edge < x_pos,2);
                crystal_x(crystal_x==0) = 1;

                crystal_y = sum(y_edge < y_pos,2);  
                crystal_y(crystal_y==0) = 1;

               %% 按照仁冬给的对应图来编码，这个编码使晶体编码方向顺着12个模块的方向，避免后面编码会绕
                crystal_num = 36 - ((crystal_x - 1) * 6 + crystal_y);
                clear crystal_x crystal_y x_pos y_pos;
                if board == 1 
                    decode_couple_data(couple_data(:,2)==evt_num,3) = crystal_num;
                else
                    decode_couple_data(couple_data(:,14)==evt_num,3) = crystal_num;
                end

        %        %% 各晶体上事件能谱
        %         figure;
        %         for num = 1 : 36
        %             eng_total = sum(eng(:,1:9),2);
        %             subplot(6,6,num);hist(eng_total(crystal_num==num),0:1:2000);xlim([0 3000]);
        %         end
            end
            clear sng_data;
            LOR_data = [LOR_data decode_couple_data];
        end
        LOR_data_box = [LOR_data_box; LOR_data];
        clear couple_data decode_couple_data eng LOR_data;
    end
end
LOR_data = LOR_data_box;
save([filename '_LOR_data.mat'],'LOR_data');
