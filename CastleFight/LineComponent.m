//
//  LineComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/7/29.
//
//

#import "LineComponent.h"
#import "RenderComponent.h"

@implementation LineComponent

-(id)init {
    if (self = [super init]) {
        _line = 0;
    }
    return self;
}

-(void)setLine:(int)line {
    NSString *assert = [NSString stringWithFormat:@"Line value is between 0 & %d", kMapPathMaxLine];
    NSAssert(_line >= 0 && _line < kMapPathMaxLine, assert);
    
    RenderComponent *render = (RenderComponent *)[self.entity getComponentOfClass:[RenderComponent class]];
    render.position = ccp(render.position.x, render.position.y + (line - _line) * kMapPathHeight);
    
    _line = line;
}

@end
