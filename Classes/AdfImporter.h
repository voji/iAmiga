//
//  AdfDownloader.h
//  iUAE
//
//  Created by Simon Toens on 3/25/15.
//
//

#import <Foundation/Foundation.h>

@interface AdfImporter : NSObject

/**
 * Handles .adf and .zip paths.  Intended to be used with the AppDelegate's 
 * - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
 * method. 
 */
- (BOOL)import:(NSString *)path;

- (BOOL)isDownloadedAdf:(NSString *)path;

@end