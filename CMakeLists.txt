cmake_minimum_required(VERSION 3.0.0)
project(crswifty VERSION 0.1.0)

include(CTest)
include_directories(include/** /usr/include/dbus-1.0/ /usr/include/dbus-c++-1/ /usr/include/x86_64-linux-gnu/ openssl1/include/)
link_libraries(ssl crypto)
enable_testing()

add_compile_options(
    "-fpermissive"
)
# It used to be rma_host but now it is shim_only main.cpp until we find a valid use after free within the browser process.
add_executable(crafter crafter/main.cc)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)