function [] = mag_noise_filter()
%Here is the code for the electromagnetic noise filtering algorithm

openfiles; %this calls the openfiles function
D_list_calc(mag_A, mag_B); %calculates D_list
correlation_calc(mag_A, mag_B, D_list)


interference(D_list, C_1, C_2)

    %/////////////////////////////////////////
    
    function openfiles
    %Requires: mag_A.txt and mag_B.txt to be properly formatted text files
    %Modifies: nothing
    %Effects: opens mag_A.txt and mag_B.txt for reading

        mag_A = textread('mag_A.txt');
        mag_B = textread('mag_B.txt');

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
    time_file = fopen('time_stamps_sample.txt');
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
 
    for i= 1:numel(a)
        fprintf(fileID, '%s \t \t %f5 \t \t %f5 \n', times_char_array(i,:), a(i), x(i));
        fprintf(fileID, '\n');
    end
    end

    %//////////////////////////////////////

    function plotting(x_n, a_n, D_list, k)
    %plots B1, B2, x_n, a_n in one window

    %functions to plot
    B1 = x_n - a_n;
    B2 = x_n - k*a_n;
    x_n = B1 - a_n;
    a_n = D_list./(k-1);

    % B1 plot
    figure(1)
    subplot(2,2,1)
    plot(n, B1)
    hold on;
    title('B1(n)')
    ylabel('Mag Field Strength')
    xlabel('n')
    hold off;


    %B2 plot
    subplot(2,2,2)
    plot(n, B2)
    hold on;
    title('B2(n)')
    ylabel('Mag Field Strength')
    xlabel('n')
    hold off;

    %x_n plot
    subplot(2,2,3)
    plot(n, x_n)
    hold on;
    title('x(n)')
    ylabel('Mag Field Strength')
    xlabel('n')
    hold off;

    %a_n plot
    subplot(2,2,4)
    plot(n, a_n)
    hold on;
    title('a(n)')
    ylabel('Mag Field Strength')
    xlabel('n')
    hold off;
end
end

