
CMAKE_MINIMUM_REQUIRED(VERSION 2.8.7 FATAL_ERROR)
PROJECT(bankocr)

INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR}/vendor/gtest-1.7.0/include)
INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR}/vendor/gtest-1.7.0)

add_subdirectory(${PROJECT_SOURCE_DIR}/vendor/gtest-1.7.0)
add_library(gtest_all STATIC ${PROJECT_SOURCE_DIR}/vendor/gtest-1.7.0/src/gtest-all.cc)
LINK_DIRECTORIES(${PROJECT_SOURCE_DIR}/vendor/gtest-1.7.0)

ADD_EXECUTABLE(test-all ${PROJECT_SOURCE_DIR}/test/bankocr_test.cpp)
target_link_libraries(test-all gtest_all)

enable_testing()
add_test(test-all test-all)
