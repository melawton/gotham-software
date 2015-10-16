#include <vector>
//function names a directly lifted from the function names given in the .m version of this gile
using namespace std;


#ifndef MAG_NOISE_FILTER
#define MAG_NOISE_FILTER

const int HOURS_TO_SECONDS = 360; //used to convert hours to seconds
const int MINUTES_TO_SECONDS = 60; //used to convert minu
//mag_a mag_b hold the count
//d list is  just the difference
//c1 and c2 are just numbers 
//times are stored as seconds

//Requires: the files represented by aFile and bFile must be well formed and all vectors must be empty
//Modifies: magA, timeA, magB, timeB
//Effects: reads data from both files and stores the magnetic field measurement into the corresponding mag vect
//         and stores the time stamp (converted to seconds i.e. 01:00:00 ->360) into the correct time array
void openFiles(vector<double> &magA, vector<double> &timeA , vector<double> &magB, vector<double> &timeB,
			   string aFile, string bFile);
//Requires: all vectors have been filled correctly
//Modifies: D_list, timeD
//Effects: Fills in D_list and timeD
//NOTE: This version is a little more abstracted than the other version in matlab
//this allows for the case whwere magA and magBs times arent synced
void D_list_calc(const vector<double> &magA, const vector<double> &timeA,
 				 const vector<double> &magB, const vector<double> &timeB,
 				 vector<double> &D_list, vector<double> &timeD);
//Requires: all vectors have been filled correctly and the correct time list is passed with each mag vector
//Modifies: nothing
//Effect: returns the correlation coeffition for what ever mag list is passed
double calculateC(const vector<double> &mag, const vector<double> &time, 
				  const vector<double> D_list, const vector<double> timeD);
//Requires: all vectors are properly initialized
//modifies: ntohing
//Effects: performs noise filtering on the two readings and outputs a file in the format of the matlab version
void interference(vector<double> magA, const vector<double> &timeA,
  const vector<double> &magB, const vector<double> &timeB, string outFile);
//Requires: aFile and bFile are the file names of valid magnetometer reading files
//modifies: nothing
//Effects: performs noise filering on the two files and outputs a filtered file.
void generateReducedFile(string aFile, string bFile, string outFile);

#endif
