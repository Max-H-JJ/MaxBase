
#include <iostream>
#include <stdint.h>
//opencv headfiles
#include "opencv2/opencv.hpp"
#include<opencv2/highgui/highgui.hpp>
#include<opencv2/core/core.hpp>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/video.hpp>
#include <string.h>

using namespace std;
using namespace cv;

const string Threshold_window_name = "Threshold Demo";
const string BGR_2_HSV_window_name = "HSV Demo";
const string BGR_2_HSV_Bar_Window = "HSV track_Bar Demo";

const string Threshold_bar_name = "Threshold_track_bar";
const string BGR_2_HSV_bar_name = "HSV_track_bar";

int initial_value = 0; // initial value of trackbar 
int track_value = 255; //maxima and current value of trackbar

int H_Min = 0;
int H_Max = 255;
int S_Min = 0;
int S_Max = 255;
int V_Min = 0;
int V_Max = 255;

Mat eroded, dilated, draw_output;
void Threshold_Demo(int, void*); // function to monitor threshold change in the frame

void HSV_Demo(int, void*);//function to monitor HSV value change in the frame

void Creat_HSV_Trackbar(); // trackbar installed to finout intrested HSV value ranges

void cycle_play_vedio();
Mat  Threshold, frame, HSV_demo, HSV_filted;
int main()
{
	vector<vector<Point>> contours;
	vector<Vec4i>hierarchy;
	


	namedWindow(Threshold_window_name, WINDOW_FREERATIO);
	namedWindow(BGR_2_HSV_window_name, WINDOW_FREERATIO);
	namedWindow(BGR_2_HSV_Bar_Window, WINDOW_FREERATIO);
	namedWindow("show", WINDOW_FREERATIO);
	namedWindow("eroded", WINDOW_FREERATIO);
	namedWindow("dilated", WINDOW_FREERATIO);
	namedWindow("contours", WINDOW_FREERATIO);
	Creat_HSV_Trackbar();  
	VideoCapture vid("white.MOV");
	//frame = imread("black.PNG");
	while (vid.read(frame))
	{
		// read in stream 
		//vid >> frame;
		if (frame.empty())
		{
			cout << "File Open Error!!" << endl;
		}
		imshow("show", frame);
		// convert BGR to HSV
		cvtColor(frame, HSV_demo, COLOR_BGR2HSV);
		// filter color
		inRange(HSV_demo, Scalar(H_Min, S_Min,V_Min), Scalar(H_Max, S_Max, V_Max), HSV_filted);  
		imshow(BGR_2_HSV_window_name, HSV_filted);
		blur(HSV_filted,HSV_filted,Size(3, 3));

	
		//reate a kernel to perform erosion and diolasion of image
		Mat kernel = getStructuringElement(MORPH_RECT,Size(3,3));
		
		
		
		dilate(HSV_filted, dilated, kernel); //dilation operation
		imshow("dilated", dilated);
		erode(dilated, eroded, kernel);//erosion operation
		imshow("eroded", eroded);
		
		Threshold_Demo(1, 0); // filted and convert int binary image

		
		//find contours
		findContours(dilated, contours, hierarchy, RETR_CCOMP, CHAIN_APPROX_SIMPLE);
		
		//find bounding rects of contours
		vector<Rect>boundRect(contours.size());
		vector<vector<Point> > contours_poly(contours.size());
		//iterate all contours and conduct polygon approximation
		for (int i = 0; i < contours.size(); i++)
		{
			approxPolyDP(contours[i], contours_poly[i], 3, true);
			boundRect[i] = boundingRect(contours_poly[i]);
		}
		// draw all the contours and approximated polygon
		dilated = Mat::zeros(dilated.size(), CV_8UC3); // initialization 
		for (int i = 0; i < contours.size(); i++)
		{
			drawContours(dilated, contours_poly, i, Scalar(0,0,255), 1,8,vector<Vec4i>(),0,Point());
			rectangle(dilated, boundRect[i].tl(), boundRect[i].br(), Scalar(0,255,255), 3, LINE_8, 0);
		}
		/*namedWindow("draw_output", WINDOW_FREERATIO);
		imshow("draw_output", draw_output);*/
		imshow("contours", dilated);
		
		
		

		if (waitKey(30) >= 0)
			break;
	}
	return 0;
}

void Threshold_Demo(int, void*)
{
	createTrackbar(Threshold_bar_name, Threshold_window_name, &initial_value, track_value, Threshold_Demo);
	threshold(dilated, Threshold,initial_value,track_value,THRESH_BINARY);
	imshow(Threshold_window_name, dilated);
}

// convert BGR into HSV
void HSV_Demo(int,void*)
{
	Creat_HSV_Trackbar();
	cvtColor(frame, HSV_demo, COLOR_BGR2HSV);
	inRange(HSV_demo, Scalar(H_Min, S_Min, V_Min), Scalar(H_Max, S_Max, V_Max),HSV_filted); // filter color 
	imshow(BGR_2_HSV_window_name, HSV_filted);
}

void Creat_HSV_Trackbar()
{
	createTrackbar("H_Lower_Limit", BGR_2_HSV_Bar_Window, &H_Min, H_Max, HSV_Demo);
	createTrackbar("H_Upper_Limit", BGR_2_HSV_Bar_Window, &H_Max, 255, HSV_Demo);
	createTrackbar("S_Lower_Limit", BGR_2_HSV_Bar_Window, &S_Min, S_Max, HSV_Demo);
	createTrackbar("S_Upper_Limit", BGR_2_HSV_Bar_Window, &S_Max, 255, HSV_Demo);
	createTrackbar("V_Lower_Limit", BGR_2_HSV_Bar_Window, &V_Min, V_Max, HSV_Demo);
	createTrackbar("V_Upper_Limit", BGR_2_HSV_Bar_Window, &V_Max, 255, HSV_Demo);
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
