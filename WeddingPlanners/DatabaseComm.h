//
//  DatabaseComm.h
//  WeddingPlanners
//
//  Created by Rohan Sawhney on 3/8/14.
//  Copyright (c) 2014 DSTEWeddingPlanners. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DatabaseCommDelegate <NSObject>
@optional

- (void)userSignUpDidSucceed:(BOOL)success withErrorDetails:(NSString *)errorDetails;
- (void)userLogInDidSucceed:(BOOL)success withErrorDetails:(NSString *)errorDetails;

- (void)userProfilePictureDidUpload:(BOOL)success;
- (void)userProfilePictureProgress:(short)progress;

- (void)sentEmail:(BOOL)succeed;

@end

@interface DatabaseComm : NSObject

// User
+ (void)signUpUserWithWifeName:(NSString *)wifeName husbandName:(NSString *)husbandName husbandEmail:(NSString *)husbandEmail wifeEmail:(NSString *)wifeEmail password:(NSString *)password forDelegate:(id<DatabaseCommDelegate>)delegate;
+ (void)logInUserWithWifeName:(NSString *)wifeName husbandName:(NSString *)husbandName collaboratorName:(NSString *)collaboratorName password:(NSString *)password forDelegate:(id<DatabaseCommDelegate>)delegate;
+ (void)logOutUser;

+ (void)setHusbandName:(NSString *)husbandName;
+ (NSString *)husbandName;

+ (void)setWifeName:(NSString *)wifeName;
+ (NSString *)wifeName;

+ (void)setCollaboratorName:(NSString *)collaboratorName;
+ (NSString *)collaboratorName;

+ (NSString *)userId;
+ (BOOL)userIsRegistered;

+ (void)setWeddingDate:(NSDate *)date;
+ (void)setWeddingMaxBudget:(NSNumber *)maxBudget;

+ (void)resetWifeEmail:(NSString *)wifeEmail;
+ (NSString *)wifeEmail;

+ (void)resetHusbandEmail:(NSString *)husbandEmail;
+ (NSString *)husbandEmail;

+ (void)resetCollaboratorEmail:(NSString *)collaboratorEmail;
+ (NSString *)collaboratorEmail;

+ (void)sendInviteToCollaboratorWithName:(NSString *)collaboratorName email:(NSString *)collaboratorEmail password:(NSString *)password forDelegate:(id<DatabaseCommDelegate>)delegate;;
+ (void)addCollaboratorToCollaboratorList:(PFUser *)collaborator;
+ (void)removeCollaboratorFromCollaboratorList:(PFUser *)collaborator;
+ (NSArray *)collaboratorList;

+ (void)addTaskToTaskList:(PFObject *)task;
+ (void)removeTaskFromTaskList:(PFObject *)task;
+ (NSArray *)taskList;

+ (void)uploadProfilePicture:(UIImage *)profilePicture forUserWithType:(NSString *)userType forDelegate:(id<DatabaseCommDelegate>)delegate;
+ (void)removeProfilePictureForUserWithType:(NSString *)userType;
+ (UIImage *)profilePictureForUserWithType:(NSString *)userType;

// Tasks

+ (PFObject *)createTaskWithType:(NSString *)taskType onDate:(NSDate *)eventDate withMaxBudget:(NSNumber *)taskMaxBudget;
+ (PFObject *)removeTaskWithObjectId:(NSString *)eventId forUser:(PFObject *)user;
+ (PFObject *)taskWithObjectId:(NSString *)taskId;

+ (void)resetTaskType:(NSString *)taskType forTaskWithObjectId:(NSString *)taskId;
+ (void)resetTaskDate:(NSDate *)taskDate forTaskWithObjectId:(NSString *)taskId;
+ (void)resetTaskMaxBudget:(NSNumber *)taskMaxBudget forTaskWithObjectId:(NSString *)taskId;

+ (void)addToDoItemWithDescription:(NSString *)description forTask:(PFObject *)task;
+ (void)markToDoItemWithDescription:(NSString *)description asChecked:(NSNumber *)checked forTask:(PFObject *)task;
+ (void)editToDoItemWithOldDescription:(NSString *)oldDescription withNewDescription:(NSString *)newDescription forTask:(PFObject *)task;
+ (NSArray *)toDoListForTask:(PFObject *)task;

+ (void)setSelectedRecommendation:(NSString *)recommendationObject forTask:(PFObject *)task;
+ (NSArray *)getRecommendationsForTask:(PFObject *)task;

+ (void)addSubtaskToSubtaskList:(PFObject *)subtask;
+ (void)removeSubtaskToSubtaskList:(PFObject *)subtask;
+ (NSArray *)subtaskList;

@end
