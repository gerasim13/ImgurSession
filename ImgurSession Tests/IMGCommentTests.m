//
//  IMGCommentTests.m
//  ImgurSession
//
//  Created by Xtreme Dev on 2014-03-20.
//  Copyright (c) 2014 GeoffMacDonald. All rights reserved.
//

#import "IMGTestCase.h"

@interface IMGCommentTests : IMGTestCase

@end


@implementation IMGCommentTests

/**
 Posts image to comment on, comments on it, replies to comment, then deletes everything
 */
#warning: may fail due to comment rate, which imgur thinks is spam
- (void)testCommentReplyAndDelete{
    
    __block BOOL deleteSuccess = NO;
    
    [self postTestImage:^(IMGImage * image, void(^success)()){
        
        [IMGCommentRequest submitComment:@"test comment" withImageID:image.imageID withParentID:0 success:^(NSUInteger commentId) {
            
            [IMGCommentRequest replyToComment:@"test reply" withImageID:image.imageID withCommentID:commentId success:^(NSUInteger replyId) {
                
                
                [IMGCommentRequest deleteCommentWithID:replyId success:^() {
                    
                    [IMGCommentRequest deleteCommentWithID:commentId  success:^() {
                        
                        deleteSuccess = YES;
                        success();
                        
                    } failure:failBlock];
                    
                } failure:failBlock];
                
            } failure:failBlock];
            
        } failure:failBlock];
    }];
    
    expect(deleteSuccess).will.beTruthy();
}

@end