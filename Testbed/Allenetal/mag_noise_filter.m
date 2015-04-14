function [] = mag_noise_filter()
%Requires: mag_A_time.txt and mag_B_time.txt to be properly formatted text files
%Modifies: nothing
%Effects: functions in correct order of operation, calculates 

openfiles; 
D_list_calc(mag_A, mag_B); 
correlation_calc(mag_A, mag_B, D_list);
interference(D_list, C_1, C_2);

plotting(x, a, D_list, k, time);

%print k value to command window
k


    %/////////////////////////////////////////
    
    function openfiles
    %Requires: mag_A_time.txt and mag_B_time.txt to be properly formatted text files
    %Modifies: nothing
    %Effects: opens mag_A.txt and mag_B.txt for reading
    
        fileID = fopen('mag_A_time.txt', 'r');
        magA = textscan(fileID,'%s %s');
        fclose(fileID);
        times = magA{1};
        measurements_A = magA{:,2}; 
        
        fileID = fopen('time_stamps.dat','wt');
        [nrows,ncols] = size(times);        
        for row = 1:nrows
            fprintf(fileID,'%s \n',times{row,:});
        end
        fclose(fileID);
             
        fileID = fopen('mag_A.dat','wt');
        [nrows,ncols] = size(measurements_A);
        for row = 1:nrows
            fprintf(fileID,'%s \n',measurements_A{row,:});
        end
        fclose(fileID);
             
        fileID = fopen('mag_B_time.txt');
        magB = textscan(fileID, '%s %s');
        fclose(fileID);
        measurements_B = magB{:,2};
        
        fileID = fopen('mag_B.dat','wt');
        [nrows,ncols] = size(measurements_B);
        for row = 1:nrows
            fprintf(fileID,'%s \n',measurements_B{row,:});
        end
        fclose(fileID);
        
        mag_A = textread('mag_A.dat');
        mag_B = textread('mag_B.dat');
        mag_A = mag_A(:,1);
        mag_B = mag_B(:,1);
        
        %counts of number of data points we have   
        fid = fopen('mag_A_time.txt','r');
        fseek(fid, 0, 'eof');
        chunksize = ftell(fid);
        fseek(fid, 0, 'bof');
        ch = fread(fid, chunksize, '*uchar');
        nol = sum(ch == sprintf('\n')); % number of lines 
        fclose(fid)

        time = [1:nol]; %sets up "time" matrix for x axis in graphing

    end

    %/////////////////////////////////////////
    
    function D_list_calc(mag_A, mag_B)
    %Requires: mag_A.txt and mag_B.txt to be properly formatted text files
    %Modifies: D_list
    %Effects: subtracts mag_A from mag_B, stores results in D_list

        D_list = mag_B - mag_A;

    end

    %/////////////////////////////////////////
    
    function correlation_calc(mag_A, mag_B, D_list)
    %Requires: mag_A.txt, mag_B.txt and D_list must be same size
    %Modifies: C_1, C_2
    %Effects: C_1 is the correlation between D_list and mag_A
    %         C_2 is the correlation between D_list and mag_B
    
        C_1 = sum(mag_A.* D_list);
        C_2 = sum(mag_B.* D_list);
 
    end

    %/////////////////////////////////////////
    
    function interference(D_list, C_1, C_2)
    %Requires: valid D_list, C_1, C_2 (correlation values) 
    %Modifies: nothing
    %Effects: calculates k constant, x (ambient), a (interference)
    %         x and a are both arrays. 
    
   
        k = C_1/C_2;
        a = D_list./(k-1);
        x = mag_A - a;
    
        %Reads in the times from a text file
        
        time_file = fopen('time_stamps.dat');
        timeline = fgetl(time_file);
        n=1;
        
        while(ischar(timeline))
            times_cell{n} = timeline;
            timeline = fgetl(time_file);
            n=n+1;
        end
        
        fclose(time_file);

        times_char_array = char(times_cell);

        fileID = fopen('Results.txt','wt');
        fprintf(fileID, '%s \t %s \t %s \n', 'times', 'a', 'x');
        fprintf(fileID, '\n');
        
        [nrow, ncol]= size(times_char_array);
        for i= 1:nrow
            fprintf(fileID, '%s \t \t %f5 \t \t %f5 \n', times_char_array(i,:), a(i), x(i));
            fprintf(fileID, '\n');
        end
        
    end

    %//////////////////////////////////////

    function plotting(x_n, a_n, D_list, k, time)
    %Requires: valid x_n, a_n, D_list, k arrays. time must be a matrix of 
    %          integers the same size as x_n and a_n
    %Modifies: nothing
    %Effects: Generates graphs for B1, B2, a, x. 

        %functions to plot
    
        B1 = x_n + a_n;
        B2 = x_n + k*a_n;

        % B1 plot
            figure(1)
            subplot(2,2,1)
            plot(time, B1)
            ylim([-0.001 0.001]) %adjusts y axis range
            hold on;
            title('B1(n)')
            ylabel('Mag Field Strength')
            xlabel('n')
            hold off;

        %B2 plot
            subplot(2,2,2)
            plot(time, B2)
            ylim([-0.001 0.001]) %adjusts y axis range
            hold on;
            title('B2(n)')
            ylabel('Mag Field Strength')
            xlabel('n')
            hold off;

        %x_n plot
            subplot(2,2,3)
            plot(time, x_n)
            ylim([-0.001 0.001]) %adjusts y axis range
            hold on;
            title('x(n)')
            ylabel('Mag Field Strength')
            xlabel('n')
            hold off;

        %a_n plot
            subplot(2,2,4)
            plot(time, a_n)
            ylim([-0.001 0.001]) %adjusts y axis range
            hold on;
            title('a(n)')
            ylabel('Mag Field Strength')
            xlabel('n')
            hold off;
    end

    %//////////////////////////////////////
    
end

