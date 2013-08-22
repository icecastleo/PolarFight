//
//  TouchComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/6/18.
//
//

#import "Component.h"

typedef enum {
    kNoTouchType = 0,
    kTapType = 1,
    kDragType,
} TouchType;

@protocol TouchComponentDelegate <NSObject>

@optional
-(void)handleTap;
-(void)drawPan:(NSArray *)path;
-(void)handlePan:(NSArray *)path;
-(void)handleSelect;
-(void)handleUnselect;

@end

@interface TouchComponent : Component

@property BOOL touchable;

@property (readonly) BOOL canSelect;
//@property (nonatomic) BOOL hasDragLine;
@property (nonatomic) NSString *dragImage1;
@property (nonatomic) NSString *dragImage2;
@property (nonatomic) TouchType touchType;

@property (nonatomic, weak) id<TouchComponentDelegate> delegate;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
