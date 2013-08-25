//
//  OrbBoardComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/8/14.
//
//

#import "OrbBoardComponent.h"
#import "EntityFactory.h"
#import "OrbComponent.h"
#import "RenderComponent.h"
#import "cocos2d.h"

#define kOrbBoardLastColumnNum 99

@interface OrbBoardComponent() {
}

@end

@implementation OrbBoardComponent

+(NSString *)name {
    static NSString *name = @"OrbBoardComponent";
    return name;
}

-(id)initWithEntityFactory:(EntityFactory *)entityFactory {
    if (self = [super init]) {
        
        _entityFactory = entityFactory;
        _orbs = [[NSMutableArray alloc] init];
        
        //TODO: create lots of Orb.
    }
    return self;
}

//-(void)produceOrbs {
//    RenderComponent *boardRenderCom = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];
//    
//    for (int j = 0; j<_rows; j++) {
//        
//        int randomOrb = OrbRed + arc4random_uniform(OrbBottom-1);
//        
//        int randomExist = arc4random_uniform(2);
//        if (randomExist == 0) {
//            randomOrb = OrbNull;
//        }
//
//        Entity *orb = [_entityFactory createOrbForType:randomOrb];
//        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
//        orbCom.board = self.entity;
//        orbCom.position = CGPointMake(kOrbBoardLastColumnNum, j);
//        RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
//        
//        if (randomOrb == OrbNull) {
//            [orbRenderCom.node setVisible:NO];
//        }
//        
//        CGPoint position = [boardRenderCom.sprite convertToNodeSpace:CGPointMake(boardRenderCom.sprite.boundingBox.size.width+kOrb_XSIZE,kOrb_YSIZE/2+(kOrb_YSIZE+kOrb_YPad)*j)];
//        position = [boardRenderCom.node convertToWorldSpace:position];
//        orbRenderCom.node.position = position;
//        [boardRenderCom.node addChild:orbRenderCom.node];
//        
//        [self adjustOrbPosition:orb realPosition:orbRenderCom.node.position];
//        
//        [_board addObject:orb];
//    }
//}

-(void)moveOrb:(Entity *)startOrb ToPosition:(CGPoint)targetPosition {
    CGPoint target = [self getPositionInTheBoardFromRealPosition:targetPosition floor:YES];
    Entity *targetOrb = [self getOrbInPosition:target];
    if (!targetOrb) { //out of board
        return;
    }
    [self exchangeOrb:startOrb targetOrb:targetOrb];
}

-(CGPoint)getPositionInTheBoardFromRealPosition:(CGPoint)position floor:(BOOL)isFloor {
    int x,y;
    if (isFloor) {
        x = floor(position.x / (kOrbWidth));
        y = floor(position.y / (kOrbHeight));
    }else {
        x = round(position.x / (kOrbWidth));
        y = round(position.y / (kOrbHeight));
    }
    
    if (x>= kOrbBoardColumns -1) {
        x = kOrbBoardColumns -1;
    }
    if (y>= kOrbBoardRows -1) {
        y = kOrbBoardRows -1;
    }
    return CGPointMake(x, y);
}

-(Entity *)getOrbInPosition:(CGPoint)position {
    Entity *target = nil;
    for (Entity *orb in self.orbs) {
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        if (CGPointEqualToPoint(orbCom.position, position)) {
            target = orb;
            break;
        }
    }
    return target;
}

-(void)exchangeOrb:(Entity *)startOrb targetOrb:(Entity *)targetOrb {
    
    OrbComponent *startOrbCom = (OrbComponent *)[startOrb getComponentOfName:[OrbComponent name]];
    OrbComponent *targetOrbCom = (OrbComponent *)[targetOrb getComponentOfName:[OrbComponent name]];
    
    RenderComponent *startRenderCom = (RenderComponent *)[startOrb getComponentOfName:[RenderComponent name]];
    RenderComponent *targetRenderCom = (RenderComponent *)[targetOrb getComponentOfName:[RenderComponent name]];
    
    CGPoint tempOrbPoint = startOrbCom.position;
    CGPoint tempRenderPoint = startRenderCom.node.position;
    
    startOrbCom.position = targetOrbCom.position;
    targetOrbCom.position = tempOrbPoint;
    startRenderCom.node.position = targetRenderCom.node.position;
    targetRenderCom.node.position = tempRenderPoint;
}

-(void)adjustOrbPosition:(Entity *)orb realPosition:(CGPoint)realPosition {
    CGPoint boardPosition = [self getPositionInTheBoardFromRealPosition:realPosition floor:YES];
    OrbComponent *orbComponent = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
    int currentX = orbComponent.position.x;
    if (boardPosition.x == currentX) {
        return;
    }else {
        orbComponent.position = boardPosition;
    }
}

-(void)clean {
    NSMutableArray *deletOrbs = [[NSMutableArray alloc] init];
    for (Entity *orb in self.orbs) {
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        if (orbCom.position.x <= 0) {
            [deletOrbs addObject:orb];
        }
    }
    for (Entity *orb in deletOrbs) {
        RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
        [self.orbs removeObject:orb];
        
        [orbRenderCom.sprite runAction:
         [CCSequence actions:
          [CCFadeOut actionWithDuration:0.5f],
          [CCCallBlock actionWithBlock:^{
             [orbRenderCom.node removeFromParentAndCleanup:YES];
         }],nil]];
        
        [orb removeSelf];
    }
    [deletOrbs removeAllObjects];
}

-(NSArray *)findMatchFromPosition:(CGPoint)position CurrentOrb:(Entity *)currentOrb {
    
    OrbComponent *currentOrbCom = (OrbComponent *)[currentOrb getComponentOfName:[OrbComponent name]];
    if (currentOrbCom.type == OrbNull) {
        return nil;
    }
    
    NSMutableArray *matchArray = [[NSMutableArray alloc] init];
    
    for (Entity *orb in self.orbs) {
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        if (orbCom.type == currentOrbCom.type) {
            if (orbCom.position.x == currentOrbCom.position.x) {
                if (abs(orbCom.position.y - currentOrbCom.position.y) <= 1) {
                    [matchArray addObject:orb];
                    continue;
                }
            }
            if (orbCom.position.y == currentOrbCom.position.y) {
                if (abs(orbCom.position.x - currentOrbCom.position.x) <= 1) {
                    [matchArray addObject:orb];
                    continue;
                }
            }
        }
    }
    
    return matchArray;
}

-(void)matchClean:(NSArray *)matchArray {
    
    for (Entity *orb in matchArray) {
        RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
        [orbRenderCom.node setVisible:NO];
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        orbCom.type = OrbNull;
    }
}

@end
