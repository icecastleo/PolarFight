//
//  ProjectileRange.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/18.
//
//

#import "Range.h"

@interface ProjectileRange : Range {
    Range *effectRange;
    
    NSMutableDictionary *piercingEntities;
}

@property (readonly) BOOL isPiercing;

@end
