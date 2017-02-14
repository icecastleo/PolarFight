//
//  FightStageLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/10/15.
//
//

#import "FightStageLayer.h"

@implementation FightStageLayer

-(id)init {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    if (self = [super initWithRect:CGRectMake(winSize.width/4, 0, winSize.width/2, winSize.height)]) {
        
    }
    return self;
}

@end
