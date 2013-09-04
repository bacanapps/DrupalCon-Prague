// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Session.h instead.

#import <CoreData/CoreData.h>


extern const struct SessionAttributes {
	__unsafe_unretained NSString *body;
	__unsafe_unretained NSString *day;
	__unsafe_unretained NSString *fav;
	__unsafe_unretained NSString *from;
	__unsafe_unretained NSString *level;
	__unsafe_unretained NSString *room;
	__unsafe_unretained NSString *serverId;
	__unsafe_unretained NSString *special;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *to;
	__unsafe_unretained NSString *track;
} SessionAttributes;

extern const struct SessionRelationships {
	__unsafe_unretained NSString *speaker;
} SessionRelationships;

extern const struct SessionFetchedProperties {
} SessionFetchedProperties;

@class Speaker;













@interface SessionID : NSManagedObjectID {}
@end

@interface _Session : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SessionID*)objectID;





@property (nonatomic, strong) NSString* body;



//- (BOOL)validateBody:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* day;



//- (BOOL)validateDay:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* fav;



@property BOOL favValue;
- (BOOL)favValue;
- (void)setFavValue:(BOOL)value_;

//- (BOOL)validateFav:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* from;



@property int32_t fromValue;
- (int32_t)fromValue;
- (void)setFromValue:(int32_t)value_;

//- (BOOL)validateFrom:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* level;



@property int16_t levelValue;
- (int16_t)levelValue;
- (void)setLevelValue:(int16_t)value_;

//- (BOOL)validateLevel:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* room;



//- (BOOL)validateRoom:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* serverId;



@property int16_t serverIdValue;
- (int16_t)serverIdValue;
- (void)setServerIdValue:(int16_t)value_;

//- (BOOL)validateServerId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* special;



@property BOOL specialValue;
- (BOOL)specialValue;
- (void)setSpecialValue:(BOOL)value_;

//- (BOOL)validateSpecial:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* to;



@property int32_t toValue;
- (int32_t)toValue;
- (void)setToValue:(int32_t)value_;

//- (BOOL)validateTo:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* track;



//- (BOOL)validateTrack:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Speaker *speaker;

//- (BOOL)validateSpeaker:(id*)value_ error:(NSError**)error_;





@end

@interface _Session (CoreDataGeneratedAccessors)

@end

@interface _Session (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBody;
- (void)setPrimitiveBody:(NSString*)value;




- (NSString*)primitiveDay;
- (void)setPrimitiveDay:(NSString*)value;




- (NSNumber*)primitiveFav;
- (void)setPrimitiveFav:(NSNumber*)value;

- (BOOL)primitiveFavValue;
- (void)setPrimitiveFavValue:(BOOL)value_;




- (NSNumber*)primitiveFrom;
- (void)setPrimitiveFrom:(NSNumber*)value;

- (int32_t)primitiveFromValue;
- (void)setPrimitiveFromValue:(int32_t)value_;




- (NSNumber*)primitiveLevel;
- (void)setPrimitiveLevel:(NSNumber*)value;

- (int16_t)primitiveLevelValue;
- (void)setPrimitiveLevelValue:(int16_t)value_;




- (NSString*)primitiveRoom;
- (void)setPrimitiveRoom:(NSString*)value;




- (NSNumber*)primitiveServerId;
- (void)setPrimitiveServerId:(NSNumber*)value;

- (int16_t)primitiveServerIdValue;
- (void)setPrimitiveServerIdValue:(int16_t)value_;




- (NSNumber*)primitiveSpecial;
- (void)setPrimitiveSpecial:(NSNumber*)value;

- (BOOL)primitiveSpecialValue;
- (void)setPrimitiveSpecialValue:(BOOL)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSNumber*)primitiveTo;
- (void)setPrimitiveTo:(NSNumber*)value;

- (int32_t)primitiveToValue;
- (void)setPrimitiveToValue:(int32_t)value_;




- (NSString*)primitiveTrack;
- (void)setPrimitiveTrack:(NSString*)value;





- (Speaker*)primitiveSpeaker;
- (void)setPrimitiveSpeaker:(Speaker*)value;


@end
