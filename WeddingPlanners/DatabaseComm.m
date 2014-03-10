//
//  DatabaseComm.m
//  WeddingPlanners
//
//  Created by Rohan Sawhney on 3/8/14.
//  Copyright (c) 2014 DSTEWeddingPlanners. All rights reserved.
//

#import "DatabaseComm.h"

@implementation DatabaseComm

+ (void)signUpUserWithWifeName:(NSString *)wifeName husbandName:(NSString *)husbandName collaboratorName:(NSString *)collaboratorName husbandEmail:(NSString *)husbandEmail wifeEmail:(NSString *)wifeEmail collaboratorEmail:(NSString *)collaboratorEmail password:(NSString *)password forDelegate:(id<DatabaseCommDelegate>)delegate
{
    PFUser *user = [PFUser user];
    
    user.username = wifeName;
    user.email = wifeEmail;
    
    user[@"wifeName"] = husbandName;
    user[@"wifeEmail"] = husbandEmail;
    user[@"husbandName"] = husbandName;
    user[@"husbandEmail"] = husbandEmail;
    user[@"collaboratorName"] = collaboratorName;
    user[@"collaboratorEmail"] = collaboratorEmail;
    user[@"collaboratorList"] = @[];
    user[@"taskList"] = @[];
    user.password = password;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            [[NSUserDefaults standardUserDefaults] setObject:wifeName forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if([delegate respondsToSelector:@selector(userSignUpDidSucceed:withErrorDetails:)]){
                [delegate userSignUpDidSucceed:YES withErrorDetails:nil];
            }
        }else{
            if([delegate respondsToSelector:@selector(userSignUpDidSucceed:withErrorDetails:)]){
                [delegate userSignUpDidSucceed:NO withErrorDetails:[error userInfo][@"error"]];
            }
        }
    }];
}

+ (void)logInUserWithWifeName:(NSString *)wifeName husbandName:(NSString *)husbandName collaboratorName:(NSString *)collaboratorName password:(NSString *)password forDelegate:(id<DatabaseCommDelegate>)delegate
{
    NSString *username;
    if(wifeName) username = wifeName;
    else username = collaboratorName;
    
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
        if(user){
            if([delegate respondsToSelector:@selector(userLogInDidSucceed:withErrorDetails:)]){
                [delegate userLogInDidSucceed:YES withErrorDetails:nil];
            }
        }else{
            if([delegate respondsToSelector:@selector(userLogInDidSucceed:withErrorDetails:)]){
                [delegate userLogInDidSucceed:NO withErrorDetails:[error userInfo][@"error"]];
            }
        }
    }];
}

+ (void)logOutUser
{
    [PFUser logOut];
}

+ (void)setHusbandName:(NSString *)husbandName
{
    [PFUser currentUser][@"husbandName"] = husbandName;
    [[PFUser currentUser] saveInBackground];
}

+ (NSString *)husbandName
{
    return [PFUser currentUser][@"husbandName"];
}

+ (void)setWifeName:(NSString *)wifeName
{
    [PFUser currentUser][@"wifeName"] = wifeName;
    [[PFUser currentUser] saveInBackground];
}

+ (NSString *)wifeName
{
    return [PFUser currentUser][@"wifeName"];
}

+ (void)setCollaboratorName:(NSString *)collaboratorName
{
    [PFUser currentUser][@"collaboratorName"] = collaboratorName;
    [[PFUser currentUser] saveInBackground];
}

+ (NSString *)collaboratorName
{
    return [PFUser currentUser][@"collaboratorName"];
}

+ (NSString *)userId
{
    return [PFUser currentUser].objectId;
}

+ (BOOL)userIsRegistered
{
    return [self userId] != nil;
}

+ (void)setWeddingDate:(NSDate *)date
{
    [PFUser currentUser][@"weddingDate"] = date;
    [[PFUser currentUser] saveInBackground];
}

+ (void)setWeddingMaxBudget:(NSNumber *)maxBudget
{
    [PFUser currentUser][@"weddingMaxBudget"] = maxBudget;
    [[PFUser currentUser] saveInBackground];
}

+ (void)resetWifeEmail:(NSString *)wifeEmail
{
    [PFUser currentUser][@"wifeEmail"] = wifeEmail;
    [[PFUser currentUser] saveInBackground];
}

+ (NSString *)wifeEmail
{
    return [PFUser currentUser][@"wifeEmail"];
}

+ (void)resetHusbandEmail:(NSString *)husbandEmail
{
    [PFUser currentUser][@"husbandEmail"] = husbandEmail;
    [[PFUser currentUser] saveInBackground];
}

+ (NSString *)husbandEmail
{
    return [PFUser currentUser][@"husbandEmail"];
}

+ (void)resetCollaboratorEmail:(NSString *)collaboratorEmail
{
    [PFUser currentUser][@"collaboratorEmail"] = collaboratorEmail;
    [[PFUser currentUser] saveInBackground];
}

+ (NSString *)collaboratorEmail
{
    return [PFUser currentUser][@"collaboratorEmail"];
}

+ (void)sendInviteToCollaboratorWithName:(NSString *)collaboratorName email:(NSString *)collaboratorEmail password:(NSString *)password forDelegate:(id<DatabaseCommDelegate>)delegate
{
    // cloud
    [PFCloud callFunctionInBackground:@"inviteUser" withParameters:@{@"creatingUser":[PFUser currentUser],@"email":collaboratorEmail,@"password":password,@"husbandName":[self husbandName],
        @"wifeName":[self wifeName],@"collaboratorName":[self collaboratorName]} block:^(NSArray *data, NSError *error){
        if(!error){
            if([delegate respondsToSelector:@selector(sentEmail:)]){
                [delegate sentEmail:YES];
            }
        }else if([delegate respondsToSelector:@selector(sentEmail:)]){
            [delegate sentEmail:NO];
        }
    }];
}

