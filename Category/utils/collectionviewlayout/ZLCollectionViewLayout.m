//
//  ZLCollectionViewLayout.m
//  Category
//
//  Created by long on 2018/5/17.
//  Copyright © 2018年 long. All rights reserved.
//

#import "ZLCollectionViewLayout.h"


#pragma mark -
#pragma mark - attributes
/** 背景属性 */
@interface ZLCollectionViewBackgroundLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) UIEdgeInsets imageInset;

@end

#pragma mark - backgroundreuseableview
@interface ZLCollectionBackgroundReusableView : UICollectionReusableView
@end


#pragma mark -
#pragma mark - layout

static NSString * const kBackgroundDecorationViewKind = @"ZLCollectionBackgroundReusableView";

static const CGFloat kDefaultItemSpace = 10;
static const CGFloat kDefaultItemWidth = 50;
static const CGFloat kDefaultItemHeight = 50;
static const CGFloat kDefaultLineSpace = 10;


@interface ZLCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *layouts;
@property (nonatomic, assign) CGFloat scrollLength;

@end


@implementation ZLCollectionViewLayout

- (instancetype)init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.scrollLength = 0.f;
    }
    return self;
}


#pragma mark - private method
- (void)_setupFlowLayoutAttributes {
    NSUInteger section = [self.collectionView numberOfSections];
    if (!section) return;
    
    NSUInteger count;
    id delegate = self.collectionView.delegate;
    
    CGFloat height = 0;          // 总长度
    
    CGFloat lineWidth = 0;       // 每组最大长度
    CGFloat marginFront = 0;     // 每组初始margin (left / top)
    UIEdgeInsets insets = UIEdgeInsetsZero;
    CGFloat lineSpace;
    CGFloat space;
    
    CGFloat lineHeight = 0;      // 记录每组换行长度
    CGSize itemSize = CGSizeMake(kDefaultItemWidth, kDefaultItemHeight);
    
    CGFloat width = 0;           // 每行item + space 宽度
    CGFloat front = 0;           // 每行item 的 x / y
    
    CGFloat itemWidth;
    CGFloat itemHeight;
    CGPoint itemOrigin;
    
    // background
    CGPoint beginPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    // 遍历每个区
    for (int i = 0; i < section; i ++) {
        count = [self.collectionView numberOfItemsInSection:i];
        
        // 添加区头
        [self _setupSectionHeader:YES section:i resultHeight:&height];
        
        // 记录背景初始位置 并注册
        if ([self _hasBackgroundView]) {
            beginPoint = [self _scrollVertical] ? CGPointMake(0, height) : CGPointMake(height, 0);
            
            [self registerClass:[ZLCollectionBackgroundReusableView class] forDecorationViewOfKind:kBackgroundDecorationViewKind];
        }
        
        // 设置配置参数
        if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            insets = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:i];
            if ([self _scrollVertical]) {
                lineWidth = CGRectGetWidth(self.collectionView.frame) - (insets.left + insets.right) - (self.collectionView.contentInset.left + self.collectionView.contentInset.right);
                marginFront = insets.left;
                height += insets.top;
            } else {
                lineWidth = CGRectGetHeight(self.collectionView.frame) - (insets.top + insets.bottom) - (self.collectionView.contentInset.top - self.collectionView.contentInset.bottom);
                if (@available (iOS 11.0, *)) {
                    lineWidth -= (self.collectionView.adjustedContentInset.top + self.collectionView.adjustedContentInset.bottom);
                }
                marginFront = insets.top;
                height += insets.left;
            }
            front = marginFront;
        }
        
        space = [self _spaceBetweenItemsWithSection:i];
        lineSpace = [self _spaceBetweenLinesWithSection:i];
        
        // 遍历每个item
        for (int j = 0; j < count; j ++) {
            UICollectionViewLayoutAttributes *layout = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            [self.layouts addObject:layout];
            
            if ([delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
                itemSize = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            }
            
            if ([self _scrollVertical]) {
                itemWidth = itemSize.width;
                itemHeight = itemSize.height;
            } else {
                itemWidth = itemSize.height;
                itemHeight = itemSize.width;
            }
            lineHeight = itemHeight > lineHeight ? itemHeight : lineHeight;
            
            if (lineWidth - width >= space + itemWidth) {
                // 这行能容下这个item
                if (width) width += space;
            } else {
                // 不能容下 换行
                height += (lineHeight + lineSpace);
                front = marginFront;
                width = 0;
            }
            
            if ([self _scrollVertical]) {
                itemOrigin = CGPointMake(front, height);
            } else {
                itemOrigin = CGPointMake(height, front);
            }
            layout.frame = (CGRect) {
                .origin = itemOrigin,
                .size = itemSize
            };
            
            front += itemWidth + space;
            width += itemWidth;
        }
        
        // 换区重置参数
        height += lineHeight + ([self _scrollVertical] ? insets.bottom : insets.right);
        front = marginFront;
        width = 0;
        
        
        // 设置背景
        if ([self _hasBackgroundView]) {
            
            endPoint = [self _scrollVertical] ? CGPointMake(lineWidth + insets.left + insets.right, height) : CGPointMake(height, lineWidth + insets.top + insets.bottom);
            
            ZLCollectionViewBackgroundLayoutAttributes *layout = [self _layoutAttributesForBackgroundWithSection:i beginPoint:beginPoint endPoint:endPoint];
            [self.layouts addObject:layout];
        }
        
        
        // 添加区尾
        [self _setupSectionHeader:NO section:i resultHeight:&height];
    }
    
    self.scrollLength = height;
}
// 设置分区头/分区尾
- (void)_setupSectionHeader:(BOOL)isHeader section:(NSUInteger)section resultHeight:(CGFloat *)height {
    
    id delegate = self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        
        UICollectionViewLayoutAttributes *layout = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:(isHeader ? UICollectionElementKindSectionHeader : UICollectionElementKindSectionFooter) withIndexPath:[NSIndexPath indexPathWithIndex:section]];
        layout.zIndex = 10;
        [self.layouts addObject:layout];
        
        CGSize size;
        CGPoint origin;
        if (isHeader) {
            size = [delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
        } else {
            size = [delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
        }
        if ([self _scrollVertical]) {
            origin = CGPointMake(0, *height);
            *height += size.height;
        } else {
            origin = CGPointMake(*height, 0);
            *height += size.width;
        }
        layout.frame = (CGRect) {
            .origin = origin,
            .size = size
        };
    }
}
- (CGFloat)_spaceBetweenItemsWithSection:(NSUInteger)section {
    
    id delegate = self.collectionView.delegate;
    CGFloat space = kDefaultItemSpace;
    if ([delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        space = [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    return space;
}
- (CGFloat)_spaceBetweenLinesWithSection:(NSUInteger)section {
    
    id delegate = self.collectionView.delegate;
    CGFloat lineSpace = kDefaultLineSpace;
    if ([delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        lineSpace = [delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    return lineSpace;
}
- (BOOL)_scrollVertical {
    return self.scrollDirection == UICollectionViewScrollDirectionVertical;
}

#pragma mark - background private
- (BOOL)_hasBackgroundView {
    return [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:backgroundColorForSection:)] || [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:backgroundImageForSection:)];
}
- (ZLCollectionViewBackgroundLayoutAttributes *)_layoutAttributesForBackgroundWithSection:(NSUInteger)section beginPoint:(CGPoint)begin endPoint:(CGPoint)end {
    
    CGRect backgroundRect = (CGRect) {
        .origin = begin,
        .size = CGSizeMake(end.x - begin.x, end.y - begin.y)
    };
    id delegate = self.collectionView.delegate;
    
    // 设置 装饰背景 布局属性
    ZLCollectionViewBackgroundLayoutAttributes *layout = [ZLCollectionViewBackgroundLayoutAttributes layoutAttributesForDecorationViewOfKind:kBackgroundDecorationViewKind withIndexPath:[NSIndexPath indexPathWithIndex:section]];
    layout.frame = backgroundRect;
    layout.zIndex = -10;
    
    if ([delegate respondsToSelector:@selector(collectionView:layout:backgroundColorForSection:)]) {
        layout.backgroundColor = [delegate collectionView:self.collectionView layout:self backgroundColorForSection:section];
    }
    if ([delegate respondsToSelector:@selector(collectionView:layout:backgroundImageForSection:)]) {
        layout.backgroundImage = [delegate collectionView:self.collectionView layout:self backgroundImageForSection:section];
    }
    
    if ([delegate respondsToSelector:@selector(imageInsetOfcollectionView:layout:backgroundImageForSection:)]) {
        layout.imageInset = [delegate imageInsetOfcollectionView:self.collectionView layout:self backgroundImageForSection:section];
    } else if (!UIEdgeInsetsEqualToEdgeInsets(self.backgroundImageInset, UIEdgeInsetsZero)) {
        layout.imageInset = self.backgroundImageInset;
    }
    
    return layout;
}


#pragma mark - override
- (void)prepareLayout {
    [super prepareLayout];
    
    [self.layouts removeAllObjects];
    [self _setupFlowLayoutAttributes];
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.layouts;
}

//可滚动范围
- (CGSize)collectionViewContentSize {
    return [self _scrollVertical] ?
        CGSizeMake(0, self.scrollLength) :
        CGSizeMake(self.scrollLength, 0);
}


#pragma mark - property
- (NSMutableArray<UICollectionViewLayoutAttributes *> *)layouts {
    if (!_layouts) {
        _layouts = [NSMutableArray array];
    }
    return _layouts;
}

@end





#pragma mark -
#pragma mark - attributes
@implementation ZLCollectionViewBackgroundLayoutAttributes
@end


#pragma mark - reuseableview
@interface ZLCollectionBackgroundReusableView ()

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation ZLCollectionBackgroundReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    if ([layoutAttributes isKindOfClass:[ZLCollectionViewBackgroundLayoutAttributes class]]) {
        ZLCollectionViewBackgroundLayoutAttributes *attr = (ZLCollectionViewBackgroundLayoutAttributes *)layoutAttributes;
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
