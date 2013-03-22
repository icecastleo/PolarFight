//
//  CharacterData.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/20.
//
//

#import <Foundation/Foundation.h>

@interface CharacterDataObject : NSObject <NSCoding>

@property (nonatomic, strong) NSString *characterId;
@property (nonatomic, strong) NSString *level;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
