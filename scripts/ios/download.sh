#!/bin/bash

# IOS publish script WIP; doublecheck that they follow patterns in linux/android scripts before running

LIB_ROOT=../..
OS=ios
IOS_LIBS_DIR=$LIB_ROOT/$OS/libs
IOS_INCL_DIR=$LIB_ROOT/$OS/include

TAG_COMMIT=$(git log -1 --pretty=format:"%H")

rm -rf flutter_libmwc_bins
git clone https://git.cypherstack.com/stackwallet/flutter_libmwc_bins
if [ -d flutter_libmwc_bins ]; then
  cd flutter_libmwc_bins
else
  echo "Failed to clone flutter_libmwc_bins"
  exit 1
fi

HEADER=libmwc_wallet.h
BIN=libmwc_wallet.a

for TARGET in aarch64-apple-ios
do
  ARCH_PATH=$TARGET/release
  if [ $(git tag -l $TARGET"_$TAG_COMMIT") ]; then
      git checkout $TARGET"_$TAG_COMMIT"
      if [ -f "$OS/$ARCH_PATH/$BIN" ]; then
        mkdir -p ../$IOS_LIBS_DIR
        mkdir -p ../$IOS_INCL_DIR
        # TODO verify bin checksum hashes
        cp -rf "$OS/$ARCH_PATH/$BIN" "../$IOS_LIBS_DIR/$BIN"
        cp -rf "$OS/$ARCH_PATH/$HEADER" "../$IOS_INCL_DIR/$HEADER"
      else
        echo "$TARGET not found!"
      fi
  else
      echo "No precompiled bins for $TARGET found!"
  fi
done
