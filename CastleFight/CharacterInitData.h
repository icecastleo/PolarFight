//
//  CharacterData.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/20.
//
//

#import <Foundation/Foundation.h>
#import "PlistDictionaryInitialing.h"

@interface CharacterInitData : NSObject <NSCoding, PlistDictionaryInitialing>

@property (readonly) NSString *cid;
@property int level;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
