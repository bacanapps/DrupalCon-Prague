// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Speaker.m instead.

#import "_Speaker.h"

const struct SpeakerAttributes SpeakerAttributes = {
	.avatar = @"avatar",
	.company = @"company",
	.firstName = @"firstName",
	.lastName = @"lastName",
	.serverId = @"serverId",
	.twitter = @"twitter",
	.username = @"username",
};

const struct SpeakerRelationships SpeakerRelationships = {
	.session = @"session",
};

const struct SpeakerFetchedProperties SpeakerFetchedProperties = {
};

@implementation SpeakerID
@end

@implementation _Speaker

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Speaker" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Speaker";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Speaker" inManagedObjectContext:moc_];
}

- (SpeakerID*)objectID {
	return (SpeakerID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"serverIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"serverId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic avatar;






@dynamic company;






@dynamic firstName;






@dynamic lastName;






@dynamic serverId;



- (int16_t)serverIdValue {
	NSNumber *result = [self serverId];
	return [result shortValue];
}

- (void)setServerIdValue:(int16_t)value_ {
	[self setServerId:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveServerIdValue {
	NSNumber *result = [self primitiveServerId];
	return [result shortValue];
}

- (void)setPrimitiveServerIdValue:(int16_t)value_ {
	[self setPrimitiveServerId:[NSNumber numberWithShort:value_]];
}





@dynamic twitter;






@dynamic username;






@dynamic session;

	
- (NSMutableSet*)sessionSet {
	[self willAccessValueForKey:@"session"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"session"];
  
	[self didAccessValueForKey:@"session"];
	return result;
}
	






@end
