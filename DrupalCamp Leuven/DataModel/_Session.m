// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Session.m instead.

#import "_Session.h"

const struct SessionAttributes SessionAttributes = {
	.body = @"body",
	.from = @"from",
	.level = @"level",
	.serverId = @"serverId",
	.special = @"special",
	.title = @"title",
	.to = @"to",
	.track = @"track",
};

const struct SessionRelationships SessionRelationships = {
	.speaker = @"speaker",
};

const struct SessionFetchedProperties SessionFetchedProperties = {
};

@implementation SessionID
@end

@implementation _Session

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Session";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Session" inManagedObjectContext:moc_];
}

- (SessionID*)objectID {
	return (SessionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"fromValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"from"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"levelValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"level"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"serverIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"serverId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"specialValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"special"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"toValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"to"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic body;






@dynamic from;



- (int16_t)fromValue {
	NSNumber *result = [self from];
	return [result shortValue];
}

- (void)setFromValue:(int16_t)value_ {
	[self setFrom:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveFromValue {
	NSNumber *result = [self primitiveFrom];
	return [result shortValue];
}

- (void)setPrimitiveFromValue:(int16_t)value_ {
	[self setPrimitiveFrom:[NSNumber numberWithShort:value_]];
}





@dynamic level;



- (int16_t)levelValue {
	NSNumber *result = [self level];
	return [result shortValue];
}

- (void)setLevelValue:(int16_t)value_ {
	[self setLevel:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveLevelValue {
	NSNumber *result = [self primitiveLevel];
	return [result shortValue];
}

- (void)setPrimitiveLevelValue:(int16_t)value_ {
	[self setPrimitiveLevel:[NSNumber numberWithShort:value_]];
}





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





@dynamic special;



- (BOOL)specialValue {
	NSNumber *result = [self special];
	return [result boolValue];
}

- (void)setSpecialValue:(BOOL)value_ {
	[self setSpecial:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSpecialValue {
	NSNumber *result = [self primitiveSpecial];
	return [result boolValue];
}

- (void)setPrimitiveSpecialValue:(BOOL)value_ {
	[self setPrimitiveSpecial:[NSNumber numberWithBool:value_]];
}





@dynamic title;






@dynamic to;



- (int16_t)toValue {
	NSNumber *result = [self to];
	return [result shortValue];
}

- (void)setToValue:(int16_t)value_ {
	[self setTo:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveToValue {
	NSNumber *result = [self primitiveTo];
	return [result shortValue];
}

- (void)setPrimitiveToValue:(int16_t)value_ {
	[self setPrimitiveTo:[NSNumber numberWithShort:value_]];
}





@dynamic track;






@dynamic speaker;

	
- (NSMutableSet*)speakerSet {
	[self willAccessValueForKey:@"speaker"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"speaker"];
  
	[self didAccessValueForKey:@"speaker"];
	return result;
}
	






@end
