//
//  deerViewController.m
//  stock
//
//  Created by Daniel Kong on 10/29/15.
//  Copyright © 2015 DK. All rights reserved.
//

#import "deerViewController.h"

@interface deerViewController ()

@end

@implementation deerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    // works
//    [self login];
    // works
//    [self investment_profile];
    
    // works
//    [self watchlists];
    
    // quote_fb
    [self quote_fb];
    
//    [self quotes:@"AAPL"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - private

- (void)setupUI {
    // this one does not have ex-white space while calling 
    UIButton *loginRobinhood = [[UIButton alloc] init];
    loginRobinhood.frame = CGRectMake(0, 20, self.view.bounds.size.width, 44);
    loginRobinhood.backgroundColor = [UIColor colorWithRed:0.5 green:0.85 blue:0.82 alpha:1]; //#81d8d0 tiffany
    [loginRobinhood addTarget:self
                     action:@selector(login)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginRobinhood];
}

- (void)login {
    //    https://api.robinhood.com

//    NSURLSession *session = [NSURLSession sharedSession];

    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"https://api.robinhood.com/api-token-auth/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
//    ContentType = 'application/json'
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    UserAgent = 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3'
    [request addValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3" forHTTPHeaderField:@"UserAgent"];

    // pass token then
//    xhr.setRequestHeader('Authorization', 'Token ' + res.token);
    
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: @"firstname.lastName", @"username",
                             @"XXXXXXXX", @"password",
                             nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"back");
        
        NSError *error2 = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error2];
    
        if (error != nil) {
            NSLog(@"Error parsing JSON.");
        }
        else {
//            "non_field_errors" =     (
//                                      "Unable to log in with provided credentials."
//                                      );
            if (jsonDict[@"token"]) {
                NSString *token = [jsonDict objectForKey:@"token"];
                NSLog(@"User token: %@", jsonDict);
            } else {
                NSLog(@"%@", jsonDict);
            }
        }
    }];
    
    [postDataTask resume];
}

//(lldb) po jsonDict
//{
//    "annual_income" = "75000_99999";
//    "investment_experience" = "good_investment_exp";
//    "investment_objective" = "cap_preserve_invest_obj";
//    "liquid_net_worth" = "50000_99999";
//    "liquidity_needs" = "very_important_liq_need";
//    "risk_tolerance" = "med_risk_tolerance";
//    "source_of_funds" = "savings_personal_income";
//    "suitability_verified" = 1;
//    "tax_bracket" = "";
//    "time_horizon" = "short_time_horizon";
//    "total_net_worth" = "65000_99999";
//    "updated_at" = "2015-03-09T17:24:35.973028Z";
//    user = "https://api.robinhood.com/user/";
//}

- (void)investment_profile {
    //    https://api.robinhood.com
    
    //    NSURLSession *session = [NSURLSession sharedSession];
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"https://api.robinhood.com/user/investment_profile/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //    ContentType = 'application/json'
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    UserAgent = 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3'
    [request addValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3" forHTTPHeaderField:@"UserAgent"];
    
    // pass token then
    //    xhr.setRequestHeader('Authorization', 'Token ' + res.token);
    
    [request addValue:@"Token ----" forHTTPHeaderField:@"Authorization"];
    //
    
    [request setHTTPMethod:@"GET"];

//    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
//    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"back");
        
        NSError *error2 = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error2];
        
        if (error != nil) {
            NSLog(@"Error parsing JSON.");
        }
        else {
            //            "non_field_errors" =     (
            //                                      "Unable to log in with provided credentials."
            //                                      );
            if (jsonDict[@"token"]) {
                NSString *token = [jsonDict objectForKey:@"token"];
                NSLog(@"User token: %@", jsonDict);
            } else {
                NSLog(@"%@", jsonDict);
            }
        }
    }];
    
    [getDataTask resume];
}

- (void)quotes:(NSString *)stock {
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"https://api.robinhood.com/quotes/"];//?symbols=AAPL
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
//    client.addHeader("Accept", "*/*");
//    client.addHeader("Accept-Encoding", "gzip, deflate");
//    client.addHeader("Accept-Language", "en;q=1, fr;q=0.9, de;q=0.8, ja;q=0.7, nl;q=0.6, it;q=0.5");
//    client.addHeader("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
//    client.addHeader("X-Robinhood-API-Version", "1.0.0");
//    client.addHeader("Connection", "keep-alive");
//    client.addHeader("User-Agent", "Robinhood/823 (iPhone; iOS 7.1.2; Scale/2.00)");

    [request addValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [request addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [request addValue:@"en;q=1, fr;q=0.9, de;q=0.8, ja;q=0.7, nl;q=0.6, it;q=0.5" forHTTPHeaderField:@"Accept-Language"];
//    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"1.0.0" forHTTPHeaderField:@"Connection"];
    [request addValue:@"keep-alive" forHTTPHeaderField:@"Accept"];
    [request addValue:@"Robinhood/823 (iPhone; iOS 7.1.2; Scale/2.00)" forHTTPHeaderField:@"UserAgent"];
    [request addValue:@"Token -----" forHTTPHeaderField:@"Authorization"];
    
    [request setHTTPMethod:@"GET"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: stock, @"symbols", nil]; //
    NSData *getData = [NSJSONSerialization dataWithJSONObject:mapData options:NSJSONWritingPrettyPrinted error:&error];
    
//    NSJSONSerialization.dataWithJSONObject(self.criteriaDic(), options: nil, error: &err)
//    NSString *getString = [NSString stringWithFormat:@"symbols=%@",stock];
//    NSData *getData = [getString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSData *getData = [NSJSONSerialization dataWithJSONObject:mapData options:nil error:&error];
    
    [request setHTTPBody:getData];
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"back");
        

        if (error != nil) {
            NSLog(@"Error parsing JSON.");
        }
        else {
            
            NSError *error2 = nil;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error2];
            
            //            "non_field_errors" =     (
            //                                      "Unable to log in with provided credentials."
            //                                      );
            
            
            if (jsonDict[@"token"]) {
                NSString *token = [jsonDict objectForKey:@"token"];
                NSLog(@"User token: %@", jsonDict);
            } else {
                NSLog(@"%@", jsonDict);
            }
        }
    }];
    
    [getDataTask resume];
}

