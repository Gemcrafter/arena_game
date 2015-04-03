#SEGMENT IS TO TRACK DOWN AND REPAIR
# First bug fixed (Nil value pulls replaced with Magnuson +++ The Majestic
# unchecked the visibility comments, looped it and capitalized.

# require 'bigdecimal'  #needed to handle numbers math effectively
=begin
# HOW TO CALL THE STATS
# player here is used generically to describe combatant, contestant, character id 
puts gladiator[1]				# skill_name[player_number]
puts gladiator[2]
puts "gl1 #{stat_name[1][4]}"   # returns chain skill description for player1
puts "gl1 #{stat[1][4]}"		# returns chain rating for player1
puts "gl1 #{chain[1]}"     		# returns chain rating for player1
puts "gl2 #{stat_name[2][4]}"	# returns chain skill description for player2
puts "gl2 #{stat[2][4]}"		# returns chain rating for player2 (chain is the 5th stat starting at zero)
puts "gl2 #{chain[2]}"			# returns chain rating for player2
# puts "verification for composites-player 1"
# each weaponry array has only one value (the sum)
=end


(
@@keystats = Array.new   
first_name = Array.new
name_title = Array.new
@first_name = Array.new
@name_title = Array.new
@@stat_name = Array.new
@@stat = Array.new
@stat=Array.new
@@slot=Array.new
@stat_name=Array.new
@gladiator=Array.new
# WEAPONRY
@blades=Array.new
@hafted=Array.new
@poles=Array.new
@chain=Array.new
@improvised=Array.new
@shield=Array.new
# MISSILES
@bow_rof=Array.new
@bow_aim=Array.new
@crossbow=Array.new
@hurl=Array.new
@throwing=Array.new
@throw_rof=Array.new
# MARTIAL_ARTS
@striking=Array.new
@takedown=Array.new
@grapple=Array.new
@throws=Array.new
@blocks=Array.new
@timing=Array.new
# PHYSICAL
@muscle=Array.new
@mass=Array.new
@reach=Array.new
@fortitude=Array.new
@stamina=Array.new
@presence=Array.new
# EDGE
@will_power=Array.new
@spirit=Array.new
@killer_instinct=Array.new
@trickiness=Array.new
@psyche=Array.new
@entertainment=Array.new
# AGILITY
@evasion=Array.new
@mobility=Array.new
@reflex=Array.new
@kinetics=Array.new
@acrobatic=Array.new
@coordination=Array.new

# SUMMARY
	@weaponry=Array.new
	@missiles=Array.new
	@martial_arts=Array.new
	@physical=Array.new
	@edge=Array.new
	@agility=Array.new
	@overall=Array.new
# intiative sequence
#@@firststrike = Array.new deployed later

# IN GAME STATS
@active=Array.new
@tiebreaker=Array.new
@health=Array.new
@slot=Array.new
@survival_status=Array.new
# health is just a flag for if still eligible for combat

# @dice_target and @dice_faces > sets default dice ranges for multi_success. 
# these values can be specifically modified where needed by putting in a diff variable or value into the method call
@dice_target=5; @dice_faces=6
@cumulative=Array.new

@hit_location=1 #sets as default so a non-nil result is avoided until the loop is set
@@combatant=3 # SHOW NUMBER OF COMBATANTS
@@subtotal=0
#probably want to have a nil-check in here or solve this issue (do until non-nil)

@@keystats=[1..36]	#keystats is an array of initiative dice that can be picked from (ex: agility, dodge, etc. currently all, change as refined)
@@draw = 2   # how many stat dice are thrown for initiative
 # Array.new list
 
)

