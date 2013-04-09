//
//  CCScrollLayerAdvance.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/8.
//
//

#import "CCScrollLayerAdvance.h"

@implementation CCScrollLayerAdvance

-(id)initWithRect:(CGRect)rect layers:(NSArray *)layers {
    if (self = [super initWithRect:rect]) {        
        CCScrollView *scrollView = self.scrollView;
        
        scrollView.contentSize = CGSizeMake(rect.size.width * layers.count, rect.size.height);
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        scrollView.bounces = YES;
        
        for (int i = 0; i < layers.count; i++) {
            CCLayer *layer = layers[i];
            
            layer.position = ccp(rect.size.width * i, 0);
            [self addChild:layer];
        }

        pageControl = [[UIPageControl alloc] init];
        
        CGPoint pagePosition = [[CCDirector sharedDirector] convertToUI:rect.origin];
        
        pageControl.frame = CGRectMake(pagePosition.x, pagePosition.y - MAX(32, rect.size.height / 10), rect.size.width, 32);
        pageControl.currentPage = 0;
        pageControl.numberOfPages = layers.count;
        pageControl.userInteractionEnabled = NO;
        
        [[CCDirector sharedDirector].view addSubview:pageControl];
    }
    return self;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    int currnetPage = floor((scrollView.contentOffset.x - width/2) / width) + 1;
    pageControl.currentPage = currnetPage;

    [super scrollViewDidScroll:scrollView];
}

-(void)dealloc {
    [pageControl removeFromSuperview];
    [pageControl release];
    [super dealloc];
}

@end
