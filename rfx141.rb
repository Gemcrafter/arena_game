# This loads the long list files needed for character generation without encumbering the main program
# rfx125.rb/rfx_meth5 works completely for at least one round :)

require_relative "0001generation_list.rb"
require_relative "rfx_meth15.rb"   #idea is to pull methods into separate file -- test this (eventual module/class)
require_relative "rfx_rollem.rb"
# use 0001 (character builder) to store fighter backups for hall of fame.
# ideally write data to a seperate file, also add experience routine to update this

# multi_success(char_id, pool_size,@dice_target,@dice_faces)
# @dice_target,@dice_faces

# WE NEED TO STORE HALL_of_FAME
# alternately we can reset the stats after battle... but better to store/write file as created
# will give practice for writing files.

# NEEDS MUCH CLEANUP WORK (NOTES AND SURPLUS VARIABLES FROM TESTING CLEARED OUT 

# LETS SHOW ALL STATS FOR VERIFICATION FOR NOW
# NEED SOMETHING TO COUNT THE UPPER END OF THE RANGE, INSTEAD OF A SET '38'
puts "CONTESTANTS IN BATTLE"   #cid tracks character IDs as input (probably will have to do this throughout each loop
@cid=0
c = 0
# @trait = 0
(1..@@combatant).each do |c|
	puts "this is c"
	puts c
	@c=c
	
	puts "this should report the stats"
	reportstats(@c)

end

#end
# @@track = 0
@@statbank = Array.new  # stores pre-fight stats for hall of fame
# @@statbank =[]
# trait = 0

# this works for a single warrior
@@battleset = Array.new  #this stores players pre-fight stats (for hall of fame induction or whatever)
# turns out we need to load and clear statbank, and each time feed that to a new array

(1..@@combatant).each do |cr|
  @cr = cr
  reinforce(@cr)
  @@battleset[@cr] = @@statbank
end

@@dice_result = 0
@rounds = 0	
# COMBAT SEQUENCE BEGINS
@@evote = 20 #range for roll vs emperor whim
@whim = 0
@win_condition = 2
# TO CREATE ALTERNATE DUEL STRUCTURES can either use an if and everything else in a method/class
# launching 1-round, multi-round, set-round, first-blood, etc conditions use if to select the loop to use
=begin
  m = Array.new
 (0..2).each do |i|
 m << z[i]  #empty array m is appended by the values in  z[i] creating a new array, this is what we want
 end
=end
while @win_condition > 1 do

		puts ""
		puts "Test roll for each combatant"
		puts " "

# pick an eligible slot  (@keyslot should be an input) used in grab_initiative


# SETTINGS   ************ SETTINGS ********************* SETTINGS ****************** SETTINGS ****************** SETTINGS **************
set_arrays
@swing_chance = 5   #sets qualify number for attack rolls
@initiative_dice_used = 3  # USUALLY 3
@force_first_strike = 1   # default is 0,  TEST flag for initiative ties
# SETTINGS   ************ SETTINGS ********************* SETTINGS ****************** SETTINGS ****************** SETTINGS **************
@rounds += 1
# ROLL INITIATIVE  # COMBAT SEQUENCE (first_strike) 	

# Makes all rolls for initiative (battle order)
(1..@@combatant).each do
	|c|
	@cid=c
	battle_order
end

# Identify highest initiative roll 
(1..@@combatant).each do |c|
	@cid = c
	@win[@cid]=@lightning[@cid] 
		# puts "verify win_cid #{@win[@cid]}"
		# puts "highest initiative roll in group #{@win.max}"
	end
	
# If highest initiative in group or tied gets active flag, makes eligible to attack
(1..@@combatant).each do |c|
	@cid = c	
	winmax = @win.max    
	first_strike(@cid,winmax) 
	if @force_first_strike == 1 #used for testing can set flag in settings area (around line 40 now)
	then
	 @active[@cid] = 1  #ACTIVATE AND SET TO ONE TO FORCE FIRST STRIKE, TO ZERO TO MAKE ALL INELIGIBLE
	end
end

	
if @simul_tracker >1 
	then puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  SIMULTANIOUS ATTACK   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
end

finding_active   # identifies all gladiators with active flag
show_active      # displays all active gladiators

	# VFY confirmed @attacker stores all eligible attacker IDs
		# puts "verify @attacker array #{@attacker} character ID for all eligible fighter IDs" 
 
	# VFY watch for simul attacks and make sure the hit dice are actually relooping when same
	puts "* prepare for combat *"	
