
#include "license.hpp"

#include <iostream>
using std::cout;

namespace Splash
{
    void License()
    {
        std::cout << "By continuing to use Splash's toolchain, you agree to its license terms" << std::endl;
        std::cout << "Learn more at https://github.com/ericnantel/splash/blob/master/LICENSE" << std::endl;
    }
};