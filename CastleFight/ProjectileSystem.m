//
//  ProjectileSystem.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/18.
//
//

#import "ProjectileSystem.h"
#import "ProjectileComponent.h"
#import "ProjectileEvent.h"
#import "TeamComponent.h"

@implementation ProjectileSystem

-(void)update:(float)delta {
    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfClass:[ProjectileComponent class]]) {
        ProjectileComponent *projectile = (ProjectileComponent *)[entity getComponentOfClass:[ProjectileComponent class]];
        TeamComponent *team = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
        
        for (ProjectileEvent *event in projectile.projectileEvents) {
            [self.entityFactory createProjectileEntityWithEvent:event forTeam:team.team];
        }
        
        [projectile.projectileEvents removeAllObjects];
    }
}

@end
