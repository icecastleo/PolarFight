//
//  MainStatusLayer.h
//  CastleFight
//
//  Created by 朱 世光 on 13/4/1.
//
//

#import "cocos2d.h"
#import "MainScene.h"
#import <StoreKit/StoreKit.h>

@interface MainStatusLayer : CCLayer<SKProductsRequestDelegate> {
    CCLabelBMFont *moneyLabel;
    
    UIAlertView *baseAlert;
}

-(id)initWithMainScene:(MainScene *)scene;

@end
