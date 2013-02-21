//
//  ObjectiveCAdaptor.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/2/19.
//
//

#import "ObjectiveCAdaptor.h"
#import "CPlusPlusClass.h"

@interface ObjectiveCAdaptor() {
    CPlusPlusClass *testObj;
}

@end

@implementation ObjectiveCAdaptor

-(id)init {
    if (self = [super init]) {
        testObj = new CPlusPlusClass();
    }
    return self;
}

-(void)objectiveFunc {
    testObj->setInt(5);
    testObj->func();
}

- (void)dealloc {
    delete testObj;
}

@end
