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
#import "Magic.h"

@implementation OrbComponent

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _matchInfo = dic;
    }
    return self;
}

-(void)handleDrag:(NSArray *)path {
    CGPoint position = [[path lastObject] CGPointValue];
    RenderComponent *boardRenderCom = (RenderComponent *)[self.board getComponentOfClass:[RenderComponent class]];
    
    CGPoint position2 = [boardRenderCom.sprite convertToNodeSpace:position];
    
    OrbBoardComponent *boardCom = (OrbBoardComponent *)[self.board getComponentOfClass:[OrbBoardComponent class]];
    [boardCom moveOrb:self.entity ToPosition:position2];
}

-(void)handleTap:(NSArray *)path {
    
}

-(void)executeMatch:(int)number {
    
    NSAssert(number >= 3, @"should not call this function when it is less than 3.");
    
    if (number > 5) {
        number = 5;
    }
    
    NSDictionary *dic = [self.matchInfo objectForKey:[NSString stringWithFormat:@"%d",number]];
    
    //execute a magic method
    NSString *magicName = [dic objectForKey:@"magicName"];
    Magic *magic = [[NSClassFromString(magicName) alloc] init];
    
    //FIXME: give summon data to magic
//    NSDictionary *summonDic = [dic objectForKey:@"summonData"];
//    SummonComponent
    
    [magic active];
}

@end