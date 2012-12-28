//
//  CharacterStatus.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/6.
//
//

#import <Foundation/Foundation.h>

@interface Status : NSObject {
    int type;
    BOOL isDead;
}

@property (readonly) int type;
@property (readonly) BOOL isDead;

//-(id) initWithType:(StatusType)statusType;
-(id) initWithType:(int)statusType;

@end
