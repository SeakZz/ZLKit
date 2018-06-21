//
//  ZLPageTabView.m
//  Category
//
//  Created by long on 2018/4/11.
//  Copyright © 2018年 long. All rights reserved.
//

#import "ZLPageTabView.h"
#import "UIColor+ZLExtension.h"
#import "UIView+ZLFrame.h"

#pragma mark - cell interface
@interface ZLPageTabCell: UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

@end


#pragma mark -
#pragma mark - pagebarview
static NSString *const identifier = @"ZLPageTabCell";

@interface ZLPageTabView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) CALayer *bottomLineLayer;

@end

@implementation ZLPageTabView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupDefaultValues];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    self.lineView.bottom = self.height;
    self.bottomLineLayer.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 1, CGRectGetWidth(self.bounds), 1);
}

- (void)setupDefaultValues {
    
    self.titleColor = [UIColor colorWithRgbHex:0x666666];
    self.titleFont = [UIFont systemFontOfSize:ZLPageTabCellTitleFontSize];
}

#pragma mark - public method
- (void)setLineCenterX:(CGFloat)centerX {
    if (!(self.style & ZLSegmentValueChangedStyleLine)) return;
    
    self.lineView.center = CGPointMake(centerX, self.lineView.center.y);
}
- (void)setColorChangedWithIndex:(NSUInteger)idx progress:(CGFloat)progress {
    if (!(self.style & ZLSegmentValueChangedStyleColor)) return;
    
    ZLPageTabCell *cell = (ZLPageTabCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    ZLPageTabCell *anotherCell = (ZLPageTabCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx + 1 inSection:0]];
    
    cell.titleColor = [UIColor mixColor1:self.titleColor color2:self.selectedTitleColor ratio:fabs(progress)];
    anotherCell.titleColor = [UIColor mixColor1:self.selectedTitleColor color2:self.titleColor ratio:fabs(progress)];
}
- (void)setFontChangedWithIndex:(NSUInteger)idx progress:(CGFloat)progress {
    if (!(self.style & ZLSegmentValueChangedStyleFont)) return;
    
    ZLPageTabCell *cell = (ZLPageTabCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    ZLPageTabCell *anotherCell = (ZLPageTabCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx + 1 inSection:0]];
    
    CGFloat i = (self.selectedTitleFont.pointSize - self.titleFont.pointSize) * progress;
    cell.titleFont = [UIFont fontWithName:self.titleFont.fontName size:self.selectedTitleFont.pointSize - i];
    anotherCell.titleFont = [UIFont fontWithName:self.titleFont.fontName size:self.titleFont.pointSize + i];
}
- (void)scrollKeepCellPositionCenterToIndex:(NSUInteger)idx {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - setter
- (void)setStyle:(ZLSegmentValueChangedStyle)style {
    _style = style;
    
    if (style & ZLSegmentValueChangedStyleLine) {
        [self.collectionView addSubview:self.lineView];
        self.lineView.backgroundColor = self.lineColor;
    }
    if (style & ZLSegmentValueChangedStyleColor) {
        
    }
    if (style & ZLSegmentValueChangedStyleFont) {
        
    }
}
- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    _bottomLineColor = bottomLineColor;
    
    [self.layer addSublayer:self.bottomLineLayer];
    self.bottomLineLayer.backgroundColor = bottomLineColor.CGColor;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLPageTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.title = self.titles[indexPath.row];
    
    if (self.style & ZLSegmentValueChangedStyleColor) {
        cell.titleColor = self.currentIndex == indexPath.item ? self.selectedTitleColor : self.titleColor;
    } else {
        cell.titleColor = self.titleColor;
    }
    
    
    if (self.style & ZLSegmentValueChangedStyleFont) {
        cell.titleFont = self.currentIndex == indexPath.item ? self.selectedTitleFont : self.titleFont;
    } else {
        cell.titleFont = self.titleFont;
    }
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self.widths[indexPath.item] floatValue], self.bounds.size.height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.item;
    if (self.itemSelectedBlock) self.itemSelectedBlock(indexPath.row);
}

#pragma mark - property
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZLPageTabViewLineWidth, ZLPageTabViewLineHeight)];
    }
    return _lineView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        
        [_collectionView registerClass:[ZLPageTabCell class] forCellWithReuseIdentifier:identifier];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
- (CALayer *)bottomLineLayer {
    if (!_bottomLineLayer) {
        _bottomLineLayer = [CALayer layer];
    }
    return _bottomLineLayer;
}
- (UIColor *)lineColor {
    if (!_lineColor) {
        _lineColor = [UIColor redColor];
    }
    return _lineColor;
}
- (UIColor *)selectedTitleColor {
    if (!_selectedTitleColor) {
        _selectedTitleColor = [UIColor redColor];
    }
    return _selectedTitleColor;
}
- (UIFont *)selectedTitleFont {
    if (!_selectedTitleFont) {
        _selectedTitleFont = [UIFont systemFontOfSize:17];
    }
    return _selectedTitleFont;
}

@end





#pragma mark -
#pragma mark - tabcell
@interface ZLPageTabCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZLPageTabCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    
    self.titleLabel.text = _title;
    self.titleLabel.frame = self.bounds;
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    self.titleLabel.textColor = titleColor;
}
- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    
    self.titleLabel.font = titleFont;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
