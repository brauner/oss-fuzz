#!/bin/bash -eu
# Copyright 2019 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

# build project
./autogen.sh
./configure
make -j$(nproc)
make install

# build fuzzers
for fuzzers in $(find $SRC -name '*_fuzzer.cc'); do
  base=$(basename -s .cc $fuzzers)
  $CXX $CXXFLAGS -std=c++11 -Iinclude \
  $fuzzers ./getopt/.libs/libgetopt.a \
  ./src/.libs/libmatio.a -o $OUT/$base $LIB_FUZZING_ENGINE
done
