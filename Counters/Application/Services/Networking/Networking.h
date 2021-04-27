
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: - Completion Handler
typedef void (^JSONCompletionHandler) (id _Nullable object, NSError * _Nullable error);
// MARK: - Handlers
typedef void (^DataCompletionHandler) (NSData * _Nullable data, NSError * _Nullable error);

// MARK: - Error
extern NSErrorDomain const CountersErrorDomain;

typedef NS_ENUM(NSInteger, CountersErrorCode) {
    CountersErrorCodeNoData = -777,
    CountersErrorCodeInvalidURL = -770,
    CountersErrorCodeServerInvalidStatusCode = -500
};

// MARK: - Networking
@interface Networking : NSObject
- (NSURLSessionTask *)dataRequestURL:(NSURLRequest *)urlRequest
                   completionHandler:(DataCompletionHandler)completion;

- (NSMutableURLRequest *)makeRequestWithURL:(NSURL *)url
                                 httpMethod:(NSString *)method
                                 parameters:(NSDictionary<NSString *, NSString *> * _Nullable)parameters;

- (NSError *)error:(CountersErrorCode)code;
@end

NS_ASSUME_NONNULL_END
