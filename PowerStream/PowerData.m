//
//  PowerData.m
//  PowerStream
//
//  Created by Simon on 04/11/2014.
//  Copyright (c) 2014 SJL. All rights reserved.
//

#import "PowerData.h"

@implementation PowerData

- (NSString*) asString {
    return [NSString stringWithFormat:@"Voltage: %@ V, Active: %@ W, Reactive: %@ VAR",
            [NSString stringWithFormat:@"%.02f", [self.voltage doubleValue]],
            [NSString stringWithFormat:@"%.02f", [self.activePower doubleValue]],
            [NSString stringWithFormat:@"%.02f", [self.reactivePower doubleValue]]];
}
@end
