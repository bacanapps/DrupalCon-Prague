// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Speaker.h instead.

#import <CoreData/CoreData.h>


extern const struct SpeakerAttributes {
	__unsafe_unretained NSString *avatar;
	__unsafe_unretained NSString *company;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *serverId;
	__unsafe_unretained NSString *twitter;
	__unsafe_unretained NSString *username;
} SpeakerAttributes;

extern const struct SpeakerRelationships {
	__unsafe_unretained NSString *session;
} SpeakerRelationships;

extern const struct SpeakerFetchedProperties {
} SpeakerFetchedProperties;

@class Session;









@interface SpeakerID : NSManagedObjectID {}
@end

@interface _Speaker : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SpeakerID*)objectID;





@property (nonatomic, strong) NSString* avatar;



//- (BOOL)validateAvatar:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* company;



//- (BOOL)validateCompany:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstName;



//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lastName;



//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* serverId;



@property int16_t serverIdValue;
- (int16_t)serverIdValue;
- (void)setServerIdValue:(int16_t)value_;

//- (BOOL)validateServerId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* twitter;



//- (BOOL)validateTwitter:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* username;



//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *session;

- (NSMutableSet*)sessionSet;





@end

@interface _Speaker (CoreDataGeneratedAccessors)

- (void)addSession:(NSSet*)value_;
- (void)removeSession:(NSSet*)value_;
- (void)addSessionObject:(Session*)value_;
- (void)removeSessionObject:(Session*)value_;

@end

@interface _Speaker (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAvatar;
- (void)setPrimitiveAvatar:(NSString*)value;




- (NSString*)primitiveCompany;
- (void)setPrimitiveCompany:(NSString*)value;




- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;




- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;




- (NSNumber*)primitiveServerId;
- (void)setPrimitiveServerId:(NSNumber*)value;

- (int16_t)primitiveServerIdValue;
- (void)setPrimitiveServerIdValue:(int16_t)value_;




- (NSString*)primitiveTwitter;
- (void)setPrimitiveTwitter:(NSString*)value;




- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;





- (NSMutableSet*)primitiveSession;
- (void)setPrimitiveSession:(NSMutableSet*)value;


@end
