#include "mag_noise_filter.h"
#include <fstream>
#include <stdlib.h>
#include <iomanip>

void openFiles(vector<double> &magA, vector<double> &timeA , vector<double> &magB, vector<double> &timeB,
			   string aFile, string bFile){
	ifstream in; //object for reading in file
	in.open(aFile);
	string temps;
  double tempd;

	double seconds; //holding variable for time
	while(in>>tempd){ //read hour place if there is a line left
		seconds = tempd * HOURS_TO_SECONDS;
		in.get(); //eat :
    in >> tempd;
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
    in >> tempd;
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
			if(timeA[i] == timeB[j]){ //if the times are the same
				D_list.push_back(magB[j] - magA[i]);  //add this to D_list
				timeD.push_back(timeA[i]); //add time to D's time
			}
		}

	}
}

double calculateC(const vector<double> &mag, const vector<double> &time, 
				  const vector<double> D_list, const vector<double> timeD){
  double sum = 0;
	for(int i = 0, leni = mag.size(); i < leni; ++i){
		for(int j = 0, lenj = D_list.size(); j < lenj; ++j){
			if(time[i] == timeD[j]){ //if the times are the same
				sum +=mag[i]*D_list[j];
			}
		}
	}
	return sum;
}


void interference(vector<double> magA, const vector<double> &timeA,
 				 const vector<double> &magB, const vector<double> &timeB, string outFile){
	vector<double> D_list;
	vector<double> timeD;
	//calculate variables needed
	D_list_calc(magA, timeA, magB, timeB, D_list, timeD);
	double c1 = calculateC(magA, timeA, D_list, timeD);
	double c2 = calculateC(magB, timeB, D_list, timeD);
	double k = c1/c2;
	vector<double> a = D_list;
	//make thhe a vector
	for(int i = 0, leni = D_list.size(); i < leni; ++i){
		a[i]/=(k-1);
	}
	//magA is now the X vector after this
	for(int i = 0, leni = magA.size(); i < leni; ++i){
		for(int j = 0, lenj = a.size(); j < lenj; ++j){
			if(timeA[i] == timeD[j]){
				magA[i] -= a[j];
			}
		}
	}
  //output to file
	ofstream out;
	out.open(outFile); //output file
  out << "time                    ambient                interference" << endl;
	for(int i = 0, leni = magA.size(); i < leni; ++i){
		for(int j = 0, lenj = a.size(); j < lenj; ++j){
			if(timeA[i] == timeD[j]){
        out <<left<< setw(20) << fixed << setprecision(10) << timeA[i] << "    " 
          << setprecision(19) << setw(20) << a[i] << "   " << setw(20) << magA[i] << endl;
			}
		}
	}
  out.close();
}

void generateReducedFile(string aFile, string bFile, string outFile){
  vector<double> magA, magB, timeA, timeB;
  openFiles(magA, timeA, magB, timeB, aFile, bFile);
  interference(magA, timeA, magB, timeB, outFile);
}


int main(){
  generateReducedFile("mag_A_time.txt", "mag_B_time.txt", "Results1.txt");




}