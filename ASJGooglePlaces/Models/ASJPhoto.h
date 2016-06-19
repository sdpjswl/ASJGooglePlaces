//
// ASJPhoto.h
//
// Copyright (c) 2015 Sudeep Jaiswal
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/NSArray.h>
#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSObject.h>

@interface ASJPhoto : NSObject

/**
 *  The photo's width.
 */
@property (assign, nonatomic) NSUInteger width;

/**
 *  The photo's height.
 */
@property (assign, nonatomic) NSUInteger height;

/**
 *  The unique reference ID assigned to each photo by Google. This is needed to make the API call to download a photo.
 */
@property (copy, nonatomic) NSString *photoReference;

/**
 *  A helper method that creates an array of 'ASJPhoto' model objects from a JSON response.
 *
 *  @param response JSON fetched from Google API.
 *
 *  @return An array of 'ASJPhoto' instances.
 */
+ (NSArray<ASJPhoto *> *)photosForResponse:(NSDictionary *)response;

@end
