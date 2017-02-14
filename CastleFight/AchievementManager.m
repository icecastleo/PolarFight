//
//  AchievementManager.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/28.
//
//

#import "AchievementManager.h"
#import "Property.h"
#import "Achievement.h"
#import "FileManager.h"

//game center
#import "GameCenterManager.h"

@interface AchievementManager()

@property NSMutableDictionary *properties;
@property NSMutableDictionary *achievements;

-(void)doSetValue:(NSString *)propertyName Value:(int)value IgnoreActivationContraint:(BOOL)ignored;
-(BOOL)hasTagInTheProperty:(Property *)property Tags:(NSArray *)tags;
-(void)checkPropertyExistsForArray:(NSArray *)propertyNames;
-(void)calculateAchievementPercentage:(Achievement *)aAchievement;
-(void)dealWithUnLockedAchievement:(Achievement *)aAchievement;

@end

@implementation AchievementManager

-(id)init {
    if (self = [super init]) {
        _properties = [NSMutableDictionary dictionary];
        _achievements = [NSMutableDictionary dictionary];
    }
    return self;
}

-(id)initWithAchievements:(NSArray *)achievements AndProperties:(NSArray *)properties {
    if (self = [super init]) {
        _properties = [NSMutableDictionary dictionary];
        _achievements = [NSMutableDictionary dictionary];
        for (Achievement *achievement in achievements) {
            [_achievements setValue:achievement forKey:achievement.name];
        }
        for (Property *property in properties) {
            [_properties setValue:property forKey:property.name];
        }
    }
    return self;
}

-(void)doSetValue:(NSString *)propertyName Value:(int)value IgnoreActivationContraint:(BOOL)ignored {
    
    [self checkPropertyExistsForArray:@[propertyName]];
    
    Property *property = [self.properties objectForKey:propertyName];
    if (!ignored) {
        if ([property.activation isEqualToString:ACTIVE_IF_GREATER_THAN]) {
            value = value > property.value ? value : property.value;
        }else if([property.activation isEqualToString:ACTIVE_IF_LESS_THAN]) {
            value = value < property.value ? value : property.value;
        }
    }
    property.value = value;
}

-(BOOL)hasTagInTheProperty:(Property *)property Tags:(NSArray *)tags {
    BOOL hasTag = NO;
    
    for (NSString *tag in tags) {
        if (property.tags != nil) {
            hasTag = YES;
            if (![property.tags containsObject:tag]) {
                hasTag = NO;
                break;
            }
        }
    }
    return  hasTag;
}

-(void)checkPropertyExistsForArray:(NSArray *)propertyNames {
    NSString *pName;
    for (NSString *propertyName in propertyNames) {
        if ([self.properties objectForKey:propertyName] == nil) {
            pName = propertyName;
        }
    }
    NSAssert(pName == nil, @"Unknow achienement's property name. check if it was correctly defined by defineProperty()");
}

#pragma mark public fuctions

-(int)getValueFromProperty:(NSString *)propertyName {
    [self checkPropertyExistsForArray:@[propertyName]];
    Property *property = [self.properties objectForKey:propertyName];
    return  property.value;
}

-(void)addValueForPropertyNames:(NSArray *)propertyNames Value:(int)value {
    for (NSString *propertyName in propertyNames) {
        int addValue = [self getValueFromProperty:propertyName] + value;
        [self setValueForProperty:propertyName Value:addValue IgnoreActivationConstraint:NO];
    }
}

-(void)setValueForProperty:(NSString *)propertyName Value:(int)value IgnoreActivationConstraint:(BOOL)ignored {
    [self doSetValue:propertyName Value:value IgnoreActivationContraint:ignored];
}

-(void)resetPropertiesWithTags:(NSArray *)tags {
    for (NSString *key in self.properties) {
        Property *property = [self.properties objectForKey:key];
        if (tags == nil || [self hasTagInTheProperty:property Tags:tags]) {
            [property reset];
        }
    }
}

-(void)checkAchievementsForTags:(NSArray *)tags {
    for (NSString *key in self.achievements) {
        Achievement *aAchievement = [self.achievements objectForKey:key];
        if (aAchievement.unLocked == FALSE) {
            [self calculateAchievementPercentage:aAchievement];
            for (NSString *propertyName in aAchievement.propertyNames) {
                Property *aProperty = [self.properties objectForKey:propertyName];
                if ((tags == nil || [self hasTagInTheProperty:aProperty Tags:tags]) && [aProperty isActive]) {
                    if (aAchievement.percentage == 1) {
                        aAchievement.unLocked = TRUE;
                        [self dealWithUnLockedAchievement:aAchievement];
                        break;
                    }
                }
            }
        }
    }
}

-(NSArray *)getAllUnLockedAchievementsForTags:(NSArray *)tags {
    NSMutableArray *unlockedAchievements = [NSMutableArray array];
    for (NSString *key in self.achievements) {
        Achievement *aAchievement = [self.achievements objectForKey:key];
        if (aAchievement.unLocked == TRUE) {
            for (NSString *propertyName in aAchievement.propertyNames) {
                Property *aProperty = [self.properties objectForKey:propertyName];
                if (tags == nil || [self hasTagInTheProperty:aProperty Tags:tags]) {
                    [unlockedAchievements addObject:aAchievement];
                }
            }
        }
    }
    return unlockedAchievements;
}

-(NSArray *)getPropertiesForTags:(NSArray *)tags {
    NSMutableArray *targetProperties = [NSMutableArray array];
    for (NSString *key in self.properties) {
        Property *aProperty = [self.properties objectForKey:key];
        if (tags == nil || [self hasTagInTheProperty:aProperty Tags:tags]) {
            [targetProperties addObject:aProperty];
        }
    }
    return targetProperties;
}

-(BOOL)getStatusfromAchievement:(NSString *)achievementName {
    Achievement *achievement = [self.achievements objectForKey:achievementName];
    return achievement.unLocked;
}

-(void)calculateAchievementPercentage:(Achievement *)aAchievement {
    double percentageCompleted = 0;
    for (NSString *propertyName in aAchievement.propertyNames) {
        Property *aProperty = [self.properties objectForKey:propertyName];
        percentageCompleted += aProperty.percentage;
    }
    percentageCompleted = percentageCompleted/aAchievement.propertyNames.count;
    aAchievement.percentage = percentageCompleted > 1 ? 1 : percentageCompleted;
    [[FileManager sharedFileManager].gameCenterManager reportAchievementWithID:aAchievement.name percentComplete:aAchievement.percentage*100];
    NSLog(@"name:%@,percent:%g",aAchievement.name,aAchievement.percentage);
}

-(void)dealWithUnLockedAchievement:(Achievement *)aAchievement {
    //TODO: we might let the game center deal with the message.
    if(aAchievement.name == nil){
        return;
    }
    
    [[FileManager sharedFileManager].gameCenterManager showNotification:aAchievement.name message:aAchievement.message identifier:aAchievement.name];
}

@end
