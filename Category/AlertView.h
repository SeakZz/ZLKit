//
//  AlertView.h
//  Category
//
//  Created by long on 2018/1/16.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView

@property (nonatomic, strong) void (^nextBlock)(void);

@end
