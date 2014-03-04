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
    NSError *save_err = nil;
    EKSource *event_source = nil;
    BOOL save_result;

    EKCalendar *yo_reminders = nil;

    /* go find the 'yo' reminders list */
    for (EKCalendar *cal in [store calendarsForEntityType:EKEntityTypeReminder]) {
        if ([[cal title] isEqualToString:@"yo"]) {
            return cal;
        }
    }

    if (yo_reminders == nil) {
        /* create the 'yo' reminders list... */
        yo_reminders = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:store];
        [yo_reminders setTitle:@"yo"];

        /* get and set the source for it--we want iCloud... */
        for (EKSource *s in [store sources]) {
            if (([s sourceType] == EKSourceTypeCalDAV) && ([[s title] isEqualToString:@"iCloud"])) {
                event_source = s;
                break;
            }
        }
        if (event_source == nil) {
            NSLog(@"Unable to set iCloud as source for reminders list 'yo'");
            return nil;
        }
        [yo_reminders setSource:event_source];
        save_result = [store saveCalendar:yo_reminders commit:YES error:&save_err];
        if (save_result == YES) {
            return yo_reminders;
        }
    }
    
    return nil;
}

- (int) createReminderWithMessageText:(NSString *)msg
{
    NSError *save_err;
    BOOL rc;
//    NSLog(@"%d Creating a reminder with message '%@', on date %@", getpid(), msg, myTimeSpec.notificationDate);
    EKReminder *rem = [EKReminder reminderWithEventStore:event_store];
    
    if (myTimeSpec != nil) {
        EKAlarm *reminder_alarm = [EKAlarm alarmWithAbsoluteDate:myTimeSpec.notificationDate];
        [rem addAlarm:reminder_alarm];
        [rem setStartDateComponents:myTimeSpec.notificationDateComponents];
        [rem setDueDateComponents:myTimeSpec.notificationDateComponents];
    }
    
    rem.title = msg;
    rem.calendar = reminder_cal;
    rem.startDateComponents = myTimeSpec.notificationDateComponents;
    rem.dueDateComponents = myTimeSpec.notificationDateComponents;
    
    if (![reminder_cal allowsContentModifications]) {
        NSLog(@"%d Houston, we may have a problem...", getpid());
    }
    
//    NSLog(@"%d %@", getpid(), [rem description]);
    rc = [event_store saveReminder:rem commit:YES error:&save_err];
    
    if (rc) {
        NSLog(@"Reminder '%@' (%@) saved...", rem.title,[myTimeSpec.notificationDate description]);
        return SUCCESS;
    }
    else {
        NSLog(@"%d Failed to save reminder to event store.", getpid());
        NSLog(@"%d Reminder with title: %@, start date components: %@", getpid(), rem.title, [rem.startDateComponents description]);
        NSLog(@"%d Tried saving in reminders list '%@'", getpid(), reminder_cal.title);
        NSLog(@"%d %@", getpid(), [save_err localizedDescription]);
        return FAILURE;
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *timeString;
    NSString *msgString;
    NSArray *args = [[NSProcessInfo processInfo] arguments];
    if ([args count] == 3) {
        timeString = [args objectAtIndex:1];
        msgString = [args objectAtIndex:2];
    }
    else {
        msgString = [args objectAtIndex:1];
        timeString = nil;
    }
    
    if (timeString) {
        myTimeSpec = [[ATETimeSpec alloc] initWithString:timeString];
        NSLog(@"%d Current Date:      %@", getpid(), [NSDate date]);
        NSLog(@"%d Reminder On Date:  %@", getpid(), [myTimeSpec notificationDate]);
    }
    else {
        myTimeSpec = nil;
    }
    
    event_store = [[EKEventStore alloc] init];
    [event_store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        int rc;
        
        if (!granted) {
            NSLog(@"%d No access to reminders...", getpid());
            if (error != Nil) {
                NSLog(@"%d %@", getpid(), [error localizedDescription]);
            }
        }
        else {
            NSLog(@"%d Access to reminders granted...", getpid());
            reminder_cal = [self getRemindersCalendarFromEventStore:event_store];
            if (reminder_cal == nil) {
                NSLog(@"%d No event calendar named 'yo'", getpid());
                [NSApp terminate:self];
            }
            
            rc = [self createReminderWithMessageText:msgString];
            assert(rc == 0);
        } /* END else... */
        
        [NSApp terminate:self];
    }]; /* END requestAccess completion block */
}

@end
