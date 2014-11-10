Hangman
=======

A two-player Hangman game that supports computer players in any of the positions (guesser or referee). Computer can even play against itself. 


How to Play
-----------

* Save the repo
* Navigate to the repo directory
* Open up pry or IRB and load hangman.rb like so: 
```
load 'hangman.rb'
```
+ Create 2 players for the game. Computer players must be initialized with a dictionary in a text file.
```
player_one = HumanPlayer.new
player_two = ComputerPlayer.new('dictionary.txt')
```
+ Create a new game, passing the guessing player first and the referee second. Then call play_game on the game. 
```
game = Hangman.new(player_one, player_two)
game.play_game
```
+ Follow the onscreen instructions and enjoy!
