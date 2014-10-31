#include <map>
#include <cmath>
#include <vector>
#include <string>
#include <queue>
#include <fstream>
#include <algorithm>
#include <opencv2/opencv.hpp>
using namespace cv;
using namespace std;

const int STEP_X[] = { 0, 1, 0, - 1 };
const int STEP_Y[] = { 1, 0, - 1, 0 };
const int CIRCLE_X[] = { 0, 0, 0, 1, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 7, 7, 8, 8, 8 };
const int CIRCLE_Y[] = { 3, 4, 5, 1, 2, 6, 7, 1, 7, 0, 8, 0, 8, 0, 8, 1, 7, 1, 2, 6, 7, 3, 4, 5 };
const int TOLERANCE_RADIUS = 4;
const int RERANK_NUM = 1000;

const double PI = acos(-1.0);
const double DEG_TRANS = 180.0 / PI;

struct ImageInfo
{
    string originPath;
    string sketchPath;
};

struct Score
{
    int id;
    double score;
    bool operator <(const Score &s) const
    {
        if (score == s.score)
        {
            return id < s.id;
        }
        return score > s.score;
    }
};

map<int, ImageInfo> getImagesInfo()
{
    map<int, ImageInfo> images;
    fstream fin;
    fin.open("images.info", ios::in);
    int id;
    string originPath, sketchPath;
    while (fin >> id >> originPath >> sketchPath)
    {
        images[id] = { originPath, sketchPath };
    }
    fin.close();
    return images;
}

/**
 * Load sketch to a boolean matrix. 
 * Sketch should be a 200 * 200 grayscale image, in which sketch is represented by black pixels.
 */
vector<vector<bool>> loadSketch(string path)
{
    IplImage* image = cvLoadImage(path.c_str(), CV_LOAD_IMAGE_GRAYSCALE);
    vector<vector<bool>> sketch(200, vector<bool>(200, false));
    for (int i = 0; i < 200; ++i)
    {
        for (int j = 0; j < 200; ++j)
        {
            sketch[i][j] = ((unsigned char)((image->imageData + i * image->widthStep)[j])) < 128;
        }
    }
    cvReleaseImage(&image);
    return sketch;
}

void localDfs(const vector<vector<bool>> &sketch, vector<vector<bool>> &local, 
              const int x, const int y, const int lx, const int ly)
{
    local[lx][ly] = true;
    for (int k = 0; k < 4; ++k)
    {
        int tx = x + STEP_X[k];
        int ty = y + STEP_Y[k];
        if (tx >= 0 && tx < 200)
        {
            if (ty >= 0 && ty < 200)
            {
                if (sketch[tx][ty])
                {
                    int tlx = lx + STEP_X[k];
                    int tly = ly + STEP_Y[k];
                    if (tlx >= 0 && tlx < 9)
                    {
                        if (tly >= 0 && tly < 9)
                        {
                            if (!local[tlx][tly])
                            {
                                localDfs(sketch, local, tx, ty, tlx, tly);
                            }
                        }
                    }
                }
            }
        }

    }
}

int countSketchPixel(const vector<vector<bool>> &sketch)
{
    int num = 0;
    for (int x = 0; x < 200; ++x)
    {
        for (int y = 0; y < 200; ++y)
        {
            num += sketch[x][y];
        }
    }
    return num;
}

/**
 * Calculate the angle of the sketch.
 * Returns a 200 * 200 * 6 matrix, the last dimension is the angle divided to 6 bins.
 */
vector<vector<vector<bool>>> calcAngle(const vector<vector<bool>> &sketch)
{
    vector<vector<vector<bool>>> angle(200, vector<vector<bool>>(200, vector<bool>(6, false)));
    for (int x = 0; x < 200; ++x)
    {
        for (int y = 0; y < 200; ++y)
        {
            if (sketch[x][y])
            {
                vector<vector<bool>> local(9, vector<bool>(9, false));
                localDfs(sketch, local, x, y, 4, 4);
                for (int c = 0; c < 24; ++c)
                {
                    int cx = CIRCLE_X[c];
                    int cy = CIRCLE_Y[c];
                    if (local[cx][cy])
                    {
                        int localAngle = ((int)(atan2(cy - 4.0, cx - 4.0) * DEG_TRANS) + 15 + 360) % 180;
                        angle[x][y][localAngle / 30] = true;
                    }
                }
            }
        }
    }
    return angle;
}

