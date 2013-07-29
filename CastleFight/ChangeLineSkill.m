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
    LineComponent *lineCom = (LineComponent *)[self.owner getComponentOfClass:[LineComponent class]];
    int line = 0;
    do {
        line = arc4random_uniform(kMapPathMaxLine);
    } while (lineCom.currentLine == line);
    [lineCom changeLine:line];
}

@end
