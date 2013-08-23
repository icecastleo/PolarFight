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

+(NSString *)name {
    static NSString *name = @"OrbComponent";
    return name;
}

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _matchInfo = dic;
    }
    return self;
}

//-(void)handlePan:(NSArray *)path {
//    CGPoint position = [[path lastObject] CGPointValue];
//    RenderComponent *boardRenderCom = (RenderComponent *)[self.board getComponentOfName:[RenderComponent name]];
//    
//    CGPoint position2 = [boardRenderCom.sprite convertToNodeSpace:position];
//    
//    OrbBoardComponent *boardCom = (OrbBoardComponent *)[self.board getComponentOfName:[OrbBoardComponent name]];
//    [boardCom moveOrb:self.entity ToPosition:position2];
//}
//
//-(void)handleTap {
//    
//}

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
