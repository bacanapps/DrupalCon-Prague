#import "_Speaker.h"

@interface Speaker : _Speaker {}
// Custom logic goes here.

+ (Speaker *)speakerWithServerId:(NSInteger)serverId usingManagedObjectContext:(NSManagedObjectContext *)moc;

- (void)updateAttributes:(NSDictionary *)attributes;

@end
