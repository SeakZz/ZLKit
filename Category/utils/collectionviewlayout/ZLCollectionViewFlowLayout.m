//
//  ZLCollectionViewFlowLayout.m
//  Category
//
//  Created by long on 2018/1/31.
//  Copyright © 2018年 long. All rights reserved.
//

#import "ZLCollectionViewFlowLayout.h"
#import "ZLCollectionReusableView.h"

static NSString * const kDecorationViewKind = @"ZLCollectionReusableView";

@interface ZLCollectionViewFlowLayout ()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *decorationViewLayoutAttributes;

@end

@implementation ZLCollectionViewFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.itemAlignment = ZLCollectionViewFlowLayoutItemAlignmentAuto;
    }
    return self;
}


#pragma mark - private method
- (NSArray<UICollectionViewLayoutAttributes *> *)resetPositionOfItemsLayouts:(NSArray <UICollectionViewLayoutAttributes *> *)layouts withItemAlignment:(ZLCollectionViewFlowLayoutItemAlignment)itemAlignment {
    
    switch (itemAlignment) {
        case ZLCollectionViewFlowLayoutItemAlignmentAuto:
            break;
        case ZLCollectionViewFlowLayoutItemAlignmentLeft:
            [self resetPositionAlignmentLeftOfItems:layouts];
            break;
        case ZLCollectionViewFlowLayoutItemAlignmentRight:
            [self resetPositionAlignmentRightOfItems:layouts];
            break;
        case ZLCollectionViewFlowLayoutItemAlignmentCenter:
            [self resetPositionAlignmentCenterOfItems:layouts];
            break;
    }
    
    return layouts;
}

// 设置左对齐
- (void)resetPositionAlignmentLeftOfItems:(NSArray <UICollectionViewLayoutAttributes *> *)layouts {
    
    CGFloat y = FLT_MAX;
    CGFloat x = 0;
    id delegate = self.collectionView.delegate;
    for (UICollectionViewLayoutAttributes *layout in layouts) {
        if ([layout.representedElementKind isEqualToString:UICollectionElementKindSectionHeader] ||
            [layout.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            continue;
        }
        
        // 判断是否换行
        if (y != CGRectGetMinY(layout.frame)) {
            
            // 换行处理
            y = CGRectGetMinY(layout.frame);
            
            x = self.sectionInset.left;
            if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
                x = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:layout.indexPath.section].left;
            }
        }
        
        // 重新设置cell 的 x
        layout.frame = (CGRect) {
            .origin = CGPointMake(x, y),
            .size = layout.frame.size
        };
        x += CGRectGetWidth(layout.frame);
        
        CGFloat space = self.minimumInteritemSpacing;
        if ([delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
            space = [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:layout.indexPath.section];
        }
        x += space;
    }
}

// 设置右对齐
- (void)resetPositionAlignmentRightOfItems:(NSArray <UICollectionViewLayoutAttributes *> *)layouts {
    
    CGFloat y = FLT_MAX;
    
    // 保存一行的 item layoutattributes
    NSMutableArray<UICollectionViewLayoutAttributes *> *lineLayouts = [NSMutableArray array];
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    CGFloat right;
    
    id delegate = self.collectionView.delegate;
    for (UICollectionViewLayoutAttributes *layout in layouts) {
        if ([layout.representedElementKind isEqualToString:UICollectionElementKindSectionHeader] ||
            [layout.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            continue;
        }
        
        // 判断是否换行
        if (y != CGRectGetMinY(layout.frame)) {
            // 换行处理
            
            right = width - self.sectionInset.right;
            if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
                right = width - [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:layout.indexPath.section].right;
            }
            
            [self setFrameOfLineLayouts:lineLayouts right:right];
            
            [lineLayouts removeAllObjects];
            
            y = CGRectGetMinY(layout.frame);
        }
        
        [lineLayouts addObject:layout];
    }
    
    if (!lineLayouts.count) return;
    right = width - self.sectionInset.right;
    if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        right = width - [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:lineLayouts.firstObject.indexPath.section].right;
    }
    [self setFrameOfLineLayouts:lineLayouts right:right];
}

