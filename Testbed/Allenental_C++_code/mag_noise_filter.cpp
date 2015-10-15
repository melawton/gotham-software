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

}
