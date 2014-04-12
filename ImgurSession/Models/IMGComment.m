//
//  IMGComment.m
//  ImgurSession
//
//  Created by Geoff MacDonald on 2014-03-12.
//  Copyright (c) 2014 GeoffMacDonald. All rights reserved.
//

#import "IMGComment.h"

@interface IMGComment ()

@property (readwrite,nonatomic) NSInteger commentID;
@property (readwrite,nonatomic) NSString *galleryID;
@property (readwrite,nonatomic) NSString *caption;
@property (readwrite,nonatomic) NSString *author;
@property (readwrite,nonatomic) NSInteger authorID;
@property (readwrite,nonatomic) BOOL onAlbum;
@property (readwrite,nonatomic) NSString *albumCover;
@property (readwrite,nonatomic) NSInteger ups;
@property (readwrite,nonatomic) NSInteger downs;
@property (readwrite,nonatomic) NSInteger points;
@property (readwrite,nonatomic) NSDate * datetime;
@property (readwrite,nonatomic) NSInteger parentID;
@property (readwrite,nonatomic) BOOL deleted;
@property (readwrite,nonatomic) NSArray * children;

@end

@implementation IMGComment

#pragma mark - Init With Json

- (instancetype)initWithJSONObject:(NSDictionary *)jsonData error:(NSError *__autoreleasing *)error{
    
    if(self = [super init]) {
        
        if(![jsonData isKindOfClass:[NSDictionary class]]){
            
            *error = [NSError errorWithDomain:IMGErrorDomain code:IMGErrorMalformedResponseFormat userInfo:@{@"ImgurClass":[self class]}];
            return nil;
        } else if (!jsonData[@"id"] || !jsonData[@"image_id"] || !jsonData[@"comment"]){
            
            *error = [NSError errorWithDomain:IMGErrorDomain code:IMGErrorResponseMissingParameters userInfo:nil];
            return nil;
        }
        
        _commentID = [jsonData[@"id"] integerValue];
        _galleryID = jsonData[@"image_id"];
        _caption = jsonData[@"comment"];
        _author = jsonData[@"author"];
        _authorID = [jsonData[@"author_id"] integerValue];
        _onAlbum = [jsonData[@"on_album"] boolValue];
        _albumCover = jsonData[@"album_cover"];
        _ups = [jsonData[@"ups"] integerValue];
        _downs = [jsonData[@"downs"] integerValue];
        _points = [jsonData[@"points"] integerValue];
        _datetime = [NSDate dateWithTimeIntervalSince1970:[jsonData[@"datetime"] integerValue]];
        _parentID = [jsonData[@"parent_id"] integerValue];
        _deleted = [jsonData[@"deleted"] boolValue];
        
        _children = jsonData[@"children"];
    }
    return [self trackModels];
}

#pragma mark - Describe

- (NSString *)description{
    return [NSString stringWithFormat:@"%@; caption: \"%@\"; author: \"%@\"; authorId: %ld; imageId: %@;",  [super description], self.caption, self.author, (long)self.authorID, self.galleryID];
}

-(BOOL)isEqual:(id)object{
    
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[IMGComment class]]) {
        return NO;
    }
    
    return ([object commentID] == self.commentID);
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    
    NSInteger commentID = [[decoder decodeObjectForKey:@"commentID"] integerValue];
    NSInteger authorID = [[decoder decodeObjectForKey:@"authorID"] integerValue];
    NSInteger ups = [[decoder decodeObjectForKey:@"ups"] integerValue];
    NSInteger downs = [[decoder decodeObjectForKey:@"downs"] integerValue];
    NSInteger points = [[decoder decodeObjectForKey:@"points"] integerValue];
    NSInteger parentID = [[decoder decodeObjectForKey:@"parentID"] integerValue];
    BOOL onAlbum = [[decoder decodeObjectForKey:@"onAlbum"] boolValue];
    BOOL deleted = [[decoder decodeObjectForKey:@"deleted"] boolValue];
    
    NSString * galleryID = [decoder decodeObjectForKey:@"galleryID"];
    NSString * caption = [decoder decodeObjectForKey:@"caption"];
    NSString * author = [decoder decodeObjectForKey:@"author"];
    NSString * albumCover = [decoder decodeObjectForKey:@"albumCover"];
    
    NSDate * datetime = [decoder decodeObjectForKey:@"datetime"];
    NSArray * children = [decoder decodeObjectForKey:@"children"];
    
    if (self = [super initWithCoder:decoder]) {
        _commentID = commentID;
        _authorID = authorID;
        _ups = ups;
        _downs = downs;
        _points = points;
        _parentID = parentID;
        _onAlbum = onAlbum;
        _deleted = deleted;
        
        _galleryID = galleryID;
        _caption = caption;
        _author = author;
        _albumCover = albumCover;
        
        _datetime = datetime;
        _children = children;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.galleryID forKey:@"galleryID"];
    [coder encodeObject:self.caption forKey:@"caption"];
    [coder encodeObject:self.author forKey:@"author"];
    [coder encodeObject:self.albumCover forKey:@"albumCover"];
    
    [coder encodeObject:self.datetime forKey:@"datetime"];
    [coder encodeObject:self.children forKey:@"children"];
    
    [coder encodeObject:@(self.commentID) forKey:@"commentID"];
    [coder encodeObject:@(self.authorID) forKey:@"authorID"];
    [coder encodeObject:@(self.ups) forKey:@"ups"];
    [coder encodeObject:@(self.downs) forKey:@"downs"];
    [coder encodeObject:@(self.points) forKey:@"points"];
    [coder encodeObject:@(self.parentID) forKey:@"parentID"];
    [coder encodeObject:@(self.onAlbum) forKey:@"onAlbum"];
    [coder encodeObject:@(self.deleted) forKey:@"deleted"];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    
    IMGComment * copy = [[[self class] allocWithZone:zone] init];
    
    if (copy) {
        // Copy NSObject subclasses
        [copy setGalleryID:[self.galleryID copyWithZone:zone]];
        [copy setCaption:[self.caption copyWithZone:zone]];
        [copy setAuthor:[self.author copyWithZone:zone]];
        [copy setAlbumCover:[self.albumCover copyWithZone:zone]];
        [copy setDatetime:[self.datetime copyWithZone:zone]];
        [copy setChildren:[self.children copyWithZone:zone]];
        
        // Set primitives
        [copy setCommentID:self.commentID];
        [copy setAuthorID:self.authorID];
        [copy setUps:self.ups];
        [copy setDowns:self.downs];
        [copy setPoints:self.points];
        [copy setParentID:self.parentID];
        [copy setOnAlbum:self.onAlbum];
        [copy setDeleted:self.deleted];
    }
    
    return copy;
}
@end
