/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * Created by james <https://github.com/mystcolor> on 9/28/11.
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageDecoder.h"

@implementation UIImage (ForceDecode)

+ (UIImage *)decodedImageWithImage:(UIImage *)image {
    return image;
    // do not decode animated images
    if (image.images) { return image; }

    CGImageRef imageRef = image.CGImage;

    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
    BOOL anyAlpha = (alpha == kCGImageAlphaFirst ||
                     alpha == kCGImageAlphaLast ||
                     alpha == kCGImageAlphaPremultipliedFirst ||
                     alpha == kCGImageAlphaPremultipliedLast);

    if (anyAlpha) { return image; }

    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);

    CGContextRef context = CGBitmapContextCreate(NULL, width,
                                                 height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 CGImageGetColorSpace(imageRef),
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);

    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(context);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];

    CGContextRelease(context);
    CGImageRelease(imageRefWithAlpha);

    return imageWithAlpha;
}

@end
