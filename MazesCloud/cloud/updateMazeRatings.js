Parse.Cloud.define("updateMazeRatings", function(request, response) 
{
	var mazeObjectId = request.params.mazeObjectId;

	var mazeQuery = new Parse.Query("MAMaze");
	mazeQuery.equalTo("objectId", mazeObjectId);
	
	mazeQuery.find(
	{
    	success: function(results) 
		{
			var maze = results[0];
			
			var mazeRatingQuery = new Parse.Query("MAMazeRating");
			mazeRatingQuery.equalTo("maze", maze);
			mazeRatingQuery.equalTo("user", user);
			
			mazeRatingQuery.find(
			{
		    	success: function(results) 
				{
					var starsSum = 0;

					for (var i = 0; i < results.length; i = i + 1) 
					{
						starsSum = starsSum + results[i].get("stars");
					}

					maze.save(
					{
				    	ratingCount : results.length,
				    	averageRating : starsSum / results.length
				  	}, 
					{
				    	success: function(mazeAgain) 
						{
							response.success();
				    	},
				    	error: function(mazeAgain, error) 
						{
					      	response.error("Unable to update maze ratings.");
				    	}
				  	});
		    	},
		    	error: function() 
				{
		      		response.error("Unable to find maze rating.");
		    	}
		  	});
    	},
    	error: function() 
		{
      		response.error("Unable to find maze.");
    	}
  	});
});