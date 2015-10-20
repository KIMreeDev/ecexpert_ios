//
//  QRCodeReaderDelegate.h
//  ECExpert
//
//  Created by renchunyu on 15/1/22.
//  Copyright (c) 2015年 renchunyu. All rights reserved.
//

#ifndef ECExpert_QRCodeReaderDelegate_h
#define ECExpert_QRCodeReaderDelegate_h

@class QRCodeReaderViewController;

/**
 * This protocol defines delegate methods for objects that implements the
 * `QRCodeReaderDelegate`. The methods of the protocol allow the delegate to be
 * notified when the reader did scan result and or when the user wants to stop
 * to read some QRCodes.
 */
@protocol QRCodeReaderDelegate <NSObject>

@optional

#pragma mark - Listening for Reader Status
/** @name Listening for Reader Status */

/**
 * @abstract Tells the delegate that the reader did scan a QRCode.
 * @param reader The reader view controller that scanned a QRCode.
 * @param result The content of the QRCode as a string.
 */
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result;

/**
 * @abstract Tells the delegate that the user wants to stop scanning QRCodes.
 * @param reader The reader view controller that the user wants to stop.
 */
- (void)readerDidCancel:(QRCodeReaderViewController *)reader;

@end
#endif
