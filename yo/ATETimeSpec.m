//
//  ATETimeSpec.m
//  Hey
//
//  Created by Alex Esplin on 8/8/12.
//  Copyright (c) 2012 Alex Esplin. All rights reserved.
//

#import "ATETimeSpec.h"

@implementation ATETimeSpec

@synthesize type = _type;
@synthesize notificationDate = _notificationDate;
@synthesize notificationDateList = _notificationDateList;

- (id) initWithString:(NSString *)tsArg
{
    if (self = [super init]) {
        /* TODO: parse the time spec and create the notification date here */
        switch ([tsArg characterAtIndex:0])
        {
            case '+': {
                
                _type = TimeSpecRelative;
                
                if (![self _readRelativeTimeSpecString:tsArg]) {
                    return nil;
                }
                
                break;
            }
                
            case '@':
                
                _type = TimeSpecAbsolute;
                
                if (![self _readAbsoluteTimeSpecString:tsArg]) {
                    return nil;
                }
                
                break;
                
            case 'e':
                
                fprintf(stdout, "need to parse repeating time-spec...\n");
                
                break;
                
            default:
                /* Houston, we have a problem... */
                return nil;
                
                /* not reached */
                break;
        }
        
        return self;
    }
    
    return nil;
}

/**
 _readRelativeTimeSpecString
 
 Reads a string of the type: +[<count>[w|d|h|m|s]]|[hh:mm:ss]
 
 Sets _notificationDate with the relative time read from the spec
 
 Returns:   YES if successful
            NO if unable to parse the time-spec
 */
- (BOOL) _readRelativeTimeSpecString:(NSString *)tsArg
{
    char unitChar;
    NSString *timeString;
    NSNumber *timeInterval;
    
    /* check for hh:mm:ss form */
    if ([tsArg rangeOfString:@":"].location != NSNotFound) {
        int hours;
        int minutes;
        int seconds;
        int interval;
        
        timeString = [tsArg substringWithRange:NSMakeRange(1, [tsArg length] -1)];
        NSArray *timeTokens = [timeString componentsSeparatedByString:@":"];
        
        hours = [[timeTokens objectAtIndex:0] intValue];
        minutes = [[timeTokens objectAtIndex:1] intValue];
        seconds = [[timeTokens objectAtIndex:2] intValue];
        
        interval = seconds + (minutes * SECONDS_PER_MINUTE) + (hours * SECONDS_PER_HOUR);
        _notificationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
        return YES;
    }
    
    timeString = [tsArg substringWithRange:NSMakeRange(1, [tsArg length] - 2)];
    timeInterval = [NSNumber numberWithLong:[timeString integerValue]];
    
    unitChar = [tsArg characterAtIndex:[tsArg length] - 1];
    
    switch (unitChar) {
            
        case 'w':
            
            _notificationDate = [NSDate dateWithTimeIntervalSinceNow:[timeInterval intValue] * SECONDS_PER_WEEK];
            break;
            
        case 'd':
            
            _notificationDate = [NSDate dateWithTimeIntervalSinceNow:[timeInterval intValue] * SECONDS_PER_DAY];
            break;
            
        case 'h':
            
            _notificationDate = [NSDate dateWithTimeIntervalSinceNow:[timeInterval intValue] * SECONDS_PER_HOUR];
            break;
            
        case 'm':
            
            _notificationDate = [NSDate dateWithTimeIntervalSinceNow:[timeInterval intValue] * SECONDS_PER_MINUTE];
            break;
            
        case 's':
            
            _notificationDate = [NSDate dateWithTimeIntervalSinceNow:[timeInterval intValue]];
            break;
            
        default:
            
            fprintf(stdout, "Unrecognized relative time units identifier: %c...\n", unitChar);
            return NO;
            break;
    }
    
    return YES;
} /* END _readRelativeTimeSpecString: */

/**
 _readAbsoluteTimeSpecString
 
 Reads a string of the type: @<[yyyy/mm/dd_]hh:mm[:ss]
 
 Sets _notificationDate with the time specified
 
 Returns:   YES if successful
            NO if unable to parse the time-spec
 */
- (BOOL) _readAbsoluteTimeSpecString:(NSString *)tsArg
{
    int year;
    int month;
    int day;
    int hours;
    int minutes;
    int seconds;
    
    NSString            *timeString;
    NSCalendar          *myCal;
    NSDateComponents    *notificationDateComponents;
    NSDateComponents    *currentDateComponents;
    NSArray             *dateTimeTokens;
    NSArray             *dateTokens;
    NSArray             *timeTokens;
    
    myCal = [NSCalendar currentCalendar];
    timeString = [tsArg substringWithRange:NSMakeRange(1, [tsArg length] - 1)];
    notificationDateComponents = [[NSDateComponents alloc] init];
    currentDateComponents = [myCal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                   fromDate:[NSDate date]];
    
    /* we got a date_time time-spec */
    if ([tsArg rangeOfString:@"_"].location != NSNotFound) {
        dateTimeTokens = [timeString componentsSeparatedByString:@"_"];
        dateTokens = [[dateTimeTokens objectAtIndex:0] componentsSeparatedByString:@"/"];
        timeTokens = [[dateTimeTokens objectAtIndex:1] componentsSeparatedByString:@":"];
        
        month = [[dateTokens objectAtIndex:0] intValue];
        day = [[dateTokens objectAtIndex:1] intValue];
        year = [[dateTokens objectAtIndex:2] intValue];
        
        hours = [[timeTokens objectAtIndex:0] intValue];
        minutes = [[timeTokens objectAtIndex:1] intValue];
        
        if ([timeTokens count] > 2) {
            seconds = [[timeTokens objectAtIndex:2] intValue];
        }
        else {
            seconds = 0;
        }
        
        [notificationDateComponents setYear:year];
        [notificationDateComponents setMonth:month];
        [notificationDateComponents setDay:day];
    }
    else {
        timeTokens = [timeString componentsSeparatedByString:@":"];
        
        hours = [[timeTokens objectAtIndex:0] intValue];
        minutes = [[timeTokens objectAtIndex:1] intValue];
        
        if ([timeTokens count] > 2) {
            seconds = [[timeTokens objectAtIndex:2] intValue];
        }
        else {
            seconds = 0;
        }
        [notificationDateComponents setYear:[currentDateComponents year]];
        [notificationDateComponents setMonth:[currentDateComponents month]];
        [notificationDateComponents setDay:[currentDateComponents day]];
    }    
    
    [notificationDateComponents setHour:hours];
    [notificationDateComponents setMinute:minutes];
    [notificationDateComponents setSecond:seconds];
    
    _notificationDate = [myCal dateFromComponents:notificationDateComponents];
    return YES;
} /* END _readAbsoluteTimeSpecString: */

@end


















