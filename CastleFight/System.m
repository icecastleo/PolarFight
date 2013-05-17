//
//  System.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "System.h"

@implementation System

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory {
    if ((self = [super init])) {
        self.entityManager = entityManager;
        self.entityFactory = entityFactory;
    }
    return self;
}

-(void)update:(float)delta; {
    
}

@end