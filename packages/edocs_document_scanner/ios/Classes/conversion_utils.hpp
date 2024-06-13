#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

class ConversionUtils {
    public:
    static uint8_t *matrix_to_bytearray(Mat mat);
    static Mat bytearray_to_matrix(uint8_t *bytes, int byteCount);
};
