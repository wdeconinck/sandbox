#!/bin/sh


MPI_IMPL="$1"
os=`uname`
OMPIVER=openmpi-3.0.0
MPICHVER=3.2.1

case "$os" in
    Darwin)
        brew update
        brew upgrade cmake
        brew list oclint || brew cask uninstall oclint # Prevent conflict with gcc
        case "$MPI_IMPL" in
            mpich|mpich3)
                brew install mpich
                ;;
            openmpi)
                brew install openmpi
                ;;
            *)
                echo "Unknown MPI implementation: $MPI_IMPL"
                exit 1
                ;;
        esac
    ;;

    Linux)
        case "$MPI_IMPL" in
            mpich)
                if [ -f mpich/include/mpi.h ]; then
                  echo "mpich/include/mpi.h found."
                fi
                if [ -f mpich/lib/libmpich.so ]; then
                  echo "libmpich.so found -- nothing to build."
                else
                  echo "Downloading mpich source..."
                  wget http://www.mpich.org/static/downloads/${MPICHVER}/mpich-${MPICHVER}.tar.gz
                  tar xfz mpich-${MPICHVER}.tar.gz
                  rm mpich-{MPICHVER}.tar.gz
                  echo "Configuring and building mpich..."
                  cd mpich-${MPICHVER}
                  ./configure \
                          --prefix=$(pwd)/../mpich \
                          --enable-static=false \
                          --enable-alloca=true \
                          --enable-threads=single \
                          --enable-fortran=yes \
                          --enable-fast=all \
                          --enable-g=none \
                          --enable-timing=none
                  make -j8 /dev/null
                  make install
                  cd -
                fi
                ;;
            openmpi)
                if [ -f openmpi/include/mpi.h ]; then
                  echo "openmpi/include/mpi.h found."
                fi
                if [ -f openmpi/lib/libmpi.so ] || [ -f openmpi/lib64/libmpi.so ]; then
                  echo "libmpi.so found -- nothing to build."
                else
                  echo "Downloading openmpi source..."
                  wget --no-check-certificate https://www.open-mpi.org/software/ompi/v3.0/downloads/$OMPIVER.tar.gz
                  tar -zxf $OMPIVER.tar.gz
                  rm $OMPIVER.tar.gz
                  echo "Configuring and building openmpi..."
                  cd $OMPIVER
                  ./configure \
                          --prefix=$(pwd)/../openmpi
                  make -j8 > /dev/null
                  make install
                  cd -
                fi
                ;;
            *)
                echo "Unknown MPI implementation: $MPI_IMPL"
                exit 1
                ;;
        esac
        ;;

    *)
        echo "Unknown operating system: $os"
        exit 1
        ;;
esac