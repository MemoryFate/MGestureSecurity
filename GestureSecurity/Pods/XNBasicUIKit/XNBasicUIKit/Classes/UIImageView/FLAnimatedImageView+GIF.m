//
//  FLAnimatedImageView+GIF.m
//  XNBasicUIKit
//
//  Created by 江红胡 on 2018/5/7.
//

#import "FLAnimatedImageView+GIF.h"
#import "UIImageView+WebCache.h"
#import "FLAnimatedImage.h"
#import "NSString+XNB.h"

@implementation FLAnimatedImageView (GIF)

- (void)xnb_animatedImageWithGIFURL:(NSURL *)url
{
    if ([url.absoluteString xnb_gifImageUrl]) {
        __block FLAnimatedImage *animatedImage = nil;
        dispatch_queue_t imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);;
        dispatch_async(imageQueue, ^{
            animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:url]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.animatedImage = animatedImage;
            });
        });
    } else {
        [self sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [[SDWebImageManager sharedManager] cacheKeyForURL:url];
            
            self.image = image;
        }];
    }
}

@end
