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
#import "RenderComponent.h"

@implementation SummonComponent

@dynamic canSummon;
@dynamic isCostSufficient;

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
                
                [self updateStockLabel:[NSString stringWithFormat:@"%d",_currentStock]];
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
    
    if([self canSummon]) {
        [self.entity sendEvent:kEventSelectable Message:[NSNumber numberWithBool:YES]];
        [self.entity sendEvent:kEventCancelMask Message:nil];
        
    } else {
        [self.entity sendEvent:kEventSelectable Message:[NSNumber numberWithBool:NO]];
        [self.entity sendEvent:kEventUseMask Message:[NSNumber numberWithFloat:0]];
    }
}

-(void)finishSummon {
    switch (_summonType) {
        case kSummonTypeNormal: {
            _currentCooldown = _cooldown;
            
            PlayerComponent *player = (PlayerComponent *)[self.entity getComponentOfClass:[PlayerComponent class]];
            player.food -= _cost;
            
            
            [self.entity sendEvent:kEventUseMask Message:[NSNumber numberWithFloat:_cooldown]];
            break;
        }
        case kSummonTypeStock: {
            _currentStock--;
            if(_currentStock == 0) {
                [self.entity sendEvent:kEventSelectable Message:[NSNumber numberWithBool:NO]];
              //FIXME: [from:_currentCooldown/_cooldown*100 to:0] mask percentage.
                [self.entity sendEvent:kEventUseMask Message:[NSNumber numberWithFloat:_cooldown]];
//                [self.menuItem disableSummon];
//                [self.menuItem resetMask:_currentCooldown from:_currentCooldown/_cooldown*100 to:0];
            }
            
            NSString *s = [[NSNumber numberWithFloat:_currentStock] stringValue];
            [self.menuItem updateLabelString:s];
            break;
        }
        case kSummonTypeStockOnce:
            _currentStock--;
            _currentCooldown = _cooldown;
            [self.entity sendEvent:kEventSelectable Message:[NSNumber numberWithBool:NO]];
            [self.entity sendEvent:kEventUseMask Message:[NSNumber numberWithFloat:_cooldown]];
//            if(self.menuItem) {
//                if (self.menuItem) {
//                    [self.menuItem disableSummon];
//                    [self.menuItem resetMask:_cooldown from:100 to:0];
//                }
//            }
             break;
        default:
            break;
    }
}

-(void)setEntity:(Entity *)entity {
    [super setEntity:entity];
    [self initStockLabel];
}

-(void)initStockLabel {
    switch (_summonType) {
        case kSummonTypeNormal:
            break;
        case kSummonTypeStock: {
            _currentCooldown = _cooldown;
            [self.entity sendEvent:kEventUseMask Message:[NSNumber numberWithFloat:_cooldown]];
            [self updateStockLabel:[NSString stringWithFormat:@"%d",_currentStock]];
            break;
        }
        case kSummonTypeStockOnce: {
            _currentCooldown = _cooldown;
            [self.entity sendEvent:kEventUseMask Message:[NSNumber numberWithFloat:_cooldown]];
            [self updateStockLabel:@""];
            break;
        }
        default:
            break;
    }
}

-(void)updateStockLabel:(NSString *)string {
    RenderComponent *renderCom = (RenderComponent *)[self.entity getComponentOfClass:[RenderComponent class]];
    CCLabelBMFont* label = (CCLabelBMFont*)[renderCom.node getChildByTag:kCostLabelTag];
    [label setString:string];
}

@end
