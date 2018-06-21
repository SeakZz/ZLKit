//
//  AlertView.m
//  Category
//
//  Created by long on 2018/1/16.
//  Copyright © 2018年 long. All rights reserved.
//

#import "AlertView.h"

@interface AlertView ()

@end


@implementation AlertView


- (IBAction)next:(id)sender {
    if (self.nextBlock) self.nextBlock();
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
