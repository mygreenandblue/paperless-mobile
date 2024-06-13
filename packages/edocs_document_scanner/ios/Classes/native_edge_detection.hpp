#include <iostream>
struct Coordinate
{
    double x;
    double y;
};

struct DetectionResult
{
    Coordinate *topLeft;
    Coordinate *topRight;
    Coordinate *bottomLeft;
    Coordinate *bottomRight;
};

extern "C" struct ProcessingInput
{
    char *path;
    DetectionResult detectionResult;
};

extern "C" struct DetectionResult *detect_edges_from_file(char *str);

extern "C" struct DetectionResult *detect_edges(uint8_t *bytes, int byteCount);

extern "C" uint8_t *process_image(
    uint8_t *bytes,
    int byteCount,
    double topLeftX,
    double topLeftY,
    double topRightX,
    double topRightY,
    double bottomLeftX,
    double bottomLeftY,
    double bottomRightX,
    double bottomRightY);

extern "C" bool process_image_from_file(
    char *path,
    double topLeftX,
    double topLeftY,
    double topRightX,
    double topRightY,
    double bottomLeftX,
    double bottomLeftY,
    double bottomRightX,
    double bottomRightY);