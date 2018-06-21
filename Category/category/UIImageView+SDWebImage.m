//
//  UIImageView+SDWebImage.m
//  Category
//
//  Created by long on 2018/1/10.
//  Copyright © 2018年 long. All rights reserved.
//

#import "UIImageView+SDWebImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+ZLDraw.h"

@implementation UIImageView (SDWebImage)

- (void)sd_loadImageWithUrlString:(NSString *)urlString
                 placeholderImage:(UIImage *)placeholder {
    
    [self sd_setImageWithURL:[NSURL URLWithString:urlString]
            placeholderImage:placeholder];
}

- (void)sd_loadCircleImageWithUrlString:(NSString *)urlString
                       placeholderImage:(UIImage *)placeholder {
    
    [self sd_loadImageWithUrlString:urlString
                   placeholderImage:placeholder
                       cornerRadius:self.bounds.size.width / 2];
}

- (void)sd_loadImageWithUrlString:(NSString *)urlString
                 placeholderImage:(UIImage *)placeholder
                     cornerRadius:(CGFloat)radius {
    
    self.image = placeholder;
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageRetryFailed | SDWebImageAvoidAutoSetImage progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        if (!image) return ;
        
        NSString *imageKey = [NSString stringWithFormat:@"long_%@", imageURL.absoluteString];
        
        UIImage *cacheImage;
        cacheImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageKey];
        if (cacheImage) {
            self.image = cacheImage;
            return;
        }
        cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageKey];
        if (cacheImage) {
            self.image = cacheImage;
            return;
        }
        
        [image asyncDrawImageWithSize:self.bounds.size
                         cornerRadius:radius
                           completion:^(UIImage *image) {
            self.image = image;
            
            [[SDImageCache sharedImageCache] storeImage:image forKey:imageKey completion:nil];
        }];
    }];
}


@end
