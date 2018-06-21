//
//  NSArray+ZLExtension.m
//  Category
//
//  Created by long on 2018/1/30.
//  Copyright © 2018年 long. All rights reserved.
//

#import "NSArray+ZLExtension.h"

@implementation NSArray (ZLExtension)

- (NSArray *)reverseArray {
    return [[self reverseObjectEnumerator] allObjects];
}


@end
