//
//  SideEffect.h
//  CastleFight
//
//  Created by  DAN on 13/5/23.
//
//

#import <Foundation/Foundation.h>

@class StateComponent;

@interface SideEffect : NSObject

@property double percentage;
@property StateComponent *component;

-(id)initWithSideEffectCommponent:(StateComponent *)component andPercentage:(double)percentage;

@end
