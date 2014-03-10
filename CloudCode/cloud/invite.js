// in invite.js module:
exports.inviteUser = function(creatingUser,email,tempPass,husbandName,wifeName,collaboratorName,response)
{
  "use strict";
    if (!tempPass) {                         
        tempPass = genRandomPass();
    }
 
    var user = new Parse.User();
    user.set ("username", collaboratorName);
    user.set ("password", tempPass);
    user.set ("email", email);
    user.set ("collaboratorEmail", email);
    user.set ("wifeName", wifeName);
    user.set ("husbandName", husbandName);
    user.set ("collaboratorName", collaboratorName);


    // TODO: set other user properties. Only the invited user can change them
    // after the user has been created.
 
    user.signUp(null, {
        success: function(createdUser) {
            sendInvitationEmail(email, subject, tempPass, husbandName, wifeName, collaboratorName, {
                    success: function(httpResponse) {
                        console.log("User " + createdUser.id + " created, and sent email: " + httpResponse.status);
                        response.success(createdUser);
                    },
                    error: function (httpResponse) {
                        console.error("user "+ createdUser.id +" created, but couldn't email them. " + httpResponse.status + " " + httpResponse.text);
                        response.error("user "+ createdUser.id +" created, but couldn't email them. " + httpResponse.status);
                    }
                 });
            }
        },
        error: function(user,error) {
            response.error("parse error: couldn't create user " + error.code + " " + error.message);
        }	   
    });
    
};
 
function sendInvitationEmail(email,subject,tempPass,husbandName,wifeName,collaboratorName,callbackObject) {
    "use strict";
    var sendgrid = require("sendgrid");
    var secrets = require("cloud/secrets.js");
	sendgrid.initialize(secrets.sendgriduser, secrets.sendgridpw); // TODO: your creds here...
	
	var fromname = "My Service";
	var from = "noreply@myservice.com";
	var subject = "Welcome to Wedding Planners!";
	var template = "hello {collaboratorName}, {wifeName} and {husbandName} have invited you to Wedding Planners to help plan their wedding. Your password is {pass}" ;
    var emailText = template.replace(/{collaboratorName}/g,collaboratorName).replace(/{wifeName}/g,wifeName).replace(/{husbandName}/g,husbandName).replace(/{pass}/g,tempPass);
    
    sendgrid.sendEmail({
        to: email,
        from: from,
    fromname: fromname,
        subject: subject,
        text: emailText,
        
    }, callbackObject);
}
 
function genRandomPass() {
    return "1223"; // TODO: generate a password using a random pw generator
}
