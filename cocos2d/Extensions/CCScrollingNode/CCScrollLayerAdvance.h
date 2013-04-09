//
//  CCScrollLayerAdvance.h
//  CastleFight
//
//  Created by 朱 世光 on 13/4/8.
//
//

#import "CCScrollNode.h"

@interface CCScrollLayerAdvance : CCScrollNode {
    UIPageControl *pageControl;
}

-(id)initWithRect:(CGRect)rect layers:(NSArray *)layers;

@end
