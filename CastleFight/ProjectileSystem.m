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
    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfName:[ProjectileComponent name]]) {
        ProjectileComponent *projectile = (ProjectileComponent *)[entity getComponentOfName:[ProjectileComponent name]];
        TeamComponent *team = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
        
        for (ProjectileEvent *event in projectile.projectileEvents) {
            [self.entityFactory createProjectileEntityWithEvent:event forTeam:team.team];
        }
        
        [projectile.projectileEvents removeAllObjects];
    }
}

@end
