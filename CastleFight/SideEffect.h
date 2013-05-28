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

@property int percentage;
@property StateComponent *component;

-(id)initWithSideEffectCommponent:(StateComponent *)component andPercentage:(int)percentage;

@end