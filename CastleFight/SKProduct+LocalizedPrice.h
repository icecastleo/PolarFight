//
//  SKProduct+LocalizedPrice.h
//  CastleFight
//
//  Created by 陳 謙 on 13/4/9.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end