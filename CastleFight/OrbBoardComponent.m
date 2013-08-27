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
        
        _columns = [NSMutableArray arrayWithCapacity:kOrbBoardColumns];
        
        _entityFactory = entityFactory;
        _orbs = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)moveOrb:(Entity *)orb toPosition:(CGPoint)position {
//    CGPoint target = [self getPositionInTheBoardFromRealPosition:position floor:YES];
//    Entity *targetOrb = [self getOrbInPosition:target];
//
//    if (!targetOrb) { //out of board
//        return;
//    }
//    
//    [self exchangeOrb:orb targetOrb:targetOrb];
    
    RenderComponent *renderA = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
    
    int deltaX = abs(renderA.node.position.x - position.x);
    int deltaY = abs(renderA.node.position.y - position.y);
    
    // FIXME: Limit to move one line!
    if ((deltaX > kOrbWidth/2 && deltaY < kOrbHeight/2) ||
        (deltaX < kOrbWidth/2 && deltaY > kOrbHeight/2)) {
        
        CGPoint orbPositionA = [self convertRenderPositionToOrbPosition:renderA.node.position];
        
        Entity *entityA = [self orbAtPosition:orbPositionA];
        
        if (entityA != orb) {
            // Orb system have not create orb yet! so we have to wait it!
            return;
        }
        
        CGPoint orbPositionB = [self convertRenderPositionToOrbPosition:position];
        
        Entity *entityB = [self orbAtPosition:orbPositionB];
        RenderComponent *renderB = (RenderComponent *)[entityB getComponentOfName:[RenderComponent name]];
        
        CGPoint temp = renderB.node.position;
        renderB.node.position = renderA.node.position;
        renderA.node.position = temp;
        
        [[_columns objectAtIndex:orbPositionA.x] replaceObjectAtIndex:orbPositionA.y withObject:entityB];
        [[_columns objectAtIndex:orbPositionB.x] replaceObjectAtIndex:orbPositionB.y withObject:entityA];
    }
}

-(CGPoint)convertRenderPositionToOrbPosition:(CGPoint)position {
    int x = MAX(0, (position.x - kOrbBoradLeftMargin) / kOrbWidth - (kOrbBoardColumns - _columns.count));
    int y = MIN(kOrbBoardRows - 1, MAX(0, (position.y - kOrbBoradDownMargin) / kOrbHeight));
    
//    CCLOG(@"%f %f -> %d %d", position.x, position.y, x, y);
    
    return ccp(x, y);
}

-(Entity *)orbAtPosition:(CGPoint)position {
    return [[_columns objectAtIndex:position.x] objectAtIndex:position.y];
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

-(void)exchangeOrb:(Entity *)orb targetOrb:(Entity *)targetOrb {
    
    OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
    OrbComponent *targetOrbCom = (OrbComponent *)[targetOrb getComponentOfName:[OrbComponent name]];
    
    RenderComponent *startRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
    RenderComponent *targetRenderCom = (RenderComponent *)[targetOrb getComponentOfName:[RenderComponent name]];
    
    CGPoint tempOrbPoint = orbCom.position;
    CGPoint tempRenderPoint = startRenderCom.node.position;
    
    orbCom.position = targetOrbCom.position;
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
