#include "mag_noise_filter.h"
#include <fstream>
#include <stdlib.h>
void openFiles(vector<double> &magA, vector<double> &timeA , vector<double> &magB, vector<double> &timeB
			   string aFile, string bFile){
	ifstream in; //object for reading in file
	in.open(aFile);
	string temps;
	double tempd

	double seconds; //holding variable for time
	while(in>>tempd){ //read hour place if there is a line left
		seconds = tempd * HOURS_TO_SECONDS;
		in.get(); //eat :
		in>>tempd
		seconds += tempd * MINUTES_TO_SECONDS;
		in.get(); //eat :
		in>>tempd;
		seconds += tempd;
		timeA.push_back(seconds); //add to vector
		in>>tempd; //read in magfield
		magA.push_back(tempd); //add to vector
	}
	in.close();//close file
	in.open(bFile); // open next file
	while(in>>tempd){ //read hour place if there is a line left
		seconds = tempd * HOURS_TO_SECONDS;
		in.get(); //eat :
		in>>tempd
		seconds += tempd * MINUTES_TO_SECONDS;
		in.get(); //eat :
		in>>tempd;
		seconds += tempd;
		timeB.push_back(seconds); //add to vector
		in>>tempd; //read in magfield
		magB.push_back(tempd); //add to vector
	}
}

void D_list_calc(const vector<double> &magA, const vector<double> &timeA,
 				 const vector<double> &magB, const vector<double> &timeB,
 				 vector<double> &D_list, vector<double> &timeD){
	//iterate over both magA and magB
	for(int i = 0, leni = magA.size(); i < leni; ++i){
		for(int j = 0, lenj = magB.size(); j < lenj; ++j){
			if(timeA[i] == timeB[i]){ //if the times are the same
				D_list.push_back(mag_B - mag_A);  //add this to D_list
				timeD.push_back(timeA[i]); //add time to D's time
			}
		}

	}
}

double calculateC(vector<double> &mag, vector<double> &time, vector<double> D_list, vector<double> timeD){
	sum = 0;
	for(int i = 0, leni = mag.size(); i < leni; ++i){
		for(int j = 0, lenj = D_list.size(); j < lenj; ++j){
			if(time[i] == timeD[i]){ //if the times are the same
				sum +=mag[i]*D_list[i];
			}
		}
	}
	return sum;
}