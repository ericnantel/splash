
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
                const auto imgSrcPath = args.At(1);
                const auto imgDstPath = args.At(2);
                const auto imgDstFormat = args.At(3);
                const auto imgTolerance = args.At(4);
                const auto imgInverse = args.At(5);

                const char* fileOpenMode;
                FILE* fileHandle;

                fileOpenMode = "rb";
                fileHandle = fopen(std::string(imgSrcPath).c_str(), fileOpenMode);
                if (fileHandle == NULL)
                {
                    std::cout << "Cannot open jpeg file..." << imgSrcPath << std::endl;
                    return;
                }

                jpeg_decompress_struct decompressor;
                jpeg_error_mgr errorManager;
                
                decompressor.err = jpeg_std_error(&errorManager);
                
                jpeg_create_decompress(&decompressor);

                jpeg_stdio_src(&decompressor, fileHandle);
                jpeg_read_header(&decompressor, TRUE);

                jpeg_start_decompress(&decompressor);
                auto imgWidth = decompressor.output_width;
                auto imgHeight = decompressor.output_height;
                auto imgChannels = decompressor.num_components;
                auto* imgData = new unsigned char[imgWidth * imgHeight * imgChannels];                

                auto rowStride = imgWidth * imgChannels;

                unsigned char* scanlines[1] = { nullptr };
                while (decompressor.output_scanline < decompressor.output_height)
                {
                    scanlines[0] = &imgData[0] + (decompressor.output_scanline * rowStride);
                    jpeg_read_scanlines(&decompressor, scanlines, 1);
                }

                jpeg_finish_decompress(&decompressor);
                jpeg_destroy_decompress(&decompressor);
                
                fclose(fileHandle);
                fileHandle = NULL;

                fileOpenMode = (imgDstFormat == "Z80") ? "w+" : "w+b";
                fileHandle = fopen(std::string(imgDstPath).c_str(), fileOpenMode);
                if (fileHandle == NULL)
                {
                    std::cout << "Cannot open binary file..." << imgDstPath << std::endl;
                    return;
                }

                auto threshold = (unsigned char)(imgTolerance * 255);

                auto binWidth = imgWidth;
                auto binHeight = imgHeight;
                auto binChannels = 1;
                auto* binData = new unsigned char[binWidth * binHeight * binChannels];

                auto pixelCount = imgWidth * imgHeight;
                if (imgChannels == 1)
                {
                    for (auto pixelIndex = 0U; pixelIndex < pixelCount; ++pixelIndex)
                    {
                        auto singleChannel = imgData[1 * pixelIndex + 0];
                        auto greyscale = singleChannel;
                        auto binary = greyscale < threshold ? 0 : 1;
                        binData[1 * pixelIndex + 0] = binary;
                    }
                }
                else if (imgChannels == 3)
                {
                    for (auto pixelIndex = 0U; pixelIndex < pixelCount; ++pixelIndex)
                    {
                        auto redChannel = imgData[3 * pixelIndex + 0];
                        auto greenChannel = imgData[3 * pixelIndex + 1];
                        auto blueChannel = imgData[3 * pixelIndex + 2];
                        auto greyscale = (unsigned char)(0.33333333 * (redChannel + greenChannel + blueChannel));
                        auto binary = greyscale < threshold ? 0 : 1;
                        binData[1 * pixelIndex + 0] = binary;
                    }
                }

                if (imgInverse)
                {
                    for (auto pixelIndex = 0U; pixelIndex < pixelCount; ++pixelIndex)
                    {
                        binData[1 * pixelIndex + 0] = (binData[1 * pixelIndex + 0] == 0) ? 1 : 0;
                    }
                }

                delete[] imgData;
                imgData = nullptr;

                if (imgDstFormat == "Z80")
                {
                    if (pixelCount >= 8)
                    {
                        auto byteCount = (unsigned int)(pixelCount / 8);

                        fprintf(fileHandle, "%d\n", byteCount);

                        for (auto pixelIndex = 0U; pixelIndex < pixelCount; ++pixelIndex)
                        {
                            auto colIndex = (pixelIndex % imgWidth);
                            auto lastColIndex = (imgWidth - 1);

                            if (colIndex == 0)
                            {
                                fprintf(fileHandle, ".DB ");
                            }

                            auto binary = binData[1 * pixelIndex + 0];

                            fprintf(fileHandle, "%d", binary);

                            if ((pixelIndex % 8) == 7)
                            {
                                fprintf(fileHandle, "b");

                                if (colIndex < lastColIndex)
                                {
                                    fprintf(fileHandle, ", ");
                                }
                            }
                            
                            if (colIndex == lastColIndex)
                            {
                                fprintf(fileHandle, "\n");
                            }
                        }

                        fprintf(fileHandle, "\n.end\n");
                    }
                    else
                    {
                        auto byteCount = 1;

                        fprintf(fileHandle, "%d\n", byteCount);

                        unsigned char byte = 0;
                        for (auto pixelIndex = 0U; pixelIndex < pixelCount; ++pixelIndex)
                        {
                            auto binary = binData[1 * pixelIndex + 0];
                            if (binary)
                            {
                                byte |= (1U << pixelIndex);
                            }
                        }
                        fprintf(fileHandle, ".DB %d\n", byte);

                        fprintf(fileHandle, "\n.end\n");
                    }
                }
                else
                {
                    if (pixelCount >= 8)
                    {
                        auto byteCount = (unsigned int)(pixelCount / 8);

                        fwrite(&byteCount, sizeof(unsigned int), 1, fileHandle);

                        for (auto byteIndex = 0U; byteIndex < byteCount; ++byteIndex)
                        {
                            unsigned char byte = 0;
                            for (auto bitIndex = 0U; bitIndex < 8; ++bitIndex)
                            {
                                auto pixelIndex = 8U * byteIndex + bitIndex;
                                auto binary = binData[1 * pixelIndex + 0];
                                if (binary)
                                {
                                    byte |= (1U << bitIndex);
                                }
                            }
                            fwrite(&byte, sizeof(unsigned char), 1, fileHandle);
                        }
                    }
                    else
                    {
                        auto byteCount = 1;

                        fwrite(&byteCount, sizeof(unsigned int), 1, fileHandle);

                        unsigned char byte = 0;
                        for (auto pixelIndex = 0U; pixelIndex < pixelCount; ++pixelIndex)
                        {
                            auto binary = binData[1 * pixelIndex + 0];
                            if (binary)
                            {
                                byte |= (1U << pixelIndex);
                            }
                        }
                        fwrite(&byte, sizeof(unsigned char), 1, fileHandle);
                    }
                }

                fclose(fileHandle);
                fileHandle = NULL;

                delete[] binData;
                binData = nullptr;
            }
        }
    };
};