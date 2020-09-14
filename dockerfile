	#latest 22/07/2020
ARG DOCKER_REGISTRY

FROM ${DOCKER_REGISTRY}sdk_plus:latest as builder

RUN mkdir -p /app/OrthophotoAlgorithm
WORKDIR /app/OrthophotoAlgorithm
 
RUN mkdir /Common

# Copy dependency projects
RUN mv /sdk_plus/AlgorithmSDK/ /Common/AlgorithmSDK/
RUN mv /sdk_plus/MQ/ /Common/MQ/
RUN mv /sdk_plus/AlgorithmsCommon/ /Common/AlgorithmsCommon/
RUN mv /sdk_plus/Logger/ /Common/Logger/

COPY . .

RUN dotnet restore -v n --source /sdk_plus/packages OrthophotoAlgorithm.csproj
RUN dotnet publish --source /sdk_plus/packages -c Release -o /app/OrthophotoAlgorithm/published/

FROM continuul/build-essential:latest as base
##### Size 442MB (size of the build-essential docker image) #####

LABEL Orthophoto with GDal 3.10

# Login as root
USER root

# Installing libmagic
COPY archives/libmagic-5.37-r1.apk .
RUN apk add libmagic-5.37-r1.apk --no-cache

##### Size 448MB #####
# Installing file
COPY archives/file-5.28-r0.apk .
RUN apk add file-5.28-r0.apk --no-cache

##### Size 449MB #####

# Installing sqlite
COPY archives/sqlite-autoconf-3320000.tar.gz .
RUN tar xzf sqlite-autoconf-3320000.tar.gz -C /usr/local
WORKDIR /usr/local/sqlite-autoconf-3320000
RUN ./configure --prefix=/usr/local
RUN make
RUN make install

##### SIZE 542MB #####

# Installing sqlite libs
COPY archives/sqlite-libs-3.15.2-r2.apk .
RUN apk add sqlite-libs-3.15.2-r2.apk --no-cache

# Installing sqlite dev
COPY archives/sqlite-dev-3.15.2-r2.apk .
RUN apk add sqlite-dev-3.15.2-r2.apk --no-cache

##### SIZE 545MB #####

# Installing proj-6.3.2
COPY archives/proj-6.3.2RC1.tar.gz .
RUN tar xzf proj-6.3.2RC1.tar.gz -C /usr/local
WORKDIR /usr/local/proj-6.3.2
RUN ./configure
RUN make
RUN make install

##### SIZE 855MB #####

# Installing linux headers
COPY archives/linux-headers-4.4.6-r1.apk .
RUN apk add linux-headers-4.4.6-r1.apk --no-cache

##### SIZE 860MB #####

## Installing GDal 3.1.0
COPY archives/gdal-3.1.0.tar.gz .
RUN mkdir /usr/local/gdal
RUN tar xzf gdal-3.1.0.tar.gz -C /usr/local/gdal
WORKDIR /usr/local/gdal/gdal-3.1.0
RUN ./configure --with-proj=/usr/local
RUN make
RUN make install

##### SIZE 2.15GB #####

COPY archives/libintl-0.20.2-r0.apk .
RUN apk add libintl-0.20.2-r0.apk --no-cache

##### SIZE 2.15GB #####
#
## Copy the current folder which contains C++ source code to the Docker image under /usr/src
COPY ./LocalOrthophoto /usr/src/orthophoto
#
## Specify the working directory
WORKDIR /usr/src/orthophoto
#
#
RUN mkdir -p /app
#
##### SIZE 2.28GB #####

