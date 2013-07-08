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

-(id)initWithCharacterInitData:(CharacterInitData *)initData {
    if (self = [super init]) {
        _data = initData;
        
        NSDictionary *dic = [[FileManager sharedFileManager] getCharacterDataWithCid:_data.cid];
        _cost = [[dic objectForKey:@"cost"] intValue];
        
        
    
        _currentCooldown = 0;
        _currentStock=0;
        _summon = NO;
        _summonType=kSummonTypeStockOnce;
        [self setCooldown];
        
        
        
        
    }
    return self;
}
-(void) setWithMenuItem:(UnitMenuItem*) item{
    
      _currentCooldown=_cooldown;
    [item resetMask:self.currentCooldown from:self.currentCooldown/self.cooldown*100 to:0];
    switch (_summonType) {
        case kSummonTypeNormal:
            break;
        case kSummonTypeStock:
        {
            NSString *s = [[NSNumber numberWithFloat:_currentStock] stringValue];
            [item updateLabelString:s];
        }
            break;
        case kSummonTypeStockOnce:
        {
            NSString *s = [[NSNumber numberWithFloat:_currentStock] stringValue];
            [item updateLabelString:s];
        }
            break;
        default:
            break;
    }
    
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
            break;
    }
    
    
}

-(void) updateSummon{

    if(self.menuItem)
    {
        if([self canSummon])
        {
            [self.menuItem enableSummon];
           
        } else {
             [self.menuItem disableSummon];
        }
        
        //    CCLOG(@"cooldown is %f,current cooldown is %f",summon.cooldown,summon.currentCooldown);
        
        switch (_summonType) {
            case kSummonTypeNormal:
                if(_cooldown==_currentCooldown)
                    [self.menuItem resetMask:_cooldown from:100 to:0];
                
                
                
                
                break;
            case kSummonTypeStock:
                if(_currentCooldown<=0)
                {
                    _currentStock++;
                    _currentCooldown=_cooldown;
                    NSString *s = [[NSNumber numberWithFloat:_currentStock] stringValue];
                    [self.menuItem updateLabelString:s];
                    
                }
                 break;
            case kSummonTypeStockOnce:
                if(_currentCooldown<=0&&_currentStock==0)
                {
                    _currentStock++;
                    _currentCooldown=_cooldown;
                    NSString *s = [[NSNumber numberWithFloat:_currentStock] stringValue];
                    [self.menuItem updateLabelString:s];
                    
                }
                 break;
            default:
                break;
        }
        
      
        
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
            if(_currentStock>0)
                return YES;
        case kSummonTypeStockOnce:
            if(_currentStock>0)
                return YES;
        default:
            break;
    }
    
   
    
    return NO;
}

-(BOOL)isCostSufficient {
    NSAssert(_player, @"Who will you summon for?");
    
    if (_player.food >= _cost) {
        return YES;
    } else {
        return NO;
    }
   
   
}

-(void) finishSummon{
    
    switch (_summonType) {
        case kSummonTypeNormal:
           _currentCooldown = _cooldown;
            break;
        case kSummonTypeStock:
            _currentStock--;
            
            if(self.menuItem)
            {
                if(_currentStock==0)
                 {
                    
                         [self.menuItem resetMask:_currentCooldown from:_currentCooldown/_cooldown*100 to:0];
                     
                 }
                NSString *s = [[NSNumber numberWithFloat:_currentStock] stringValue];
                [self.menuItem updateLabelString:s];
            }
             break;
        case kSummonTypeStockOnce:
            _currentStock--;
            if(self.menuItem)
            {
                if(_currentStock==0)
                {
                    _currentCooldown=_cooldown;
                    [self.menuItem resetMask:_currentCooldown from:_currentCooldown/_cooldown*100 to:0];
                    
                }
                NSString *s = [[NSNumber numberWithFloat:_currentStock] stringValue];
                [self.menuItem updateLabelString:s];
            }
             break;
        default:
            break;
    }
   
}

@end
