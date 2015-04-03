def battle_order
	
	multi_initiative(@cid,@initiative_dice_used) #multi_initiative(char_id, attempts) #note 3 stats now used for init
	@init_dice[@cid] = @cumulative[@cid]   
# VFY	puts "#{@gladiator[@cid]} has #{@init_dice[@cid]} init_dice"
	puts ""
	 #multi_success(char_id, pool_size,dice_target,dice_faces)
	multi_success(@cid, @init_dice[@cid],@dice_target,@dice_faces)  # initiative rolls, use defaults
	@lightning[@cid] = @successes[@cid]
    puts "#{@gladiator[@cid]} has #{@init_dice[@cid]} init_dice and scored initiative #{@lightning[@cid]}"
	puts " "
end	

def set_arrays 
@win_condition = 0
@@keystat = Array.new 
@i = 0  
(1..36).each {|i| @@keystat[@i] = i}
# puts @@keystat.sample
@success_tracker = Array.new
@lightning = Array.new           # initiative successes total
@successes = Array.new         # initiative success counter
@win=Array.new
@win[0]=0
@init_dice=Array.new
# puts "pool verify #{@init_dice[@cid]}"
@simul_tracker=0
		# pick a random number from a predefined array
		#  stat[c][random 6,27,18,25-36 ] .. dodge bonus
		# define the array of defensive skills
		@def_dodge = Array.new
		@def_shield = Array.new
		@def_dodge = [7,18,25,26,27,28,29,]
		@def_shield = [6,30,31,32,33,34,35,36]
		@dgb = 0
		@dfb = 0

@attack_impact = Array.new  # Count attack dice (this should be a method, I think, lets work out basics first)
@not_target = Array.new  #not target is the initiator of the successful attack
@defence_impact = Array.new
@penetration = Array.new # @penetration[attacker_id] is damage taken
@attack_power = Array.new   #weapon dice + attack bonus dice
end



def reportstats(character_id)
					puts " "
					puts "starting reportstats(id)"
				@cid = character_id  #THIS IS NEW (we want to be able to use the input)
				(0..38).each do |m|
				@m = m
				 # puts "try @c #{@c}"
				 #puts "should show"
				puts "#{@stat[@cid][@m]} #{@stat_name[@cid][@m]} ----- #{@gladiator[@cid]}"  #getting a nil result
				end
end

def reinforce(character)
  @character = character
  @@statbank = []
 (0..36).each do |i|
 @@statbank << @stat[character][i]  #empty array m is appended by the values in  z[i] creating a new array, this is what we want
 end
