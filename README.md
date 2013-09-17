#Ruby Blackjack

##How to play

Run `ruby blackjack.rb`

(Tested with Ruby 1.8.7 p374)

##About this Game

Game of 'command line blackjack' that supports multiple players, betting, doubling down, and splitting.

- $1 minimum bet
- One hand per player
- Dealer does not hit on soft 17
- Blackjack pays 3 to 2
- No insurance

Change starting stack and number of decks in `config.rb`

##Tests

To run the test suite, you'll need Rspec:

`gem install rspec`

then simply run `rspec` in the blackjack directory

##Design Considerations

###1. MVC Architecture

Although a small application, I wanted to separate responsibilities and follow the [MVC Architecture](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller). This prevents inter-weaving of code, and allows each component to be easily changed or refactored without unexpected side effects.

- **Model:** Components are self contained and separated according to responsibility. Each model stores the state of players, cards, hands etc and corresponds to the parts of a real Blackjack game.
- **View:** Contains all output and does not persist data. This makes it simple to include other languages, or make changes to the user interface without effecting functionality.
- **Controller:** Deals with the game flow and delegating user input

###2. Unix Philosophy

While doing any kind of development, I am constantly thinking about [Unix Philosophy](http://en.wikipedia.org/wiki/Unix_philosophy) and building functionality is a simple and extendable way such that code can be re-used or re-purposed later. It also helps readability.

- Short, simple, clear, modular, and extendable code
- Model methods perform one clear task and I tried to keep them 5 lines or less
- Methods take few arguments, and return logical data types


###3. Comprehensive Testing

Rspec is used to test all model methods, and ensure unexpected behavior is easily detected. This was very useful when refactoring and simplifying methods.
