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
    if (_children.count == 0) {
        return;
    }
    
    CGSize contentSize = ((CCMenuItem *)[_children objectAtIndex:0]).contentSize;
    
    int row = (_children.count + column - 1) / column;
    
    CGFloat width = contentSize.width * column + padding.x * (column - 1);
    CGFloat height = contentSize.height * row + padding.y * (row - 1);
    
    [self setContentSize:CGSizeMake(width, height)];
    
    CGFloat x = -width / 2;
    CGFloat y = height / 2;
    
    for (int i = 0; i < _children.count; i++) {
        CCMenuItem *item = [_children objectAtIndex:i];
        item.position = ccp(x + item.contentSize.width / 2, y - item.contentSize.height / 2);
        
        if ((i + 1) % column == 0) {
            x = -width / 2;
            y -= contentSize.height + padding.y;
        } else {
            x += contentSize.width + padding.x;
        }
    }
}

@end