end

	def pick_slot(eligible_slots)
		@slot_id = eligible_slots.sample
		# puts "@slot_id #{@slot_id}"
	end

	# IS IT PULLING THE NIL RATING BECAUSE CHAR/SLOT_ID ARE EMPTY ON FIRST PASS? OR NIL VALUES BEING FED IN SOMEWHERE
	def grab_rating(char_id, slot_id)
	  @char_id = char_id
	  @slot_id = slot_id
	#  puts "#{@gladiator[@char_id]} uses #{@stat_name[@char_id][@slot_id]}" #shows gladiator and randomly selected rating name
	  @rating = @stat[@char_id][@slot_id]
	#  puts "#{@stat_name[char_id][slot_id]} @rating is #{@rating}"          # shows rating name and rating
	end

	# @@keystat is used for the full 36 slot, use a targeted array of slots you want to pick from	
	def grab_initiative(char_id)	
	pick_slot(@@keystat) 
	grab_rating(@cid,@slot_id)
	end

	def multi_initiative(char_id, attempts)
		@cid = char_id
		@cumulative[@cid] = 0
		i=0
		@cumulative[@cid] = i
		(1..attempts).each do
			grab_initiative(char_id)
			# puts "is @rating still here? #{@rating}"  #YES
			@cumulative[@cid] = @cumulative[@cid] +@rating
			puts "cumulative rating is #{@cumulative[@cid]}"
		end
	end

	
	def verify_score(dice_res, goal)
		# ENABLE FLAGS TO SHOW ACTUAL DICE RESULTS AS ROLLED
		@score = 0
			if @@dice_result >= goal
			then
			   @score = @score + 1
			   # puts "success"
			else
			   # puts "try another dice"
			end
	end

	#  ::: success goal=(target_number), high = (dice size) #puts @score
	def success(goal,high)
		@goal=0
		@success_check = Rollem.new
		@success_check.roll(high)
		@goal = goal
		verify_score(@@dice_result, goal)
	end

	def multi_success(char_id, pool_size,dice_target,dice_faces)
		@cid= char_id
		
		# @success_tracker[@cid] 
		i=0
		@successes[@cid] = 0  
		@success_tracker = i
			(1..pool_size).each do
				success(dice_target,dice_faces)   # target 5+ on d6 may want to change these to inputs. # success_attempt(goal,high)
				@successes[@cid] = @score +@successes[@cid]
				# WHAT IS SCORE AND SHOULD IT HAVE A CID?
			end
	end

		def first_strike(char_id, winmax) 
			# checks to see if ties highest initiative roll of group and flags them as active
			if @lightning[@cid] == @win.max 	
				@active[@cid]=1 
				@simul_tracker +=1
				# simul_tracker checks for simultanious combat (when high rolls tie and are >0)
				puts "#{@gladiator[@cid]} is eligible to attack. eligibility flag #{@active[@cid]} eligible so far #{@simul_tracker}"
			else
				@active[@cid] = 0  
				# puts "ineligible #{@active[c]}"
				puts "#{@gladiator[@cid]} is ineligible to attack. Eligibility flag #{@active[@cid]} eligible so far #{@simul_tracker} "	
			end
		end

	# When rewriting attack selections, try to use existing methods where possible.
		def finding_active
			@attacker = Array.new
			# identifies active gladiators
			@attacker = (1..@@combatant).find_all {
				|c|
				@c=c; 
				@active[@c] ==1   #flags if gladiator is active by having highest initiative
				}  
				puts "@attacker array of active fighters #{@attacker}"  #@attacker now contains only the winning fighters [1,2]
				puts "~~~~~~~~~~~"
		end

		def show_active
			@attacker.each do |a|
				@a = a
				puts "#{@gladiator[@a]} wins initiative"
			end
		end

# SELECT WEAPON
# weapon skill provides half of the attack dice used after initiative (penetration)
		def select_weapon(att_id)
			@cid = att_id
			sw = Rollem.new
			@weapon = sw.roll(12)
	#		puts "#{@gladiator[@cid]} rolled weapon slot #{@weapon} a #{@stat_name[@cid][@weapon]} type with a skill of #{@stat[@cid][@weapon]}"
		end
# additional attack dice after itiative (used for penetration)
		def power_bonus(att_id)
			@cid = att_id
			pb = Rollem.new
			@att_bonus = pb.rollspread(19,23)
	#		puts " #{@gladiator[@cid]} for slot #{@att_bonus} has an attack bonus of #{@stat[@cid][@att_bonus]} a #{@stat_name[@cid][@att_bonus]} "	
			puts " "
		end

# skills used for defending after initiative (dodge+defend)
		def dodge_bonus(target)   
			@target = target
			@dgb = @def_dodge.sample
			puts " "
	#		puts "dodge_bonus slot #{@dgb} is #{@stat_name[@target][@dgb]} -- rating #{@stat[@target][@dgb]} for #{@gladiator[@target]}"
		end
# additional defensive skills after intiative 
		def defend_bonus(target)
			@target=target
			@dfs = @def_shield.sample  #samples the defend bonus (@def_shield array)
	#			puts "defend_bonus slot #{@dfs} is #{@stat_name[@target][@dfs]} -- rating #{@stat[@target][@dfs]} for #{@gladiator[@target]}"
			puts " "
		end

def defender_resists(defender_id)  #dodge_bonus(target) ==> stat_name[@target][dgb]	#counts counter dice
	# @target_id[@attacked_by]
		# determine which bonuses the defender recieves to counter the attack
	dodge_bonus(defender_id)   # # @stat[@target][@dgb]
	defend_bonus(defender_id)  # # @stat[@target][@dfs]
	@defense_ops[@target] = @stat[@target][@dfs] + @stat[@target][@dgb]  #count defense ops
	puts "defense_ops #{@defense_ops[@target]} for #{@gladiator[@target]}"	
	# determine how many successful defences were made  # multi_success(char_id, pool_size,dice_target,dice_faces)
	end

		
