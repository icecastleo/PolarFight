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

@interface OrbBoardComponent() {
    int combos;
    int combosOrbSum; // only for test
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
        x = floor((position.x-kOrbBoradLeftMargin) / (kOrbWidth));
        y = floor((position.y-kOrbBoradDownMargin) / (kOrbHeight));
    }else {
        x = round((position.x-kOrbBoradLeftMargin) / (kOrbWidth));
        y = round((position.y-kOrbBoradDownMargin) / (kOrbHeight));
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
    
    NSMutableArray *xArray = [[NSMutableArray alloc] init];
    NSMutableArray *yArray = [[NSMutableArray alloc] init];
    
    for (Entity *orb in self.orbs) {
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        if (orbCom.type == currentOrbCom.type) {
            if (orbCom.position.x == currentOrbCom.position.x) {
                [xArray addObject:orbCom];
            }
            if (orbCom.position.y == currentOrbCom.position.y) {
                [yArray addObject:orbCom];
            }
        }
    }
    
    [xArray sortUsingComparator:^(OrbComponent *obj1, OrbComponent *obj2) {
        int y1 = obj1.position.y;
        int y2 = obj2.position.y;
        if (y1 > y2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    [yArray sortUsingComparator:^(OrbComponent *obj1, OrbComponent *obj2) {
        int x1 = obj1.position.x;
        int x2 = obj2.position.x;
        if (x1 > x2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    NSMutableArray *matchXArray = [[NSMutableArray alloc] init];
    NSMutableArray *matchYArray = [[NSMutableArray alloc] init];
    
    int xStart = 0;
    int xEnd = 0;
    for (int i=0; i<xArray.count; i++) {
        OrbComponent *orbCom = [xArray objectAtIndex:i];
        if (orbCom.position.y > currentOrbCom.position.y) {
            OrbComponent *lastOrbCom = [xArray objectAtIndex:xEnd];
            if (orbCom.position.y == lastOrbCom.position.y+1) {
                xEnd = i;
            }else {
                break;
            }
        } else {
            OrbComponent *lastOrbCom = [xArray objectAtIndex:xEnd];
            if (orbCom.position.y != lastOrbCom.position.y+1) {
                xStart = i;
            }
            xEnd = i;
        }
    }
    
    int yStart = 0;
    int yEnd = 0;
    for (int i=0; i<yArray.count; i++) {
        OrbComponent *orbCom = [yArray objectAtIndex:i];
        if (orbCom.position.x > currentOrbCom.position.x) {
            OrbComponent *lastOrbCom = [yArray objectAtIndex:yEnd];
            if (orbCom.position.x == lastOrbCom.position.x+1) {
                yEnd = i;
            }else {
                break;
            }
        } else {
            OrbComponent *lastOrbCom = [yArray objectAtIndex:yEnd];
            if (orbCom.position.x != lastOrbCom.position.x+1) {
                yStart = i;
            }
            yEnd = i;
        }
    }
    
    for (int i= xStart; i<=xEnd; i++) {
        [matchXArray addObject:[xArray objectAtIndex:i]];
    }
    for (int i= yStart; i<=yEnd; i++) {
        [matchYArray addObject:[yArray objectAtIndex:i]];
    }
    
    NSMutableArray *matchArray = [[NSMutableArray alloc] init];
    
    if (matchXArray.count >= 3) {
        for (OrbComponent *orbCom in matchXArray) {
            [matchArray addObject:orbCom.entity];
        }
    }
    if (matchYArray.count >= 3) {
        for (OrbComponent *orbCom in matchYArray) {
            [matchArray addObject:orbCom.entity];
        }
    }
    
    return matchArray;
}

-(void)matchClean:(NSArray *)matchArray {
    combos++;
    // only test
    combosOrbSum = matchArray.count;
    [self showCombos];
    if (combos>=5) {
        matchArray = self.orbs;
        CCAction *shake = [CCShake actionWithDuration:3.0 amplitude:ccp(5, 5)];
        [self.entityFactory.mapLayer runAction:shake];
    }
    for (Entity *orb in matchArray) {
        RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
        [orbRenderCom.sprite runAction:
         [CCSequence actions:
          [CCFadeOut actionWithDuration:0.5f],
          [CCCallBlock actionWithBlock:^{
             [orbRenderCom.node setVisible:NO];
         }],nil]];
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        orbCom.type = OrbNull;
    }
}

-(void)showCombos {
    if ([self.entityFactory.mapLayer getChildByTag:kCombosLabelTag]) {
        [self.entityFactory.mapLayer removeChildByTag:kCombosLabelTag cleanup:YES];
    }
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    //test
    CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Combos: %d, sum: %d",combos,combosOrbSum] fontName:@"Helvetica" fontSize:30];
//    CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Combos: %d",combos] fontName:@"Helvetica" fontSize:30];
    
    label.color = ccRED;
    label.position =  ccp(winSize.width - label.boundingBox.size.width/2, kOrbBoradDownMargin + (kOrbBoardRows+1)*kOrbHeight);
    [self.entityFactory.mapLayer addChild:label z:INT16_MAX tag:kCombosLabelTag];
    
    [label runAction:
     [CCSequence actions:
      [CCFadeOut actionWithDuration:5.0f],
      [CCCallBlock actionWithBlock:^{
         combos = 0;
         [self.entityFactory.mapLayer removeChildByTag:kCombosLabelTag cleanup:YES];
     }],nil]];
}

@end
