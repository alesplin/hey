//
//  ATEAppDelegate.m
//  yo
//
//  Created by Alex Esplin on 9/8/13.
//  Copyright (c) 2013 Alex Esplin. All rights reserved.
//

#import "ATEAppDelegate.h"
#import "ATETimeSpec.h"
#import <EventKit/EventKit.h>

@implementation ATEAppDelegate

- (EKCalendar *) getRemindersCalendarFromEventStore:(EKEventStore *)store
{
    NSArray *cal_list = [store calendarsForEntityType:EKEntityTypeReminder];
    
//    NSLog(@"Got %d calendars for reminders...", (int)[cal_list count]);
    for (EKCalendar *cal in cal_list) {
        if ([[cal title] isEqualToString:@"Reminders"]) {
            return cal;
        }
    }
    
    return nil;
}

- (int) createReminderWithMessageText:(NSString *)msg
{
    NSError *save_err;
    BOOL rc;
    NSLog(@"Creating a reminder with message '%@', on date %@", msg, myTimeSpec.notificationDate);
    EKReminder *rem = [EKReminder reminderWithEventStore:event_store];
    EKAlarm *reminder_alarm = [EKAlarm alarmWithAbsoluteDate:myTimeSpec.notificationDate];
    [rem addAlarm:reminder_alarm];
    rem.title = msg;
    rem.calendar = reminder_cal;
    rem.startDateComponents = myTimeSpec.notificationDateComponents;
    
    if (![reminder_cal allowsContentModifications]) {
        NSLog(@"Houston, we may have a problem...");
    }
    
    rc = [event_store saveReminder:rem commit:YES error:&save_err];
    
    if (rc) {
        NSLog(@"Reminder created...");
        return SUCCESS;
    }
    else {
        NSLog(@"Failed to save reminder to event store.");
        NSLog(@"Reminder with title: %@, start date components: %@", rem.title, [rem.startDateComponents description]);
        NSLog(@"Tried saving in reminders list '%@'", reminder_cal.title);
        NSLog(@"%@", [save_err localizedDescription]);
        return FAILURE;
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSArray *args = [[NSProcessInfo processInfo] arguments];
    NSString *timeString = [args objectAtIndex:1];
    NSString *msgString = [args objectAtIndex:2];
    
    myTimeSpec = [[ATETimeSpec alloc] initWithString:timeString];
    NSLog(@"Current Date:      %@", [NSDate date]);
    NSLog(@"Reminder On Date:  %@", [myTimeSpec notificationDate]);
    
    event_store = [[EKEventStore alloc] init];
    [event_store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        int rc;
        
        if (!granted) {
            fprintf(stdout, "No access to reminders...\n");
            if (error != Nil) {
                fprintf(stderr, "%s\n", [[error localizedDescription] UTF8String]);
            }
        }
        else {
            fprintf(stdout, "Access granted to reminders...\n");
            reminder_cal = [self getRemindersCalendarFromEventStore:event_store];
            if (reminder_cal == nil) {
                NSLog(@"No event calendar named 'Reminders'");
                [NSApp terminate:self];
            }
            
            rc = [self createReminderWithMessageText:msgString];
        } /* END else... */
    }]; /* END requestAccess completion block */
    
    [NSApp terminate:self];
}

@end