def weapon_power(char_id)  # calculates attack bonuses
	@cid = char_id
	puts "verify attacker[@cid] is #{@cid}" # => attacker[c] returns a blank
	@attack_impact[@cid] = 0
	@not_target[@cid] = 0   #some of these may need to be moved they are used elsewhere in target selection

		puts " "
		puts  "count attack dice for #{@gladiator[@cid]}"
	
	# determines which bonuses are used in attack
	select_weapon(@cid)
	power_bonus(@cid)
		# reports for verification
		puts "----- attacking bonuses ---CONFIRM ---"
	#	puts "#{@gladiator[@cid]} uses a #{@stat_name[@cid][@weapon]} @slot #{@weapon} for a weapon bonus of #{@stat[@cid][@weapon]} dice"
	#	puts "power bonus for #{@stat_name[@cid][@att_bonus]} @slot #{@att_bonus} with a rating  of #{@stat[@cid][@att_bonus]} dice"
		
	@attack_power[@cid] = @stat[@cid][@weapon] + @stat[@cid][@att_bonus]
		puts "VERIFY #{@gladiator[@cid]} TOTAL ATTACK DICE #{@attack_power[@cid]}"  #MAY NEED TO TAG @ATTACK POWER @CID
		puts "test @score #{@score} pre-attack"  # is carried over from previous value (initiative if first attacker)
	# MAY BE DOUBLING ATTACK POWER, IN 854 ?
end


		# BUILD AN ARRAY CALLED @alive OF  CHARACTER ID WHERE HEALTH >0 ; to clear use @alive.clear
 def living(char_id)  
	@cid = char_id
	if @stat[@cid][39] == 1  # @health stat
	then
     @alive.push(@cid)
	end
end

def summon_living
	(1..@@combatant).each  {|c| @c = c; living(@c)}
end

def identify_defender(att_id)
	@attacked_by = att_id       #used to avoid @cid conflict
#VFY	puts "@attacked_by is #{@attacked_by}"
	# @not_target[@cid] = @cid
	# puts "test @not_target[@cid] #{@not_target[@cid]}"
puts "ALIVE CLEARED NOW"
	@alive.clear

	# pulls array of all alive gladiators and removes the acting attacker. 
	summon_living
		puts "#{@stat_name[@attacked_by][39]} score  #{@stat[@attacked_by][39]} for #{@gladiator[@attacked_by]}"
		# puts @alive
		puts "@alive array is now  includes #{@alive} remove attacker  #{@gladiator[@attacked_by]} from target list"
		
		if @stat[@attacked_by][39] == 1  #checks to see if attackers health is positive
		then 
		# we are deleting 1, because that's the health rating.  Should be deleting the cid
		# @alive.delete(@stat[@attacked_by][39])  # this deletes the value of the (@health) argument from the array 
		@alive.delete(@attacked_by)  # this should the acting characters cid (note this is an arg)
		puts "@alive array is now #{@alive}"
		end
	
	puts "@alive contains #{@alive}"
	# check for an empty set (in case everyone else was killed already)  #this should probably be a method call
		if @alive.empty? == true
		then puts "there are no available targets RETURN TO MAIN"
			return   # this simply exits the subroutine may want to set up so goes to end game
		end

	@target_id[@attacked_by] = @alive.sample   # @target_id[@attacked_by] ~= target_id[attacked_by]
	
# VFY	puts "the target for #{@gladiator[@attacked_by]} is #{@gladiator[@target_id[@attacked_by]]}"  	

end

def penetration(striker, blocker)
	# puts "striker #{striker} blocker #{blocker}"
	@striker = striker
	@blocker = blocker
	@impact[@striker] = @successes[@striker] - @successes[@blocker]
	@hits_taken[@blocker] = @impact[@striker]
puts "!!!!!!!!!!!!! penetration is #{@impact[@striker]}  #{@gladiator[@striker]} with #{@successes[@striker]} strikes vs #{@gladiator[@blocker]} with #{@successes[@blocker]} blocks"
end

