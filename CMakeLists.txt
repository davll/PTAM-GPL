cmake_minimum_required(VERSION 2.8)
project(PTAM)

find_package(OpenCV REQUIRED)
find_package(X11 REQUIRED)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libstdc++ -D_OSX")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libstdc++ -L/opt/X11/lib")

include_directories(Src ${OpenCV_INCLUDE_DIR} ${X11_INCLUDE_DIR})

add_executable(PTAM Src/ARDriver.cc
                    Src/ATANCamera.cc
                    Src/Bundle.cc
                    Src/EyeGame.cc
                    Src/GLWindow2.cc
                    Src/GLWindowMenu.cc
                    Src/HomographyInit.cc
                    Src/KeyFrame.cc
                    Src/Map.cc
                    Src/MapMaker.cc
                    Src/MapPoint.cc
                    Src/MapViewer.cc
                    Src/MiniPatch.cc
                    Src/PatchFinder.cc
                    Src/Relocaliser.cc
                    Src/ShiTomasi.cc
                    Src/SmallBlurryImage.cc
                    Src/System.cc
                    Src/Tracker.cc
                    Src/main.cc
                    VideoSource_Linux_OpenCV.cc)

add_executable(CameraCalibrator Src/GLWindow2.cc
                                Src/GLWindowMenu.cc
                                Src/CalibCornerPatch.cc
                                Src/CalibImage.cc
                                Src/CameraCalibrator.cc
                                Src/ATANCamera.cc
                                VideoSource_Linux_OpenCV.cc)

target_link_libraries(PTAM ${OpenCV_LIBS} ${X11_LIBS}
                           -llapack -lblas -lGVars3 -lcvd -lGL)
target_link_libraries(CameraCalibrator ${OpenCV_LIBS} ${X11_LIBS}
                                       -llapack -lblas -lGVars3 -lcvd -lGL)
