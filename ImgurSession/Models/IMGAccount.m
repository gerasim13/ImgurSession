//
//  IMGAccount.m
//  ImgurSession
//
//  Created by Johann Pardanaud on 10/07/13.
//  Distributed under the MIT license.
//

#import "IMGAccount.h"
#import "IMGImage.h"
#import "IMGGalleryImage.h"
#import "IMGGalleryAlbum.h"
#import "IMGComment.h"
#import "IMGGalleryProfile.h"

@interface IMGAccount ()
@property (readwrite) NSString *username;
@property (readwrite) NSString *bio;
@property (readwrite) NSInteger accountID;
@property (readwrite) NSURL *url;
@property (readwrite) float reputation;
@property (readwrite) NSDate *created;
@end

@implementation IMGAccount;

#pragma mark - Init With Json

- (instancetype)initWithJSONObject:(NSDictionary *)jsonData error:(NSError * __autoreleasing *)error{
    
    return [self initWithJSONObject:jsonData withName:@"me" error:error];;
}

- (instancetype)initWithJSONObject:(NSDictionary *)jsonData withName:(NSString *)username error:(NSError * __autoreleasing *)error{
    
    if(self = [super init]) {
        
        if(![jsonData isKindOfClass:[NSDictionary class]]){
            
            *error = [NSError errorWithDomain:IMGErrorDomain code:IMGErrorMalformedResponseFormat userInfo:@{@"ImgurClass":[self class]}];
            return nil;
        } else if (!jsonData[@"id"] || !jsonData[@"url"] || !jsonData[@"bio"]){
            
            *error = [NSError errorWithDomain:IMGErrorDomain code:IMGErrorResponseMissingParameters userInfo:nil];
            return nil;
        }
        
        _username = username;
        _accountID = [jsonData[@"id"] integerValue];
        _url = [NSURL URLWithString:jsonData[@"url"]];
        _bio = jsonData[@"bio"];
        _reputation = [jsonData[@"reputation"] floatValue];
        _created = [NSDate dateWithTimeIntervalSince1970:[jsonData[@"created"] integerValue]];
    }
    return [self trackModels];
}


#pragma mark - Describe

- (NSString *)description{
    return [NSString stringWithFormat: @"%@; accountID: %lu; url: \"%@\"; bio: \"%@\"; reputation: %.2f; created: %@", [super description], (unsigned long)self.accountID, self.url, self.bio, self.reputation, self.created];
}

-(BOOL)isEqual:(id)object{
    
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[IMGAccount class]]) {
        return NO;
    }
    
    return ([object accountID] == self.accountID);
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    
    NSInteger accountID = [[decoder decodeObjectForKey:@"accountID"] integerValue];
    NSString * username = [decoder decodeObjectForKey:@"username"];
    NSURL * url = [decoder decodeObjectForKey:@"url"];
    NSString * bio = [decoder decodeObjectForKey:@"bio"];
    float reputation = [[decoder decodeObjectForKey:@"reputation"] floatValue];
    NSDate *created = [decoder decodeObjectForKey:@"created"];
    
    if (self = [super initWithCoder:decoder]) {
        _accountID = accountID;
        _bio = bio;
        _username = username;
        _reputation = reputation;
        _url = url;
        _created = created;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [super encodeWithCoder:coder];
    
    [coder encodeObject:@(self.accountID) forKey:@"accountID"];
    [coder encodeObject:self.username forKey:@"username"];
    [coder encodeObject:self.url  forKey:@"url"];
    [coder encodeObject:self.bio forKey:@"bio"];
    [coder encodeObject:@(self.reputation) forKey:@"reputation"];
    [coder encodeObject:self.created forKey:@"created"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    IMGAccount * copy = [[[self class] allocWithZone:zone] init];
    
    if (copy) {
        // Copy NSObject subclasses
        [copy setUsername:[self.username copyWithZone:zone]];
        [copy setBio:[self.bio copyWithZone:zone]];
        [copy setUrl:[self.url copyWithZone:zone]];
        [copy setCreated:[self.created copyWithZone:zone]];
        
        // Set primitives
        [copy setAccountID:self.accountID];
        [copy setReputation:self.reputation];
    }
    
    return copy;
}

@end
