Parse.Cloud.define("getCurrentUserMazes", function(request, response) 
{
	var userObjectId = request.params.userObjectId;

	var userQuery = new Parse.Query("MAUser");
	userQuery.equalTo("objectId", userObjectId);

	userQuery.find(
	{	
    	success: function(results) 
		{
			var user = results[0];
				
			var mazeQuery = new Parse.Query("MAMaze");
			mazeQuery.equalTo("user", user);
			mazeQuery.ascending("name");

			mazeQuery.find(
			{
		    	success: function(results) 
				{
					var mazes = results;
				
					var utilities = require('cloud/utilities.js');
					utilities.getTopMazeItems(request, response, mazes);
		    	},
		    	error: function() 
				{
		      		response.error("Unable to find mazes.");
		    	}
		  	});
	   	},
	   	error: function() 
		{
	     		response.error("Unable to find user.");
	   	}
	});
});

