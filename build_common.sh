#!/bin/bash

## Available defines for building chm_lib with particular options
# CHM_USE_PREAD: build chm_lib to use pread/pread64 for all I/O
# CHM_USE_IO64:  build chm_lib to support 64-bit file I/O
#
#CFLAGS=-DCHM_USE_PREAD -DCHM_USE_IO64
#CFLAGS=-DCHM_USE_PREAD -DCHM_USE_IO64 -g -DDMALLOC_DISABLE
#LDFLAGS=-lpthread
#
# ASAN only seems to work with -O0 (intentionally inserted bug didn't trigger
# when I compiled with -O1, -O2 and -O3, but maybe it's because aggresive
# optimizations eliminated the code completely)

CHM_SRCS="src/chm_lib.c src/lzx.c"

clang_rel()
{
  echo "clang_rel"
  CC=clang
  CFLAGS="-g -fsanitize=address -O0 -Isrc -Weverything -Wno-format-nonliteral -Wno-padded -Wno-conversion"
  OUT=obj/clang/rel
  mkdir -p $OUT
  $CC -o $OUT/test $CFLAGS $CHM_SRCS tools/test.c tools/sha1.c
  $CC -o $OUT/extract $CFLAGS $CHM_SRCS tools/extract.c
  $CC -o $OUT/enum $CFLAGS $CHM_SRCS tools/enum.c
  $CC -o $OUT/chm_http $CFLAGS $CHM_SRCS tools/chm_http.c
}

build_afl()
{
  echo "build_afl"
  CC=afl-clang
  CFLAGS="-g -fsanitize=address -O3 -Isrc -Weverything -Wno-format-nonliteral -Wno-padded -Wno-conversion"
  OUT=obj/afl/rel
  mkdir -p $OUT
  $CC -o $OUT/test $CFLAGS $CHM_SRCS tools/test.c tools/sha1.c
  #$CC -o $OUT/extract $CFLAGS $CHM_SRCS tools/extract.c
  #$CC -o $OUT/enum $CFLAGS $CHM_SRCS tools/enum.c
  #$CC -o $OUT/chm_http $CFLAGS $CHM_SRCS tools/chm_http.c
}

clang_rel_one()
{
  echo "clang_rel_on"
  CC=clang
  CFLAGS="-g -fsanitize=address -O0 -Isrc -Weverything -Wno-format-nonliteral -Wno-padded -Wno-conversion"
  OUT=obj/clang/rel
  mkdir -p $OUT
  $CC -o $OUT/test $CFLAGS $CHM_SRCS tools/test.c tools/sha1.c
  #$CC -o $OUT/chm_http $CFLAGS $CHM_SRCS tools/chm_http.c
}

clang_dbg()
{
  echo "clang_dbg"
  CC=clang
  CFLAGS="-g -fsanitize=address -O0 -Isrc -Weverything -Wno-format-nonliteral -Wno-padded -Wno-conversion"
  OUT=obj/clang/dbg
  mkdir -p $OUT
  $CC -o $OUT/test $CFLAGS $CHM_SRCS tools/test.c tools/sha1.c
  $CC -o $OUT/extract $CFLAGS $CHM_SRCS tools/extract.c
  $CC -o $OUT/enum $CFLAGS $CHM_SRCS tools/enum.c
  $CC -o $OUT/chm_http $CFLAGS $CHM_SRCS tools/chm_http.c
}

gcc_rel()
{
  echo "gcc_rel"
  #CC=/usr/local/opt/gcc/bin/gcc-5
  CC=gcc-5 # this is on mac when installed with brew install gcc
  CFLAGS="-g -O3 -Isrc -Wall -Wextra -Wpedantic"
  OUT=obj/gcc/rel
  mkdir -p $OUT
  $CC -o $OUT/test $CFLAGS $CHM_SRCS tools/test.c tools/sha1.c
  $CC -o $OUT/extract $CFLAGS $CHM_SRCS tools/extract.c
  $CC -o $OUT/enum $CFLAGS $CHM_SRCS tools/enum.c
  $CC -o $OUT/chm_http $CFLAGS $CHM_SRCS tools/chm_http.c
}
