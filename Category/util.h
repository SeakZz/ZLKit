//
//  util.h
//  Category
//
//  Created by long on 2018/2/9.
//  Copyright © 2018年 long. All rights reserved.
//

#ifndef util_h
#define util_h


UIScrollView *sv = [UIScrollView new];
[sv.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];

#endif /* util_h */