#RUN g++ -o libLocalOrthophoto.so calcorthophoto.cpp imreg.cpp imregio.cpp imregmath.cpp Orthophoto.cpp warping.cpp -shared -lgdal
RUN g++ -c -x c++ "calcorthophoto.cpp" -g2 -gdwarf-2 -o "calcorthophoto.o" -Wall -Wswitch -W"no-deprecated-declarations" -W"empty-body" -Wconversion -W"return-type" -Wparentheses -W"no-format" -Wuninitialized -W"unreachable-code" -W"unused-function" -W"unused-value" -W"unused-variable" -O0 -fno-strict-aliasing -fno-omit-frame-pointer -fpic -fthreadsafe-statics -fexceptions -frtti -std=c++11
RUN g++ -c -x c++ "imreg.cpp" -g2 -gdwarf-2 -o "imreg.o" -Wall -Wswitch -W"no-deprecated-declarations" -W"empty-body" -Wconversion -W"return-type" -Wparentheses -W"no-format" -Wuninitialized -W"unreachable-code" -W"unused-function" -W"unused-value" -W"unused-variable" -O0 -fno-strict-aliasing -fno-omit-frame-pointer -fpic -fthreadsafe-statics -fexceptions -frtti -std=c++11
RUN g++ -c -x c++ "imregio.cpp" -g2 -gdwarf-2 -o "imregio.o" -Wall -Wswitch -W"no-deprecated-declarations" -W"empty-body" -Wconversion -W"return-type" -Wparentheses -W"no-format" -Wuninitialized -W"unreachable-code" -W"unused-function" -W"unused-value" -W"unused-variable" -O0 -fno-strict-aliasing -fno-omit-frame-pointer -fpic -fthreadsafe-statics -fexceptions -frtti -std=c++11
RUN g++ -c -x c++ "imregmath.cpp" -g2 -gdwarf-2 -o "imregmath.o" -Wall -Wswitch -W"no-deprecated-declarations" -W"empty-body" -Wconversion -W"return-type" -Wparentheses -W"no-format" -Wuninitialized -W"unreachable-code" -W"unused-function" -W"unused-value" -W"unused-variable" -O0 -fno-strict-aliasing -fno-omit-frame-pointer -fpic -fthreadsafe-statics -fexceptions -frtti -std=c++11
#RUN g++ -c -x c++ "main.cpp" -g2 -gdwarf-2 -o "main.o" -Wall -Wswitch -W"no-deprecated-declarations" -W"empty-body" -Wconversion -W"return-type" -Wparentheses -W"no-format" -Wuninitialized -W"unreachable-code" -W"unused-function" -W"unused-value" -W"unused-variable" -O0 -fno-strict-aliasing -fno-omit-frame-pointer -fpic -fthreadsafe-statics -fexceptions -frtti -std=c++11
RUN g++ -c -x c++ "Orthophoto.cpp" -g2 -gdwarf-2 -o "Orthophoto.o" -Wall -Wswitch -W"no-deprecated-declarations" -W"empty-body" -Wconversion -W"return-type" -Wparentheses -W"no-format" -Wuninitialized -W"unreachable-code" -W"unused-function" -W"unused-value" -W"unused-variable" -O0 -fno-strict-aliasing -fno-omit-frame-pointer -fpic -fthreadsafe-statics -fexceptions -frtti -std=c++11
RUN g++ -c -x c++ "warping.cpp" -g2 -gdwarf-2 -o "warping.o" -Wall -Wswitch -W"no-deprecated-declarations" -W"empty-body" -Wconversion -W"return-type" -Wparentheses -W"no-format" -Wuninitialized -W"unreachable-code" -W"unused-function" -W"unused-value" -W"unused-variable" -O0 -fno-strict-aliasing -fno-omit-frame-pointer -fpic -fthreadsafe-statics -fexceptions -frtti -std=c++11

RUN ar ru libLocalOrthophoto.a calcorthophoto.o imreg.o imregio.o imregmath.o Orthophoto.o warping.o /usr/local/lib/libgdal.so 
#RUN ranlib libLocalOrthophoto.a
RUN g++ Orthophoto.cpp libLocalOrthophoto.a /usr/lib/libstdc++fs.a /usr/lib/libstdc++.a /usr/lib/gcc/x86_64-alpine-linux-musl/6.2.1/libgcc.a -o "/app/libLocalOrthophoto.so" -shared -fPIC -static-libstdc++ -static-libgcc
#RUN g++ -o "/app/libLocalOrthophoto.so" -Wl,--no-undefined -Wl,-z,relro -Wl,-z,now -Wl,-z,noexecstack -shared "calcorthophoto.o" "imreg.o" "imregio.o" "imregmath.o" "Orthophoto.o" "warping.o" -lgdal -lstdc++fs

##### SIZE 2.28GB #####

COPY ./LocalOrthophoto/temp.tif /app


FROM alpine as orthophotofinal

# Login as root
USER root



# If not installed - Failed to load , error: Error loading shared library libintl.so.8: No such file or directory (needed by /app/shared/Microsoft.NETCore.App/3.1.4/libcoreclr.so)
COPY archives/libintl-0.20.2-r0.apk . 
RUN apk add libintl-0.20.2-r0.apk --no-cache


RUN mkdir -p /app
WORKDIR /app
COPY archives/aspnetcore-runtime-3.1.4-linux-musl-x64.tar.gz .
RUN tar -xf aspnetcore-runtime-3.1.4-linux-musl-x64.tar.gz -C /app


COPY ./LocalOrthophoto/temp.tif /app
COPY --from=base /app/ /app

WORKDIR /usr/local/lib
COPY --from=base /usr/local/lib/libgdal.so.27 /usr/local/lib/libproj.so.15 /usr/local/lib/libsqlite3.so.0 /usr/lib/libstdc++.so.6 /usr/lib/libgcc_s.so.1 /usr/local/lib/
#WORKDIR /usr/src/orthophoto
#COPY --from=base /usr/src/orthophoto .
WORKDIR /app
COPY --from=builder /app/OrthophotoAlgorithm/published .
COPY --from=base /app/libLocalOrthophoto.so .
COPY --from=base /usr/local/share/proj/proj.db /app/proj.db

WORKDIR /usr/local

ENV LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib:/usr/lib64:&{LD_LIBRARY_PATH}"
ENV PATH="/app:${PATH}"
ENV DOTNET_ROOT=/app
ENV PROJ_LIB=/app


WORKDIR /app
RUN mkdir -p $AlgorithmSDK:AlgorithmRootDirectory
RUN mkdir -p $Orthophoto:VRTLocalFolderPath
#RUN ldd /app/libLocalOrthophoto.so

#COPY Orthophoto_Data/*.dt2 /OrthophotoAlgorithmVRT/./
#COPY Orthophoto_Data/*.dt2 /app/./
COPY Orthophoto_Data/Vector_district.vrt /app/Vector_district.vrt
COPY Orthophoto_Data/left_rpc.txt /OrthophotoAlgorithmVRT/left_rpc.txt


RUN chmod 777 /app/OrthophotoAlgorithm.dll

#RUN chmod -R 777 /usr/src
RUN chmod -R 777 /OrthophotoAlgorithmVRT




WORKDIR /app
ENTRYPOINT ["dotnet","OrthophotoAlgorithm.dll"]