+ (void)addCollaboratorToCollaboratorList:(PFUser *)collaborator
{
    [[PFUser currentUser] addUniqueObject:collaborator forKey:@"collaboratorList"];
    [[PFUser currentUser] saveInBackground];
}

+ (void)removeCollaboratorFromCollaboratorList:(PFUser *)collaborator
{
    [[PFUser currentUser] removeObjectsInArray:@[collaborator] forKey:@"collaboratorList"];
    [[PFUser currentUser] saveInBackground];
}

+ (NSArray *)collaboratorList
{
    return [PFUser currentUser][@"collaboratorList"];
}

+ (void)addTaskToTaskList:(PFObject *)task
{
    [[PFUser currentUser] addUniqueObject:task forKey:@"taskList"];
    [[PFUser currentUser] saveInBackground];
}

+ (void)removeTaskFromTaskList:(PFObject *)task
{
    [[PFUser currentUser] removeObjectsInArray:@[task] forKey:@"taskList"];
    [[PFUser currentUser] saveInBackground];
}

+ (NSArray *)taskList
{
    return [PFUser currentUser][@"taskList"];
}


+ (UIImage *)profilePictureForUser:(NSString *)userType
{
    return nil;
}

+ (NSString *)userProfilePictureKeyForUserType:(NSString *)userType
{
    NSString *userProfilePictureKey;
    if([userType isEqualToString:@"couple"]){
        userProfilePictureKey = @"coupleProfilePictureData";
    }else{
        userProfilePictureKey = @"collaboratorProfilePictureData";
    }

    return userProfilePictureKey;
}

+ (void)uploadProfilePicture:(UIImage *)profilePicture forUserWithType:(NSString *)userType forDelegate:(id<DatabaseCommDelegate>)delegate
{
    NSString *userProfilePictureKey = [self userProfilePictureKeyForUserType:userType];
    
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(profilePicture) forKey:userProfilePictureKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSData *imageData = UIImagePNGRepresentation(profilePicture);
    PFFile *imageFile = [PFFile fileWithName:@"img" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(succeeded){
            [PFUser currentUser][userProfilePictureKey] = imageFile;
            [[PFUser currentUser] saveInBackground];
            
            if([delegate respondsToSelector:@selector(userProfilePictureDidUpload:)]){
                [delegate userProfilePictureDidUpload:YES];
            }
        }else{
            if([delegate respondsToSelector:@selector(userProfilePictureDidUpload:)]){
                [delegate userProfilePictureDidUpload:NO];
            }
        }
    }progressBlock:^(int percentDone){
        if([delegate respondsToSelector:@selector(userProfilePictureProgress:)]){
            [delegate userProfilePictureProgress:percentDone];
        }
    }];
}

+ (void)removeProfilePictureForUser:(NSString *)userType
{
    NSString *userProfilePictureKey = [self userProfilePictureKeyForUserType:userType];
    
    [[PFUser currentUser] removeObjectForKey:userProfilePictureKey];
    [[PFUser currentUser] saveInBackground];
}

+ (UIImage *)profilePictureForUserWithType:(NSString *)userType;
{
    NSString *userProfilePictureKey = [self userProfilePictureKeyForUserType:userType];
    
    NSData* profilePictureData = [[NSUserDefaults standardUserDefaults] objectForKey:userProfilePictureKey];
    UIImage *profilePicture = [UIImage imageWithData:profilePictureData];
    
    if(profilePicture == nil){
        if([userProfilePictureKey isEqualToString:@"coupleProfilePictureData"]) profilePicture = [UIImage imageNamed:@"defaultCoupleProfilePicture.png"];
        else profilePicture = [UIImage imageNamed:@"defaultUserProfilePicture.png"];
        
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(profilePicture) forKey:userProfilePictureKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return profilePicture;
}

// Tasks

+ (PFObject *)createTaskWithType:(NSString *)taskType onDate:(NSDate *)eventDate withMaxBudget:(NSNumber *)eventMaxBudget
{
    
}

+ (PFObject *)removeTaskWithObjectId:(NSString *)eventId forUser:(PFObject *)user
{
    
}

+ (PFObject *)taskWithObjectId:(NSString *)taskId
{
    
}

+ (void)resetTaskType:(NSString *)taskType forTaskWithObjectId:(NSString *)taskId
{
    
}

+ (void)resetTaskDate:(NSDate *)taskDate forTaskWithObjectId:(NSString *)taskId
{
    
}

+ (void)resetTaskMaxBudget:(NSNumber *)taskMaxBudget forTaskWithObjectId:(NSString *)taskId
{
    
}

+ (void)addToDoItemWithDescription:(NSString *)description forTask:(PFObject *)task
{
    
}

+ (void)markToDoItemWithDescription:(NSString *)description asChecked:(NSNumber *)checked forTask:(PFObject *)task
{
    
}

+ (void)editToDoItemWithOldDescription:(NSString *)oldDescription withNewDescription:(NSString *)newDescription forTask:(PFObject *)task
{
    
}

+ (NSArray *)toDoListForTask:(PFObject *)task
{
    
}

+ (void)setSelectedRecommendation:(NSString *)recommendationObject forTask:(PFObject *)task
{
    
}

+ (NSArray *)getRecommendationsForTask:(PFObject *)task
{
    
}

+ (void)addSubtaskToSubtaskList:(PFObject *)subtask
{
    
}

+ (void)removeSubtaskToSubtaskList:(PFObject *)subtask
{
    
}

+ (NSArray *)subtaskList
{
    
}

@end
