/**
 * @author Adam Jędrzejowski <adam@jedrzejowski.pl>
 * @file kalman.cpp
 */

#include <fstream>
#include <iostream>
#include <sstream>
#include <vector>

using namespace std;

ifstream realXFile, mesXFile, mesVFile;
vector<double> realXData, mesXData, mesVData;
const double T = 0.01;

void readFileContent(ifstream &file, vector<double> &data) {

	string line;
	double number;

	while (std::getline(file, line)) {
		istringstream(line) >> number;
		data.push_back(number);
	}
}

void kalmanFilter(vector<double> &from, vector<double> &to, double Q, double R, double offset) {

	double x = 0, P = 0, K;

	for(std::vector<int>::size_type i = 1; i < from.size(); i++){

		P = P + Q;
		K = P / (P + R);
		x = x + K * (from[i - 1] - x) - offset;
		P = (1 - K) * P;

		to[i] = x;
	}
}

int main() {
	double temp = 0;

	realXFile.open("rzeczywiste_polozenie.csv");
	mesXFile.open("zmierzone_polozenie.csv");
	mesVFile.open("zmierzona_predkosc.csv");

	if (!realXFile.good() || !mesVFile.good() || !mesVFile.good()) {
		cerr << "Któryś z plików nie został wczytany";
		exit(1);
	}

	readFileContent(realXFile, realXData);
	readFileContent(mesXFile, mesXData);
	readFileContent(mesVFile, mesVData);

	unsigned long size = realXData.size();

	ofstream output("polozenie_wyliczone.csv");
	vector<double> kalmanX1Data(size);
	vector<double> kalmanX2Data(size);
	vector<double> kalmanV1Data(size);

	kalmanFilter(mesXData, kalmanX1Data, 0.9, 775, 0);
	kalmanFilter(kalmanX1Data, kalmanX2Data, 5, 500, 0);
	kalmanFilter(mesVData, kalmanV1Data, 5, 500, 0.004);

	output << std::scientific;

	double velocitySum = 0;

	for (std::vector<int>::size_type i = 1; i < size; i++) {
		velocitySum = velocitySum + kalmanV1Data[i - 1] * T;

		temp = (velocitySum +
				kalmanX2Data[i] +
				kalmanX2Data[i-1] + kalmanV1Data[i-1]*T
			) / 3;
		output << temp << endl;
	}

	cout << "Wyniki zapisano do: 'polozenie_wyliczone.csv'" << endl;

	return 0;
}