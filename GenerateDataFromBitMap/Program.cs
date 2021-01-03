using System;
using System.Drawing;

namespace GenerateData
{
    class Program
    {

        static Bitmap image1;

        static void Main(string[] args)
        {
            try
            {
                // Retrieve the image.
                image1 = new Bitmap(@"C:\users\zoggi\desktop\Untitled.bmp");


                // Loop through the images pixels to reset color.
                for (int row = 0; row < 4; ++row)
                {
                    
                    for(int column = 0; column < 128; ++column)
                    {
                        if (column % 8 == 0)
                        {
                            Console.Write("DB ");
                        }

                        byte data = 0;
                        for (int pixel = 0; pixel < 8; ++pixel)
                        {
                            Color pixelColor = image1.GetPixel(column, row * 8 + pixel);
                            if (pixelColor.R != 255 || pixelColor.G != 255 || pixelColor.B != 255)
                            {
                                data |= (byte)(1 << pixel);
                            }
                        }

                        Console.Write("0x" + data.ToString("X2"));

                        if (column == 127 || (column % 8 == 7))
                        {
                            Console.Write("\n");
                        }
                        else
                        {
                            Console.Write(", ");
                        }

                    }
                    Console.Write("\n");
                }
              
            }
            catch (ArgumentException)
            {
                Console.Write("error");
            }
        }
    }
}
