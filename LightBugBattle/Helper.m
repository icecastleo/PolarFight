//
//  Helper.m
//  LightBugBattle
//
//  Created by Huang Hsing on 12/11/12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Helper.h"


@implementation Helper

//void calc(circle cir1,circle cir2)
+(CGPoint) moveRedirectWhileCollisionP1:(CGPoint)point1 R1:(float)r1 P2:(CGPoint)point2 R2:(float)r2 Location:(CGPoint)location
{
    CGPoint targetLocation = ccp(0,0);
    
    double x1,x2,y1,y2;//此為兩圓相交的坐標
    if(point1.y!=point2.y)//兩圓圓心Y值不同時
    {//m= y=mx+k的x項系數、k= y=mx+k的k項常數、 a、b、c= x=(-b±√(b^2-4ac))/2a的係數
        double m=(point1.x-point2.x)/(point2.y-point1.y),k=(pow(r1,2)-pow(r2,2)+pow(point2.x,2)-pow(point1.x,2)+pow(point2.y,2)-pow(point1.y,2))/(2*(point2.y-point1.y));
        double a=1+pow(m,2),b=2*(k*m-point2.x-m*point2.y),c=pow(point2.x,2)+pow(point2.y,2)+pow(k,2)-2*k*point2.y-pow(r2,2);
        
        if(b*b-4*a*c>=0)//有交點時
        {
            x1=((-b)+sqrt(b*b-4*a*c))/(2*a);//x=(-b+√(b^2-4ac))/2a
            y1=m*x1+k;//y=mx+k
            x2=((-b)-sqrt(b*b-4*a*c))/(2*a);//x=(-b-√(b^2-4ac))/2a
            y2=m*x2+k;//y=mx+k
            if(b*b-4*a*c>0)//兩交點
            {
                
                if( ccpDistance(location, ccp(x1,y1)) > ccpDistance(location, ccp(x2,y2)) )
                    targetLocation = ccp(x2, y2);
                else
                    targetLocation = ccp(x1, y1);
            
            }
            else//一交點
            {
                targetLocation = ccp(x1, y1);
            }
        }
        else//沒有交點時
        {
            CCLOG(@"NO POINT");
            targetLocation = point1;
        }
    }
    else if(point1.y==point2.y)//兩圓圓心Y值相同時
    {//x1= 兩交點的x值、 a、b、c= x=(-b±√(b^2-4ac))/2a的係數
        x1=-(pow(point1.x,2)-pow(point2.x,2)-pow(r1,2)+pow(r2,2))/(2*point2.x-2*point1.x);
        double a=1,b=-2*point1.y,c=pow(x1,2)+pow(point1.x,2)-2*point1.x*x1+pow(point1.y,2)-pow(r1,2);
        if(b*b-4*a*c>=0)
        {
            y1=((-b)+sqrt(b*b-4*a*c))/(2*a);//y=(-b+√(b^2-4ac))/2a
            y2=((-b)-sqrt(b*b-4*a*c))/(2*a);//y=(-b-√(b^2-4ac))/2a
            if(b*b-4*a*c>0)//兩交點
            {
                if( ccpDistance(location, ccp(x1,y1)) > ccpDistance(location, ccp(x2,y2)) )
                    targetLocation = ccp(x2, y2);
                else
                    targetLocation = ccp(x1, y1);
            }
            else//一交點
            {
                targetLocation = ccp(x1, y1);
            }
        }
        else//沒有交點時
        {
            CCLOG(@"NO POINT");
            targetLocation = point1;
        }
    }
    
    return targetLocation;
}
@end
