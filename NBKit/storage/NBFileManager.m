//
//  NBFileManager.m
//  BJEducation
//
//  Created by MingLQ on 2015-11-28.
//  Copyright © 2015年 com.bjhl. All rights reserved.
//

#import "NBFileManager.h"

@implementation NBFileManager

#pragma mark - singleton

static NBFileManager *SharedFileManager = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (SharedFileManager) {
        return nil;
    }
    @synchronized(self) {
        if (!SharedFileManager) {
            SharedFileManager = [super allocWithZone:zone];
            return SharedFileManager;
        }
    }
    return nil;
}

+ (instancetype)sharedFileManager {
    return [self new] ?: SharedFileManager;
}

#pragma mark -

- (NSString *)pathForDirectory:(NSSearchPathDirectory)directory {
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES).firstObject;
}

- (NSString *)pathForLibrary {
    return [self pathForDirectory:NSLibraryDirectory];
}

- (NSString *)pathForLibraryWithSubpath:(NSString *)subpath {
    return [[self pathForLibrary] stringByAppendingPathComponent:subpath];
}

- (NSString *)pathForDocument {
    return [self pathForDirectory:NSDocumentDirectory];
}

- (NSString *)pathForDocumentWithSubpath:(NSString *)subpath {
    return [[self pathForDocument] stringByAppendingPathComponent:subpath];
}

- (NSString *)pathForCaches {
    return [self pathForDirectory:NSCachesDirectory];
}

- (NSString *)pathForCachesWithSubpath:(NSString *)subpath {
    return [[self pathForCaches] stringByAppendingPathComponent:subpath];
}

- (NSString *)pathForTemporary {
    return NSTemporaryDirectory();
}

- (NSString *)pathForTemporaryWithSubpath:(NSString *)subpath {
    return [[self pathForTemporary] stringByAppendingPathComponent:subpath];
}

- (BOOL)createDirectoryAtPath:(NSString *)path {
    return [self createDirectoryAtPath:path error:nil];
}

- (BOOL)createDirectoryAtPath:(NSString *)path error:(NSError **)error {
    return [self createDirectoryAtPath:path forceCreate:YES error:error];
}

- (BOOL)createDirectoryAtPath:(NSString *)path forceCreate:(BOOL)forceCreate error:(NSError **)error {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
        return YES;
    }
    else {
        if (forceCreate) {
            [fileManager removeItemAtPath:path error:nil];
        }
        return [fileManager createDirectoryAtPath:path
                      withIntermediateDirectories:YES
                                       attributes:nil
                                            error:error];
    }
}

- (BOOL)removeItemsInPath:(NSString *)path {
    return [self removeItemsInPath:path error:nil];
}

- (BOOL)removeItemsInPath:(NSString *)path error:(NSError **)error {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        return YES;
    }
    if (!isDirectory) {
        return NO;
    }
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for (NSString *content in contents) {
        NSString *subpath = [path stringByAppendingPathComponent:content];
        BOOL removed = [fileManager removeItemAtPath:subpath error:error];
        if (!removed) {
            return NO;
        }
    }
    return YES;
}

- (NSUInteger)sizeInByteAtPath:(NSString *)path {
    NSUInteger bytes = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for (NSString *content in contents) {
        NSString *subpath = [path stringByAppendingPathComponent:content];
        BOOL isDirectory = NO;
        BOOL fileExists = [fileManager fileExistsAtPath:subpath isDirectory:&isDirectory];
        if (isDirectory) {
            bytes += [self sizeInByteAtPath:subpath];
        }
        else if (fileExists) {
            NSDictionary *attributes = [fileManager attributesOfItemAtPath:subpath error:nil];
            bytes += [attributes fileSize];
        }
    }
    return bytes;
}

- (double)sizeInKiloByteAtPath:(NSString *)path {
    return (double)[self sizeInByteAtPath:path] / 1024;
}

- (double)sizeInMegaByteAtPath:(NSString *)path {
    return (double)[self sizeInKiloByteAtPath:path] / 1024;
}

- (double)sizeInGigaByteAtPath:(NSString *)path {
    return (double)[self sizeInMegaByteAtPath:path] / 1024;
}

@end