# ================================================================================================================

@alive = Array.new
summon_living    # builds an array of all living gladiators by char_id (checks health)

	# VFY verification that the alive array is loaded properly (used for target selection)
		# puts "alive array #{@alive} should clear all character ID's for next use"  
@smackdown = Array.new
@injury_count = 0  #should be above battle array (resets at start of entire game round)
@smackdown.clear  #empties all previous injuries, alternately could store them and start the injury loop at first new damage (keeps battle record)
@attacked_by=0
@target_id = Array.new  
@impact = Array.new
@hits_taken = Array.new
@defense_ops = Array.new   # to allow @defense_ops[@target]  may need a different array name.  see how this works out.
@damage_taken = Array.new   # duplicates hits_taken sort of, look at this
# ========================================================================================================
puts " ==================================  ROUND BEGINS  ============================================= "
# IDENTIFY TARGETS
@attacker.each { |a|
puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
puts "verify attacker array at start of circuit #{@attacker}"
	@att = a   #@cid cannot be used as it is used in the called methods
	@swing = a
	
	identify_defender(@att)
		puts "the target for #{@gladiator[@att]} is contestant number #{@target_id[@attacked_by]}  #{@gladiator[@target_id[@attacked_by]]}" 
	swing_weapons(@swing)
		puts "#{@gladiator[@swing]} made #{@successes[@swing]} on #{@attack_power[@swing]} tries"
	defender_resists(@target_id[@attacked_by])
	# determine how many successful defences were made  #multi_success(char_id, pool_size,dice_target,dice_faces)
	multi_success(@target_id[@attacked_by], @defense_ops[@target],5,@dice_faces) # TEMP ADJ DICE CHANCE

puts "defence successes for #{@gladiator[@target_id[@attacked_by]]} are  #{@successes[@target_id[@attacked_by]]} "
puts  "while defending vs #{@gladiator[@att]} against #{@attack_power[@swing]} attack tries and #{@successes[@swing]} successes"
# is overwriting in line 116 now commented out (was calling it again) -- ^clarify 108 for consistent data^

puts " "
puts "-------------------------------------------- STATUS SUMMARY ---------------------------------------"
puts "#{@gladiator[@swing]} attacks for #{@successes[@swing]} on #{@attack_power[@swing]} tries vs "
puts "#{@gladiator[@target_id[@attacked_by]]} who had #{@successes[@target_id[@attacked_by]]} on #{@defense_ops[@target]} defensive tries"
puts "---------------------------------------------------------------------------------------------------"
#  is looping thru for each attacker, verified.

# make sure casualties arent counted during the round, otherwise they lose their counter attack


# this loading should be matched -- see 280 meth5.rb

@def_id = @target_id[@attacked_by]
puts "TEST def_id #{@def_id}" #<--- returns empty so set it or change it
penetration(@attacked_by,@def_id)
puts "penetration is #{@impact[@striker]} for  #{@gladiator[@striker]} with #{@successes[@striker]} strikes vs #{@gladiator[@blocker]} with #{@successes[@blocker]} blocks"
puts "verify attacker array at end of circuit#{@attacker}"
#  might have something to do with the alive.clear
	@hits_taken[@blocker] = @impact[@striker]
	@injury_severity = @impact[@striker]
puts "hits taken by  #{@gladiator[@blocker]}  #{@hits_taken[@blocker]} -- hits inflicted by #{@gladiator[@striker]} is #{@impact[@striker]}"
battle_status(@striker,@blocker,@injury_severity)
puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
puts " "

}    


# if penetration>0
# note   smackdown =[att_id, target_id, damage]  #stores for wound checking
# This works if only one possible strike per attacker

# TRACK DAMAGE


puts "injury_count = #{@injury_count}"
#POST LOOP  
# SMACKDOWN NOW TRACKS ALL INJURIES (if no injuries should be empty.  should be cleared at start of round 
if @injury_count > 0
	then
	puts "injury count in post loop #{@injury_count}"
		(1..@injury_count).each do |ic|
			@ic = ic
				print "smackdown[ #{@ic} ] is #{@smackdown[@ic]}"  #reports injury should feed this into the health meter
				puts " "
				puts "wound #{@ic}"
				puts "smackdown [ #{ic} ][0] striker is #{@smackdown[@ic][0]}"
				puts "smackdown [ #{ic} ][1] blocker is #{@smackdown[@ic][1]}"
				puts "smackdown [ #{ic} ][2] penetration is #{@smackdown[@ic][2]}"
				# attack_summary(striker,blocker,penetration)
				attack_summary(@smackdown[@ic][0],@smackdown[@ic][1],@smackdown[@ic][2])
				
		end
		
