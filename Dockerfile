from emscripten/emsdk

USER root

#################
# Standart Libs #
#################

RUN apt-get update 

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata
RUN apt-get -y install git build-essential cmake vim wget rapidjson-dev tcl-dev tk-dev libfreetype6-dev libgl1-mesa-dev libxmu-dev libxi-dev
# RUN apt-get install -y build-essential cmake wget tcl-dev tk-dev libxmu-dev libxi-dev libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev

###############
# OpenCascade #
###############

WORKDIR /opt/build
RUN git clone https://git.dev.opencascade.org/repos/occt.git --depth=1
RUN cd occt && git checkout tags/V7_7_2
# RUN wget https://github.com/Open-Cascade-SAS/OCCT/archive/refs/tags/V7_7_0.tar.gz 

#RUN wget https://dev.opencascade.org/system/files/occt/OCC_7.7.0_release/opencascade-7.7.0.tgz
#RUN wget https://github.com/tpaviot/oce/releases/download/official-upstream-packages/opencascade-7.5.0.tgz
# RUN tar -zxvf V7_7_0.tar.gz >> installed_occt770_files.txt

WORKDIR /opt/build/occt/build

#RUN emmake cmake \
#  -DCMAKE_SIZEOF_VOID_P=8 \
#  -DINSTALL_DIR=/opt/build/occt770 \
#  -DBUILD_RELEASE_DISABLE_EXCEPTIONS=OFF \
#  -DBUILD_MODULE_Draw=OFF \
#  -DBUILD_LIBRARY_TYPE="Static" \
#  ..

RUN  cmake .. -G "Unix Makefiles" -D USE_RAPIDJSON:BOOL="ON" -D CMAKE_BUILD_TYPE=release -D CMAKE_INSTALL_PREFIX=/usr

RUN make -j4
RUN make install
#RUN emmake make -j10
#RUN emmake make install
