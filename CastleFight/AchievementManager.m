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

@interface AchievementManager()

@property NSMutableDictionary *properties;
@property NSMutableDictionary *achievements;

-(void)doSetValue:(NSString *)propertyName Value:(int)value IgnoreActivationContraint:(BOOL)ignored;
-(BOOL)hasTagInTheProperty:(Property *)property Tags:(NSArray *)tags;
-(void)checkPropertyExistsForArray:(NSArray *)propertyNames;

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
            if ([property.tags containsObject:tag]) {
                hasTag = YES;
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

-(void)definePropertyWithName:(NSString *)name InitialValue:(int)initialValue theActivationMode:(NSString *)activationMode ActivationValue:(int)activationValue Tags:(NSArray *)tags {
    Property *property = [[Property alloc] initWithPropertyName:name InitialValue:initialValue theActivationMode:activationMode ActivationValue:activationValue tags:tags];
    [self.properties setValue:property forKey:name];
}
-(void)defineAchievementWithName:(NSString *)name theRelatedPropertyNames:(NSArray *)propertyNames {
    [self checkPropertyExistsForArray:propertyNames];
    Achievement *achievement = [[Achievement alloc] initWithAchievementName:name theRelatedPropertyNames:propertyNames];
    [self.achievements setValue:achievement forKey:name];
}

-(int)getValueFromProperty:(NSString *)propertyName {
    [self checkPropertyExistsForArray:@[propertyName]];
    Property *property = [self.properties objectForKey:propertyName];
    return  property.value;
}

-(void)addValueForPropertyNames:(NSArray *)propertyNames Value:(int)value {
    for (NSString *propertyName in propertyNames) {
        int addValue = [self getValueFromProperty:propertyName] + value;
        [self setValueForProperty:propertyName Value:addValue IgnoreActivationContraint:NO];
    }
}

-(void)setValueForProperty:(NSString *)propertyName Value:(int)value IgnoreActivationContraint:(BOOL)ignored {
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

-(NSArray *)checkAndGetAllFinishedAchievementsForTags:(NSArray *)tags {
    NSMutableArray *unlockedAchievements = [NSMutableArray array];
    
    for (NSString *key in self.achievements) {
        Achievement *aAchievement = [self.achievements objectForKey:key];
        if (aAchievement.unLocked == FALSE) {
            int activePropertySum = 0;
            for (NSString *propertyName in aAchievement.propertyNames) {
                Property *aProperty = [self.properties objectForKey:propertyName];
                if ((tags == nil || [self hasTagInTheProperty:aProperty Tags:tags]) && aProperty.isActive) {
                    activePropertySum++;
                }
                if (activePropertySum == aAchievement.propertyNames.count) {
                    aAchievement.unLocked = TRUE;
                    [unlockedAchievements addObject:aAchievement];
                }
            }
        }
    }
    
    return unlockedAchievements;
}

@end
