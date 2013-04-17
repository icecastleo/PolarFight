//
//  InAppPurchaseManager.h
//  CastleFight
//
//  Created by 陳 謙 on 13/4/9.
//
//

#import <StoreKit/StoreKit.h>
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end


@interface InAppPurchaseManager : NSObject <SKPaymentTransactionObserver> {
    NSArray *productIdentifiers;
}
@property (readonly) NSArray *productContents;

+(InAppPurchaseManager*)sharedManager;

-(void)sendProductRequest:(id<SKProductsRequestDelegate>)delegate;
-(void)buyProduct:(SKProduct *)product;

@end
