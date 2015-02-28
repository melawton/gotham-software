function [] = mag_noise_filter()
%Here is the code for the electromagnetic noise filtering algorithm

openfiles %this calls the openfiles function
    
    %/////////////////////////////////////////
    
    function openfiles
    %Requires: mag_A.txt and mag_B.txt to be properly formatted text files
    %Modifies: nothing
    %Effects: opens mag_A.txt and mag_B.txt for reading
        
    end

    %/////////////////////////////////////////
    
    function D_list_calc
    %Requires: mag_A.txt and mag_B.txt to be properly formatted text files
    %Modifies: D_list
    %Effects: subtracts mag_A from mag_B, stores results in D_list

    end

    %/////////////////////////////////////////
    
    function correlation_calc
    %Requires: mag_A.txt, mag_B.txt and D_list must be same size
    %Modifies: arrays C_1, C_2
    %Effects: C_1 is the correlation between D_list and mag_A
    %         C_2 is the correlation between D_list and mag_B
    
    end

end

