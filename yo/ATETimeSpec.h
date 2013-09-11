//
//  ATETimeSpec.h
//  yo
//
//  Created by Alex Esplin on 9/8/13.
//  Copyright (c) 2013 Alex Esplin. All rights reserved.
//

#import "yo.h"
#import <Foundation/Foundation.h>

@interface ATETimeSpec : NSObject
{
    TimeSpecType    _type;
    NSDateComponents *_dateComponents;
    NSDate          *_notificationDate;
}

@property (readwrite,assign) TimeSpecType type;
@property (readonly) NSDate *notificationDate;
@property (readonly) NSDateComponents *notificationDateComponents;

- (id) initWithString:(NSString *) tsArg;

#pragma mark Initizialization Helpers
- (BOOL) _readRelativeTimeSpecString:(NSString *) tsArg;
- (BOOL) _readAbsoluteTimeSpecString:(NSString *) tsArg;


@end
