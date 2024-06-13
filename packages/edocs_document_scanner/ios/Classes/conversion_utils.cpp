#include "conversion_utils.hpp"
using namespace cv;
uint8_t * ConversionUtils::matrix_to_bytearray(Mat mat)
{
    int size = mat.total() * mat.elemSize();
    uint8_t *bytes = (uint8_t *)malloc(size);
    std::memcpy(bytes, mat.data, size * sizeof(uint8_t));
    return bytes;
}

Mat ConversionUtils::bytearray_to_matrix(uint8_t *bytes, int byteCount)
{
    std::vector<uint8_t> buf(bytes, bytes + byteCount);
    return imdecode(buf, IMREAD_COLOR);
}