- (void)watchlists {
    //    https://api.robinhood.com
    
    //    NSURLSession *session = [NSURLSession sharedSession];
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"https://api.robinhood.com/watchlists/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //    ContentType = 'application/json'
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    UserAgent = 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3'
    [request addValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3" forHTTPHeaderField:@"UserAgent"];
    
    // pass token then
    //    xhr.setRequestHeader('Authorization', 'Token ' + res.token);
    
    [request addValue:@"Token -----" forHTTPHeaderField:@"Authorization"];
    //
    
    [request setHTTPMethod:@"GET"];
    //    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: @"firstname", @"username",
    //                             @"xxxxx", @"password",
    //                             nil];
    //    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    //    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *error2 = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error2];
        
        if (error != nil) {
            NSLog(@"Error parsing JSON.");
        }
        else {
            //            "non_field_errors" =     (
            //                                      "Unable to log in with provided credentials."
            //                                      );
            if (jsonDict[@"token"]) {
                NSString *token = [jsonDict objectForKey:@"token"];
                NSLog(@"User token: %@", jsonDict);
            } else {
                NSLog(@"%@", jsonDict);
            }
        }
    }];
    
    [getDataTask resume];
}

//{
//    "adjusted_previous_close" = "106.9500";
//    "ask_price" = "105.8600";
//    "ask_size" = 200;
//    "bid_price" = "105.8500";
//    "bid_size" = 1400;
//    "last_extended_hours_trade_price" = "<null>";
//    "last_trade_price" = "106.0500";
//    "previous_close" = "106.9500";
//    "previous_close_date" = "2015-11-23";
//    symbol = FB;
//    "trading_halted" = 0;
//    "updated_at" = "2015-11-24T20:21:44Z";
//}
//after hour:
//{
//    "adjusted_previous_close" = "106.9500";
//    "ask_price" = "105.7500";
//    "ask_size" = 10900;
//    "bid_price" = "105.7400";
//    "bid_size" = 1100;
//    "last_extended_hours_trade_price" = "105.6700";
//    "last_trade_price" = "105.7400";
//    "previous_close" = "106.9500";
//    "previous_close_date" = "2015-11-23";
//    symbol = FB;
//    "trading_halted" = 0;
//    "updated_at" = "2015-11-24T21:00:00Z";
//}
- (void)quote_fb {
    //    https://api.robinhood.com
    
    //    NSURLSession *session = [NSURLSession sharedSession];
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"https://api.robinhood.com/quotes/EXPE/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //    ContentType = 'application/json'
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    UserAgent = 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3'
    [request addValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3" forHTTPHeaderField:@"UserAgent"];
    
    // pass token then
    //    xhr.setRequestHeader('Authorization', 'Token ' + res.token);
    
    [request addValue:@"Token -----" forHTTPHeaderField:@"Authorization"];
    //
    
    [request setHTTPMethod:@"GET"];
    //    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    //    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"back");
        
        NSError *error2 = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error2];
        
        if (error != nil) {
            NSLog(@"Error parsing JSON.");
        }
        else {
            //            "non_field_errors" =     (
            //                                      "Unable to log in with provided credentials."
            //                                      );
            if (jsonDict[@"token"]) {
                NSString *token = [jsonDict objectForKey:@"token"];
                NSLog(@"User token: %@", jsonDict);
            } else {
                NSLog(@"%@", jsonDict);
            }
        }
    }];
    
    [getDataTask resume];
}


- (void)placeOrder_fb {
    //    https://api.robinhood.com
    
    //    NSURLSession *session = [NSURLSession sharedSession];
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"https://api.robinhood.com/quotes/EXPE/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //    ContentType = 'application/json'
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    UserAgent = 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3'
    [request addValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3" forHTTPHeaderField:@"UserAgent"];
    
    // pass token then
    //    xhr.setRequestHeader('Authorization', 'Token ' + res.token);
    
    [request addValue:@"Token ----" forHTTPHeaderField:@"Authorization"];
    //
    
    [request setHTTPMethod:@"GET"];
    //    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: @"realusername", @"username",
    //                             @"XXXXX", @"password",
    //                             nil];
    //    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    //    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"back");
        
        NSError *error2 = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error2];
        
        if (error != nil) {
            NSLog(@"Error parsing JSON.");
        }
        else {
            //            "non_field_errors" =     (
            //                                      "Unable to log in with provided credentials."
            //                                      );
            if (jsonDict[@"token"]) {
                NSString *token = [jsonDict objectForKey:@"token"];
                NSLog(@"User token: %@", jsonDict);
            } else {
                NSLog(@"%@", jsonDict);
            }
        }
    }];
    
    [getDataTask resume];
}

@end
