//
//  ItemComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/10.
//
//

#import "ItemComponent.h"
#import "RenderComponent.h"
#import "MaskComponent.h"
#import "Magic.h"

@interface ItemComponent()
{
    RenderComponent *renderCom;
    TouchComponent *touchCom;
}

@end

@implementation ItemComponent

+(NSString *)name {
    static NSString *name = @"ItemComponent";
    return name;
}

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _name = [dic objectForKey:@"name"];
        _images = [dic objectForKey:@"images"];
        _effect = [dic objectForKey:@"effect"];
        _price = [[dic objectForKey:@"price"] intValue];
        _maxCount = [[dic objectForKey:@"maxCount"] intValue];
    }
    return self;
}

-(void)active {
    if(!self.count > 0) {
        return;
    }
    
    self.count--;
    
    //FIXME: need magicInfo?
    NSDictionary *magicInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"test",@"test", nil];
    Magic* magic = [[NSClassFromString(self.effect) alloc] initWithMagicInformation:magicInfo];
    
    magic.owner = self.owner;
    [magic active];
    
    CCLOG(@"%@ active count:%d",self.name,self.count);
    
    CCLabelTTF *oldLabel = (CCLabelTTF *)[renderCom.node getChildByTag:kCountLabelTag];
    
    CCLabelTTF *label = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",self.count] fntFile:@"WhiteFont.fnt"];
    label.color = oldLabel.color;
    label.position = oldLabel.position;
    label.anchorPoint = oldLabel.anchorPoint;
    
    [renderCom.node removeChildByTag:kCountLabelTag cleanup:YES];
    [renderCom.node addChild:label z:0 tag:kCountLabelTag];
    
    if (self.count == 0) {
        [self.entity addComponent:[[MaskComponent alloc] initWithRenderComponent:renderCom]];
    }
}

-(void)handleTap:(TapState)state {
    if (!renderCom) {
        renderCom = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];
    }
    if ([renderCom.node getChildByTag:kSelectedImageTag]) {
        [renderCom.node removeChildByTag:kSelectedImageTag cleanup:YES];
    }
    
    if (state == kTapStateBegan) {
        CCLOG(@"kTapStateBegan");
        if (!touchCom) {
            touchCom = (TouchComponent *)[self.entity getComponentOfName:[TouchComponent name]];
        }
        [renderCom.node addChild:touchCom.selectedSprite z:0 tag:kSelectedImageTag];
    }else if (state == kTapStateEnded) {
        CCLOG(@"kTapStateEnded");
        [self active];
    }
}

-(void)handlePan:(PanState)state positions:(NSArray *)positions {
    if (state == kPanStateEnded) {
        if ([renderCom.node getChildByTag:kSelectedImageTag]) {
            [renderCom.node removeChildByTag:kSelectedImageTag cleanup:YES];
        }
    }
}

@end
