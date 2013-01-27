//
//  Barrier.m
//  LightBugBattle
//
//  Created by Huang Hsing on 12/11/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Barrier.h"


@implementation Barrier

-(id)initWithFile:(NSString *)file radius:(float)radius {
    if (self = [super initWithFile:file]) {
        _collisionRadius = radius;
    }
    return self;
}

-(void)setPosition:(CGPoint)position {
    [super setPosition:position];
    
    _collisionPosition = ccp(position.x, position.y - self.boundingBox.size.height / 2 + _collisionRadius);
}

@end
