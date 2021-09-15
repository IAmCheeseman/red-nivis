extends Node


var dialog = [
	{
		"dialog1" : "Hello, I'm Norg!"
	},
	# A how're you doing question
	{
		"dialog1" : {
			"text" : "How are you doing?",

			"choice" : {
				"choices" : [
					"Good",
					"Bad"
				],

				"responses" : {
					"Good" : {
						"dialog2" : "That's great!",
						"dialog3" : "I'm doing good too!"
					},

					"Bad" : {
						"dialog2" : "That sucks..."
					}
				}
			}
		}
	},
	{
		"dialog1" : "Hello.",
		"dialog2" : {
			"text" : "Where are you from?",

			"choice" : {
				"choices" : [
					"I have no idea...",
					"Somewhere, probably"
				],
				"responses" : {
					"I have no idea..." : {
						"dialog3" : "Idiot."
					},
					"Somewhere, probably" : {
						"dialog3" : "Ok, but where..?"
					}
				}
			}
		}
	}

]

