//
//  StoreUnitDetailSprite.m
//  CastleFight
//
//  Created by 朱 世光 on 2013/11/5.
//
//

#import "StoreUnitDetailSprite.h"
#import "CCScissorLayer.h"

@implementation StoreUnitDetailSprite

-(id)init {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    if (self = [super initWithRect:CGRectMake(winSize.width/8, 0, winSize.width/4*2, winSize.height) maskPriotity:kCCScissorLayerTouchPriority-10]) {
        
        CCLabelTTF *name = [CCLabelTTF labelWithString:@"角色的名字" fontName:@"Baskerville-Bold" fontSize:12];
        name.anchorPoint = ccp(0, 0);
        name.position = ccp(60, self.boundingBox.size.height-20);
        name.color = ccBLACK;
        [self.frame addChild:name];
    }
    return self;
}

@end
