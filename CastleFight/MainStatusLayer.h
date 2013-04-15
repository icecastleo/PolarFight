//
//  MainStatusLayer.h
//  CastleFight
//
//  Created by 朱 世光 on 13/4/1.
//
//

#import "cocos2d.h"
#import "MainScene.h"

@interface MainStatusLayer : CCLayer {
    CCLabelBMFont *moneyLabel;
}

-(id)initWithMainScene:(MainScene *)scene;

@end
