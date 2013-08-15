Parse.Cloud.define("getHighestRatedMazes", function(request, response) 
{			
	var mazeQuery = new Parse.Query("MAMaze");
	mazeQuery.descending("averageRating").limit(5);

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
      		response.error("Unable to find maze.");
    	}
  	});
});

