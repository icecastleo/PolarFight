//
//  xmlParsing.h
//  LightBugBattle
//
//  Created by  浩翔 on 12/12/20.
//
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@protocol XMLParsingDelegate<NSObject>

-(id)initWithXMLElement:(GDataXMLElement *)aElement;

@end