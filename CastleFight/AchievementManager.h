//
//  AchievementManager.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/28.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"

@interface AchievementManager : NSObject <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate,GameCenterManagerDelegate>

-(id)initWithAchievements:(NSArray *)achievements AndProperties:(NSArray *)properties;

-(int)getValueFromProperty:(NSString *)propertyName;
-(void)addValueForPropertyNames:(NSArray *)propertyNames Value:(int)value;
-(void)setValueForProperty:(NSString *)propertyName Value:(int)value IgnoreActivationConstraint:(BOOL)ignored;

-(void)resetPropertiesWithTags:(NSArray *)tags;
-(void)checkAchievementsForTags:(NSArray *)tags;

-(NSArray *)getAllUnLockedAchievementsForTags:(NSArray *)tags;
-(NSArray *)getPropertiesForTags:(NSArray *)tags;
-(BOOL)getStatusfromAchievement:(NSString *)achievementName;

@end
