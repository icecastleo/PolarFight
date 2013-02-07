//
//  TiledMapCamera.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/2/5.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TiledMapCamera : CCNode {
    CCTMXTiledMap *map;
    
    CGPoint center;
    
    float widthMax;
    float heightMax;
    
    id target;
    SEL selector;
    
    float moveX;
    float moveY;
    bool move;
    
    int moveCountDown;
    CGPoint delta;
    CGPoint acceleration;
}

-(id)initWithTiledMap:(CCTMXTiledMap *)aMap;

-(void)moveCameraX:(float)x Y:(float)y;
-(void)moveCameraToX:(float)x Y:(float)y;
-(void)smoothMoveCameraToX:(float)x Y:(float)y;
-(void)smoothMoveCameraToX:(float)x Y:(float)y delegate:(id)aTarget selector:(SEL)aSelector;

@end