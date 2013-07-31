//
//  SkillComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/6.
//
//

#import "Component.h"
#import "ActiveSkill.h"

@interface ActiveSkillComponent : Component

@property (readonly) NSDictionary *skills;
@property ActiveSkill *currentSkill;
@property (nonatomic) NSString *activeKey;

@property (readonly) NSDictionary *skillNames;
@property (readonly) NSArray *sortSkillProbabilities;
@property (nonatomic, readonly) int sumOfProbability;

-(void)addSkillName:(NSString *)skillName andProbability:(int)probability;

-(NSString *)getSkillNameFromNumber:(int)number;

@end
