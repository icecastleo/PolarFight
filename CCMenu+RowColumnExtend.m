//
//  CCMenu+RowColumnExtend.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/17.
//
//

#import "CCMenu+RowColumnExtend.h"

@implementation CCMenu (RowColumnExtend)

-(void)alignItemsInColumn:(int)column padding:(CGPoint)padding
{
    if (children_.count == 0) {
        return;
    }
    
    CGRect boundingBox = ((CCMenuItem *)[children_ objectAtIndex:0]).boundingBox;
    
    int row = (children_.count + column - 1) / column;
    
    CGFloat width = boundingBox.size.width * column + padding.x * (column - 1);
    CGFloat height = boundingBox.size.height * row + padding.y * (row - 1);
    
    [self setContentSize:CGSizeMake(width, height)];
    
    CGFloat x = -width / 2;
    CGFloat y = height / 2;
    
    for (int i = 0; i < children_.count; i++) {
        CCMenuItem *item = [children_ objectAtIndex:i];
        item.position = ccp(x + item.boundingBox.size.width / 2, y - item.boundingBox.size.height / 2);
        
        if ((i + 1) % column == 0) {
            x = -width / 2;
            y -= boundingBox.size.height + padding.y;
        } else {
            x += boundingBox.size.width + padding.x;
        }
    }
}

@end
