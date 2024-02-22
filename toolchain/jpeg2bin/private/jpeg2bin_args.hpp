
#ifndef SPLASH_JPEG2BIN_ARGS_HPP
#define SPLASH_JPEG2BIN_ARGS_HPP

#include <vector>
using std::vector;

#include <string_view>
using std::string_view;

namespace Splash
{
    namespace Jpeg2Bin
    {
        struct Args : private std::vector<std::string_view>
        {
            using Super = std::vector<std::string_view>;

            Args() = delete;
            explicit Args(int argc, char* argv[]);

            size_t Size() const;

            const_reference At(size_t argi) const;
        };
    };
};

#endif