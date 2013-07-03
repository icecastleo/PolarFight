//
//  SummonComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/16.
//
//

#import "SummonComponent.h"
#import "FileManager.h"
#import "PlayerComponent.h"

@implementation SummonComponent

@dynamic canSummon;
@dynamic isCostSufficient;

-(id)initWithCharacterInitData:(CharacterInitData *)initData {
    if (self = [super init]) {
        _data = initData;
        
        NSDictionary *dic = [[FileManager sharedFileManager] getCharacterDataWithCid:_data.cid];
        _cost = [[dic objectForKey:@"cost"] intValue];
        
        [self setCooldown];
    
        _currentCooldown = 0;
        _summon = NO;
        _readyToLine = NO;
    }
    return self;
}

-(void)setCooldown {
    // Assume min cost of monster -> 15
    _cooldown = 3.0 + (_cost - 15) / 25.0 * 2;
}

-(BOOL)canSummon {
    if (_currentCooldown > 0 || !self.isCostSufficient) {
        return NO;
    }
    
    return YES;
}

-(BOOL)isCostSufficient {
    NSAssert(_player, @"Who will you summon for?");
    
    if (_player.food >= _cost) {
        return YES;
    } else {
        return NO;
    }
}

@end
