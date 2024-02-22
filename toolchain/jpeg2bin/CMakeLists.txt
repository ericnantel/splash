cmake_minimum_required(VERSION 3.26)
project(jpeg2bin VERSION 1.0.0)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

include_directories(
	../license
)

set(LICENSE_HEADER_FILES
	../license/license.hpp
)

set(LICENSE_SOURCE_FILES
	../license/license.cpp
)

set(LICENSE_LIBRARY_NAME_SUFFIX 
	""
)

add_library(
	license${LICENSE_LIBRARY_NAME_SUFFIX} STATIC
	${LICENSE_HEADER_FILES}
	${LICENSE_SOURCE_FILES}
)

include_directories(
	public
	private
)

set(JPEG2BIN_HEADER_FILES
	public/jpeg2bin.hpp
	private/jpeg2bin_args.hpp
)

set(JPEG2BIN_SOURCE_FILES
	main.cpp
	private/jpeg2bin.cpp
	private/jpeg2bin_args.cpp
)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")

add_executable(
	${PROJECT_NAME}
	${JPEG2BIN_HEADER_FILES}
	${JPEG2BIN_SOURCE_FILES}
)

set(STATIC_BINARIES
	license${LICENSE_LIBRARY_NAME_SUFFIX}
)

target_link_libraries(${PROJECT_NAME}
	${STATIC_BINARIES}
)