(1..@@combatant).each {
	|x|
	# puts"cats"  -- was a check for loopthru
	
	# START BY READING IN THE CHARACTER NAMES
	f=0
	i=0
	n=0
	# this opens a text file, iterates through it, runs a counter and assigns to an array
		File.open("first_name_list2.txt") do |f|
			f.each {
			|n| char_name= n
			i = (i+1)
		    @i=i
			first_name[i]=char_name.chomp! 
				if first_name[i] == nil
				then first_name[i] = "113 MAGNUSEN"
				end
			@first_name[@i]=first_name[i]
			
			}
		end
	f=0
	i=0
	n=0
	# .chomp!  removes trailing /n characters, treating as input
		File.open("name_title_list.txt") do |f|
			f.each {
			|n| char_named= n
			i = (i+1)
			@i = i
			# puts i #verification
			name_title[i]=char_named.chomp!
				if name_title[i] == nil
				then name_title[i] = "130 THE MIRACLE WORKER"
				end
			# puts name_title (shows entire array)
			@name_title[@i]=name_title[i]
			# puts @name_title (shows entire array)
			}
		end
	f=0
	i=0
	n=0
# FIXED  was pulling intermittent nil results.  spotted by looping entire section and using caps in the if then
	@random_first= "Arnold"
	@random_title= "The Iron Man"
	# THIS SECTION CONTAINS THE FIX
	@random_first= first_name.sample
	   			if @random_first == nil
				then @random_first = "Magnuson"
				end
	@random_title= name_title.sample
	   			if @random_title == nil
				then @random_title = "The Majestic"	
				end
	# @combined_name="Arnold the Ironman"
	
#puts "random_first #{@random_first}"
# this group is used for troubleshooting the gaps
#puts "random_title #{@random_title}"

# can check in the above two lines for nil if all else is not workable
	@combined_name = @random_first << " " << @random_title
puts "combined_name #{@combined_name}"

# ERROR RARE can't convert nil into string... set up a catch for this


	# assigns the composite name
	@slot[0]=@combined_name

# possibly set array.new for secondary abilities

# SCORE GENERATOR sets numeric values into @slots
@i=0
	(1..36).each do	|i|
				@i=i
				@slot[@i]=rand(1..5)
				end		
	@slot[37]=100
	@slot[38]=100
	@slot[39]=1  	
# VARIABLE NAME - GENERATED SCORE
# sets variable names = values of various @slots		
(# skills[x] to @slots list
	# WARRIOR NAME
	@gladiator[x]=@slot[0]
	# WEAPONRY
	@blades[x]=@slot[1]
	@hafted[x]=@slot[2]
	@poles[x]=@slot[3]
	@chain[x]=@slot[4]
	@improvised[x]=@slot[5]
	@shield[x]=@slot[6]
	# MISSILES
	@bow_rof[x]=@slot[7]
	@bow_aim[x]=@slot[8]
	@crossbow[x]=@slot[9]
	@hurl[x]=@slot[10]
	@throwing[x]=@slot[11]
	@throw_rof[x]=@slot[12]
	# MARTIAL_ARTS
	@striking[x]=@slot[13]
	@takedown[x]=@slot[14]
	@grapple[x]=@slot[15]
	@throws[x]=@slot[16]
	@blocks[x]=@slot[17]
	@timing[x]=@slot[18]
	# PHYSICAL
	@muscle[x]=@slot[19]
	@mass[x]=@slot[20]
	@reach[x]=@slot[21]
	@fortitude[x]=@slot[22]
	@stamina[x]=@slot[23]
	@presence[x]=@slot[24]
	# EDGE
	@will_power[x]=@slot[25]
	@spirit[x]=@slot[26]
	@killer_instinct[x]=@slot[27]
	@trickiness[x]=@slot[28]
	@psyche[x]=@slot[29]
	@entertainment[x]=@slot[30]
	# AGILITY
	@evasion[x]=@slot[31]
	@mobility[x]=@slot[32]
	@reflex[x]=@slot[33]
	@kinetics[x]=@slot[34]
	@acrobatic[x]=@slot[35]
	@coordination[x]=@slot[36]
)	
  	# 39=health, 1=alive, 0=ko, -1=toast
	

	@active[x]=@slot[37]   #used for tracking eligibility to strike in any given round
	@tiebreaker[x]=@slot[38]
	@health[x]=@slot[39]

	# create a named array
	# This array stores the variables for readability 
	# stat[blades,hafted,poles,etc]
  #stat[x] list
	@stat[x]=[
	@gladiator[x],
	@blades[x],
	@hafted[x],
	@poles[x],
	@chain[x],
	@improvised[x],
	@shield[x],
	@bow_rof[x],
	@bow_aim[x],
	@crossbow[x],
	@hurl[x],
	@throwing[x],
	@throw_rof[x],
	@striking[x],
	@takedown[x],
	@grapple[x],
	@throws[x],
	@blocks[x],
	@timing[x],
	@muscle[x],
	@mass[x],
	@reach[x],
	@fortitude[x],
	@stamina[x],
	@presence[x],
	@will_power[x],
	@spirit[x],
	@killer_instinct[x],
	@trickiness[x],
	@psyche[x],
	@entertainment[x],
	@evasion[x],
	@mobility[x],
	@reflex[x],
	@kinetics[x],
	@acrobatic[x],
	@coordination[x],
	@active[x],
	@tiebreaker[x],
	@health[x]
]
	
	
	# THIS ARRAY STORES THE TEXT NAMES FOR EACH STAT
# stat_name[x] list
	@stat_name[x] =[
	"gladiator",
	"blades",
	"hafted",
	"poles",
	"chain",
	"improvised",
	"shield",
	"bow_rof",
	"bow_aim",
	"crossbow",
	"hurl",
	"throwing",
	"throw_rof",
	"striking",
	"takedown",
	"grapple",
	"throws",
	"blocks",
	"timing",
	"muscle",
	"mass",
	"reach",
	"fortitude",
	"stamina",
	"presence",
	"will_power",
	"spirit",
	"killer_instinct",
	"trickiness",
	"psyche",
	"entertainment",
	"evasion",
	"mobility",
	"reflex",
	"kinetics",
	"acrobatic",
	"coordination",
	"active",
	"tiebreaker",
	"health"
	]
# 	puts "HEALTH #{@health}"   #LOOK AT THIS ITS ALTERNATING [nil,1,1] [nil,1]
	#  ANY SECONDARY_STATS[X] SHOULD BE PLACED HERE
	# WE WILL HAVE TO INITIALIZE ARRAYS UP TOP 
	# interestingly we could randomize off of composite lists to find momentarily necessary skill set
	
	@weaponry[x]= (@blades[x] + @hafted[x] + @poles[x] + @chain[x] + @improvised[x] + @shield[x])
	@missiles[x]= (@bow_rof[x] + @bow_aim[x] + @crossbow[x] + @hurl[x] + @throwing[x]  + @throw_rof[x])
	@martial_arts[x]= (@striking[x] + @takedown[x] + @grapple[x] + @throws[x] + @blocks[x] + @timing[x])
	@physical[x]= (@muscle[x] + @mass[x] + @reach[x] + @fortitude[x] + @stamina[x] + @presence[x])
	@edge[x]= (@will_power[x] + @spirit[x] + @killer_instinct[x] + @trickiness[x] + @entertainment[x])
	@agility[x]= (@evasion[x] + @mobility[x] + @reflex[x] + @kinetics[x] + @acrobatic[x] + @coordination[x])
	@overall[x]= (@weaponry[x] + @missiles[x] + @martial_arts[x] + @physical[x] + @edge[x] + @agility[x])
	
}	# END OF CHARACTER BUILDING CIRCUIT