// 设置居中对齐
- (void)resetPositionAlignmentCenterOfItems:(NSArray <UICollectionViewLayoutAttributes *> *)layouts {
    
    CGFloat y = FLT_MAX;
    
    // 保存一行的 item layoutattributes
    NSMutableArray<UICollectionViewLayoutAttributes *> *lineLayouts = [NSMutableArray array];
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    CGFloat leading;
    CGFloat trailing;
    CGFloat lineWidth = 0;
    CGFloat space;
    
    id delegate = self.collectionView.delegate;
    
    for (UICollectionViewLayoutAttributes *layout in layouts) {
        if ([layout.representedElementKind isEqualToString:UICollectionElementKindSectionHeader] ||
            [layout.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            continue;
        }
        
        // 判断是否换行
        if (y != CGRectGetMinY(layout.frame)) {
            // 换行处理
            
            space = self.minimumInteritemSpacing;
            if ([delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
                space = [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:layout.indexPath.section];
            }
            lineWidth += (lineLayouts.count - 1) * space;
            
            leading = self.sectionInset.left;
            trailing = self.sectionInset.right;
            if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
                leading = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:layout.indexPath.section].left;
                trailing = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:layout.indexPath.section].right;
            }
            leading += (width - leading - trailing - lineWidth) / 2;
            
            [self setFrameOfLineLayouts:lineLayouts leading:leading];
            
            [lineLayouts removeAllObjects];
            lineWidth = 0;
            
            y = CGRectGetMinY(layout.frame);
        }
        
        [lineLayouts addObject:layout];
        lineWidth += CGRectGetWidth(layout.frame);
    }
    
    if (!lineLayouts.count) return;
    space = self.minimumInteritemSpacing;
    if ([delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        space = [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:lineLayouts.firstObject.indexPath.section];
    }
    lineWidth += (lineLayouts.count - 1) * space;
    
    leading = self.sectionInset.left;
    trailing = self.sectionInset.right;
    if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        leading = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:lineLayouts.firstObject.indexPath.section].left;
        trailing = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:lineLayouts.firstObject.indexPath.section].right;
    }
    leading += (width - leading - trailing - lineWidth) / 2;
    
    [self setFrameOfLineLayouts:lineLayouts leading:leading];
}

