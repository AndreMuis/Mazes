exports.getTopMazeItems = function(request, response, mazes) {
	var userObjectId = request.params.userObjectId;

	var userQuery = new Parse.Query("MAUser");
	userQuery.equalTo("objectId", userObjectId);

	userQuery.find(
	{
    	success: function(results) 
		{
			var user = results[0];

			var mazeRatingQuery = new Parse.Query("MAMazeRating");
			mazeRatingQuery.equalTo("user", user);
			mazeRatingQuery.containedIn("maze", mazes);

			mazeRatingQuery.find(
			{
	    		success: function(results) 
				{
					var ratings = results;

					var mazeProgressQuery = new Parse.Query("MAMazeProgress");
					mazeProgressQuery.equalTo("user", user);
					mazeProgressQuery.containedIn("maze", mazes);

					mazeProgressQuery.find(
					{
			    		success: function(results) 
						{
							var progress = results;

							var topMazeItems = new Array();

							for (var i = 0; i < mazes.length; ++i)
							{
								topMazeItem = new Object();
								topMazeItem.maze = mazes[i];
								topMazeItem.mazeName = mazes[i].get("name");
								topMazeItem.averageRating = mazes[i].get("averageRating");
								topMazeItem.ratingCount = mazes[i].get("ratingCount");
								topMazeItem.userStarted = false;
								topMazeItem.userRating = -1;
								topMazeItem.updatedAt = mazes[i].updatedAt;

								for (var j = 0; j < ratings.length; ++j)
								{
									if (ratings[j].get("maze").id == mazes[i].id)
									{
										topMazeItem.userRating = ratings[j].get("stars");
									}
								}

								for (var j = 0; j < progress.length; ++j)
								{
									if (progress[j].get("maze").id == mazes[i].id)
									{
										topMazeItem.userStarted = progress[j].get("started");
									}
								}

								topMazeItems[i] = topMazeItem;
							}

							response.success(topMazeItems);				
						},
				    	error: function() 
						{
				      		response.error("Unable to find maze progress.");
				    	}
					});
	    		},
	    		error: function() 
				{
	      			response.error("Unable to find maze ratings.");
	    		}
			});
    	},
    	error: function() 
		{
      		response.error("Unable to find user.");
    	}
  	});
};

