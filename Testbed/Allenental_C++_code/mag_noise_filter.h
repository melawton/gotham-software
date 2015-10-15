#include <vector>
//function names a directly lifted from the function names given in the .m version of this gile
using namespace std;


#ifndef MAG_NOISE_FILTER
#define MAG_NOISE_FILTER

const int HOUR_TO_SECONDS = 360; //used to convert hours to seconds
const int MINUTES_TO_SECONDS = 60 //used to convert minu
//magA and B in files hold both time and field info
//d list is  just the difference
//c1 and c2 are just numbers 
//times are stored as seconds

//Requires: the files represented by aFile and bFile must be well formed and all vectors must be empty
//Modifies: magA, timeA, magB, timeB
//Effects: reads data from both files and stores the magnetic field measurement into the corresponding mag vect
//         and stores the time stamp (converted to seconds i.e. 01:00:00 ->360) into the correct time array
void openFiles(vector<double> &magA, vector<double> &timeA , vector<double> &magB, vector<double> &timeB
			   string aFile, string bFile);
void correlation_calc(const vector<double> &magA, const vector<double> &magB);
void D_list_calc(const vector<double> &magA, const vector<double> &magB);
void interference(const vector<double> &magA, const vector<double> &magB);

#endif
