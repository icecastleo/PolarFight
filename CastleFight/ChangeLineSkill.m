//
//  ChangeLineSkill.m
//  CastleFight
//
//  Created by  DAN on 13/7/29.
//
//

#import "ChangeLineSkill.h"
#import "LineComponent.h"

@implementation ChangeLineSkill

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSimpleXY,kRangeKeyType,[NSNumber numberWithInt:100],kRangeKeyRadius,nil];
        
        range = [Range rangeWithParameters:dictionary];
        self.cooldown = 5;
    }
    return self;
}

-(void)activeEffect {
    LineComponent *line = (LineComponent *)[self.owner getComponentOfClass:[LineComponent class]];
    
    int nextLine = 0;
    
    do {
        nextLine = arc4random_uniform(kMapPathMaxLine);
    } while (line.line == nextLine);
    
    line.line = nextLine;
}

@end
