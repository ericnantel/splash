
#include "license.hpp"
#include "jpeg2bin.hpp"

int main(int argc, char* argv[])
{
    //You must join the license to all toolchain executables
    Splash::License();

    //Collecting args
    Splash::Jpeg2Bin::Args args(argc, argv);

    //Starting j2b with args
    Splash::Jpeg2Bin::Start(args);

    return 0;
}