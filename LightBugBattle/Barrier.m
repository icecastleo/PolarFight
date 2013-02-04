//
//  Barrier.m
//  LightBugBattle
//
//  Created by Huang Hsing on 12/11/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Barrier.h"

@implementation Barrier
@synthesize position = _position;

-(id)initWithFile:(NSString *)file radius:(float)radius {
    if (self = [super init]) {
        _sprite = [CCSprite spriteWithFile:file];
        _radius = radius;
    }
    return self;
}

-(void)setPosition:(CGPoint)position {
    @synchronized(self) {
        _position = position;
        _sprite.position = ccp(position.x, position.y - self.radius + self.sprite.boundingBox.size.height / 2);
    }
}

-(CGPoint)position {
    @synchronized(self) {
        return _position;
    }
}

@end
