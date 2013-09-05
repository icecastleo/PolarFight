//
//  OrbComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/8/14.
//
//

#import "OrbComponent.h"
#import "OrbBoardComponent.h"
#import "RenderComponent.h"
#import "PlayerComponent.h"
#import "Magic.h"

#import "SummonToLineMagic.h"

static int kOriginalOrbOpacity = 0.25 * 255;
static int kTouchOrbOpacity = 0.6 * 255;

@interface OrbComponent () {
    CCSprite *touchSprite;
    int tempOpacity;
}

@end

@implementation OrbComponent

+(NSString *)name {
    static NSString *name = @"OrbComponent";
    return name;
}

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _originalColor = [[dic objectForKey:@"color"] intValue];
        _color = _originalColor;
        _isMovable = [[dic objectForKey:@"move"] boolValue];
        _isTappable = [[dic objectForKey:@"tap"] boolValue];
        _team = [[dic objectForKey:@"team"] intValue];
    }
    return self;
}

-(void)handlePan:(PanState)state positions:(NSArray *)positions {
    if (!self.isMovable) {
        return;
    }
    if (state == kPanStateBegan) {
        RenderComponent *render = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];

        NSAssert([render.sprite isKindOfClass:[CCSprite class]], @"I think orb's sprite is ccsprite...");
        tempOpacity = [(CCSprite *)render.sprite opacity];
        [(CCSprite *)render.sprite setOpacity:kOriginalOrbOpacity];
        
        touchSprite = [CCSprite spriteWithTexture:[(CCSprite *)render.sprite texture] rect:[(CCSprite *)render.sprite textureRect]];
        touchSprite.scaleX = render.sprite.scaleX;
        touchSprite.scaleY = render.sprite.scaleY;
        touchSprite.position = [[positions lastObject] CGPointValue];
        [touchSprite setOpacity:kTouchOrbOpacity];
        [render.node.parent addChild:touchSprite z:INT16_MAX];
    } else if (state == kPanStateMoved) {
        CGPoint position = [[positions lastObject] CGPointValue];
        [self.board moveOrb:self.entity toPosition:position];
        
        touchSprite.position = position;
    } else if (state == kPanStateEnded) {
        RenderComponent *render = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];
        
        NSAssert([render.sprite isKindOfClass:[CCSprite class]], @"I think orb's sprite is ccsprite...");
        [(CCSprite *)render.sprite setOpacity:tempOpacity];
        
        [touchSprite removeFromParentAndCleanup:YES];
        touchSprite = nil;
    }
}

-(void)handleTap {
    if (!self.isTappable) {
        return;
    }
    NSDictionary *matchDic = [self.board findMatchForOrb:self.entity];
    if (!matchDic) {
        return;
    }
    
    NSArray *matchArray = [matchDic objectForKey:kOrbMainMatch];
    NSArray *sameColorOrbs = [matchDic objectForKey:kOrbSameColorMatch];
    
    if ((matchArray.count+sameColorOrbs.count) >= kOrbMinMatchSum) {
        [self executeMatch:matchArray.count];
        [self.board matchClean:matchDic];
    }
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventRemoveComponent) {
        if (touchSprite) {
            [touchSprite removeFromParentAndCleanup:YES];
        }
    }
}

-(void)executeMatch:(int)number {
    
    NSMutableDictionary *magicInfo = [[NSMutableDictionary alloc] init];
    [magicInfo setValue:self.summonData forKey:@"SummonData"];
    
    int addLevel = 0;
    switch (number) {
        case 4:
            addLevel += 1;
            break;
        case 5:
            addLevel += 2;
            break;
        default:
            break;
    }
    [magicInfo setValue:[NSNumber numberWithInt:addLevel] forKey:@"addLevel"];
    //test
    Magic *magic = [[SummonToLineMagic alloc] initWithMagicInformation:magicInfo];
    magic.entityFactory = self.board.entityFactory;
    [magic active];
}

@end
