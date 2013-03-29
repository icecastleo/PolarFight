//
//  DependentAttribute.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/15.
//
//

#import <Foundation/Foundation.h>
@class Attribute;

@interface DependentAttribute : NSObject {
    __weak Attribute *father;
}

@property (readwrite, nonatomic) int value;

-(id)initWithAttribute:(Attribute*)anAttribute;

@end
