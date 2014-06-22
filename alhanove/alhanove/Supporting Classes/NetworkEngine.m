    /******************************************************************************
 *
 * Copyright (C) 2013 T Dispatch Ltd
 *
 * Licensed under the GPL License, Version 3.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.gnu.org/licenses/gpl-3.0.html
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 ******************************************************************************
 *
 * @author Marcin Orlowski <marcin.orlowski@webnet.pl>
 *
 ****/

#import "NetworkEngine.h"
#import "MKNetworkKit.h"

#define PASSENGER_SERVER_URL @"wishlist.com"
#define FLEET_API_KEY @"c24fe46b6bafd28a713ae440dada178a"
#define PASSENGER_CLIENT_ID @"1111"
#define PASSENGER_CLIENT_SECRET @"1111"

#define PASSENGER_AUTH_URL @"http://wishlist.com/oauth/access_token"
//#define PASSENGER_AUTH_URL @"http://jaziil.com/oauth/access_token"

#define API_URL @"http://wishlist.com/passenger/api/v2"
//#define API_URL @"http://jaziil.com/passenger/api/v2"
#define USE_SSL NO

// API
#define PASSENGER_API_PATH @"wishlist/api/v1"

@interface NetworkEngine()
{
    NSString *_accessToken;
}

@end

@implementation NetworkEngine

+ (NetworkEngine *)getInstance
{
	static NetworkEngine *ineInstance;
	
	@synchronized(self)
	{
		if (!ineInstance)
		{
			ineInstance = [[NetworkEngine alloc] initWithHostName:PASSENGER_SERVER_URL
                                                          apiPath:PASSENGER_API_PATH
                                               customHeaderFields:@{@"Accept-Encoding" : @"gzip"}
                           ];
		}
		return ineInstance;
	}
}

- (NSString*)redirectUrl
{
    return @"http://127.0.0.1";
}

- (NSString*)authUrl
{
    NSString* url = [NSString stringWithFormat:@"%@?response_type=code&client_id=%@&redirect_uri=%@&scope=&key=%@", PASSENGER_AUTH_URL, @"", [self redirectUrl], FLEET_API_KEY];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)getRefreshToken:(NSString*)authorizationCode
               withUser:(NSString*)email
               password:(NSString*)password
        completionBlock:(NetworkEngineCompletionBlock)completionBlock
           failureBlock:(NetworkEngineFailureBlock)failureBlock
{
    /*
     //2- check connectivity
     if (![GenericMethods connectedToInternet])
     {
     [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
     return;
     }
     */
    
    NSString* path = PASSENGER_AUTH_URL;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"grant_type"] = @"password_mobile";
    params[@"username"] = (email) ? email : @"";
    params[@"client_id"] = @"";
    params[@"client_secret"] = @"";
    params[@"password"] = password;
    params[@"code"]  = authorizationCode;
    params[@"scope"] = @"passengerapi";
    
    MKNetworkOperation *op = [self operationWithLocationPath:path params:params httpMethod:@"TOKEN" ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary* response = operation.responseJSON;
        NSNumber* status = response[@"status"];
        if ([status integerValue] == 401) {
            completionBlock(response);
        }else{
            _accessToken = response[@"access_token"];
            
            NSNumber* expiresIn = response[@"expires_in"];
            NSMutableDictionary* timeDict = [[NSMutableDictionary alloc]init];
            timeDict[@"time_now"] = [NSDate date];
            timeDict[@"expire_in"] = expiresIn;
            timeDict[@"expire_at"] = expiresIn;
            
            [[NSUserDefaults standardUserDefaults] setObject:timeDict forKey:@"expired_access"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            completionBlock(nil);
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        if (error.code == 400) {
            
            NSError* err = [[NSError alloc] initWithDomain:error.domain code:400 userInfo:nil];
            failureBlock(err);
        }else{
            failureBlock([NSError errorFromAPIResponse:errorOp.responseJSON andError:error]);
        }
    }];
    
    [self enqueueOperation:op];
    
}

