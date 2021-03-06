// --------------------------------------------------------------------------
//
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

@interface UIImage(ECCore)

- (UIImage*)imageByCroppingToRect:(CGRect)bounds;
- (UIImage*)imageByresizingToFit:(CGSize)targetSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage*)imageAsThumbnail:(NSInteger)thumbnailSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage*)imageByResizingTo:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage*)imageByResizingWithContentMode:(UIViewContentMode)contentMode bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage*)imageAsGreyscale:(CGFloat)scale;
- (UIImage*)imageByColourising:(UIColor *)theColor;

@end

