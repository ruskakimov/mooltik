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

struct LineFillTask {
    int x;
    int y;
    int parentDy; // y + parentDy is the y coordinate of parent
    int parentXl; // left x of parent's filled line
    int parentXr; // right x of parent's filled line

    LineFillTask(int x, int y, int parentDy, int parentXl, int parentXr) {
        this->x = x;
        this->y = y;
        this->parentDy = parentDy;
        this->parentXl = parentXl;
        this->parentXr = parentXr;
    }
};

PUBLIC
// Floods the 4-connected color area with another color.
// Returns 0 if successful.
// Returns -1 if no changes were done.
int flood_fill(uint32_t* pixels_pointer, int width, int height, int x, int y, int fillColor) {
    auto image = Image(pixels_pointer, width, height);

    uint32_t oldColor = *image.getPixel(x, y);

    if (oldColor == fillColor) return -1;

    std::queue<LineFillTask> q;
    q.push(LineFillTask(x, y, 0, 0, 0));

    auto scanLine = [&](int xl, int xr, int y, int parentDy) {
        bool streak = false;
        for (int x = xl; x <= xr; x++) {
            if (!streak && *image.getPixel(x, y) == oldColor) {
                q.push(LineFillTask(x, y, parentDy, xl, xr));
                streak = true;
            }
            else if (streak && *image.getPixel(x, y) != oldColor) {
                streak = false;
            }
        }
    };

    while (!q.empty()) {
        auto t = q.front();
        q.pop();

        x = t.x;
        y = t.y;

        int xl = x;
        int xr = x;

        // Find start of the line.
        while (xl - 1 >= 0 && *image.getPixel(xl - 1, y) == oldColor) xl--;

        // Fill the whole line.
        for (int x = xl; x < width && *image.getPixel(x, y) == oldColor; x++) {
            *image.getPixel(x, y) = fillColor;
            xr = x;
        }

        // Scan for new lines above.
        if (t.parentDy == -1) {
            if (xl < t.parentXl) scanLine(xl, t.parentXl, y - 1, 1);
            if (xr > t.parentXr) scanLine(t.parentXr, xr, y - 1, 1);
        }
        else if (y > 0) {
            scanLine(xl, xr, y - 1, 1);
        }

        // Scan for new lines below.
        if (t.parentDy == 1) {
            if (xl < t.parentXl) scanLine(xl, t.parentXl, y + 1, -1);
            if (xr > t.parentXr) scanLine(t.parentXr, xr, y + 1, -1);
        }
        else if (y < height - 1) {
            scanLine(xl, xr, y + 1, -1);
        }
    }

    return 0;
}