end







# RESOLVE INJURIES (after all strikes have taken place)
# if @injury_count > 0


# do a loop for injury count to assess actual damage

# @smackdown[ic,0] = @attacker
# @smackdown[ic,1] = @blocker
# @smackdown[ic,2] = @hits_taken[@blocker]   #penetration
# clear smackdown at end of each battle round


puts "================================== ROUND COMPLETE ==================================="

# --------------------------------------- 		ABOVE LOOP WORKS.  PROCEED AT 150  -------------------------------------
# put all the defense things into a method similar to swing weapons
@attacker = Array.new

puts " "
# puts "defender #{@target_id[@attacked_by]} #{@gladiator[@target_id[@attacked_by]]} vs. attacker #{@attacked_by} #{@gladiator[@attacked_by]}"
@def_id = @target_id[@attacked_by].to_i  # compress to simplify ??? good idea??? watch this ??? # watch to see if tracking effected
# puts "@def_id is #{@def_id}"
# puts "defid #{@def_id.inspect} attby #{@attacked_by.inspect}"
# puts " "
@injured = 0
@vc=0


=begin
record impact
applydamage(blocker)  #@hits_taken[@blocker] = @impact[@striker]

=end


puts " !~~~~~~~~~~~~~~~~~~ VICTORY CHECK ~~~~~~~~~~~~~~~~~~~~~~!"			
puts " LOOP THRU ROUND SUMMARY "
(1..@@combatant).each do |x|
@x =x
round_summary(@x)
end

puts "see how many are still standing"
puts "health status check survivors array @health: #{@health}"

		# COUNT SURVIVORS
@survivors=0
@health.each.find_all do |i| 
	if i==1 
	then puts i
	@survivors += 1
			# puts "survivors count = #{@survivors}"  # keeps a running count
			# may want a check to see if anyone unconscious only
	end
end  
puts "survivors count = #{@survivors}"  # when placed here should give a final count

# We will want to tag this for specific fighters so we can name winner.. etc
# DETERMINE OUTCOME (FOR ONE ROUND FIGHT, LATER MAKE THIS 'DETERMINE CONTINUATION'
puts " "
puts " THE FINAL OUTCOME "
			
	if @survivors > 1
	puts "The crowd applauds the skill of the contestants, the Emperor shall decide if they should be awarded for their skills"
	elsif
	@survivors == 1 
	puts "the battle ends in victory"
	elsif @survivors ==0 
	then puts "the battle is a draw"
	end
			
# @win_condition = 0  #set to zero to make only a single pass (put into defaults with if loop and alt name.. or battle rounds counter)	
#WIN CONDITION TRACKER
# @win_condition = 1  # TEST flag for one loop
@win_condition = @survivors  # DEFAULT WIN CONDITION
puts "win condition #{@win_condition} if win condition is >1 the fight should continue"

end # SHOULD END ENTIRE BATTLE	~~~~~~~~~~~~~~~~~~~ IF YOU GET HERE THE FIGHT SHOULD BE DONE

puts "@@combatant #{@@combatant}"

(1..@@combatant).each do |c|
	puts "this is c"
	puts c
	@c=c
	puts "this should report the stats"
	reportstats(@c)
	# puts "@gladiator#{[@c]} STATBANK #{@statbank}"
end

puts " "
puts "The battle lasted #{@rounds} rounds"
puts " "
declare_winners

puts "~~~~~~~~~~~~~~~~"
puts " "

 puts " -----====== BATTLESET ===== CONTAINS PRE-FIGHT STATS =====-----------"
# Example of how to grab a specific fighter
# print @@battleset[1]
 
(1..@@combatant).each do |cbt|
@cbt = cbt
puts " "
print @@battleset[@cbt]
end

