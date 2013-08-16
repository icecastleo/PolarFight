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
    int _currentColumn;
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
        _currentColumn = -1;
        
        _board = [NSMutableArray arrayWithCapacity:_columns]; // x axis
        //TODO: create lots of Orb.
    }
    return self;
}

-(void)produceOrbs {
    _currentColumn = ++_currentColumn%_columns;
    
    RenderComponent *boardRenderCom = (RenderComponent *)[self.entity getComponentOfClass:[RenderComponent class]];
    NSMutableArray *newColumn = [[NSMutableArray alloc] init];
    for (int j = 0; j<_rows; j++) {
        
        int randomExist = arc4random_uniform(2);
        if (randomExist == 0) {
            continue;
        }
        
        int randomOrb = OrbRed + arc4random_uniform(OrbBottom-1);
        Entity *orb = [_entityFactory createOrbForType:randomOrb];
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfClass:[OrbComponent class]];
        orbCom.board = self.entity;
        orbCom.position = CGPointMake(_currentColumn, j);
        RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfClass:[RenderComponent class]];
        
        CGPoint position = [boardRenderCom.sprite convertToNodeSpace:CGPointMake(boardRenderCom.sprite.boundingBox.size.width+kOrb_XSIZE,kOrb_YSIZE/2+(kOrb_YSIZE+kOrb_YPad)*j)];
        position = [boardRenderCom.node convertToWorldSpace:position];
        orbRenderCom.node.position = position;
        [boardRenderCom.node addChild:orbRenderCom.node];
        
        [newColumn addObject:orb];
    }
    [_board addObject:newColumn];
}

-(void)removeColumn:(int)index {
    [_board removeObjectAtIndex:index];
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
//        [self exchangeOrb:startOrb targetOrb:targetOrb];
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
