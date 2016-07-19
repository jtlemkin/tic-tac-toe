#This class stores information about the board
class Board
	attr_accessor :cells

	#Create a board with nine cells
	def initialize
		@cells = []

		9.times { @cells << Cell.new }	
	end

	#Display board with name of cells
	def to_s
		s = ""

		@cells.each_with_index do |cell, i|
			s += cell.name
			s += (i + 1) % 3 == 0 ? "\n" : " | "
		end

		s
	end

	#Allow player to pick whether to be 'X' or 'O'
	def get_player
		puts "Will player 1 be X or O?"
		player = gets.chomp
		puts ""

		if player == "x" || player == "X"
			puts "Player 1: X"
			puts "Player 2: O"

			return "X", "O"
		elsif player == "o" or player == "O"
			puts "Player 1: O"
			puts "Player 2: X"

			return "O", "X"
		else
			puts "Input not valid."
			puts
			puts "Player 1: X"
			puts "Player 2: O"

			return "X", "O"
		end
	end

	#prompt the user for cell name
	def get_name
		puts "What tile would you like to claim? (1-9)"
		name = gets.chomp
	end

	def check(to_check, error)
		if /[1-9]/.match(to_check)
			true
		else
			puts error
			puts " "

			false
		end
	end

	#check to see if a submitted cell name is numeric
	def is_valid_tile?(name)
		error = "Not a valid tile. Please choose again."

		check(name, error)
	end

	#check to see if cell already claimed
	def is_unclaimed?(cell)
		error = "Tile already claimed. Please choose again."

		check(cell.to_s, error)
	end

	#allow a player to claim a cell
	def claim(player)
		name = get_name
		cell = @cells[name.to_i - 1]
		puts ""

		until is_valid_tile?(name) && is_unclaimed?(cell) do
			name = get_name
			cell = @cells[name.to_i - 1]
		end

		puts "You chose #{name}."
		puts ""

		cell.name = player
	end

	#check to see if all the cells is one row is owned by a single player
	def is_match? cells
		owners = []

		cells.each_with_index do |cell, i|
			owners[i] = cell.name
		end

		owners.uniq.length == 1
	end

	#check to see if a player has won the game
	def is_won?
		case
		when self.is_match?(@cells[0..2]) then true
		when self.is_match?(@cells[3..5]) then true
		when self.is_match?(@cells[6..8]) then true
		when self.is_match?([@cells[0], @cells[3], @cells[6]]) then true
		when self.is_match?([@cells[1], @cells[4], @cells[7]]) then true
		when self.is_match?([@cells[2], @cells[5], @cells[8]]) then true
		when self.is_match?([@cells[0], @cells[4], @cells[8]]) then true
		when self.is_match?([@cells[2], @cells[4], @cells[6]]) then true
		else false
		end
	end

	#Play the game
	def play
		turns = 9

		waiter, player = self.get_player

		turns.times do
			player, waiter = waiter, player

			puts self
			puts ""
			puts "It is now #{player}'s turn."

			self.claim(player)

			break if is_won?
		end

		puts is_won? ? "Congratulations! #{player} has won the game!" : 
		"Too bad. It's a tie"
	end

	#This class stores information about the cells
	class Cell
		attr_accessor :name

		@@cell_count = 0

		#Create a cell that displays its position
		def initialize
			@@cell_count += 1
			@name = @@cell_count.to_s
		end

		#Display cell with name
		def to_s
			self.name
		end

	end
end

b = Board.new

b.play