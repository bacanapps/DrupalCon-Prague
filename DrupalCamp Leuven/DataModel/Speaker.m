#import "Speaker.h"

#import "NSDictionary+ObjectForKeyOrNil.h"

@interface Speaker ()

// Private interface goes here.

@end


@implementation Speaker

// Custom logic goes here.

+ (Speaker *)speakerWithServerId:(NSInteger)serverId usingManagedObjectContext:(NSManagedObjectContext *)moc {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Speaker entityName]];
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

- (void)updateAttributes:(NSDictionary *)attributes {

    self.avatar = [attributes objectForKeyOrNil:@"avatar"];
    self.firstName = [attributes objectForKeyOrNil:@"first_name"];
    self.company = [attributes objectForKeyOrNil:@"organization"];
    self.lastName = [attributes objectForKeyOrNil:@"last_name"];
    self.twitter = [attributes objectForKeyOrNil:@"twitter"];
    self.username = [attributes objectForKeyOrNil:@"username"];
    
}

@end
