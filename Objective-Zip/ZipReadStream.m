//
//  ZipReadStream.m
//  Objective-Zip v. 0.7.2
//
//  Created by Gianluca Bertani on 28/12/09.
//  Copyright 2009-10 Flying Dolphin Studio. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without 
//  modification, are permitted provided that the following conditions 
//  are met:
//
//  * Redistributions of source code must retain the above copyright notice, 
//    this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright notice, 
//    this list of conditions and the following disclaimer in the documentation 
//    and/or other materials provided with the distribution.
//  * Neither the name of Gianluca Bertani nor the names of its contributors 
//    may be used to endorse or promote products derived from this software 
//    without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
//  POSSIBILITY OF SUCH DAMAGE.
//

#import "ZipReadStream.h"
#import "ZipException.h"

#include "unzip.h"


@implementation ZipReadStream {
    __weak id<NSStreamDelegate> _delegate;
     BOOL _isOpen;
}


- (id) initWithUnzFileStruct:(unzFile)unzFile fileNameInZip:(NSString *)fileNameInZip {
	if (self= [super init]) {
		_unzFile= unzFile;
		_fileNameInZip= fileNameInZip;
        _delegate = self;
        _isOpen = YES;
	}
	
	return self;
}


- (void)setDelegate:(id<NSStreamDelegate>)delegate {
    if (delegate) {
        _delegate = delegate;
    } 
    else
    {
        _delegate = self;
    }
}

- (id<NSStreamDelegate>)delegate {
    return _delegate;
}

- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {
    //no-op. this is a polling stream.
}

- (void)removeFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode {
    //no-op. this is a polling stream.
}

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len {
    int retval= unzReadCurrentFile(_unzFile, buffer, len);
	if (retval < 0) {
#ifdef THROW_ZIP_EXCEPTIONS
		NSString *reason= [NSString stringWithFormat:@"Error in reading '%@' in the zipfile", _fileNameInZip];
		@throw [[ZipException alloc] initWithError:err reason:reason];
#endif
	}
    return retval;
}


- (BOOL)getBuffer:(uint8_t **)buffer length:(NSUInteger *)len {
    //We don't use this method
    return NO;
}

- (void)open {
    //No-op. file already opened.    
}

- (BOOL)hasBytesAvailable {
    return YES;
}

- (void) close {
	int err= unzCloseCurrentFile(_unzFile);
	if (err != UNZ_OK) {
#ifdef THROW_ZIP_EXCEPTIONS
		NSString *reason= [NSString stringWithFormat:@"Error in closing '%@' in the zipfile", _fileNameInZip];
		@throw [[ZipException alloc] initWithError:err reason:reason];
#endif
	}
    _isOpen = NO;
}


- (void)dealloc {
    if (_isOpen) {
        [self close];
    }
}


@end
