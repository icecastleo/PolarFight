//
//  MinionAIStateWalk.m
//  CastleFight
//
//  Created by 朱 世光 on 13/9/16.
//
//

#import "MinionAIStateWalk.h"
#import "RenderComponent.h"
#import "MoveComponent.h"
#import "GroupComponent.h"
#import "ActiveSkillComponent.h"
#import "MinionAIStateAttack.h"
#import "TeamComponent.h"
#import "CharacterComponent.h"
#import "MinionAIStatePanic.h"

@interface MinionAIStateWalk() {
    MoveComponent *move;
    ActiveSkillComponent *skills;

    Entity *target;
}

@end

@implementation MinionAIStateWalk

-(void)enter:(Entity *)entity {
    move = (MoveComponent *)[entity getComponentOfName:[MoveComponent name]];
    skills = (ActiveSkillComponent *)[entity getComponentOfName:[ActiveSkillComponent name]];
}

-(void)updateEntity:(Entity *)entity {
    if (target.isDead) {
        target = nil;
    }
    
    if (target != nil) {
        ActiveSkill *skill = [skills.skills objectForKey:@"attack1"];
        
        if (ccpDistance(entity.position, target.position) > skill.range.width) {
            if (entity.position.x > target.position.x) {
                move.velocity = ccpSub(ccpAdd(target.position, ccp(skill.range.width * 0.8, 0)), entity.position);
            } else {
                move.velocity = ccpSub(ccpAdd(target.position, ccp(-skill.range.width * 0.8, 0)), entity.position);
            }
        } else {
            [self changeState:[[MinionAIStateAttack alloc] initWithGeneral:self.general] forEntity:entity];
        }
        return;
    }
    
    if (self.general.isDead == NO) {
        MoveComponent *generalMove = (MoveComponent *)[self.general getComponentOfName:[MoveComponent name]];
        
        // Follow general
        if (CGPointEqualToPoint(generalMove.velocity, CGPointZero) == NO) {
            GroupComponent *group = (GroupComponent *)[entity getComponentOfName:[GroupComponent name]];
            [self flock:entity withEntities:group.groupEntities withSeparationWeight:0.3 andAlignmentWeight:0.5 andCohesionWeight:0.3];
        } else {
            ActiveSkill *skill = [skills.skills objectForKey:@"attack1"];
            
            if ([skill checkRange]) {
                [self changeState:[[MinionAIStateAttack alloc] initWithGeneral:self.general] forEntity:entity];
            } else {
                // Find a target
                int range = (entity.boundingBox.size.width + entity.boundingBox.size.height)*2;
                
                TeamComponent *entityTeam = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
                
                for (Entity *enemy in [entity getAllEntitiesPosessingComponentOfName:[CharacterComponent name]]) {
                    if (enemy.eid == entity.eid) {
                        continue;
                    }
                    
                    TeamComponent *enemyTeam = (TeamComponent *)[enemy getComponentOfName:[TeamComponent name]];
                    
                    if (entityTeam.team == enemyTeam.team) {
                        continue;
                    }
                    
                    if (enemy.isDead) {
                        continue;
                    }
                    
                    if (ccpDistance(entity.position, enemy.position) > range) {
                        continue;
                    }
                    
                    if (target == nil) {
                        target = enemy;
                    } else {
                        CharacterComponent *targetCharacter = (CharacterComponent *)[target getComponentOfName:[CharacterComponent name]];
                        CharacterComponent *enemyCharacter = (CharacterComponent *)[enemy getComponentOfName:[CharacterComponent name]];
                        
                        if (targetCharacter.type == enemyCharacter.type) {
                            if (ccpDistance(entity.position, target.position) > ccpDistance(entity.position, enemy.position)) {
                                target = enemy;
                            }
                        } else {
                            if (enemyCharacter.type == kCharacterTypeMinion) {
                                target = enemy;
                            }
                        }
                    }
                }
                
                // Probably game end! Group general and minion!
                if (target == nil) {
                    GroupComponent *group = (GroupComponent *)[entity getComponentOfName:[GroupComponent name]];
                    [self flock:entity withEntities:group.groupEntities withSeparationWeight:0.4 andAlignmentWeight:0.0 andCohesionWeight:0.3];
                }
            }
        }
    } else {
        [self changeState:[[MinionAIStatePanic alloc] initWithGeneral:self.general] forEntity:entity];
    }
}

-(void)exit:(Entity *)entity {
    move.velocity = CGPointZero;
}

