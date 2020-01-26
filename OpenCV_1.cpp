#include <iostream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;
using namespace std;

int main()
{
  cout << "Docker OpenCV test" ;
  Mat im = imread("Roni.jpeg");
  if (im.empty())
  {
    cout << "Cannot open image!" << endl;
    return 1;
  }
  else
  {
        cout << "image opened succesfully!" << endl;
        //return 0;
  }
  //imshow("Image", im);
    string filename = "/opencv/build/savedimage.bmp";
    imwrite(filename, im);
  //waitKey(0);
}