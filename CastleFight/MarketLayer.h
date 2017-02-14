//
//  MarketLayer.h
//  CastleFight
//
//  Created by 陳 謙 on 13/4/9.
//
//
#import "cocos2d.h"
#import "CCLayer.h"

@interface MarketLayer : CCLayer {
    NSArray *products;
}

+(CCScene *)sceneWithProducts:(NSArray *)products;

@end