def applydamage(blocker,striker)
	@injured = blocker
	@striker = striker
	puts " "
	puts "area hit #{@stat_name[@injured][@hit_location]} on #{@gladiator[@injured]} has #{@stat[@injured][@hit_location]} rating for #{@stat_name[@injured][@hit_location]} "
	puts "area hit #{@stat_name[@injured][@hit_location]} on #{@gladiator[@injured]} takes #{@damage_taken[@injured]} damage"
	@battle_damage = @stat[@injured][@hit_location] - @damage_taken[@injured]
	puts "adjusted stat #{@stat_name[@injured][@hit_location]} after battle damage  is #{@battle_damage}"
	 # KILLS can check if #{@battle_damage} <=0 and credit the @striker with a kill for exp
	@stat[@injured][@hit_location] = @battle_damage
	puts "test if ratings updated inside applydamage. #{@stat_name[@injured][@hit_location]} rating is now #{@stat[@injured][@hit_location]}"
end

def woundcheck(blocker,striker)     # needs to be above def attack_summary as it will be called? may need to transfer any damage as well
	@striker = striker
	@injured = blocker
	@hit_location = rand(1..36) # use [#,#,#].sample later when target areas worked out
	# puts "Character checked in woundcheck #{@gladiator[@blocker]} who takes #{@damage_taken[@blocker]} in location #{@hit_location} stat #{@stat_name[@blocker][@hit_location]} "
puts "Character checked in woundcheck #{@gladiator[@injured]} who takes #{@damage_taken[@injured]} in location #{@stat_name[@injured][@hit_location]}  stat #{@stat_name[@injured][@hit_location]} "
    applydamage(@blocker,@striker)
end

def victory_check(character_id)
	@vc = character_id
	puts "@vc char id #{@vc}  @hit_location #{@hit_location}"
	# puts "See if #{@stat_name[@vc][@hit_location]} "
	puts "for #{@gladiator[@vc]} is updated inside victory_check. "
    puts "updated stat for #{@stat_name[@vc][@hit_location]} is now #{@stat[@vc][@hit_location]}"  # skill name + stat
	puts " "

	# SEE IF INJURY IS FATAL 
	@survival_status[@vc] = @stat[@vc][@hit_location]
	@ssc = @survival_status[@vc]
			#   #{@gladiator[@vc]}
	puts "SSC #{@ssc}"
	puts "Gladiator #{@gladiator[@vc]} #{@ssc}"
		if @ssc > 0 	 
			 puts "#{@gladiator[@vc]} bears the marks of courage, but fights on for freedom and glory"
			 @stat[@vc][39] = 1  #set @health score for the injured party
			 puts "@health #{@health}" # => [nil,1,1] ==> @health[@vc]
			 puts "@health[@id] #{@health[@vc]}" # ==>1
			 puts "victory check health stat #{@stat[@vc][39]} @health[@id] #{@health[@vc]}" 
			 
		elsif @ssc == 0 
			 "#{@gladiator[@vc]} is unable to continue fighting. The Emperor will choose a fate"
			# @stat[@vc][39] = 0
			@health[@vc] =0
			  puts "victory check health #{@health[@vc]}"
			  puts "@health[@id] #{@health[@vc]}"
		elsif @ssc < 0 
			 puts "#{@gladiator[@vc]} has been sent to feast with the Gods"
			 # @stat[@vc][39] = -1 # may set this as a sliding number to reflect degree of critical hit description
			 @health[@vc] = -1
			 # may be useful to leave as a single number for filtering purposes.  keep this note.
			  puts "victory check health #{@health[@vc]}  1=alive 0=may spare -x gladiator is toast "
			  puts "@health[@id] #{@health[@vc]}"
		else 
			puts "LOOK AT VICTORY CHECK IN 872, THIS SHOULDNT GET THRU"
		end
			# REWRITE ABOVE TO DIRECTLY MODIFY THE STAT  @stat[@vc][39]
end	



