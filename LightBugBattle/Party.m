//
//  Party.m
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/10.
//
//

#import "Party.h"
#import "Role.h"
#import "Character.h"

@implementation Party
@synthesize roles = _roles, players = _players;

- (id) init {
    
    if ((self = [super init])) {
        _roles = [[[NSMutableArray alloc] init] autorelease];
        _players = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
    
}

- (void) dealloc {
    self.roles = nil;
    self.players = nil;
    [self.roles release];
    [self.players release];
    [super dealloc];
}

- (Role *) basicRoleFromName:(NSString *)name
{
    for (Role *role in self.roles) {
        if ([role.name isEqualToString:name]) {
            return role;
        }
    }
    return nil;
}

- (NSMutableArray *) players
{
    for (Role *role in self.roles) {
        //Character *character = [Character alloc]
    }
    
    return nil;
}

@end
