//
//  PowerData.h
//  PowerStream
//
//  Created by Simon on 04/11/2014.
//  Copyright (c) 2014 SJL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PowerData : NSObject

@property NSNumber* datetime;
@property NSNumber* voltage;
@property NSNumber* activePower;
@property NSNumber* reactivePower;
- (NSString*) asString;

@end
