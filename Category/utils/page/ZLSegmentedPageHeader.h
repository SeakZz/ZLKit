//
//  ZLSegmentedPageHeader.h
//  Category
//
//  Created by long on 2018/4/16.
//  Copyright © 2018年 long. All rights reserved.
//

#ifndef ZLSegmentedPageHeader_h
#define ZLSegmentedPageHeader_h

typedef NS_OPTIONS(NSUInteger, ZLSegmentValueChangedStyle) {
    /** 无效果 */
    ZLSegmentValueChangedStyleNone = 0,
    /** 选中下划线 */
    ZLSegmentValueChangedStyleLine = 1 << 0,
    /** 选中变色 */
    ZLSegmentValueChangedStyleColor = 1 << 1,
    /** 选中变大 */
    ZLSegmentValueChangedStyleFont = 1 << 2,
};

// ZLSegmentedPageController
static CGFloat const ZLSegmentedPageControllerSegmentHeight = 39;
static CGFloat const ZLSegmentedPageControllerSegmentItemSpace = 20;
static CGFloat const ZLPageTabCellTitleFontSize = 15;


// ZLPageTabView
static CGFloat const ZLPageTabViewLineHeight = 2;
static CGFloat const ZLPageTabViewLineWidth = 50;

#endif /* ZLSegmentedPageHeader_h */
