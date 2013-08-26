//
//  TouchComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/6/18.
//
//

#import "Component.h"

typedef enum {
//    kTouchStateBegin,
    kTouchStateMove,
    kTouchStateEnd,
} TouchState;

@protocol TouchComponentDelegate <NSObject>

@optional
-(void)handleTap;
-(void)handlePan:(TouchState)state path:(NSArray *)path;
-(void)handleSelect;
-(void)handleUnselect;

@end

@interface TouchComponent : Component

@property BOOL touchable;

@property (readonly) BOOL canSelect;
//@property (nonatomic) BOOL hasDragLine;
@property (nonatomic) NSString *dragImage1;
@property (nonatomic) NSString *dragImage2;

@property (nonatomic, weak) id<TouchComponentDelegate> delegate;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
