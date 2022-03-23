extends Panel

onready var rankLabel = $Margin/Data/Rank
onready var nameLabel = $Margin/Data/Name
onready var scoreLabel = $Margin/Data/Score

func setup(rank: int, name: String, score: int) -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	rankLabel.text = "#%d  " % rank
	nameLabel.text = name
	scoreLabel.text = "%d" % score