# WRITING TO FILE
# normally would use puts instead of print (default, keeps one record per line) just want to look at it for now. works
# currently writes all characters, will want to just collect the survivors and put each on a single line, test this first
# if not using @@battleset[id] then will print all in one line as a single record... hmm work with this some, for reloads etc later.
# note this setup currently overwrites the whole file, probably want to add to the next record line, somehow
# use a+ (append read/write-mode) instead of w+ (overwrite read/write-mode)
# still need to put a return # ok the puts line does it, but puts a blank in between record sets
# does however put each fighter on a different line (something about |line| )
File.open("hall_of_fame.txt", "a+") do |f|
  @@battleset.each { |element| f.print(element); f.puts}
end

# need some kind of symbol after # to show conditional testing flags 
=begin
#   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!     POST COMBAT    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
=end

# PRIORITIES
# betting algorithm
# output cleanup
# output to web
# output hall of fame
# create a wins slot for experience
# cleanup main combat loop
# refactor to use classes


#  BETTING SEQUENCE (ODDS CALC) 
# (odds calculator) could random sample stats or use total score
# due to fraction issues  probably set as 10 pays 19 or whatever
# alternately could 'fastfight' the battle 5-10 times and do it that way  with a win:win ratio
# pull alternate stats, run sim file w/o printouts hmm...

# CLEANUP
# remove all non-descriptive battle lines/duplicates/checks/tests etc from display



# consider making attack rolls more effective, higher smackdown chance?
#  MAKE SURE A SIMULTANIOUS COMBAT ANNOUNCEMENT IS POSTED WHEN APPLICABLE
#  SETTINGS ::: CREATE A SECTION WITH KEY LINE AND INPUT REFERENCES (ATT DICE, ETC, OR JUST THE BASES FOR THOSE TO PRE-SET)



#THINGS TO DO 
#  MAYBE REFACTOR FIRST SO IS ORGANIZED PROPERLY FOR LATER MODS
# pre-fight, store fighters
# identify anyone at end of fight with @health >0, award the win
# track injuries sustained during battle
# track kills for EXP

puts kamikaze  # => kamikaze
=begin
You can also use other methods such as map to go over each item in an array, perform a calculation with it, 
and output the results as a new array with each item modified by that calculation. 
Methods like this are most convenient for arrays that contains similar items, such as our strs array of strings.

strs.map{ |item| item + "?" }
 => ["book?", "table?", "computer?", "mouse?"]

The map function does not modify the original array,
 but returns the new array which you need to save into a new variable if you want to preserve it. 
 Again, if you want to make a map destructive, you can add a bang or exclamation mark to it.
=end


# INTEGERS ARE TREATED DIFFERENTLY THAN STRINGS... NOW WE ARE GETTING TO THE ROOT OF IT.... (http://ruby.bastardsbook.com/chapters/variables/)
=begin
 refer to:     http://www.reactive.io/tips/2009/01/11/the-difference-between-ruby-symbols-and-strings/
Symbols are Strings, Sort Of

The truth of the matter is that Symbols are Strings, just with an important difference, Symbols are immutable. 
Mutable objects can be changed after assignment while immutable objects can only be overwritten.
 Ruby is quite unique in offering mutable Strings, which adds greatly to its expressiveness.
 However mutable Strings can have their share of issues in terms of creating unexpected results and reduced performance. 
 It is for this reason Ruby also offers programmers the choice of Symbols.

So, how flexible are Symbols in terms of representing data? The answer is just as flexible as Strings. Lets take a look at some valid Strings and their Symbol equivalents.
=end

=begin
However, Ruby has a special convention for variables that, during the course of a program, will not change in value. These are called, as expected, constants.

PI_ESTIMATE = 3.14159265
radius = 42
the_circumference = 2 * PI_ESTIMATE * radius   #   263.8937826

=end

=begin
The results shouldn't surprise you. But what happens to jerry when we change what the first variable, tom, refers to?

tom = "kitty"
jerry = tom
tom = "mouse"

puts tom   
#=> mouse

puts jerry   
#=> "kitty"

As I mentioned earlier, don't use integers to test this out, as they are treated differently.
=end
# key to force initiative ties  
# swing_weapons method has the attack roll setting (under: set_arrays section)
# line 42, set initiative dice (under: set_arrays section) (next to swing weapons)
# multi_success def (121 rfx_meth6, has default settings for rolls... initiative usually), or can set on the feed in.
# battle_order def can accept dice settings.
# Force first strike Line 66


# @@combatant list needs to be set to the alive array, to avoid the dead rising and striking :)