//TODO updated get access token for refresh token
-(void)getAccessTokenForRefreshToken:(NSString*)token
                      completionBlock:(NetworkEngineCompletionBlock)completionBlock
                         failureBlock:(NetworkEngineFailureBlock)failureBlock
{
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    
    NSString* path = PASSENGER_AUTH_URL;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"grant_type"] = @"refresh_token";
    params[@"refresh_token"] = (token) ? token : @"";
    params[@"client_id"] =@"";
    params[@"client_secret"] = @"";

    MKNetworkOperation *op = [self operationWithLocationPath:path params:params httpMethod:@"TOKEN" ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
        NSDictionary* response = operation.responseJSON;
        _accessToken = response[@"access_token"];
        NSNumber* expiresIn = response[@"expires_in"];
        NSMutableDictionary* timeDict = [[NSMutableDictionary alloc]init];
        timeDict[@"time_now"] = [NSDate date];
        timeDict[@"expire_in"] = expiresIn;
        
        [[NSUserDefaults standardUserDefaults] setObject:timeDict forKey:@"expired_access"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        completionBlock(operation.responseJSON);
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        failureBlock([NSError errorFromAPIResponse:errorOp.responseJSON andError:error]);
    }];
    
    [self enqueueOperation:op];
    
}



- (void)searchForLocation:(NSString *)location
                 latitude:(NSString*)lat
                longitude:(NSString*)lng
                    token:(NSString*)pageToken
          completionBlock:(NetworkEngineCompletionBlockTrack)completionBlock
             failureBlock:(NetworkEngineFailureBlock)failureBlock
{
    //2- check connectivity
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    NSString* path;
    
    location = [location stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString* keyApi = @"AIzaSyD9uVPJ6IY4gTyvOKd5LQLsb5LAujvaBtQ";
    //NSString* latlng = [NSString stringWithFormat:@"%@,%@",lat,lng];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Default_Language"] isEqualToString:@"ar"])
        path = [NSString stringWithFormat:@"%@?query=%@&sensor=true&radius=50000&sensor=true&language=ar&key=%@&pagetoken=%@", @"https://maps.googleapis.com/maps/api/place/textsearch/json", location, keyApi,pageToken];
    else
        path = [NSString stringWithFormat:@"%@?query=%@&sensor=true&&radius=50000&sensor=true&language=en&key=%@&pagetoken=%@", @"https://maps.googleapis.com/maps/api/place/textsearch/json", location, keyApi,pageToken];
    
    
    MKNetworkOperation *op = [self operationWithLocationPath:path params:nil httpMethod:@"GET" ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary* response = operation.responseJSON;
        completionBlock(response[@"results"] , response[@"next_page_token"]);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        failureBlock([NSError errorFromAPIResponse:errorOp.responseJSON andError:error]);
    }];
    
    [self enqueueOperation:op];
}

- (void)cancelReverseForLocationOperations
{
    [MKNetworkEngine cancelOperationsContainingURLString:@"http://maps.googleapis.com/maps/api/geocode/"];
}

- (void)createAccount:(NSString *)firstName
             lastName:(NSString *)lastName
                email:(NSString *)email
                phone:(NSString *)phone
          countryCode:(NSString *)countryCode
             timeZone:(NSString *)zone
             password:(NSString *)password
            dateBirth:(NSString *)birthDate
               gender:(NSString *)gender
      completionBlock:(NetworkEngineCompletionBlock)completionBlock
         failureBlock:(NetworkEngineFailureBlock)failureBlock{
    
    NSString* path = [NSString stringWithFormat:@"%@/passengers",API_URL];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                    @"firstname": firstName,
                                                                                    @"lastname" : lastName,
                                                                                    @"email" : email,
                                                                                    @"mobile" : phone,
                                                                                    @"country_code" : countryCode,
                                                                                    @"time_zone" : zone,
                                                                                    @"origin" : @"IOS",
                                                                                    @"password" : password,
                                                                                    @"password_confirmation" : password,
                                                                                    @"gender" : gender,
                                                                                    @"birthday" : (birthDate) ? birthDate : @""
                                                                                    }];
    
    MKNetworkOperation *op = [self operationWithLocationPath:path params:params httpMethod:@"POST" ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        completionBlock(operation.responseJSON);
        _accessToken = @"amb0P2jRtA8qjni6Ut95y2r8Uoy0yzvzRe8CLDRN";
        
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        NSDictionary* response = errorOp.responseJSON;
        NSNumber* status = response[@"status"];
        if ([status integerValue] == 403 || [status integerValue] == 401) {
            NSError* err = [[NSError alloc] initWithDomain:response[@"error_message"] code:403 userInfo:nil];
            failureBlock(err);
        }else
            failureBlock([NSError errorFromAPIResponse:errorOp.responseJSON andError:error]);
    }];
    
    [self enqueueOperation:op];

}

