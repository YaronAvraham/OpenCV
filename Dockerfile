#Download base image hulkinbrain/docker-opencv2
FROM hulkinbrain/docker-opencv2

LABEL Yaron Avraham

# Login as root
USER root

# update image
RUN apt-get update

# Specify the working directory
WORKDIR /opencv/build/

# Copy the current folder which contains C++ source code to the Docker image under /opencv/build/
COPY . /opencv/build/


ENV LD_LIBRARY_PATH="/usr/local/lib/"

# Use GCC to compile the OpenCV_1.cpp source file
RUN g++ -o OpenCV_Example.out -L/usr/local/lib OpenCV_1.cpp `pkg-config opencv --cflags --libs`
 
# Run the program output from the previous step
RUN "/opencv/build/OpenCV_Example.out"

RUN date

RUN ls -sh -lt

#RUN cp "/opencv/build/savedimage2.bmp" "NewImage.bmp"

# RUN cp  /opencv/build/savedimage.bmp c:\\images\\savedimage.bmp


