//
//  MQRequester.m
//  Rainville_Module
//
//  Created by 冯明庆 on 2020/6/19.
//

#import "MQRequester.h"

MQRequester * MQ_REQUESTER;

@interface MQRequester () <NSURLSessionTaskDelegate , NSURLSessionDataDelegate>

@property (nonatomic , strong) NSURLRequest *req;
@property (nonatomic , strong) NSURLSession *sess;
@property (nonatomic , retain) dispatch_source_t timer;

- (void) prepare;

- (void) mq_send_data : (NSDictionary *) data
                error : (NSError *) e;

@end

@implementation MQRequester

+ (void)load { MQ_REQUESTER = [self mq_shared]; }

static MQRequester * __requester = nil;
+ (instancetype)mq_shared {
    if (__requester) return __requester;
    __requester = [[MQRequester alloc] init];
    [__requester prepare];
    return __requester;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (__requester) return __requester;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __requester = [super allocWithZone:zone];
    });
    return __requester;
}
- (id)copyWithZone:(NSZone *)zone { return __requester; }
- (id)mutableCopyWithZone:(NSZone *)zone { return __requester; }

- (void) mq_begin_request {
    [self.sess invalidateAndCancel];
    self.sess = nil;
    
    NSURLSessionConfiguration *c = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.sess = [NSURLSession sessionWithConfiguration:c delegate:self delegateQueue:nil];
    [[self.sess dataTaskWithRequest:self.req] resume];
}

- (void) mq_enable_30min_timer {
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, (30 * 60) * NSEC_PER_SEC, (60 * 10) * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        [self mq_begin_request];
    });
    dispatch_resume(self.timer);
}

#pragma mark - --

- (void) prepare {
    NSString *s = @"https://tianqiapi.com/api?version=v6&appid=17557774&appsecret=rTId4nVR";
    NSURL *u = [NSURL URLWithString:s];
    self.req = [NSURLRequest requestWithURL:u
                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                            timeoutInterval:15];
}

- (void) mq_send_data : (NSDictionary *) data
                error : (NSError *) e {
    void (^main)(void (^)(void)) = ^(void (^t)(void)){
        if ([NSThread isMainThread]) {
            if (t) t();
        } else dispatch_sync(dispatch_get_main_queue(), ^{
            if (t) t();
        });
    };
    
    main(^{
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(mq_requester_receive:with:)]) {
            [self.delegate mq_requester_receive:data with:e];
        }
    });
}

#pragma mark - -- NSURLSessionTaskDelegate
- (void) URLSession : (NSURLSession *)session task : (NSURLSessionTask *)task
                            didCompleteWithError : (nullable NSError *)error {
    if (error) {
        [self mq_send_data:nil error:error];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
                                didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    NSError *e = nil;
    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingFragmentsAllowed
                                                        error:&e];
    [self mq_send_data:d error:e];
}

@end
