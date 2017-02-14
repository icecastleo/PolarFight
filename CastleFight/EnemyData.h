//
//  CharacterData.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/14.
//
//

#import <Foundation/Foundation.h>

@interface EnemyData : NSObject

@property (readonly) NSString *cid;
@property (readonly) int level;
@property (readonly) float cost;
@property (readonly) int targetRatio;

@property int currentCount;
@property int insufficientRatio;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
