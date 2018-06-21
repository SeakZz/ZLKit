//
//  NextViewController.m
//  Category
//
//  Created by long on 2018/1/23.
//  Copyright © 2018年 long. All rights reserved.
//

#import "NextViewController.h"
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>

@interface NextViewController () <WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

@end



//  0317-汽车销售致富经
@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
//    [userContentController addScriptMessageHandler:self name:@"aaa"];
    configuration.userContentController = userContentController;
    
    
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) configuration:configuration];
    
    self.webView.UIDelegate = self;
//    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:63342/0317-%E6%B1%BD%E8%BD%A6%E9%94%80%E5%94%AE%E8%87%B4%E5%AF%8C%E7%BB%8F/baipishu.html?_ijt=kp1dl7m0423ufi00buf6jrosd0"]];
    [self.webView loadRequest:request];
    
    
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    
    [self.bridge registerHandler:@"shareClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"%@", data);
        responseCallback(@"sharecompletion");
    }];
}


- (IBAction)rightBtn:(id)sender {
    //testJSFunction 是JS的方法
    [self.bridge callHandler:@"testJSFunction" data:@"一个字符串" responseCallback:^(id responseData) {
        NSLog(@"调用完JS后的回调：%@",responseData);
    }];
}


- (void)dealloc {
    
}

//#pragma mark - WKScriptMessageHandler
//- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message{
//    if ([message.name isEqualToString:@"aaa"]) {
//        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
//        // NSDictionary, and NSNull类型
//        NSLog(@"%@", message.body);
//    }
//}
//
//
//#pragma mark - WKNavigationDelegate
//// 页面开始加载时调用
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    NSLog(@"----------start");
//}
//// 当内容开始返回时调用
//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
//    NSLog(@"----------commit");
//}
//// 页面加载完成之后调用
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    NSLog(@"----------finish");
//}
//// 页面加载失败时调用
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
//    NSLog(@"----------fail");
//}
//// 接收到服务器跳转请求之后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
//
//}
//// 在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//
//    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
//    //允许跳转
//    decisionHandler(WKNavigationResponsePolicyAllow);
//    //不允许跳转
//    //decisionHandler(WKNavigationResponsePolicyCancel);
//}
//// 在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//
//    NSLog(@"%@",navigationAction.request.URL.absoluteString);
//    //允许跳转
//    decisionHandler(WKNavigationActionPolicyAllow);
//    //不允许跳转
////    decisionHandler(WKNavigationActionPolicyCancel);
//}
//#pragma mark - WKUIDelegate
//// 创建一个新的WebView
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
//    return [[WKWebView alloc]init];
//}
//// 输入框
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
//    completionHandler(@"http");
//}
//// 确认框
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
//    completionHandler(YES);
//}
//// 警告框
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//    NSLog(@"%@",message);
//    completionHandler();
//}


@end
