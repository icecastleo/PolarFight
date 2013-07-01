//
//  UnitStockMenuItem.m
//  CastleFight
//
//  Created by 陳 謙 on 13/6/29.
//
//

#import "UnitStockMenuItem.h"
#import "SummonComponent.h"
#import "PlayerComponent.h"
@implementation UnitStockMenuItem
-(void) SummonExecute:(SummonComponent*)summon
{
      summon.readyToLine=YES;
       NSMutableArray *summonComponents = summon.player.summonComponents;
    
      for (SummonComponent *otherSummon in summonComponents) {
      
          if(summon==otherSummon)
              continue;
          if(otherSummon.menuItem)
          {
              otherSummon.menuItem.isEnabled = NO;
              otherSummon.menuItem.mask.visible = YES;
          }
      }
}

-(void) updateWithoutSummon:(SummonComponent*)summon
{
    
    
    if (summon.isCostSufficient) {
        self.isEnabled = YES;
        self.mask.visible = NO;
    } else {
        self.isEnabled = NO;
        self.mask.visible = YES;
    }
    
    
}

-(void) updateSummon:(SummonComponent*)summon
{
    self.isEnabled = NO;
    self.visible = YES;
    [self.timer runAction:[CCProgressFromTo actionWithDuration:summon.cooldown from:100 to:0]];
}
@end