- (void)sendConfirmationCode:(NSString*)mobNum
             completionBlock:(NetworkEngineCompletionBlock)completionBlock
                failureBlock:(NetworkEngineFailureBlock)failureBlock{
    
    NSString* path = [NSString stringWithFormat:@"%@/passengers/send-confirm-code/%@",API_URL,mobNum];
    MKNetworkOperation *op = [self operationWithLocationPath:path params:nil httpMethod:@"GET" ssl:NO];
    
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary* response = operation.responseJSON;
        completionBlock(response);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        NSDictionary* response = errorOp.responseJSON;
        NSNumber* status = response[@"status"];
        if ([status integerValue] == 403 || [status integerValue] == 401) {
            NSError* err = [[NSError alloc] initWithDomain:response[@"error_message"] code:403 userInfo:nil];
            failureBlock(err);
        }else
            failureBlock([NSError errorFromAPIResponse:errorOp.responseJSON andError:error]);
    }];
    
    [self enqueueOperation:op];

}

- (void)forgetPasswordForMobile:(NSString*)mobile
                completionBlock:(NetworkEngineCompletionBlock)completionBlock
                   failureBlock:(NetworkEngineFailureBlock)failureBlock{
    NSString* path = [NSString stringWithFormat:@"%@/passengers/reset-password/%@/ios",API_URL,mobile];
    MKNetworkOperation *op = [self operationWithLocationPath:path params:nil httpMethod:@"GET" ssl:NO];
    
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary* response = operation.responseJSON;
        completionBlock(response);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        NSDictionary* response = errorOp.responseJSON;
        NSNumber* status = response[@"status"];
        if ([status integerValue] == 403 || [status integerValue] == 401) {
            NSError* err = [[NSError alloc] initWithDomain:response[@"error_message"] code:403 userInfo:nil];
            failureBlock(err);
        }else
            failureBlock([NSError errorFromAPIResponse:errorOp.responseJSON andError:error]);
    }];
    
    [self enqueueOperation:op];

}

- (void)activateConfirmationCode:(NSString*)code
                    mobileNumber:(NSString*)mobNum
                 completionBlock:(NetworkEngineCompletionBlock)completionBlock
                    failureBlock:(NetworkEngineFailureBlock)failureBlock{
    
    NSString* path = [NSString stringWithFormat:@"%@/passengers/confirm/%@/%@",API_URL,mobNum,code];
    MKNetworkOperation *op = [self operationWithLocationPath:path params:nil httpMethod:@"GET" ssl:NO];
    
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary* response = operation.responseJSON;
        completionBlock(response);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        NSDictionary* response = errorOp.responseJSON;
        NSNumber* status = response[@"status"];
        if ([status integerValue] == 403 || [status integerValue] == 401) {
            NSError* err = [[NSError alloc] initWithDomain:response[@"error_message"] code:403 userInfo:nil];
            failureBlock(err);
        }else
            failureBlock([NSError errorFromAPIResponse:errorOp.responseJSON andError:error]);
    }];
    
    [self enqueueOperation:op];

}

