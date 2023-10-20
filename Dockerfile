from emscripten/emsdk

USER root

#################
# Standart Libs #
#################

RUN apt-get update 

RUN apt-get install -y wget build-essential automake libtool autoconf cmake python3

############
# Freetype #
############

RUN apt-get install -y libfreetype6 libfreetype6-dev

RUN apt-get install -y tcl tcl-dev tk tk-dev 

RUN apt-get install -y libx11-dev mesa-common-dev libglu1-mesa-dev

###############
# OpenCascade #
###############

WORKDIR /opt/build
RUN wget https://github.com/Open-Cascade-SAS/OCCT/archive/refs/tags/V7_7_0.tar.gz 
#RUN wget https://dev.opencascade.org/system/files/occt/OCC_7.7.0_release/opencascade-7.7.0.tgz
#RUN wget https://github.com/tpaviot/oce/releases/download/official-upstream-packages/opencascade-7.5.0.tgz
RUN tar -zxvf V7_7_0.tar.gz >> installed_occt770_files.txt
WORKDIR /opt/build/OCCT-7_7_0/build

RUN apt-get install libfreetype-dev -y

RUN emmake cmake \
  -DCMAKE_SIZEOF_VOID_P=8 \
  -DINSTALL_DIR=/opt/build/occt770 \
  -DBUILD_RELEASE_DISABLE_EXCEPTIONS=OFF \
  -DBUILD_MODULE_Draw=OFF \
  -DBUILD_LIBRARY_TYPE="Static" \
  ..

RUN emmake make -j10
RUN emmake make install