#pragma mark Flocking
-(void)flock:(Entity *)entity withEntities:(NSMutableArray *)entities withSeparationWeight:(float)separationWeight andAlignmentWeight:(float)alignmentWeight andCohesionWeight:(float)cohesionWeigt {
    CGPoint velocity = CGPointZero;
    
    velocity = ccpAdd(velocity, [self separate:entity withEntities:entities usingMultiplier:separationWeight]);
    velocity = ccpAdd(velocity, [self align:entity withEntities:entities usingMultiplier:alignmentWeight]);
    velocity = ccpAdd(velocity, [self cohesion:entity withEntities:entities usingMultiplier:cohesionWeigt]);
    
    move.velocity = velocity;

//    CCLOG(@"%@",NSStringFromCGPoint(move.velocity));
}

-(CGPoint)separate:(Entity *)entity withEntities:(NSMutableArray *)entities usingMultiplier:(float)multiplier {
	CGPoint force = CGPointZero;
	CGPoint difference = CGPointZero;
	int	count = 0;
	
    for (Entity *groupEntity in entities) {
        if (entity.eid == groupEntity.eid) {
            continue;
        }
        
        int seperateDistance = (entity.boundingBox.size.width + entity.boundingBox.size.height + groupEntity.boundingBox.size.width + groupEntity.boundingBox.size.height)/5;
        
        if (ccpDistance(entity.position, groupEntity.position) < seperateDistance) {
            
            difference = ccpSub(entity.position, groupEntity.position);
            
            // Adjust force by distance, the closer, the force is more powerful!
            float distance = ccpDistance(entity.position, groupEntity.position);
            difference = ccpMult(difference, 1.0f/distance);
            
            force = ccpAdd(force, difference);
            count++;
        }
    }
    
	// Average
	if(count > 0) {
		force = ccpMult(force, 1.0f/count);
        force = ccpNormalize(force);
    }
	
	// apply
	if(multiplier != 1.0)
		force = ccpMult(force, multiplier);
    
	return force;
}

-(CGPoint)align:(Entity *)entity withEntities:(NSMutableArray *)entities usingMultiplier:(float)multiplier {
    int neighborDistance = (entity.boundingBox.size.width + entity.boundingBox.size.height)*2;
    
	CGPoint force = CGPointZero;
	int	count = 0;
    
    for (Entity *groupEntity in entities) {
        if (entity.eid == groupEntity.eid) {
            continue;
        }
        
        if (ccpDistance(entity.position, groupEntity.position) < neighborDistance) {
            MoveComponent *groupEntityMove = (MoveComponent *)[groupEntity getComponentOfName:[MoveComponent name]];
            
            if (CGPointEqualToPoint(groupEntityMove.velocity, CGPointZero) == NO) {
                force = ccpAdd(force, groupEntityMove.velocity);
                count++;
            }
        }
    }
    
	// Average
	if(count > 0)
		force = ccpMult(force, 1.0f / count);
    
	// apply
	if(multiplier != 1.0)
		force = ccpMult(force, multiplier);
    
	return force;
}

-(CGPoint)cohesion:(Entity *)entity withEntities:(NSMutableArray *)entities usingMultiplier:(float)multiplier {
    int neighborDistance = (entity.boundingBox.size.width + entity.boundingBox.size.height)*2;
    int ignoreDistance = (entity.boundingBox.size.width + entity.boundingBox.size.height);
    
	CGPoint force = CGPointZero;
	int	count = 0;
	
    for (Entity *groupEntity in entities) {
        if (entity.eid == groupEntity.eid) {
            continue;
        }
        
        float distance = ccpDistance(entity.position, groupEntity.position);
        
        if (distance > ignoreDistance && distance < neighborDistance) {
            force = ccpAdd(force, groupEntity.position);
            count++;
        }
    }
    
	if(count > 0) {
        // Average
		force = ccpMult(force, 1.0f/count);
        force = [self steerEntity:entity withTarget:force easeAsApproaching:NO withEaseDistance:0];
    }
	
	// apply
	if(multiplier != 1.0)
		force = ccpMult(force, multiplier);
	
	return force;
}

#pragma mark Movement
-(CGPoint)steerEntity:(Entity *)entity withTarget:(CGPoint)targetPoint easeAsApproaching:(BOOL)ease withEaseDistance:(float)easeDistance
{
	CGPoint steeringForce = ccp(targetPoint.x, targetPoint.y);
	steeringForce = ccpSub(steeringForce, entity.position);
	
	float distanceSquared = ccpLengthSQ(steeringForce);
	float easeDistanceSquared = easeDistance * easeDistance;
	
	if(distanceSquared > FLT_EPSILON)
	{
		// Slow down or not
		if(ease && distanceSquared < easeDistanceSquared) {
			float distance = sqrtf(distanceSquared);
			steeringForce = ccpMult(steeringForce, (distance/easeDistance) );
		}
		
//		// Slow down
//        MoveComponent *move = (MoveComponent *)[entity getComponentOfName:[MoveComponent name]];
//		steeringForce = ccpSub(steeringForce, move.velocity);
	}
	
    steeringForce = ccpNormalize(steeringForce);
    
	return steeringForce;
}

@end
