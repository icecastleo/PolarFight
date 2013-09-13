//
//  RoundBattleStatusLayer.h
//  CastleFight
//
//  Created by 朱 世光 on 13/9/6.
//
//

#import "CCLayer.h"
#import "RoundBattleController.h"

@interface RoundBattleStatusLayer : CCLayer

@property (readonly) CCLabelBMFont *timeLabel;

-(id)init;
-(void)displayString:(NSString *)string withColor:(ccColor3B)color;

@end
