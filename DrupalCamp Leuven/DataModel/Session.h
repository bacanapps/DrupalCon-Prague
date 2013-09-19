#import "_Session.h"

#import "Speaker.h"

@interface Session : _Session {

}
// Custom logic goes here.


+ (Session *)eventWithServerId:(NSInteger)serverId usingManagedObjectContext:(NSManagedObjectContext *)moc;

- (void)updateAttributes:(NSDictionary *)attributes withSpeakers:(NSSet *)speakers;

+ (int)countWithManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray *)getSessionsIdsUsingManagedObjectContext:(NSManagedObjectContext *)moc;

- (void)toggleFavorite:(bool)status;

@end
