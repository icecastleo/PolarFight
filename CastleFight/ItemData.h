//
//  ItemData.h
//  CastleFight
//
//  Created by  浩翔 on 13/10/24.
//
//

#import <Foundation/Foundation.h>
#import "PlistDictionaryInitialing.h"

@interface ItemData : NSObject <NSCoding, PlistDictionaryInitialing>

@property (readonly) NSString *itemId;
@property int count;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
