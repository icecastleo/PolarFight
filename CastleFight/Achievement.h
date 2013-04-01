//
//  Achievement.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/28.
//
//

#import <Foundation/Foundation.h>
#import "UserDataDelegate.h"

@interface Achievement : NSObject <NSCoding,UserDataDelegate>

@property (readonly) NSString *name;
@property (readonly) NSArray *propertyNames;
@property BOOL unLocked;

-(id)initWithAchievementName:(NSString *)name theRelatedPropertyNames:(NSArray *)propertyNames;

-(id)initWithDictionary:(NSDictionary *)dic;

//FIXME: delete this after test
-(NSString *)description;

@end
