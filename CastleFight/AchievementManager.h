//
//  AchievementManager.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/28.
//
//

#import <Foundation/Foundation.h>

@interface AchievementManager : NSObject

-(id)initWithAchievements:(NSDictionary *)achievements AndProperties:(NSDictionary *)properties;

-(void)definePropertyWithName:(NSString *)name InitialValue:(int)initialValue theActivationMode:(NSString *)mode ActivationValue:(int)theValue Tags:(NSArray *)tags;
-(void)defineAchievementWithName:(NSString *)name theRelatedPropertyNames:(NSArray *)propertyNames;

-(int)getValueFromProperty:(NSString *)propertyName;

-(void)addValueForPropertyNames:(NSArray *)propertyNames Value:(int)value;

-(void)setValueForProperty:(NSString *)propertyName Value:(int)value IgnoreActivationContraint:(BOOL)ignore;

-(void)resetPropertiesWithTags:(NSArray *)tags;

//only get the achievements during this time that you finished.
-(NSArray *)checkAndGetAllFinishedAchievements:(NSArray *)tags;

@end
