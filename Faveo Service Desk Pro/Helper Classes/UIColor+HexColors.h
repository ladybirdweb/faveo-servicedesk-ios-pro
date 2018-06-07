//
// UIColor+HexColors.h
//
// The MIT License (MIT)
//
// Copyright (c) 2010 Russell Quinn (mail@russellquinn.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#define OPAQUE_HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0	blue:(c&0xFF)/255.0	alpha:1.0];

@interface UIColor (HexColors)
+ (UIColor *)colorFromHexString:(NSString *)hex;
+ (NSString *)hexStringFromColor:(UIColor *)color;
@end

#import "UIColor+HexColors.h"

@implementation UIColor (HexColors)

+ (UIColor *)colorFromHexString:(NSString *)hex
{
	if (hex == nil)
	{
		return nil;
	}
	
	NSScanner *scanner = [NSScanner scannerWithString:hex];
	unsigned int tempInt;
	[scanner scanHexInt:&tempInt];
	
	return OPAQUE_HEXCOLOR(tempInt);
}

+ (NSString *)hexStringFromColor:(UIColor *)color
{
    if (color == nil)
    {
        return nil;
    }
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r;
    CGFloat g;
    CGFloat b;
    
    if (CGColorGetNumberOfComponents(color.CGColor) == 2)
    {
        r = components[0];
        g = components[0];
        b = components[0];
    }
    else
    {
        r = components[0];
        g = components[1];
        b = components[2];
    }
    
	r = MIN(MAX(r, 0.0f), 1.0f);
	g = MIN(MAX(g, 0.0f), 1.0f);
	b = MIN(MAX(b, 0.0f), 1.0f);
    
	unsigned int hexColor = (((int)roundf(r * 255)) << 16) | (((int)roundf(g * 255)) << 8) | (((int)roundf(b * 255)));
    
    return [NSString stringWithFormat:@"%0.6X", hexColor];
}

@end
