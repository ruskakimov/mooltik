cmake_minimum_required(VERSION 3.4.1)
set (CMAKE_CXX_STANDARD 11)  
 
add_library( 
            image
            SHARED
            flood_fill.cpp
)