//
//  ScrollingNode.h
//  Cocos2dScrolling
//
//  Created by Tony Ngo on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCScrollView.h"

@interface CCScrollNode : CCNode<UIScrollViewDelegate> {
    CGFloat uiY;
}

@property (nonatomic, readonly) CCScrollView *scrollView;
@property (readonly) CGRect rect;
@property (nonatomic) BOOL adjustPosition;

-(id)initWithRect:(CGRect)aRect;

@end
