//
//  TouchComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/6/18.
//
//

#import "Component.h"

typedef enum {
    kPanStateBegan,
    kPanStateMoved,
    kPanStateEnded,
} PanState;

typedef enum {
    kTapStateBegan,
    kTapStateEnded,
} TapState;

@protocol TouchComponentDelegate <NSObject>

@optional
-(void)handleTap:(TapState)state;
-(void)handlePan:(PanState)state positions:(NSArray *)positions;
-(void)handleSelect;
-(void)handleUnselect;

@end

@class CCSprite;

@interface TouchComponent : Component

@property BOOL touchable;

@property (readonly) BOOL canSelect;
//@property (nonatomic) BOOL hasDragLine;
@property (nonatomic) NSString *dragImage1;
@property (nonatomic) NSString *dragImage2;
@property (nonatomic) CCSprite *selectedSprite;

@property (nonatomic, weak) id<TouchComponentDelegate> delegate;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
