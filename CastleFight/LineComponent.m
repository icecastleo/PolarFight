//
//  LineComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/7/29.
//
//

#import "LineComponent.h"

@implementation LineComponent

-(id)init {
    if (self = [super init]) {
        _currentLine = 0;
        _nextLine = 0;
        _doesChangeLine = NO;
    }
    return self;
}

-(void)didChange {
    _currentLine = _nextLine;
    _nextLine = 0;
    _doesChangeLine = NO;
}

-(void)changeLine:(int)line {
    _nextLine = line;
    _doesChangeLine = YES;
}

-(void)instantlyChangeLine:(int)line {
    _currentLine = line;
    _nextLine = 0;
    _doesChangeLine = NO;
}
@end
