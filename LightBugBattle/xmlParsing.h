//
//  xmlParsing.h
//  LightBugBattle
//
//  Created by  DAN on 12/12/20.
//
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@protocol xmlParsing <NSObject>

- (id)initWithDom:(GDataXMLElement *)dom;

@end