def round_summary(char_id)
				 @x=char_id
			 puts "#{@health[@x]} is the health number for #{@gladiator[@x]}"
			 if @health[@x] > 0
				puts "#{@gladiator[@x]} is prepared to continue fighting"
			 elsif @health[@x] == 0
				puts "#{@gladiator[@x]} has been put out of the fight his fate is up to the Emperor"
				# check thumbs (use charismatic, glory and honor type stats.  affects revival only)
			 elsif @health[@x] < 0
				puts "#{@gladiator[@x]} has died heroically in the arena"
			 else
				puts "something inexplicable happened"
			end
end

def kamikaze 
 	saystuff="kamikaze"
end


# Get weapon power and bonuses and see how many hits
def swing_weapons(att_id)
	@swing = att_id
	weapon_power(@swing)										# COUNT ATTACK ROLLS
	multi_success(@swing, @attack_power[@swing],@swing_chance,@dice_faces)  # RESOLVE ATTACK ROLLS (default is 5)
   # puts "***********************"
end


	
def battle_status(striker,blocker,injury_severity)
	if  injury_severity < 0
		puts "#{@gladiator[blocker]} effectively counters the attack by #{@gladiator[blocker]}"
		# blocks, possible counterstrike bonus (may set a lower threshhold
		# optional add next round initiative bonus for the blocker, or counter-attack
	elsif
		injury_severity == 0
		# successful defence without overkill
		puts "#{@gladiator[blocker]} is barely scratched by a glancing blow from  #{@gladiator[@striker]}"
	elsif 
		injury_severity > 0
		puts "#{@gladiator[blocker]} takes #{injury_severity} damage from #{@gladiator[striker]}"
		# possible follow up attack, momentum bonus for attacker
		@injury_count += 1
		@smackdown[@injury_count]=[@striker,@blocker,@injury_severity]
		puts "injury_information #{@smackdown[@injury_count]}"
	end
end

def attack_summary(striker,blocker,penetration)
	# May use this for after effects, for now just launches wound effects and victory check
	# probably consolidate
	puts "ATTACK SUMMARY POST STRIKE"
	@striker = striker
	@blocker = blocker
	@penetration = penetration
	@damage_taken[@blocker] = @penetration
	
	if @penetration < 0
		# possible flag for counter-attack
	elsif @impact[@striker] == 0	  
		# possible fatigue effects
	elsif @impact[@striker] > 0  
			
		woundcheck(@blocker,@striker)   #if we want to track the striker all the way thru the kill, start here and carry it, or do in next line
		victory_check(@blocker)
		#display damage  #call the apply damage routine or flag for later usage
	end
end


def emperors_thumbs
@emperor_inclination = ((@stat[@i][30] + @stat[@i][26] + @rounds) - (@stat[@i][28]))
# puts "survival bonus for #{@gladiator[@i]} the emperor inclination #{@emperor_inclination}"
puts " "
puts "... the crowd looks towards the Emperor..."
puts "The Emperor holds the fate of #{@gladiator[@i]} in the balance"
puts "..."
	# roll vs emperor_inclination
	@whim = rand(1..@@evote)
	if @whim <= @emperor_inclination
		puts "The crowd roars as the Emperor signals thumbs up.  #{@gladiator[@i]} is dragged from the arena."
		# Tag gladiator rejuvination = 1
	else
		puts "the Emperor signals thumbs down."
		puts " The crowd cheers as the head of  #{@gladiator[@i]}, is held aloft for the spectators"
		# Set gladiator rejuvination = 0
	end
end

# LIST WINNERS
def declare_winners
(1..@@combatant).each do |i|
	@i=i
	if @health[@i] == 1 
	 puts "#{@gladiator[@i]} wins "
	end
end 


(1..@@combatant).each do |i|
	@i=i
	if @health[@i] == 0 
	then 
	puts "the emperor must decide about  #{@gladiator[@i]}"
	end
end 


(1..@@combatant).each do |i|
	@i=i
	if @health[@i] ==  -1
	then
	puts "#{@gladiator[@i]} has fought for the last time"
	end
end 
# EMPERORS FATE CHOICE
(1..@@combatant).each do |i|
	@i=i
	if @health[@i]== 0 
	emperors_thumbs
	elsif @health[@i]== -1
	# Set gladiator rejuvination = 0
	end
end 
end  # end declare winners