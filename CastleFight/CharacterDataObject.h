//
//  CharacterData.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/20.
//
//

#import <Foundation/Foundation.h>
#import "UserDataDelegate.h"

@interface CharacterDataObject : NSObject <NSCoding,UserDataDelegate>

@property (nonatomic, strong) NSString *characterId;
@property (nonatomic, strong) NSString *level;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
