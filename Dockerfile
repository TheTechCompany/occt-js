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

WORKDIR /opt/build
RUN wget https://download.savannah.gnu.org/releases/freetype/freetype-2.10.0.tar.gz
RUN tar -zxvf freetype-2.10.0.tar.gz >> installed_freetype2100_files.txt

WORKDIR /opt/build/freetype-2.10.0
RUN sh autogen.sh
WORKDIR /opt/build/freetype2
WORKDIR /opt/build/freetype-2.10.0/build
RUN emconfigure ../configure
RUN emcmake cmake .. 
RUN emmake make install

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

###############
# Sample wasm #
###############

WORKDIR /opt/build/opencascade-7.7.0/samples/webgl/
RUN emmake cmake \
  -Dfreetype_DIR=/usr/local/lib/cmake/freetype/ \
  -DOpenCASCADE_DIR=/opt/build/occt770/lib/cmake/opencascade/ \
  -DCMAKE_INSTALL_PREFIX=/opt/build/opencascade-7.7.0/samples/webgl/ \
  .
RUN emmake make
RUN emmake make install
# Why it is comming without extension?
RUN mv occt-webgl-sample occt-webgl-sample.js

WORKDIR /opt/build/opencascade-7.7.0/samples/webgl/samples
RUN cp /opt/build/opencascade-7.7.0/data/occ/Ball.brep /opt/build/opencascade-7.7.0/samples/webgl/samples

WORKDIR /opt/build/opencascade-7.7.0/samples 

#################
# Simple servar #
#################

RUN apt-get -y install python3
EXPOSE 7000
CMD python3 -m http.server 7000
