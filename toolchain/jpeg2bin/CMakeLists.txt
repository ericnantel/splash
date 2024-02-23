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
	../thirdparty/libjpeg-turbo
)

# Add definitions
if(WITH_JPEG8 OR WITH_JPEG7)
  set(WITH_ARITH_ENC 1)
  set(WITH_ARITH_DEC 1)
endif()
if(WITH_ARITH_DEC)
  set(D_ARITH_CODING_SUPPORTED 1)
endif()
if(WITH_ARITH_ENC)
  set(C_ARITH_CODING_SUPPORTED 1)
endif()
if(NOT WITH_JPEG8)
  set(MEM_SRCDST_FUNCTIONS "global:  jpeg_mem_dest;  jpeg_mem_src;")
endif()
set(SO_AGE 3)
if(NOT WITH_JPEG8)
  set(SO_AGE 4)
endif()
if(WITH_JPEG8)
  set(JPEG_LIB_VERSION 80)
elseif(WITH_JPEG7)
  set(JPEG_LIB_VERSION 70)
else()
  set(JPEG_LIB_VERSION 62)
endif()

# Generate files
configure_file(../thirdparty/libjpeg-turbo/jversion.h.in ../../thirdparty/libjpeg-turbo/jversion.h)
configure_file(../thirdparty/libjpeg-turbo/jconfig.h.in ../../thirdparty/libjpeg-turbo/jconfig.h)
configure_file(../thirdparty/libjpeg-turbo/jconfigint.h.in ../../thirdparty/libjpeg-turbo/jconfigint.h)
if(UNIX)
  configure_file(../thirdparty/libjpeg-turbo/libjpeg.map.in ../../thirdparty/libjpeg-turbo/libjpeg.map)
endif()

set(LIBJPEG_TURBO_HEADER_FILES
	../thirdparty/libjpeg-turbo/jpeglib.h
)

find_library(LIBJPEG_TURBO_STATIC_EXTERNAL_LIBRARY
	NAMES jpeg-static libjpeg
	HINTS ../thirdparty/libjpeg-turbo/build/Release
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
	PUBLIC license${LICENSE_LIBRARY_NAME_SUFFIX}
	PRIVATE ${LIBJPEG_TURBO_STATIC_EXTERNAL_LIBRARY}
)

target_link_libraries(${PROJECT_NAME}
	${STATIC_BINARIES}
)