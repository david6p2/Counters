
#import "Networking.h"

// MARK: - Error
NSErrorDomain const CountersErrorDomain = @"counters.network.error.domain";

// MARK: - Headers
NSString * const ContentType = @"Content-Type";
NSString * const JSONContentType = @"application/json";

@interface Networking ()
@property (nonatomic, strong) NSURLSession *client;
@end

@implementation Networking

- (instancetype)init
{
    self = [super init];
    if (self) {
        __auto_type *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _client = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

- (NSURLSessionTask *)dataRequestURL:(NSURLRequest *)urlRequest
                   completionHandler:(DataCompletionHandler)completion
{
    return [self.client dataTaskWithRequest:urlRequest
                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completion(data, error);
        } else if (!data) {
            completion(nil, [self error:CountersErrorCodeNoData]);
        } else {
            completion(data, nil);
        }
    }];
}

- (NSMutableURLRequest *)makeRequestWithURL:(NSURL *)url
                                 httpMethod:(NSString *)method
                                 parameters:(NSDictionary<NSString *, NSString *> * _Nullable)parameters
{
    // Set URL
    __auto_type *request = [[NSMutableURLRequest alloc] initWithURL:url];

    // Set HTTP Method
    request.HTTPMethod = method;

    // Set HTTP Body with Parameters if available
    if (parameters != nil) {
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        if (JSONData) {
            request.HTTPBody = JSONData;
        }
    }

    // Set Header
    [request setValue:JSONContentType forHTTPHeaderField:ContentType];

    return request;
}


- (NSError *)error:(CountersErrorCode)code
{
    return [NSError errorWithDomain:CountersErrorDomain
                               code:code
                           userInfo:nil];
}

@end
