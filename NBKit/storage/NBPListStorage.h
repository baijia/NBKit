//
//  NBPListStorage.h
//  BJEducation
//
//  Created by MingLQ on 2015-12-09.
//  Copyright © 2015年 com.bjhl. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  store object base on YYModel to plist file in Documents
 */
@interface NBPListStorage : NSObject

+ (instancetype)defaultStorage;
+ (instancetype)storageWithName:(NSString *)name;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSString *name, *path;

- (id)readObjectForKey:(NSString *)key class:(Class)clazz;
- (BOOL)storeObject:(id)object forKey:(NSString *)key;

- (NSArray *)readArrayOfObjectsForKey:(NSString *)key class:(Class)clazz;
- (BOOL)storeArrayOfObjects:(NSArray<NSObject *> *)array forKey:(NSString *)key;

- (NSDictionary<id, NSObject *> *)readDictionaryOfObjectsForKey:(NSString *)key class:(Class)clazz;
- (BOOL)storeDictionaryOfObjects:(NSDictionary<id, NSObject *> *)dictionary forKey:(NSString *)key;

- (BOOL)removeStorageForKey:(NSString *)key;

@end
