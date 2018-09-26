#!/bin/bash
PYTHON2_MAJOR_VERSION=2
PYTHON2_MINOR_VERSION=7
PYTHON2_PATCH_VERSION=13

PYTHON2_VERSION=${PYTHON2_MAJOR_VERSION}.${PYTHON2_MINOR_VERSION}.${PYTHON2_PATCH_VERSION}

INSTALL_ROOT=.ros-root

set -euf -o pipefail

export AL_DIR=/home/gro/naoqi-sdk
export ALDE_CTC_CROSS=/home/gro/ctc-linux64-atom-2.5.2.74

if [ -z "$ALDE_CTC_CROSS" ]; then
  echo "Please define the ALDE_CTC_CROSS variable with the path to Aldebaran's Crosscompiler toolchain"
  exit 1
fi

mkdir -p ccache-build/
mkdir -p pepper_ros1_ws/cmake
mkdir -p pepper_ros1_ws/src
mkdir -p ${INSTALL_ROOT}/ros1_inst

cp repos/pepper_ros1.repos pepper_ros1_ws/

docker run -it --rm \
  -u $(id -u $USER) \
  -e INSTALL_ROOT=${INSTALL_ROOT} \
  -e PYTHON2_VERSION=${PYTHON2_VERSION} \
  -e PYTHON2_MAJOR_VERSION=${PYTHON2_MAJOR_VERSION} \
  -e PYTHON2_MINOR_VERSION=${PYTHON2_MINOR_VERSION} \
  -e ALDE_CTC_CROSS=/home/nao/ctc \
  -v ${PWD}/ccache-build:/home/nao/.ccache \
  -v ${PWD}/Python-${PYTHON2_VERSION}-host:/home/nao/${INSTALL_ROOT}/Python-${PYTHON2_VERSION}:ro \
  -v ${PWD}/Python-${PYTHON2_VERSION}-host:/home/nao/Python-${PYTHON2_VERSION}-host:ro \
  -v ${PWD}/${INSTALL_ROOT}/Python-${PYTHON2_VERSION}:/home/nao/${INSTALL_ROOT}/Python-${PYTHON2_VERSION}-pepper:ro \
  -v ${ALDE_CTC_CROSS}:/home/nao/ctc:ro \
  -v ${PWD}/${INSTALL_ROOT}/ros1_dependencies:/home/nao/${INSTALL_ROOT}/ros1_dependencies:ro \
  -v ${PWD}/${INSTALL_ROOT}/ros1_inst:/home/nao/${INSTALL_ROOT}/ros1_inst:rw \
  -v ${PWD}/pepper_ros1_ws:/home/nao/pepper_ros1_ws \
  ros1-pepper \
  bash -c "\
    set -euf -o pipefail && \
    export LD_LIBRARY_PATH=/home/nao/ctc/openssl/lib:/home/nao/ctc/zlib/lib:/home/nao/${INSTALL_ROOT}/Python-${PYTHON2_VERSION}/lib && \
    export PATH=/home/nao/${INSTALL_ROOT}/Python-${PYTHON2_VERSION}/bin:$PATH && \
    export PKG_CONFIG_PATH=/home/nao/${INSTALL_ROOT}/ros1_dependencies/lib/pkgconfig && \
    cd pepper_ros1_ws && \
    vcs import src < pepper_ros1.repos"

