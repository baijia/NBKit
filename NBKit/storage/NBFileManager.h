//
//  NBFileManager.h
//  NBKit
//
//  Created by MingLQ on 2015-11-28.
//  Copyright © 2016年 iOSNewbies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBFileManager : NSObject

+ (instancetype)sharedFileManager;

- (NSString *)pathForDirectory:(NSSearchPathDirectory)directory;

- (NSString *)pathForLibrary;
- (NSString *)pathForLibraryWithSubpath:(NSString *)subpath;

- (NSString *)pathForDocument;
- (NSString *)pathForDocumentWithSubpath:(NSString *)subpath;

- (NSString *)pathForCaches;
- (NSString *)pathForCachesWithSubpath:(NSString *)subpath;

- (NSString *)pathForTemporary;
- (NSString *)pathForTemporaryWithSubpath:(NSString *)subpath;

- (BOOL)createDirectoryAtPath:(NSString *)path;
- (BOOL)createDirectoryAtPath:(NSString *)path error:(NSError **)error; // forceCreate: YES
- (BOOL)createDirectoryAtPath:(NSString *)path forceCreate:(BOOL)forceCreate error:(NSError **)error;

- (BOOL)removeItemsInPath:(NSString *)path;
- (BOOL)removeItemsInPath:(NSString *)path error:(NSError **)error;

// Kilobyte, Megabyte, Gigabyte, Terabyte and Petabyte
- (NSUInteger)sizeInByteAtPath:(NSString *)path;
- (double)sizeInKiloByteAtPath:(NSString *)path;
- (double)sizeInMegaByteAtPath:(NSString *)path;
- (double)sizeInGigaByteAtPath:(NSString *)path;

@end
