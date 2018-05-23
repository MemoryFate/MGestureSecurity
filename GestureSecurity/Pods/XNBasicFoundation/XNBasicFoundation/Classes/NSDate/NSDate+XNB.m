//
//  NSDate+XNB.m
//  Pods-XNBasicFramework_Example
//
//  Created by 江红胡 on 2017/9/25.
//

#import "NSDate+XNB.h"
#import "NSDateFormatter+XNB.h"

#define kXNB_MINUTE     60
#define kXNB_HOUR       3600
#define kXNB_DAY        86400
#define kXNB_WEEK       604800
#define kXNB_YEAR       31556926

static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

@implementation NSDate (XNB)

+ (NSString *)xnb_nowDateLongString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSString *)xnb_nowDateShortString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [formatter stringFromDate:[NSDate date]];
}

+ (BOOL)xnb_isToadyInRange:(NSString *)beginDateInterVal and:(NSString *)endDateInterVal
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *todayDate = [NSDate date];
    NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:[beginDateInterVal longLongValue]/1000];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[endDateInterVal longLongValue]/1000];
    
    if (!beginDate || !endDate) {
        return NO;
    }
    
    if ([[todayDate laterDate:beginDate] isEqualToDate:todayDate] && [[todayDate earlierDate:endDate] isEqualToDate:todayDate]) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)xnb_convertDateIntervalToStringWith:(NSString *)aInterVal
{
    time_t statusCreateAt_t;
    NSString *timestamp = nil;
    time_t now;
    time(&now);
    
    statusCreateAt_t = (time_t)[aInterVal longLongValue];
    
    struct tm *nowtime;
    nowtime = localtime(&now);
    uint32_t thour = nowtime->tm_hour;
    
    localtime(&statusCreateAt_t);
    
    int distance = (int)difftime(now, statusCreateAt_t);
    if (distance < 0) {
        distance = 0;
    }
    
    if (distance < 30) {
        timestamp = @"刚刚";
    } else if (distance < 60) {
        timestamp = @"30秒前";
    } else if (distance < 60 * 60) {/* 小于1小时 */
        distance = distance / 60;
        if (distance == 0) {
            distance = 1;
        }
        timestamp = [NSString stringWithFormat:@"%d分钟前", distance];
    } else if (distance < (60 * 60 * (thour))) {/* 大于1小时，但是在今日 */
        
        timestamp = [NSString stringWithFormat:@"%d小时前", distance / 60 / 60];
    } else {
        NSDate *date_now = [NSDate dateWithTimeIntervalSince1970:now];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:statusCreateAt_t];
        NSInteger dateYear = [date year];
        NSInteger nowYear = [date_now year];
        
        if (dateYear == nowYear) {
            NSDateFormatter *dateFormatter = [NSDateFormatter xnb_dateFormatterWithFormat:@"MM-dd HH:mm"];
            timestamp = [dateFormatter stringFromDate:date];
        } else {
            NSDateFormatter *dateFormatter = [NSDateFormatter xnb_dateFormatterWithFormat:@"yyyy-MM-dd HH:mm"];
            timestamp = [dateFormatter stringFromDate:date];
        }
    }
    
    return timestamp;
}