// 设置每行靠右
- (void)setFrameOfLineLayouts:(NSArray *)lineLayouts right:(CGFloat)right {
    id delegate = self.collectionView.delegate;
    
    for (UICollectionViewLayoutAttributes *lineLayout in [[lineLayouts reverseObjectEnumerator] allObjects]) {
        
        // 重新设置cell 的 x
        lineLayout.frame = (CGRect) {
            .origin = CGPointMake(right - CGRectGetWidth(lineLayout.frame), CGRectGetMinY(lineLayout.frame)),
            .size = lineLayout.frame.size
        };
        right = CGRectGetMinX(lineLayout.frame);
        
        CGFloat space = self.minimumInteritemSpacing;
        if ([delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
            space = [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:lineLayout.indexPath.section];
        }
        right -= space;
    }
}

// 设置每行按leading 连接
- (void)setFrameOfLineLayouts:(NSArray *)lineLayouts leading:(CGFloat)leading {
    id delegate = self.collectionView.delegate;
    
    for (UICollectionViewLayoutAttributes *lineLayout in lineLayouts) {
        
        // 重新设置cell 的 x
        lineLayout.frame = (CGRect) {
            .origin = CGPointMake(leading, CGRectGetMinY(lineLayout.frame)),
            .size = lineLayout.frame.size
        };
        leading = CGRectGetMaxX(lineLayout.frame);
        
        CGFloat space = self.minimumInteritemSpacing;
        if ([delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
            space = [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:lineLayout.indexPath.section];
        }
        leading += space;
    }
}


#pragma mark - override
// 准备方法被自动调用，以保证layout实例的正确。
- (void)prepareLayout {
    [super prepareLayout];
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    id delegate = self.collectionView.delegate;
    if (!numberOfSections || ![delegate conformsToProtocol:@protocol(ZLCollectionDecorationViewDelegateFlowLayout)]) {
        return;
    }
    // 实现背景图 或者 颜色 才加载
    if (![delegate respondsToSelector:@selector(collectionView:layout:backgroundImageForSection:)] && ![delegate respondsToSelector:@selector(collectionView:layout:backgroundColorForSection:)]) {
        return;
    }
    
    [self.decorationViewLayoutAttributes removeAllObjects];
    // 注册装饰背景图
    [self registerClass:[ZLCollectionReusableView class] forDecorationViewOfKind:kDecorationViewKind];
    
    
    for (NSInteger section = 0; section < numberOfSections; section++) {
        
        NSIndexPath *ip = [[NSIndexPath alloc] initWithIndex:section];
        UICollectionViewLayoutAttributes *layout = [self layoutAttributesForDecorationViewOfKind:kDecorationViewKind atIndexPath:ip];
        
        if (!layout) continue;
        [self.decorationViewLayoutAttributes addObject:layout];
    }
}

/*
    1.返回rect中的所有的元素的布局属性
    2.返回的是包含UICollectionViewLayoutAttributes的NSArray
    3.UICollectionViewLayoutAttributes可以是cell，追加视图或装饰视图的信息，通过不同的UICollectionViewLayoutAttributes初始化方法可以得到不同类型的UICollectionViewLayoutAttributes：
    1)layoutAttributesForCellWithIndexPath:
    2)layoutAttributesForSupplementaryViewOfKind:withIndexPath:
    3)layoutAttributesForDecorationViewOfKind:withIndexPath:
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 深拷贝 消除警告 Logging only once for UICollectionViewFlowLayout cache mismatched frame
    NSArray *layouts = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    // 改变默认对齐格式
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        layouts = [self resetPositionOfItemsLayouts:layouts withItemAlignment:self.itemAlignment];
    }
    
    // 添加背景布局属性
    NSMutableArray *mutableLayouts = [layouts mutableCopy];
    for (UICollectionViewLayoutAttributes *layout in self.decorationViewLayoutAttributes) {

        // 添加rect中的所有的元素的布局属性
        if (CGRectIntersectsRect(rect, layout.frame)) {
            [mutableLayouts addObject:layout];
        }
    }
    return [mutableLayouts copy];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}

// 返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (![elementKind isEqualToString:kDecorationViewKind]) {
        return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
    }
    
    id delegate = self.collectionView.delegate;
    NSUInteger section = indexPath.section;
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
    if (numberOfItems <= 0) {
        return nil;
    }
    
    UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:numberOfItems - 1 inSection:section]];
    if (!firstItem || !lastItem) {
        return nil;
    }
    
    // 获取 sectioninset
    UIEdgeInsets sectionInset = [self sectionInset];
    if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        UIEdgeInsets inset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        sectionInset = inset;
    }
    
    
    // 设置 背景大小
    CGRect sectionFrame = CGRectUnion(firstItem.frame, lastItem.frame);
    sectionFrame.origin.x -= sectionInset.left;
    sectionFrame.origin.y -= sectionInset.top;
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        sectionFrame.size.width += sectionInset.left + sectionInset.right;
        sectionFrame.size.height = self.collectionView.frame.size.height;
    } else {
        sectionFrame.size.width = self.collectionView.frame.size.width;
        sectionFrame.size.height += sectionInset.top + sectionInset.bottom;
    }
    
    
    // 设置 装饰背景 布局属性
    ZLCollectionViewLayoutAttributes *layout = [ZLCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kDecorationViewKind withIndexPath:indexPath];
    layout.frame = sectionFrame;
    layout.zIndex = -1;
    
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


#pragma mark - getter
- (NSMutableArray<UICollectionViewLayoutAttributes *> *)decorationViewLayoutAttributes {
    if (!_decorationViewLayoutAttributes) {
        _decorationViewLayoutAttributes = [NSMutableArray array];
    }
    return _decorationViewLayoutAttributes;
}

@end
