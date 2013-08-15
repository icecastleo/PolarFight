//
//  OrbBoardComponent.m
//  CastleFight
//
//  Created by  DAN on 13/8/14.
//
//

#import "OrbBoardComponent.h"
#import "EntityFactory.h"
#import "OrbComponent.h"
#import "RenderComponent.h"
#import "cocos2d.h"

@interface OrbBoardComponent() {
    int _rows;
    int _columns;
    float _width;
    float _height;
    EntityFactory *_entityFactory;
}

@end

@implementation OrbBoardComponent

-(id)initWithEntityFactory:(EntityFactory *)entityFactory {
    if (self = [super init]) {
        _entityFactory = entityFactory;
        _rows = kOrbBoardRows;
        _columns = kOrbBoardColumns;
        _width = kOrbBoardWidth;
        _height = kOrbBoardHeight;
        
        _board = [NSMutableArray arrayWithCapacity:_columns]; // x axis
        for (int i=0; i<_columns; i++) {
            NSMutableArray *boardColumn = [NSMutableArray arrayWithCapacity:_rows];// y axis
            [_board addObject:boardColumn];
        }
        
        //TODO: create lots of Orb.
    }
    return self;
}

-(void)setEntity:(Entity *)entity {
    [super setEntity:entity];
    [self produceOrbs];
}

-(void)produceOrbs {
    RenderComponent *boardRenderCom = (RenderComponent *)[self.entity getComponentOfClass:[RenderComponent class]];
    
    for (int i=0; i<_columns; i++) {
        NSMutableArray *oldColumn = [_board objectAtIndex:i];
        for (int j = 0; j<_rows; j++) {
            int randomOrb = OrbRed + arc4random_uniform(OrbBottom-1);
            Entity *orb = [_entityFactory createOrbForType:randomOrb];
            OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfClass:[OrbComponent class]];
            orbCom.board = self.entity;
            orbCom.position = CGPointMake(i, j);
            RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfClass:[RenderComponent class]];
            
//            orbRenderCom.node.position = [boardRenderCom.sprite convertToWorldSpace:CGPointMake(_width+kOrb_XSIZE/2+(kOrb_XSIZE+kOrb_XPad)*i,kOrb_YSIZE/2+(kOrb_YSIZE+kOrb_YPad)*j)];
            
            orbRenderCom.node.position = [boardRenderCom.sprite convertToWorldSpace:CGPointMake(kOrb_XSIZE/2+(kOrb_XSIZE+kOrb_XPad)*i,kOrb_YSIZE/2+(kOrb_YSIZE+kOrb_YPad)*j+_height)];
            [orbRenderCom.node runAction:[CCMoveTo actionWithDuration:1.0 position:[boardRenderCom.sprite convertToWorldSpace:CGPointMake(kOrb_XSIZE/2+(kOrb_XSIZE+kOrb_XPad)*i,kOrb_YSIZE/2+(kOrb_YSIZE+kOrb_YPad)*j)]]];
            
            [boardRenderCom.node addChild:orbRenderCom.node];
            [oldColumn addObject:orb];
        }
    }
}

-(BOOL)isMovable:(CGPoint)targetPosition {
    
    BOOL movable = NO;
    
    int x = targetPosition.x;
    int y = targetPosition.y;
    
    if (x >= kOrbBoardMinBorder && x < _columns && y >= kOrbBoardMinBorder && y < _rows) {
        movable = YES;
    }
    
    return movable;
}

-(void)moveOrb:(Entity *)startOrb ToPosition:(CGPoint)targetPosition {
    CGPoint target = [self getPositionInTheBoardFromRealPosition:targetPosition floor:YES];
    if([self isMovable:target]) {
        Entity *targetOrb = [self getOrbInPosition:target];
        [self exchangeOrb:startOrb targetOrb:targetOrb];
        NSLog(@"exchange success");
    }
}

-(CGPoint)getPositionInTheBoardFromRealPosition:(CGPoint)position floor:(BOOL)isFloor {
    int x,y;
    if (isFloor) {
        x = floor(position.x / (kOrb_XSIZE));
        y = floor(position.y / (kOrb_YSIZE));
    }else {
        x = round(position.x / (kOrb_XSIZE));
        y = round(position.y / (kOrb_YSIZE));
    }
    
    if (x>= _columns -1) {
        x = _columns -1;
    }
    if (y>= _rows -1) {
        y = _rows -1;
    }
    if (x<0) {
        x=0;
    }
    if (y<0) {
        y=0;
    }
    
    return CGPointMake(x, y);
}

-(void)exchangeOrb:(Entity *)startOrb targetOrb:(Entity *)targetOrb {
    
    OrbComponent *startOrbCom = (OrbComponent *)[startOrb getComponentOfClass:[OrbComponent class]];
    OrbComponent *targetOrbCom = (OrbComponent *)[targetOrb getComponentOfClass:[OrbComponent class]];
    
    RenderComponent *startRenderCom = (RenderComponent *)[startOrb getComponentOfClass:[RenderComponent class]];
    RenderComponent *targetRenderCom = (RenderComponent *)[targetOrb getComponentOfClass:[RenderComponent class]];
    
    NSMutableArray *startColumn = [self.board objectAtIndex:startOrbCom.position.x];
    NSMutableArray *targetColumn = [self.board objectAtIndex:targetOrbCom.position.x];
    
    [startColumn replaceObjectAtIndex:startOrbCom.position.y withObject:targetOrb];
    [targetColumn replaceObjectAtIndex:targetOrbCom.position.y withObject:startOrb];
    
    CGPoint tempOrbPoint = startOrbCom.position;
    CGPoint tempRenderPoint = startRenderCom.node.position;
    
    startOrbCom.position = targetOrbCom.position;
    targetOrbCom.position = tempOrbPoint;
    startRenderCom.node.position = targetRenderCom.node.position;
    targetRenderCom.node.position = tempRenderPoint;
}

-(Entity *)getOrbInPosition:(CGPoint)position {
    NSMutableArray *column = [self.board objectAtIndex:position.x];
    Entity *orb = [column objectAtIndex:position.y];
    return orb;
}

@end