+ (NSString *)xnb_convertDateIntervalToSimpleStringWith:(NSString *)aInterVal
{
    time_t statusCreateAt_t;
    NSString *timestamp = nil;
    time_t now;
    time(&now);
    
    statusCreateAt_t = (time_t)[aInterVal longLongValue];
    
    struct tm *nowtime;
    nowtime = localtime(&now);
    uint32_t thour = nowtime->tm_hour;
    
    localtime(&statusCreateAt_t);
    
    int distance = (int)difftime(now, statusCreateAt_t);
    if (distance < 0) {
        distance = 0;
    }
    
    if (distance < 60 * 60) {/* 小于1小时 */
        distance = distance / 60;
        if (distance == 0) {
            distance = 1;
        }
        timestamp = [NSString stringWithFormat:@"%d分钟前", distance];
    } else if (distance < (60 * 60 * (thour))) {/* 大于1小时，但是在今日 */
        distance = distance / (60 * 60);
        if (distance == 0) {
            distance = 1;
        }
        timestamp = [NSString stringWithFormat:@"%d小时前", distance];
    } else {
        NSDate *date_now = [NSDate dateWithTimeIntervalSince1970:now];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:statusCreateAt_t];
        NSInteger dateYear = [date year];
        NSInteger nowYear = [date_now year];
        
        if (dateYear == nowYear) {
            NSDateFormatter *dateFormatter = [NSDateFormatter xnb_dateFormatterWithFormat:@"MM-dd"];
            timestamp = [dateFormatter stringFromDate:date];
        } else {
            NSDateFormatter *dateFormatter = [NSDateFormatter xnb_dateFormatterWithFormat:@"yyyy-MM-dd"];
            timestamp = [dateFormatter stringFromDate:date];
        }
    }
    
    return timestamp;
}

+ (NSCalendar *)xnb_currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar) {
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    }
    
    return sharedCalendar;
}

- (NSString *)xnb_stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle
{
    NSDateFormatter *formatter = [NSDateFormatter xnb_dateFormatterWithFormat:@""];
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
//    formatter.locale = [NSLocale currentLocale]; // Necessary?
    return [formatter stringFromDate:self];
}

- (NSString *)shortString
{
    return [self xnb_stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *)shortTimeString
{
    return [self xnb_stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *)shortDateString
{
    return [self xnb_stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString *)mediumString
{
    return [self xnb_stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *)mediumTimeString
{
    return [self xnb_stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *)mediumDateString
{
    return [self xnb_stringWithDateStyle:NSDateFormatterMediumStyle  timeStyle:NSDateFormatterNoStyle];
}

- (NSString *)longString
{
    return [self xnb_stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *)longTimeString
{
    return [self xnb_stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *)longDateString
{
    return [self xnb_stringWithDateStyle:NSDateFormatterLongStyle  timeStyle:NSDateFormatterNoStyle];
}

- (NSInteger)nearestHour
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + kXNB_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [[NSDate xnb_currentCalendar] components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

- (NSInteger)hour
{
    NSDateComponents *components = [[NSDate xnb_currentCalendar] components:componentFlags fromDate:self];
    return components.hour;
}

- (NSInteger)minute
{
    NSDateComponents *components = [[NSDate xnb_currentCalendar] components:componentFlags fromDate:self];
    return components.minute;
}

- (NSInteger)seconds
{
    NSDateComponents *components = [[NSDate xnb_currentCalendar] components:componentFlags fromDate:self];
    return components.second;
}

- (NSInteger)day
{
    NSDateComponents *components = [[NSDate xnb_currentCalendar] components:componentFlags fromDate:self];
    return components.day;
}

- (NSInteger)month
{
    NSDateComponents *components = [[NSDate xnb_currentCalendar] components:componentFlags fromDate:self];
    return components.month;
}

- (NSInteger)weekOfMonth
{
    NSDateComponents *components = [[NSDate xnb_currentCalendar] components:componentFlags fromDate:self];
    return components.weekOfMonth;
}

- (NSInteger)weekOfYear
{
    NSDateComponents *components = [[NSDate xnb_currentCalendar] components:componentFlags fromDate:self];
    return components.weekOfYear;
}

- (NSInteger)weekday
{
    NSDateComponents *components = [[NSDate xnb_currentCalendar] components:componentFlags fromDate:self];
    return components.weekday;
}

- (NSInteger)nthWeekday // e.g. 2nd Tuesday of the month is 2
{
    NSDateComponents *components = [[NSDate xnb_currentCalendar] components:componentFlags fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger)numbersOfDaysInThisMonth
{
    NSRange range = [[NSDate xnb_currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    return range.length;
}

- (NSInteger)year
{
    NSDateComponents *components = [[NSDate xnb_currentCalendar] components:componentFlags fromDate:self];
    return components.year;
}

@end
