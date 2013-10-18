//
//  RoundBattleStatusLayer.h
//  CastleFight
//
//  Created by 朱 世光 on 13/9/6.
//
//

#import "CCLayer.h"
#import "RoundBattleController.h"

@class RoundBattleController;

@interface RoundBattleStatusLayer : CCLayer

@property (readonly) CCLabelBMFont *timeLabel;
@property (readonly) CCLabelBMFont *manaLabel;

-(id)init;
-(id)initWithBattleController:(RoundBattleController *)battleController ;

-(void)displayString:(NSString *)string withColor:(ccColor3B)color;

-(void)setMagicButton;
-(void)setItemButton;

@end
