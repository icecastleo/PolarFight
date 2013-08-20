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
#import "Constant.h"
@implementation SummonComponent

@dynamic canSummon;
@dynamic isCostSufficient;

+(NSString *)name {
    static NSString *name = @"SummonComponent";
    return name;
}

-(id)initWithCharacterInitData:(CharacterInitData *)initData {
    if (self = [super init]) {
        _data = initData;
        
        NSDictionary *dic = [[FileManager sharedFileManager] getCharacterDataWithCid:_data.cid];
        _cost = [[dic objectForKey:@"cost"] intValue];
        
        _summonType = kSummonTypeStockOnce;
        
        _currentCooldown = 0;
        _currentStock = 0;
        _summon = NO;
        
        [self setCooldown];
    }
    return self;
}

-(void)setCooldown {
    // Assume min cost of monster -> 15
    switch (_summonType) {
        case kSummonTypeNormal:
            _cooldown = 3.0 + (_cost - 15) / 25.0 * 2;
            break;
        case kSummonTypeStock:
            _cooldown = _cost/3;
            break;
        case kSummonTypeStockOnce:
            _cooldown = _cost/3;
             break;
        default:
            NSAssert(NO, @"You have a wrong type!");
            break;
    }
}

-(void)setWithMenuItem:(UnitMenuItem *)item {
    switch (_summonType) {
        case kSummonTypeNormal:
            break;
        case kSummonTypeStock: {
            _currentCooldown = _cooldown;
            [item resetMask:_cooldown from:100 to:0];
            
            NSString *s = [[NSNumber numberWithFloat:_currentStock] stringValue];
            [item updateLabelString:s];
            break;
        }
        case kSummonTypeStockOnce: {
            _currentCooldown = _cooldown;
            [item resetMask:_cooldown from:100 to:0];
            [item updateLabelString:@""];
            break;
        }
        default:
            break;
    }
}

-(BOOL)canSummon {
    switch (_summonType) {
        case kSummonTypeNormal:
            if (_currentCooldown > 0 || !self.isCostSufficient) {
                return NO;
            }
            break;
        case kSummonTypeStock:
            if(_currentStock <= 0) {
                return NO;
            }
            break;
        case kSummonTypeStockOnce:
            if(_currentStock <= 0) {
                return NO;
            }
            break;
        default:
            NSAssert(NO, @"Your type is wrong!");
            break;
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

-(void)updateSummon {
    
    switch (_summonType) {
        case kSummonTypeNormal:
            break;
        case kSummonTypeStock:
            if(_currentCooldown <= 0) {
                _currentStock++;
                _currentCooldown += _cooldown;
                
                if(self.menuItem) {
                    NSString *s = [[NSNumber numberWithFloat:_currentStock] stringValue];
                    [self.menuItem updateLabelString:s];
                }
            }
            break;
        case kSummonTypeStockOnce:
            if(_currentCooldown <= 0 && _currentStock == 0) {
                _currentStock++;
                _currentCooldown = _cooldown;
            }
            break;
        default:
            break;
    }
    
    if(self.menuItem) {
        if([self canSummon]) {
            [self.menuItem enableSummon];
        } else {
            [self.menuItem disableSummon];
        }
    }
}

-(void)finishSummon {
    switch (_summonType) {
        case kSummonTypeNormal: {
            _currentCooldown = _cooldown;
            
            PlayerComponent *player = (PlayerComponent *)[self.entity getComponentOfName:[PlayerComponent name]];
            player.food -= _cost;
            
            if (self.menuItem) {
                [self.menuItem disableSummon];
                [self.menuItem resetMask:_cooldown from:100 to:0];
            }
            break;
        }
        case kSummonTypeStock:
            _currentStock--;
            
            if(self.menuItem) {
                if(_currentStock == 0) {
                    [self.menuItem disableSummon];
                    [self.menuItem resetMask:_currentCooldown from:_currentCooldown/_cooldown*100 to:0];
                }
                
                NSString *s = [[NSNumber numberWithFloat:_currentStock] stringValue];
                [self.menuItem updateLabelString:s];
            }
             break;
        case kSummonTypeStockOnce:
            _currentStock--;
            _currentCooldown = _cooldown;
            
            if(self.menuItem) {
                if (self.menuItem) {
                    [self.menuItem disableSummon];
                    [self.menuItem resetMask:_cooldown from:100 to:0];
                }
            }
             break;
        default:
            break;
    }
}

@end
