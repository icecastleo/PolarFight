//
//  ScrollingNode.h
//  Cocos2dScrolling
//
//  Created by Tony Ngo on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCScrollingNode : CCNode<UIScrollViewDelegate> {
    CGFloat uiY;
}

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (readonly) CGRect rect;

-(id)initWithRect:(CGRect)aRect;

@end
