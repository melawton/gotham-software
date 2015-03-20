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

