#import "Session.h"

#import "NSDictionary+ObjectForKeyOrNil.h"

@interface Session ()

// Private interface goes here.

@end


@implementation Session

+ (Session *)eventWithServerId:(NSInteger)serverId usingManagedObjectContext:(NSManagedObjectContext *)moc {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Session entityName]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"serverId = %d", serverId]];
    [fetchRequest setFetchLimit:1];

    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
    if (error) {
        exit(1);
    }

    if ([results count] == 0) {
        return nil;
    }

    return [results objectAtIndex:0];
}

- (void)updateAttributes:(NSDictionary *)attributes withSpeaker:(Speaker *)speaker {
 
    self.title = [attributes objectForKeyOrNil:@"title"];
    self.body = [attributes objectForKeyOrNil:@"description"];
    self.level = [NSNumber numberWithInt:[[attributes objectForKeyOrNil:@"level"] intValue]];
    self.special = [NSNumber numberWithInt:[[attributes objectForKeyOrNil:@"special"] intValue]];
    self.from = [NSNumber numberWithInt:[[attributes objectForKeyOrNil:@"from"] intValue]];
    self.to = [NSNumber numberWithInt:[[attributes objectForKeyOrNil:@"to"] intValue]];
    self.track = [[attributes objectForKeyOrNil:@"track"] componentsJoinedByString:@";"];
    self.day = [attributes objectForKeyOrNil:@"day"];
    self.room = [attributes objectForKeyOrNil:@"room"];

    self.speaker = speaker;

}

+ (int)countWithManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *countRequest = [[NSFetchRequest alloc] init];
    [countRequest setEntity:[self entityInManagedObjectContext:context]];
    int count = [context countForFetchRequest:countRequest error:nil];
    return count;
}

+ (NSArray *)getSessionsIdsUsingManagedObjectContext:(NSManagedObjectContext *)moc {
    
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Session entityName]];
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
    if (error) {
        exit(1);
    }

    if ([results count] == 0) {
        return nil;
    }

    for (Session *session in results) {
        [ids addObject:session.serverId];
    }

    return ids;
}

- (void)toggleFavorite:(bool)status {
    self.fav = [NSNumber numberWithBool:status];
}


@end
