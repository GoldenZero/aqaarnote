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

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"

//completion blocks types
typedef void (^NetworkEngineCompletionBlock)(NSObject* response);
typedef void (^NetworkEngineCompletionBlockDurDis)(NSObject* response,NSDictionary* responseDis, NSDictionary* responseDur);
typedef void (^NetworkEngineFailureBlock)(NSError* error);
typedef void (^NetworkEngineCompletionBlockTrack)(NSObject* response,NSString* responsePK);

@interface NetworkEngine : MKNetworkEngine

@property (nonatomic, strong) NSDictionary* accountPreferences;
@property (nonatomic, readonly) NSString* accessToken;

+ (NetworkEngine *)getInstance;

//OAuth login
- (NSString*)authUrl;

- (NSString*)redirectUrl;

- (void)getRefreshToken:(NSString*)authorizationCode
               withUser:(NSString*)email
               password:(NSString*)password
        completionBlock:(NetworkEngineCompletionBlock)completionBlock
           failureBlock:(NetworkEngineFailureBlock)failureBlock;

//TODO updated get access token for refresh token
- (void)getAccessTokenForRefreshToken:(NSString*)token
                      completionBlock:(NetworkEngineCompletionBlock)completionBlock
                         failureBlock:(NetworkEngineFailureBlock)failureBlock;

typedef enum LocationType
{
    LocationTypePickup = 0,
    LocationTypeDropoff
}LocationType;

-  (void)searchForLocation:(NSString *)location
                  latitude:(NSString*)lat
                 longitude:(NSString*)lng
                     token:(NSString*)pageToken
           completionBlock:(NetworkEngineCompletionBlockTrack)completionBlock
              failureBlock:(NetworkEngineFailureBlock)failureBlock;

- (void)cancelReverseForLocationOperations;

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
         failureBlock:(NetworkEngineFailureBlock)failureBlock;

- (void)sendConfirmationCode:(NSString*)mobNum
             completionBlock:(NetworkEngineCompletionBlock)completionBlock
                failureBlock:(NetworkEngineFailureBlock)failureBlock;

@end
