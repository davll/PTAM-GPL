/*
* Autor : Arnaud GROSJEAN (VIDE SARL)
* This implementation of VideoSource allows to use OpenCV as a source for the video input
* I did so because libCVD failed getting my V4L2 device
*
* INSTALLATION :
* - Copy the VideoSource_Linux_OpenCV.cc file in your PTAM directory
* - In the Makefile:
*	- set the linkflags to
	LINKFLAGS = -L MY_CUSTOM_LINK_PATH -lblas -llapack -lGVars3 -lcvd -lcv -lcxcore -lhighgui
*	- set the videosource to 
	VIDEOSOURCE = VideoSource_Linux_OpenCV.o
* - Compile the project
* - Enjoy !
* 
* Notice this code define two constants for the image width and height (OPENCV_VIDEO_W and OPENCV_VIDEO_H)
*/

#include "VideoSource.h"
#include <cvd/colourspace_convert.h>
#include <cvd/colourspaces.h>
#include <gvars3/instances.h>
#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>

using namespace CVD;
//using namespace std;
using namespace GVars3;
//using namespace cv;

VideoSource::VideoSource()
{
  std::cout << "  VideoSource_Linux: Opening video source..." << std::endl;
  
  cv::VideoCapture* cap = new cv::VideoCapture(0);
  mptr = cap;
  
  if(!cap->isOpened()){
    std::cerr << "Unable to get the camera" << std::endl;
    std::exit(-1);
  }
  std::cout << "  ... got video source." << std::endl;
  
  int width = (int) cap->get(cv::CAP_PROP_FRAME_WIDTH);
  int height = (int) cap->get(cv::CAP_PROP_FRAME_HEIGHT);
  
  mirSize = ImageRef(width, height);
};

ImageRef VideoSource::Size()
{ 
  return mirSize;
};

void VideoSource::GetAndFillFrameBWandRGB(Image<byte> &imBW, Image<Rgb<byte> > &imRGB)
{
  cv::VideoCapture* cap = (cv::VideoCapture*)mptr;
  cv::Mat frame;
  
  *cap >> frame;
  
  cv::Mat bw(frame.size(), CV_8UC1, imBW.data(), imBW.row_stride());
  cv::Mat rgb(frame.size(), CV_8UC3, imRGB.data(), imRGB.row_stride());
  
  cv::cvtColor(frame, bw, cv::COLOR_BGR2GRAY);
  cv::cvtColor(frame, rgb, cv::COLOR_BGR2RGB);
}


