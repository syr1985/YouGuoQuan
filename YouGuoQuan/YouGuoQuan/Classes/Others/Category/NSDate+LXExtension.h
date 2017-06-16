
#import <Foundation/Foundation.h>

@interface LXDateItem : NSObject
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger week;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) NSInteger second;
@end

@interface NSDate (LXExtension)
- (LXDateItem *)lx_timeIntervalSinceDate:(NSDate *)anotherDate;

//- (BOOL)lx_isToday;
//- (BOOL)lx_isYesterday;
//- (BOOL)lx_isTomorrow;
//- (BOOL)lx_isThisYear;
//+ (NSInteger)getNowWeekday;
@end
