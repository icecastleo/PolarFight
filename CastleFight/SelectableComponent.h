//
//  SelectableComponent.h
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



@interface SelectableComponent : Component

@property (nonatomic) BOOL canSelect;
@property (nonatomic) BOOL hasDragLine;
@property (nonatomic) NSString *dragImage1;
@property (nonatomic) NSString *dragImage2;
@property (nonatomic) TouchType touchType;
@property (nonatomic,assign) id tapDelegate;
@property (nonatomic,assign) id dragDelegate;

-(id)initWithDictionary:(NSDictionary *)dic;

-(void)select;
-(void)unSelected;

-(void)handleTap:(NSArray *)path;
-(void)handleDrag:(NSArray *)path;

@end
