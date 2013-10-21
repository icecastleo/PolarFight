//
//  MagicComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/7/2.
//
//

#import "MagicComponent.h"
#import "Attribute.h"
#import "Magic.h"
#import "AccumulateAttribute.h"
#import "RenderComponent.h"
#import "DrawPath.h"
#import "LevelComponent.h"

@interface MagicComponent()
{
    RenderComponent *renderCom;
    LevelComponent *levelCom;
}
@end

@implementation MagicComponent

+(NSString *)name {
    static NSString *name = @"MagicComponent";
    return name;
}

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        NSDictionary *damageAttribute = [dic objectForKey:@"damage"];
        
        _cooldown = [[dic objectForKey:@"cooldown"] floatValue];
        _damage = [[AccumulateAttribute alloc] initWithDictionary:damageAttribute];
        _name = [dic objectForKey:@"magicName"];
        _images = [dic objectForKey:@"magicImages"];
        
        NSDictionary *magicInfo = [NSDictionary dictionaryWithObjectsAndKeys: _damage,@"damage",_images,@"images",nil];
        Magic* magic = [[NSClassFromString(_name) alloc] initWithMagicInformation:magicInfo];
        _rangeSize = magic.rangeSize;
    }
    return self;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventLevelChanged) {
        [_damage updateValueWithLevel:[message intValue]];
    } 
}

-(void)changeValueByLevel:(int)level {
    [self.damage updateValueWithLevel:level];
}

-(void)activeWithPath:(NSArray *)path {
    if (!levelCom) {
        levelCom = (LevelComponent *)[self.entity getComponentOfName:[LevelComponent name]];
    }
    [self changeValueByLevel:levelCom.level];
    _canActive = YES;
    _path = path;
}

-(void)didExecute {
    _canActive = NO;
    _path = nil;
}

-(void)handlePan:(PanState)state positions:(NSArray *)positions {
    if (!renderCom) {
        renderCom = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];
    }
    if ([renderCom.node.parent getChildByTag:kDrawPathTag]) {
        [renderCom.node.parent removeChildByTag:kDrawPathTag cleanup:YES];
    }
    if (state == kPanStateMoved) {
        DrawPath *line = [DrawPath node];
        line.path = [NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:renderCom.position],[positions lastObject], nil];
        line.drawSize = self.rangeSize;
        [renderCom.node.parent addChild:line z:0 tag:kDrawPathTag];

    } else if (state == kPanStateEnded) {
        [self activeWithPath:positions];
    }
}

@end
