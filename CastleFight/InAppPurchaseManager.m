//
//  InAppPurchaseManager.m
//  CastleFight
//
//  Created by 陳 謙 on 13/4/9.
//
//

#import "InAppPurchaseManager.h"
#import "FileManager.h"

@implementation SKProduct (LocalizedPrice)

- (NSString *)localizedPrice
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
    
    return formattedString;
}

@end

@implementation InAppPurchaseManager

#pragma mark Singleton Methods

static dispatch_once_t once;
static InAppPurchaseManager *sharedInstance;

+(InAppPurchaseManager *)sharedManager {
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    if (self = [super init]) {
        productIdentifiers = [NSArray arrayWithObjects:
                              @"com.sayagain.moonfight.Test1",
                              @"com.sayagain.moonfight.Test2",
                              @"com.sayagain.moonfight.Test3",
                              @"com.sayagain.moonfight.Test4",
                              @"com.sayagain.moonfight.Test5",
                              @"com.sayagain.moonfight.Test6",
                              nil];
        
        _productContents = [NSArray arrayWithObjects:
                           @"45000",
                           @"26000",
                           @"12000",
                           @"5500",
                           @"3150",
                           @"1000",
                           nil];
        
        // restarts any purchases if they were interrupted last time the app was open
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

#pragma -
#pragma Public methods

-(void)sendProductRequest:(id<SKProductsRequestDelegate>)delegate {
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = delegate;
    [productsRequest start];
}

-(void)buyProduct:(SKProduct *)product {
    if ([SKPaymentQueue canMakePayments]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"In-App Purchases Disabled", nil)
                                                            message:NSLocalizedString(@"You need to enable in-app purchases in Home > Settings > General > Restrictions to buy features", nil)
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma -
#pragma Purchase helpers

// called when the transaction status is updated
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}


// saves a record of the transaction by storing the receipt to disk
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    // If we have some Non-Consumable product, we need to save the transaction receipt to disk.

//    [[NSUserDefaults standardUserDefaults] [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier]; ];
//    [[NSUserDefaults standardUserDefaults] synchronize];

}

// provide product
- (void)provideContent:(NSString *)productIdentifier
{
    for (int i = 0; i < productIdentifiers.count; i++) {
        if ([productIdentifier isEqualToString:productIdentifiers[i]]) {
            [FileManager sharedFileManager].userMoney += [_productContents[i] intValue];
            break;
        }
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"Purchase successfully!", nil)
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}

// called when the transaction was successful
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

// called when a transaction has been restored and and successfully completed
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

// called when a transaction has failed
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

// removes the transaction from the queue and posts a notification with the transaction result
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    
    if (wasSuccessful) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

@end

