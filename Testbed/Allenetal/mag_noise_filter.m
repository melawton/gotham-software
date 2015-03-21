function [] = mag_noise_filter()
%Here is the code for the electromagnetic noise filtering algorithm

C_1_sample = 24 %placeholder values until correlation_calc function is done
C_2_sample = 22

openfiles; %this calls the openfiles function

D_list_calc(mag_A, mag_B); %calculates D_list

%interference(D_list, C_1, C_2)

    %/////////////////////////////////////////


    function openfiles
    %Requires: mag_A.txt and mag_B.txt to be properly formatted text files
    %Modifies: nothing
    %Effects: opens mag_A.txt and mag_B.txt for reading

    %opens the files & checks to see if they open correctly.
    %saves the time stamps from mag_A_time and mag_B_time in time_stamp_A and
    %time_stamp_B.


    mag_A_time = fopen('mag_A_time.txt');
        if mag_A_time == -1
            disp('File open not successful')
        else
            while feof(mag_A_time) == 0
                time_stamp_A = textscan(mag_A_time, '%s %f')
            end
        end

    mag_B_time = fopen('mag_B_time.txt');
        if mag_B_time == -1
            disp('File open not successful')
        else
            while feof(mag_B_time) == 0
                time_stamp_B = textscan(mag_B_time, '%s %f')
            end
        end

        fclose(mag_A_time);
        fclose(mag_B_time);

%now should have 1x2 cell array "time_stamp_A" where the first element in the cell array is a column vector of strings (the time stamps) and the second element is a column vector of doubles (the data for mag_A)time_stamp_B to check this, time_stamp_A[1] should return the time stamps in a column vector and time_stamp_A[2] should return the data for mag_A to be subtracted from mag_B.time_stamp_B. does exact same thing for mag_B_time. changes the name of the second column vectors to mag_A and mag_B

        mag_A = time_stamp_A{2};
        mag_B = time_stamp_B{2};
        time_stamps = time_stamp_A{1};


    end

    %/////////////////////////////////////////

    function D_list_calc(mag_A, mag_B)
    %Requires: mag_A.txt and mag_B.txt to be properly formatted text files
    %Modifies: D_list
    %Effects: subtracts mag_A from mag_B, stores results in D_list

    D_list = mag_B - mag_A;

    end

    %/////////////////////////////////////////
    
    function correlation_calc
    %Requires: mag_A.txt, mag_B.txt and D_list must be same size
    %Modifies: C_1, C_2
    %Effects: C_1 is the correlation between D_list and mag_A
    %         C_2 is the correlation between D_list and mag_B
    C_1 = mag_A.txt.* D_list;
    C_2 = mag_B.txt.* D_list;
    C_1
    C_2
    
    
    end

    %/////////////////////////////////////////
    
    function interference(D_list, C_1_sample, C_2_sample)
    %Requires: valid D_list, C_1, C_2 (correlation values) 
    %Modifies: nothing
    %Effects: calculates k constant, x (ambient), a (interference)
    %         x and a are both arrays. 
    
    end
end

