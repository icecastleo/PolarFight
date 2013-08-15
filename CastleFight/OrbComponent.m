//
//  OrbComponent.m
//  CastleFight
//
//  Created by  DAN on 13/8/14.
//
//

#import "OrbComponent.h"
#import "OrbBoardComponent.h"
#import "RenderComponent.h"

@implementation OrbComponent

-(void)handleDrag:(NSArray *)path {
    CGPoint position = [[path lastObject] CGPointValue];
    RenderComponent *boardRenderCom = (RenderComponent *)[self.board getComponentOfClass:[RenderComponent class]];
    
    CGPoint position2 = [boardRenderCom.sprite convertToNodeSpace:position];
    
    OrbBoardComponent *boardCom = (OrbBoardComponent *)[self.board getComponentOfClass:[OrbBoardComponent class]];
    [boardCom moveOrb:self.entity ToPosition:position2];
}

-(void)handleTap:(NSArray *)path {
    
}

@end
