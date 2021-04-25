
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: - Completion Handler
typedef void (^JSONCompletionHandler) (id _Nullable object, NSError * _Nullable error);
// MARK: - Handlers
typedef void (^DataCompletionHandler) (NSData * _Nullable data, NSError * _Nullable error);

// MARK: - Error
extern NSErrorDomain const CountersErrorDomain;

typedef NS_ENUM(NSInteger, CountersErrorCode) {
    CountersErrorCodeNoData = -777
};

// MARK: - Networking
@interface Networking : NSObject
- (NSURLSessionTask *)jsonRequestURL:(NSURL *)url
                          HTTPMethod:(NSString *)method
                          parameters:(NSDictionary<NSString*, NSString*>* _Nullable)parameters
                   completionHandler:(JSONCompletionHandler)completion;

- (NSURLSessionTask *)dataRequestURL:(NSURLRequest *)urlRequest
                   completionHandler:(DataCompletionHandler)completion;

- (NSMutableURLRequest *)makeRequestWithURL:(NSURL *)url
                                 httpMethod:(NSString *)method
                                 parameters:(NSDictionary<NSString *, NSString *> * _Nullable)parameters;
@end

NS_ASSUME_NONNULL_END
