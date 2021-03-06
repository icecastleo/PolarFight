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
    
    if (!renderCom) {
        renderCom = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];
    }
    
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

-(void)handleTap {
    [self active];
}

@end
