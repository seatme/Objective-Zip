//
//  SMZipTests.m
//  DorsiaFoundation
//
//  Created by Zac Bowling on 5/21/12.
//  Copyright (c) 2012 SeatMe, Inc. All rights reserved.
//

#import "SMZipTests.h"
#import "ZipFile.h"

@implementation SMZipTests {
    NSString *_tempFilePath;
    NSString *_tempDirPath;
    NSString *_tempData;
}

- (void)setUp
{
    _tempFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.txt", [NSDate timeIntervalSinceReferenceDate] * 1000.0]];
    
    _tempData = [NSString stringWithFormat: @"I AM A TEMP FILE. I WAS CREATED AT %.0f \n\n", [NSDate timeIntervalSinceReferenceDate] * 1000.0];
    [_tempData writeToFile:_tempFilePath atomically:NO encoding:NSUTF8StringEncoding error:NULL];
    
    
    _tempDirPath = [NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"test_%.0f", [NSDate timeIntervalSinceReferenceDate] * 1000.0]];
    
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:_tempDirPath withIntermediateDirectories:YES attributes:nil error:NULL];
    
    [@"I am test file 1" writeToFile:[_tempDirPath stringByAppendingPathComponent:@"test1.txt"] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    [@"I am test file 2" writeToFile:[_tempDirPath stringByAppendingPathComponent:@"test2.txt"] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    [@"I am test file 3" writeToFile:[_tempDirPath stringByAppendingPathComponent:@"test3.txt"] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    [fileManager createDirectoryAtPath:[_tempDirPath stringByAppendingPathComponent:@"testDir"] withIntermediateDirectories:YES attributes:nil error:NULL];
    
    [@"I am test file in a directory" writeToFile:[[_tempDirPath stringByAppendingPathComponent:@"testDir"] stringByAppendingPathComponent:@"test_in_dir.txt"] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
}


- (void)testCreateSingleFileZip
{
    NSString *zipPath = [NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"single-%.0f.zip", [NSDate timeIntervalSinceReferenceDate] * 1000.0]];
    NSLog(@"creating zip at %@", zipPath);
    ZipFile *zip = [[ZipFile alloc] initWithPath:zipPath mode:ZipFileModeCreate];
    
    STAssertTrue([zip addItemWithName:[_tempFilePath lastPathComponent] atURL:[NSURL fileURLWithPath:_tempFilePath] compressionLevel:ZipCompressionLevelDefault error:NULL],@"add file to zip");
    [zip closeZipFile];
}

- (void)testCreateDirectoryFileZip
{
    NSString *zipPath = [NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"directory-%.0f.zip", [NSDate timeIntervalSinceReferenceDate] * 1000.0]];
    NSLog(@"creating directory zip at %@", zipPath);
    ZipFile *zip = [[ZipFile alloc] initWithPath:zipPath mode:ZipFileModeCreate];
    
    STAssertTrue([zip addItemWithName:[_tempDirPath lastPathComponent] atURL:[NSURL fileURLWithPath:_tempDirPath] compressionLevel:ZipCompressionLevelDefault error:NULL],@"add directory to zip");
    [zip closeZipFile];
}

- (void)tearDown {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:_tempFilePath error:NULL];
}

@end
