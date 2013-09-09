//
//  FLDynamicObject.h
//  FLTools
//
//  Created by Mike Fullerton on 5/22/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import <Foundation/Foundation.h>
#import "FishLampCore.h"

// this protocol just gets around the compiler warning when using
// the dynamic object as a dictionary.
@protocol FLDynamicObject 
@optional
- (NSUInteger)count;
- (id)objectForKey:(id)aKey;
- (NSEnumerator *)keyEnumerator;

- (NSArray *)allKeys;
- (NSArray *)allKeysForObject:(id)anObject;    
- (NSArray *)allValues;
- (NSString *)description;
- (NSString *)descriptionInStringsFileFormat;
- (NSString *)descriptionWithLocale:(id)locale;
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level;
- (BOOL)isEqualToDictionary:(NSDictionary *)otherDictionary;
- (NSEnumerator *)objectEnumerator;
- (NSArray *)objectsForKeys:(NSArray *)keys notFoundMarker:(id)marker;
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;
- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically; // the atomically flag is ignored if url of a type that cannot be written atomically.

- (NSArray *)keysSortedByValueUsingSelector:(SEL)comparator;
- (void)getObjects:(id __unsafe_unretained [])objects andKeys:(id __unsafe_unretained [])keys;

#if NS_BLOCKS_AVAILABLE
- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block NS_AVAILABLE(10_6, 4_0);
- (void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, id obj, BOOL *stop))block NS_AVAILABLE(10_6, 4_0);

- (NSArray *)keysSortedByValueUsingComparator:(NSComparator)cmptr NS_AVAILABLE(10_6, 4_0);
- (NSArray *)keysSortedByValueWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr NS_AVAILABLE(10_6, 4_0);

- (NSSet *)keysOfEntriesPassingTest:(BOOL (^)(id key, id obj, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0);
- (NSSet *)keysOfEntriesWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id key, id obj, BOOL *stop))predicate NS_AVAILABLE(10_6, 4_0);
#endif

- (void)removeObjectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id)aKey;

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;
- (void)removeAllObjects;
- (void)removeObjectsForKeys:(NSArray *)keyArray;
- (void)setDictionary:(NSDictionary *)otherDictionary;

@end

@interface FLDynamicObject : NSProxy<FLDynamicObject> /*<NSCopying, NSMutableCopying, NSCoding, NSFastEnumeration>*/ {
@private
    NSMutableDictionary* _dataDictionary;
}

@property (readwrite, strong, nonatomic) NSMutableDictionary* dataDictionary;

- (id) init;
- (id) initWithDictionary:(NSMutableDictionary*) dictionary;

+ (id) dynamicObject:(NSMutableDictionary*) dictionary;
+ (id) dynamicObject;

@end

#define FLSynthesizeDynamicObjectProperty(getter, setter, type) \
    - (type) getter { return [self.dataDictionary objectForKey:@#getter]; } \
    - (void) setter:(type) value { [self.dataDictionary setObject:value forKey:@#getter]; }