- (void)getLatestBookings:(NetworkEngineCompletionBlock)completionBlock
             failureBlock:(NetworkEngineFailureBlock)failureBlock{
    NSString* path = [NSString stringWithFormat:@"%@/bookings?status=0|1|2|4|5|7",API_URL];
    MKNetworkOperation *op = [self operationWithLocationPath:path params:nil httpMethod:@"GET" ssl:NO];
    
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary* response = operation.responseJSON;
        completionBlock(response[@"bookings"]);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        NSDictionary* response = errorOp.responseJSON;
        NSNumber* status = response[@"status"];
        if ([status integerValue] == 403 || [status integerValue] == 401) {
            NSError* err = [[NSError alloc] initWithDomain:response[@"error_message"] code:403 userInfo:nil];
            failureBlock(err);
        }else
            failureBlock([NSError errorFromAPIResponse:errorOp.responseJSON andError:error]);
    }];
    
    [self enqueueOperation:op];
    
}

- (void)cancelBooking:(NSString *)pk
WithcancellationReason:(NSString *)reason
      completionBlock:(NetworkEngineCompletionBlock)completionBlock
         failureBlock:(NetworkEngineFailureBlock)failureBlock{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    params[@"reason"] = reason;
    NSString* path = [NSString stringWithFormat:@"%@/bookings/%@/cancel",API_URL,pk];
    
    MKNetworkOperation *op = [self operationWithLocationPath:path params:params httpMethod:@"POST" ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        completionBlock(operation.responseJSON);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        NSDictionary* response = errorOp.responseJSON;
        NSNumber* status = response[@"status"];
        if ([status integerValue] == 403 || [status integerValue] == 401) {
            NSError* err = [[NSError alloc] initWithDomain:response[@"error_message"] code:403 userInfo:nil];
            failureBlock(err);
        }else
            failureBlock([NSError errorFromAPIResponse:errorOp.responseJSON andError:error]);
    }];
    
    [self enqueueOperation:op];
}

- (void)updateBooking:(NSString *)pk
          withBooking:(NSDictionary *)bookingJson
      completionBlock:(NetworkEngineCompletionBlock)completionBlock
         failureBlock:(NetworkEngineFailureBlock)failureBlock
{

    
    NSString* path = [NSString stringWithFormat:@"%@/bookings/%@",API_URL,pk];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    // TODO : set params 
    
//    params[@"type"] = bookingJson.type;
//    if ([bookingJson.type isEqualToString:@"0"]) {
//        params[@"allocated_hours"] = bookingJson.allocated_hours;
//    }
//    params[@"vehicle_category"] = bookingJson.vehicle_category;
//    params[@"pickup_position_lat"] = bookingJson.pickup_position_lat;
//    params[@"pickup_position_lng"] = bookingJson.pickup_position_lng;
//    params[@"pickup_address"] = bookingJson.pickup_address ? bookingJson.pickup_address : @"";
//    
//    params[@"dropoff_position_lat"] = bookingJson.dropoff_position_lat;
//    params[@"dropoff_position_lng"] = bookingJson.dropoff_position_lng;
//    params[@"dropoff_address"] = bookingJson.dropoff_position_address ? bookingJson.dropoff_position_address : @"";
//    
//    if (bookingJson.pickup_time)
//    {
//        params[@"pickup_time"] = bookingJson.pickup_time;
//    }
//    
//    
//    params[@"payment_method"] = bookingJson.payment_method;
//    
//    params[@"extra_instructions"] = bookingJson.extra_instructions;
//    params[@"pickup_type"] = bookingJson.pickup_type;
//    params[@"trip_dir"] = (bookingJson.trip_dir) ? bookingJson.trip_dir : @"";
    
    MKNetworkOperation *op = [self operationWithLocationPath:path params:params httpMethod:@"POST" ssl:NO];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        completionBlock(operation.responseJSON);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        NSDictionary* response = errorOp.responseJSON;
        NSNumber* status = response[@"status"];
        if ([status integerValue] == 403 || [status integerValue] == 401) {
            NSError* err = [[NSError alloc] initWithDomain:response[@"error_message"] code:403 userInfo:nil];
            failureBlock(err);
        }else
            failureBlock([NSError errorFromAPIResponse:errorOp.responseJSON andError:error]);
    }];
    
    [self enqueueOperation:op];
    
}


@end
