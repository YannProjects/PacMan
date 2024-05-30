cmake_minimum_required(VERSION 3.0.0)
project(PacMan_Hw_Test VERSION 0.1.0 LANGUAGES C)

include(CTest)
enable_testing()

add_executable(PacManHwTest main.c uart_stub/uart16550_stub.c uartns550_lite/xuartns550.c uartns550_lite/xuartns550_sinit.c)

include_directories(${PROJECT_SOURCE_DIR}/uartns550_lite ${PROJECT_SOURCE_DIR}/uart_stub)
target_link_libraries(PacManHwTest -lserialport -lsetupapi)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)