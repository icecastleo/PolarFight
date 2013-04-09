//
//  ShopUnitLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/8.
//
//

#import "ShopUnitLayer.h"
#import "FileManager.h"

@interface ShopUnitLayerMenuItem : CCMenuItemSprite

-(id)initWithCharacter:(Character *)character;

@end

@implementation ShopUnitLayerMenuItem

-(id)initWithCharacter:(Character *)character {
    if (self = [super init]) {
//        shop_cell_r.png
    }
}

@end

@implementation ShopUnitLayer

-(id)init {
    if (self = [super init]) {
        NSArray *characters = [[FileManager sharedFileManager] getChararcterArray];
    }
    return self;
}

@end
