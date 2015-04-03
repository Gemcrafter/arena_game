class Rollem
	 @dice_spread = 0
     @dice_result = 0
	 @@magic = Array.new
	 @@subtotal = 0
	 puts "@@magic #{@@magic}"
	 # if we want to use @ pips. Array.new must be created inside the def
	 # if we convert all @pips to @@pips.  Array new must be created inside the class

	 
	def roll(sides)
			dice_result = rand(1..sides)
			 @dice_result = dice_result
			 @@dice_result = dice_result
	end
	
	def rollspread(start,finish)
		    dice_spread = rand(start..finish)
			@dice_spread = dice_spread
			@@dice_spread = dice_spread
	end
	
	def dice_pool(thrown_dice,sides)
			@pips = Array.new
			@@subtotal = 0
			# @subtotal = 0  #this needs to be done at the class level
				(1..thrown_dice).each {
				|i|
				@pips[i] = roll(sides)
				# puts "~~~~~ entering def dice pool ~~~~~~~~~~"
				 # puts "pips [#{i}] is #{@pips[i]}"  #shows dice pips for each roll

				@@magic = @pips[i]
				# @subtotal=(@pips[i] + @subtotal) # this wont work because subtotal is local to the dice_pool
				@@subtotal=(@pips[i] + @@subtotal)
				# puts "@@magic inside dice_pool #{@@magic}" #verification that drawn from dice pool and matches, is correct
				#  puts "~~~leaving def dice pool ~~~~~~~~~~~~"
				}
	end

	
	# make sure your routines are run before exiting the class
	# or require the class and do in a new one

	#end of Rollem class is next line
end

class  Characters <Rollem
  # charisma = Rollem.new
  # charisma.dice_pool(3,6)
  # puts "subtotal #{@@subtotal}"
end	

class  ChooseAbility <Rollem
	# we will use this class to define various roll configurations
	# dice_pool(thrown_dice,sides)  Rollem is the dice rolling class
	def jumper36
		jump = Rollem.new
		#creates a new roll 'jump' which rolls 1 dice with 36 sides.
		jump.dice_pool(1,36)
		puts "subtotal inside jumper 36 class #{@@subtotal}"
		#puts "at cats inside ChooseAbility #{@cats}"  #this returns a range of (1..1)
		# maybe we should allow this to input dice ... then again that sorta defeats the purpose
	end
		def doublejumper36
		#creates a new roll 'jump' which rolls 1 dice with 36 sides.
		jump = Rollem.new
		jump.dice_pool(2,36)
		puts "subtotal inside jumper 36 class #{@@subtotal}"
		# testing to see if can use same variable since it has to be specifically called
	end
	
end