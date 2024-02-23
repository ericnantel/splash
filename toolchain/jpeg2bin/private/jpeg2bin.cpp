
#include "jpeg2bin.hpp"

#include <iostream>
using std::cout;

#include "jpeglib.h"
#include "jerror.h"

namespace Splash
{
    namespace Jpeg2Bin
    {
        void Start(const Args& args)
        {
            std::cout << "Starting Jpeg2Bin..." << std::endl;

            if (args.Size() > 1)
            {
            }
        }
    };
};