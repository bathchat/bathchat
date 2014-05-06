Parse.Cloud.afterSave("Message", function(request) {

    var query = new Parse.Query(Parse.Installation);
    query.containedIn('user', request.object.get("recipients"));
    
    Parse.Push.send({
        where: query, // Set our Installation query
        data: {
            alert: "New message from " + request.user.first_name + ' ' + request.user.last_name
        }
    }, {
        success: function() {
            // Push was successful
        },
        error: function(error) {
            // Handle error
        }
    });

});

Parse.Cloud.afterSave("Bath", function(request) {

    if (request.object.get("verified") == "rejected") {
        var query = new Parse.Query(Parse.Installation);
        query.equalTo('user', request.object.get("owner"));
        
        Parse.Push.send({
            where: query, // Set our Installation query
            data: {
                alert: "Sorry! Your bath registration photo was rejected."
            }
        }, {
            success: function() {
                // Push was successful
            },
            error: function(error) {
                // Handle error
            }
        });
    }

});