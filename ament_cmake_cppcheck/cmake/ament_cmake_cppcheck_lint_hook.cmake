# Copyright 2015 Open Source Robotics Foundation, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

find_package(ament_cmake_core REQUIRED)

file(GLOB_RECURSE _source_files FOLLOW_SYMLINKS
  "*.c"
  "*.cc"
  "*.cpp"
  "*.cxx"
  "*.h"
  "*.hh"
  "*.hpp"
  "*.hxx"
)
if(_source_files)
  message(STATUS "Added test 'cppcheck' to perform static code analysis on C / C++ code")

  # Get include paths for added targets
  set(_all_include_dirs "")
  if(DEFINED ament_cmake_cppcheck_ADDITIONAL_INCLUDE_DIRS)
    list(APPEND _all_include_dirs ${ament_cmake_cppcheck_ADDITIONAL_INCLUDE_DIRS})
  endif()

  # Forces cppcheck to consider ament_cmake_cppcheck_LANGUAGE as the given language if defined
  set(_language "")
  if(DEFINED ament_cmake_cppcheck_LANGUAGE)
    set(_language LANGUAGE ${ament_cmake_cppcheck_LANGUAGE})
    message(STATUS "Configured cppcheck language: ${ament_cmake_cppcheck_LANGUAGE}")
  endif()

  # Get exclude paths for added targets
  set(_all_exclude "")
  if(DEFINED ament_cmake_cppcheck_ADDITIONAL_EXCLUDE)
    list(APPEND _all_exclude ${ament_cmake_cppcheck_ADDITIONAL_EXCLUDE})
  endif()

  # BUILDSYSTEM_TARGETS only supported in CMake >= 3.7
  if(NOT CMAKE_VERSION VERSION_LESS "3.7.0")
    get_directory_property(_build_targets DIRECTORY ${PROJECT_SOURCE_DIR} BUILDSYSTEM_TARGETS)
    foreach(_target ${_build_targets})
      get_target_property(_target_type "${_target}" TYPE)
      if(NOT ${_target_type} STREQUAL "INTERFACE_LIBRARY")
        list(APPEND _all_include_dirs $<TARGET_PROPERTY:${_target},INCLUDE_DIRECTORIES>)
      endif()
    endforeach()
  endif()

  message(STATUS "Configured cppcheck include dirs: ${_all_include_dirs}")
  message(
    STATUS "Configured cppcheck exclude dirs and/or files: ${_all_exclude}"
  )
  ament_cppcheck(
    ${_language} INCLUDE_DIRS ${_all_include_dirs} EXCLUDE ${_all_exclude}
  )
endif()
