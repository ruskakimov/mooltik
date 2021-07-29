#include <stdlib.h>
#include <queue>
#include <utility>

#define PUBLIC extern "C" __attribute__((visibility("default"))) __attribute__((used))

class Image {
private:
    uint32_t* pixels_pointer;
    int width;
    int height;

public:
    Image(uint32_t* pixels_pointer, int width, int height) {
        this->pixels_pointer = pixels_pointer;
        this->width = width;
        this->height = height;
    }

    uint32_t* getPixel(int x, int y) {
        return pixels_pointer + (y * width + x);
    }
};

PUBLIC
void flood_fill(uint32_t* pixels_pointer, int width, int height, int x, int y, int fillColor) {
    auto image = Image(pixels_pointer, width, height);

    uint32_t oldColor = *image.getPixel(x, y);

    if (oldColor == fillColor) return;

    std::queue<std::pair<int, int> > q;
    q.push({ x, y });

    bool spanAbove, spanBelow;

    while (!q.empty()) {
        std::pair<int, int> p = q.front();
        q.pop();

        x = p.first;
        y = p.second;

        while (x >= 0 && *image.getPixel(x, y) == oldColor) x--;
        x++;

        spanAbove = spanBelow = false;

        while (x < width && *image.getPixel(x, y) == oldColor) {
            *image.getPixel(x, y) = fillColor;

            if (!spanAbove && y > 0 && *image.getPixel(x, y - 1) == oldColor) {
                q.push({ x, y - 1 });
                spanAbove = true;
            }
            else if (spanAbove && y > 0 && *image.getPixel(x, y - 1) == oldColor) {
                spanAbove = false;
            }

            if (!spanBelow && y < height - 1 && *image.getPixel(x, y + 1) == oldColor) {
                q.push({ x, y + 1 });
                spanBelow = true;
            }
            else if (spanBelow && y < height - 1 && *image.getPixel(x, y + 1) == oldColor) {
                spanBelow = false;
            }

            x++;
        }
    }
}
