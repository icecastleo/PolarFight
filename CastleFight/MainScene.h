//
//  MainScene.h
//  CastleFight
//
//  Created by 朱 世光 on 13/4/1.
//
//

#import "cocos2d.h"

@interface MainScene : CCScene {
    int layerIndex;
    
    CCLayer *subLayer;
}

-(void)back;
-(void)next;

@end
