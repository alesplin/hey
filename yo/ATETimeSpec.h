//
//  ATETimeSpec.h
//  Hey
//
//  Created by Alex Esplin on 8/8/12.
//  Copyright (c) 2012 Alex Esplin. All rights reserved.
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
