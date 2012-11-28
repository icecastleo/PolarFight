//
//  role.m
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/27.
//
//

#import "Role.h"

@implementation Role
@synthesize name;
@synthesize picture;
@synthesize type;
@synthesize level;
@synthesize maxHp;
@synthesize hp;
@synthesize attack;
@synthesize defense;
@synthesize speed;
@synthesize moveSpeed;
@synthesize moveTime;
@synthesize roleId;

-(void)dealloc
{
    name = nil;
    picture = nil;
    type = nil;
    level = nil;
    maxHp = nil;
    hp = nil;
    attack = nil;
    defense = nil;
    speed = nil;
    moveSpeed = nil;
    moveTime = nil;
    roleId = nil;
    
    [name release];
    [picture release];
    [type release];
    [level release];
    [maxHp release];
    [hp release];
    [attack release];
    [defense release];
    [speed release];
    [moveSpeed release];
    [moveTime release];
    [roleId release];
    
    [super dealloc];
}
@end