/**
* Generate hit map of the sketch.
* Returns a 200 * 200 * 6 matrix, the last dimension is the angle divided to 6 bins.
*/
vector<vector<vector<bool>>> generateHitMap(const vector<vector<bool>> &sketch)
{
    auto hitmap = calcAngle(sketch);
    struct Node
    {
        int x, y, theta;
        int depth;
    };
    queue<Node> q;
    for (int x = 0; x < 200; ++x)
    {
        for (int y = 0; y < 200; ++y)
        {
            for (int theta = 0; theta < 6; ++theta)
            {
                if (hitmap[x][y][theta])
                {
                    q.push({ x, y, theta, 0 });
                }
            }
        }
    }
    while (!q.empty())
    {
        Node node = q.front();
        q.pop();
        if (node.depth < TOLERANCE_RADIUS)
        {
            for (int k = 0; k < 4; ++k)
            {
                int tx = node.x + STEP_X[k];
                int ty = node.y + STEP_Y[k];
                if (tx >= 0 && tx < 200)
                {
                    if (ty >= 0 && ty < 200)
                    {
                        int theta = node.theta;
                        if (!hitmap[tx][ty][theta])
                        {
                            hitmap[tx][ty][theta] = true;
                            q.push({ tx, ty, theta, node.depth + 1 });
                        }
                    }
                }
            }
        }
    }
    return hitmap;
}

vector<vector<vector<vector<int>>>> generateEdgelIndex(map<int, ImageInfo> &images)
{
    vector<vector<vector<vector<int>>>> edgelIndex(200, vector<vector<vector<int>>>(
                                                   200, vector<vector<int>>(
                                                   6, vector<int>())));
    cout << "Generate Edgel Index: " << endl;
    for (auto image : images)
    {
        cout << image.first << ' ' << image.second.sketchPath << endl;
        auto sketch = loadSketch(image.second.sketchPath);
        auto hitmap = generateHitMap(sketch);
        for (int x = 0; x < 200; ++x)
        {
            for (int y = 0; y < 200; ++y)
            {
                for (int theta = 0; theta < 6; ++theta)
                {
                    edgelIndex[x][y][theta].push_back(image.first);
                }
            }
        }
    }
    return edgelIndex;
}

vector<Score> query(map<int, ImageInfo> &images,
                    const vector<vector<vector<vector<int>>>> &edgelIndex, 
                    const vector<vector<bool>> &querySketch)
{
    map<int, double> scores;
    auto hitmap = generateHitMap(querySketch);
    for (int x = 0; x < 200; ++x)
    {
        for (int y = 0; y < 200; ++y)
        {
            for (int theta = 0; theta < 6; ++theta)
            {
                if (hitmap[x][y][theta])
                {
                    for (auto id : edgelIndex[x][y][theta])
                    {
                        scores[id] += 1.0;
                    }
                }
            }
        }
    }
    vector<Score> result;
    for (auto score : scores)
    {
        result.push_back({ score.first, score.second });
    }
    sort(result.begin(), result.end());
    int rerankNum = min((int)result.size(), RERANK_NUM);
    while ((int)result.size() > rerankNum)
    {
        result.pop_back();
    }
    auto angle = calcAngle(querySketch);
    int queryPixelNum = countSketchPixel(querySketch);
    for (int i = (int)result.size() - 1; i >= 0; --i)
    {
        double score = 0.0;
        auto sketch = loadSketch(images[result[i].id].sketchPath);
        hitmap = generateHitMap(sketch);
        for (int x = 0; x < 200; ++x)
        {
            for (int y = 0; y < 200; ++y)
            {
                for (int theta = 0; theta < 6; ++theta)
                {
                    if (hitmap[x][y][theta])
                    {
                        if (angle[x][y][theta])
                        {
                            score += 1.0;
                        }
                    }
                }
            }
        }
        result[i].score = (result[i].score / queryPixelNum) * (score / countSketchPixel(sketch));
    }
    sort(result.begin(), result.end());
    return result;
}

int main(int argc, char* argv[])
{
    auto images = getImagesInfo();
    auto edgelIndex = generateEdgelIndex(images);
    auto querySketch = loadSketch("query.jpg");
    auto result = query(images, edgelIndex, querySketch);
    fstream fout;
    fout.open("result", ios::out);
    for (auto score : result)
    {
        fout << score.id << ' ' << score.score << endl;
    }
    fout.close();
    return 0;
}
