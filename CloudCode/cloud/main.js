Parse.Cloud.define("inviteUser", function(request, response)
{  
  var creatingUser = request.user; 
  var email = request.params.email; // string required
	var tempPass = request.params.password; // string
  var husbandName = request.params.husbandName;
  var wifeName = request.params.wifeName;
  var collaboratorName = request.params.collaboratorName;

 
    var invitejs = require("cloud/invite.js");
    invitejs.inviteUser(creatingUser,email,tempPass,husbandName,wifeName,collaboratorName,response);
 
 });
