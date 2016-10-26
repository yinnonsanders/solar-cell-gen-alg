cmake_minimum_required(VERSION 3.6)
project(SolarCellOptimization)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES main.cpp Hole.h Cell.h PaperTest.cpp)
add_executable(SolarCellOptimization ${SOURCE_FILES})