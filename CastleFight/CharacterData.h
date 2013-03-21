//
//  CharacterData.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/20.
//
//

#import <Foundation/Foundation.h>

@interface CharacterData : NSObject <NSCoding>

@property (strong) NSString *characterId;
@property (strong) NSString *level;
@property (strong) NSString *targetRatio;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
