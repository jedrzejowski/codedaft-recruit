#include <fstream>
#include <iostream>
#include <sstream>
#include <vector>

using namespace std;

ifstream realXFile, mesXFile, mesVFile;
vector<double> realXData, mesXData, mesVData, countVData;
const double T = 0.01;

void readFileContent(ifstream &file, vector<double> &data) {

	string line;
	double number;

	while (std::getline(file, line)) {
		istringstream(line) >> number;
		data.push_back(number);
	}
}

int main() {
	double temp = 0;

	realXFile.open("../rzeczywiste_polozenie.csv");
	mesXFile.open("../zmierzone_polozenie.csv");
	mesVFile.open("../zmierzona_predkosc.csv");

	if (!realXFile.good() || !mesVFile.good() || !mesVFile.good()) {
		cerr << "Któryś z plików nie został wczytany";
		exit(1);
	}

	readFileContent(realXFile, realXData);
	readFileContent(mesXFile, mesXData);
	readFileContent(mesVFile, mesVData);

	// Wyliczam prędkość na podstawie zmierzonego położenia v = dx/dt

	countVData.reserve(2000);
	countVData.push_back(0);

	ofstream heja("../wyliczone.txt");

	heja << std::scientific;

	for (std::vector<int>::size_type i = 1; i != mesXData.size() - 1; i++) {
		// Iteruje tu od drugiej do przed ostatniej wartości

		// Wyliczenie pochodnej za pomocą rożnicy

		temp = (mesXData[i + 1] - mesXData[i - 1] ) / (2*T);
		countVData.push_back(temp);

		heja << temp << endl;

		cout<<mesXData[i + 1]<<endl;
	}

	countVData.push_back(0);

	cout << countVData.size();
	return 0;
}