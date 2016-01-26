//
//  NBPListStorage.m
//  BJEducation
//
//  Created by MingLQ on 2015-12-09.
//  Copyright © 2015年 com.bjhl. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <YYModel/YYModel.h>
#import <M9Dev/M9Dev.h>

#import "NBPListStorage.h"

#import "NBFileManager.h"

@interface NBPListStorage ()

@property (nonatomic, readwrite) NSString *name, *path;

@end

@implementation NBPListStorage

+ (instancetype)defaultStorage {
    return [self storageWithName:@"NBPListStorage-Default"];
}

+ (instancetype)storageWithName:(NSString *)name {
    return [[self alloc] initWithName:name];
}

- (instancetype)init {
    return nil;
}

- (instancetype)initWithName:(NSString *)name {
    NSParameterAssert(name);
    self = [super init];
    if (self) {
        self.name = name;
        self.path = [self pathWithName:name];
    }
    return self;
}

- (BOOL)rename:(NSString *)name {
    NSParameterAssert(name);
    if (self == [NBPListStorage defaultStorage]) {
        return NO;
    }
    if ([name isEqualToString:self.name]) {
        return YES;
    }
    NSString *oldPath = self.path;
    NSString *newPath = [self pathWithName:name];
    @synchronized(self) {
        if ([[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:nil]) {
            self.name = name;
            self.path = newPath;
            return YES;
        }
    }
    return NO;
}

- (NSString *)rootPath {
    return [[NBFileManager sharedFileManager] pathForDocumentWithSubpath:@"NBPListStorage"];
}

- (NSString *)pathWithName:(NSString *)name {
    return [[self rootPath] stringByAppendingPathComponent:[self md5StringFromString:name]];
}

- (NSString *)filePathWithKey:(NSString *)key {
    NSString *name = [[self md5StringFromString:key] stringByAppendingPathExtension:@"plist"];
    NSString *file = [self.path stringByAppendingPathComponent:name];
    return file;
}

- (id)readObjectForKey:(NSString *)key class:(Class)clazz {
    NSString *file = [self filePathWithKey:key];
    @synchronized(self) {
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:file];
        return [clazz yy_modelWithDictionary:dictionary];
    }
}

- (BOOL)storeObject:(id)object forKey:(NSString *)key {
    NSString *file = [self filePathWithKey:key];
    @synchronized(self) {
        NSDictionary *dictionary = [[object yy_modelToJSONObject] asDictionary];
        if (dictionary) {
            [[NBFileManager sharedFileManager] createDirectoryAtPath:self.path];
            return [dictionary writeToFile:file atomically:YES];
        }
        else {
            return [self removeStorageForKey:key];
        }
    }
}

- (NSArray *)readArrayOfObjectsForKey:(NSString *)key class:(Class)clazz {
    NSString *file = [self filePathWithKey:key];
    @synchronized(self) {
        NSArray *array = [NSArray arrayWithContentsOfFile:file];
        return [NSArray yy_modelArrayWithClass:clazz json:array];
    }
}

- (BOOL)storeArrayOfObjects:(NSArray *)array forKey:(NSString *)key {
    NSString *file = [self filePathWithKey:key];
    @synchronized(self) {
        array = [[array yy_modelToJSONObject] asArray];
        if (array) {
            [[NBFileManager sharedFileManager] createDirectoryAtPath:self.path];
            return [array writeToFile:file atomically:YES];
        }
        else {
            return [self removeStorageForKey:key];
        }
    }
}

- (NSDictionary<id, NSObject *> *)readDictionaryOfObjectsForKey:(NSString *)key class:(Class)clazz {
    NSString *file = [self filePathWithKey:key];
    @synchronized(self) {
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:file];
        return [NSDictionary yy_modelDictionaryWithClass:clazz json:dictionary];
    }
}

- (BOOL)storeDictionaryOfObjects:(NSDictionary<id, NSObject *> *)dictionary forKey:(NSString *)key {
    NSString *file = [self filePathWithKey:key];
    @synchronized(self) {
        dictionary = [[dictionary yy_modelToJSONObject] asDictionary];
        if (dictionary) {
            [[NBFileManager sharedFileManager] createDirectoryAtPath:self.path];
            return [dictionary writeToFile:file atomically:YES];
        }
        else {
            return [self removeStorageForKey:key];
        }
    }
}

- (BOOL)removeStorageForKey:(NSString *)key {
    NSString *file = [self filePathWithKey:key];
    @synchronized(self) {
        return [[NBFileManager sharedFileManager] removeItemsInPath:file];
    }
}

#pragma mark -

- (NSString *)md5StringFromString:(NSString *)string {
    const char *chars = [string UTF8String];
    if (chars == NULL) {
        chars = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(chars, (CC_LONG)strlen(chars), r);
    NSString *md5String = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return md5String;
}

@end
