//
//  IMManager+tests.h
//  GKHelpOutAppTests
//
//  Created by kky on 2019/8/28.
//  Copyright © 2019年 kky. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface IMManager (tests)

-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType;
-(void)onRecvMessages:(NSArray<NIMMessage *> *)messages;
-(void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification;

@end

NS_ASSUME_NONNULL_END
