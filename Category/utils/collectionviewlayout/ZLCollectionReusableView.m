//
//  ZLCollectionReusableView.m
//  Category
//
//  Created by long on 2018/1/31.
//  Copyright © 2018年 long. All rights reserved.
//

#import "ZLCollectionReusableView.h"


#pragma mark - attributes
@implementation ZLCollectionViewLayoutAttributes
@end


#pragma mark - reuseableview
@interface ZLCollectionReusableView ()

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation ZLCollectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    
    if ([layoutAttributes isKindOfClass:[ZLCollectionViewLayoutAttributes class]]) {
        ZLCollectionViewLayoutAttributes *attr = (ZLCollectionViewLayoutAttributes *)layoutAttributes;
        if (attr.backgroundColor) {
            self.backgroundColor = attr.backgroundColor;
        }
        
        if (attr.backgroundImage) {
            CGRect imageRect = (CGRect) {
                .origin.x = attr.imageInset.left,
                .origin.y = attr.imageInset.top,
                .size.width = self.bounds.size.width - attr.imageInset.left - attr.imageInset.right,
                .size.height = self.bounds.size.height - attr.imageInset.top - attr.imageInset.bottom
            };
            
            self.imageView.image = attr.backgroundImage;
            self.imageView.frame = imageRect;
        }
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
    }
    return _imageView;
}

@end
