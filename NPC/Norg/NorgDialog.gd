extends Node


var dialog = [
	{
		"dialog1" : "Hello, I'm Norg!"
	},
	# A how're you doing question
	{
		"dialog1" : "How are you doing?",

		"choice" : {
			"choices" : [
				"Good",
				"Bad"
			],

			"responses" : {
				"Good" : {
					"dialog2" : "That's great!",
					"dialog3" : "I'm doing great too!"
				},

				"Bad" : {
					"dialog2" : "That sucks..."
				}
			}
		}
	}

]

