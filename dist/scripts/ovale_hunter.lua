local __Scripts = LibStub:GetLibrary("ovale/Scripts")
local OvaleScripts = __Scripts.OvaleScripts
do
    local name = "sc_hunter_beast_mastery_t19"
    local desc = "[7.0] Simulationcraft: Hunter_Beast_Mastery_T19"
    local code = [[
# Based on SimulationCraft profile "Hunter_Beast_Mastery_T19P".
#	class=hunter
#	spec=beast_mastery
#	talents=2102012

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_hunter_spells)

AddCheckBox(opt_interrupt L(interrupt) default specialization=beast_mastery)
AddCheckBox(opt_use_consumables L(opt_use_consumables) default specialization=beast_mastery)
AddCheckBox(opt_volley SpellName(volley) default specialization=beast_mastery)

AddFunction BeastmasteryInterruptActions
{
 if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting()
 {
  if target.Distance(less 5) and not target.Classification(worldboss) Spell(war_stomp)
  if target.InRange(quaking_palm) and not target.Classification(worldboss) Spell(quaking_palm)
  if target.Distance(less 8) and target.IsInterruptible() Spell(arcane_torrent_focus)
  if target.InRange(counter_shot) and target.IsInterruptible() Spell(counter_shot)
 }
}

AddFunction BeastmasteryUseItemActions
{
 Item(Trinket0Slot text=13 usable=1)
 Item(Trinket1Slot text=14 usable=1)
}

AddFunction BeastmasterySummonPet
{
 if pet.IsDead()
 {
  if not DebuffPresent(heart_of_the_phoenix_debuff) Spell(heart_of_the_phoenix)
  Spell(revive_pet)
 }
 if not pet.Present() and not pet.IsDead() and not PreviousSpell(revive_pet) Texture(ability_hunter_beastcall help=L(summon_pet))
}

### actions.precombat

AddFunction BeastmasteryPrecombatMainActions
{
}

AddFunction BeastmasteryPrecombatMainPostConditions
{
}

AddFunction BeastmasteryPrecombatShortCdActions
{
 #flask
 #augmentation
 #food
 #summon_pet
 BeastmasterySummonPet()
}

AddFunction BeastmasteryPrecombatShortCdPostConditions
{
}

AddFunction BeastmasteryPrecombatCdActions
{
 #snapshot_stats
 #potion
 if CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(prolonged_power_potion usable=1)
}

AddFunction BeastmasteryPrecombatCdPostConditions
{
}

### actions.default

AddFunction BeastmasteryDefaultMainActions
{
 #volley,toggle=on
 if CheckBoxOn(opt_volley) Spell(volley)
 #kill_command,if=equipped.qapla_eredun_war_order
 if HasEquippedItem(qapla_eredun_war_order) and pet.Present() and not pet.IsIncapacitated() and not pet.IsFeared() and not pet.IsStunned() Spell(kill_command)
 #dire_beast,if=((!equipped.qapla_eredun_war_order|cooldown.kill_command.remains>=1)&(set_bonus.tier19_2pc|!buff.bestial_wrath.up))|full_recharge_time<gcd.max|cooldown.titans_thunder.up|spell_targets>1
 if { not HasEquippedItem(qapla_eredun_war_order) or SpellCooldown(kill_command) >= 1 } and { ArmorSetBonus(T19 2) or not BuffPresent(bestial_wrath_buff) } or SpellFullRecharge(dire_beast) < GCD() or not SpellCooldown(titans_thunder) > 0 or Enemies() > 1 Spell(dire_beast)
 #dire_frenzy,if=(pet.cat.buff.dire_frenzy.remains<=gcd.max*1.2)|full_recharge_time<gcd.max|target.time_to_die<9
 if pet.BuffRemaining(pet_dire_frenzy_buff) <= GCD() * 1 or SpellFullRecharge(dire_frenzy) < GCD() or target.TimeToDie() < 9 Spell(dire_frenzy)
 #multishot,if=spell_targets>4&(pet.cat.buff.beast_cleave.remains<gcd.max|pet.cat.buff.beast_cleave.down)
 if Enemies() > 4 and { pet.BuffRemaining(pet_beast_cleave_buff) < GCD() or pet.BuffExpires(pet_beast_cleave_buff) } Spell(multishot)
 #kill_command
 if pet.Present() and not pet.IsIncapacitated() and not pet.IsFeared() and not pet.IsStunned() Spell(kill_command)
 #multishot,if=spell_targets>1&(pet.cat.buff.beast_cleave.remains<gcd.max|pet.cat.buff.beast_cleave.down)
 if Enemies() > 1 and { pet.BuffRemaining(pet_beast_cleave_buff) < GCD() or pet.BuffExpires(pet_beast_cleave_buff) } Spell(multishot)
 #chimaera_shot,if=focus<90
 if Focus() < 90 Spell(chimaera_shot)
 #cobra_shot,if=(cooldown.kill_command.remains>focus.time_to_max&cooldown.bestial_wrath.remains>focus.time_to_max)|(buff.bestial_wrath.up&(spell_targets.multishot=1|focus.regen*cooldown.kill_command.remains>action.kill_command.cost))|target.time_to_die<cooldown.kill_command.remains|(equipped.parsels_tongue&buff.parsels_tongue.remains<=gcd.max*2)
 if SpellCooldown(kill_command) > TimeToMaxFocus() and SpellCooldown(bestial_wrath) > TimeToMaxFocus() or BuffPresent(bestial_wrath_buff) and { Enemies() == 1 or FocusRegenRate() * SpellCooldown(kill_command) > PowerCost(kill_command) } or target.TimeToDie() < SpellCooldown(kill_command) or HasEquippedItem(parsels_tongue) and BuffRemaining(parsels_tongue_buff) <= GCD() * 2 Spell(cobra_shot)
 #dire_beast,if=buff.bestial_wrath.up
 if BuffPresent(bestial_wrath_buff) Spell(dire_beast)
}

AddFunction BeastmasteryDefaultMainPostConditions
{
}

AddFunction BeastmasteryDefaultShortCdActions
{
 unless CheckBoxOn(opt_volley) and Spell(volley)
 {
  #a_murder_of_crows,if=cooldown.bestial_wrath.remains<3|cooldown.bestial_wrath.remains>30|target.time_to_die<16
  if SpellCooldown(bestial_wrath) < 3 or SpellCooldown(bestial_wrath) > 30 or target.TimeToDie() < 16 Spell(a_murder_of_crows)
  #bestial_wrath,if=!buff.bestial_wrath.up
  if not BuffPresent(bestial_wrath_buff) Spell(bestial_wrath)

  unless HasEquippedItem(qapla_eredun_war_order) and pet.Present() and not pet.IsIncapacitated() and not pet.IsFeared() and not pet.IsStunned() and Spell(kill_command) or { { not HasEquippedItem(qapla_eredun_war_order) or SpellCooldown(kill_command) >= 1 } and { ArmorSetBonus(T19 2) or not BuffPresent(bestial_wrath_buff) } or SpellFullRecharge(dire_beast) < GCD() or not SpellCooldown(titans_thunder) > 0 or Enemies() > 1 } and Spell(dire_beast) or { pet.BuffRemaining(pet_dire_frenzy_buff) <= GCD() * 1 or SpellFullRecharge(dire_frenzy) < GCD() or target.TimeToDie() < 9 } and Spell(dire_frenzy)
  {
   #barrage,if=spell_targets.barrage>1
   if Enemies() > 1 Spell(barrage)
   #titans_thunder,if=(talent.dire_frenzy.enabled&(buff.bestial_wrath.up|cooldown.bestial_wrath.remains>35))|buff.bestial_wrath.up
   if Talent(dire_frenzy_talent) and { BuffPresent(bestial_wrath_buff) or SpellCooldown(bestial_wrath) > 35 } or BuffPresent(bestial_wrath_buff) Spell(titans_thunder)
  }
 }
}

AddFunction BeastmasteryDefaultShortCdPostConditions
{
 CheckBoxOn(opt_volley) and Spell(volley) or HasEquippedItem(qapla_eredun_war_order) and pet.Present() and not pet.IsIncapacitated() and not pet.IsFeared() and not pet.IsStunned() and Spell(kill_command) or { { not HasEquippedItem(qapla_eredun_war_order) or SpellCooldown(kill_command) >= 1 } and { ArmorSetBonus(T19 2) or not BuffPresent(bestial_wrath_buff) } or SpellFullRecharge(dire_beast) < GCD() or not SpellCooldown(titans_thunder) > 0 or Enemies() > 1 } and Spell(dire_beast) or { pet.BuffRemaining(pet_dire_frenzy_buff) <= GCD() * 1 or SpellFullRecharge(dire_frenzy) < GCD() or target.TimeToDie() < 9 } and Spell(dire_frenzy) or Enemies() > 4 and { pet.BuffRemaining(pet_beast_cleave_buff) < GCD() or pet.BuffExpires(pet_beast_cleave_buff) } and Spell(multishot) or pet.Present() and not pet.IsIncapacitated() and not pet.IsFeared() and not pet.IsStunned() and Spell(kill_command) or Enemies() > 1 and { pet.BuffRemaining(pet_beast_cleave_buff) < GCD() or pet.BuffExpires(pet_beast_cleave_buff) } and Spell(multishot) or Focus() < 90 and Spell(chimaera_shot) or { SpellCooldown(kill_command) > TimeToMaxFocus() and SpellCooldown(bestial_wrath) > TimeToMaxFocus() or BuffPresent(bestial_wrath_buff) and { Enemies() == 1 or FocusRegenRate() * SpellCooldown(kill_command) > PowerCost(kill_command) } or target.TimeToDie() < SpellCooldown(kill_command) or HasEquippedItem(parsels_tongue) and BuffRemaining(parsels_tongue_buff) <= GCD() * 2 } and Spell(cobra_shot) or BuffPresent(bestial_wrath_buff) and Spell(dire_beast)
}

AddFunction BeastmasteryDefaultCdActions
{
 #auto_shot
 #counter_shot,if=target.debuff.casting.react
 if target.IsInterruptible() BeastmasteryInterruptActions()
 #use_items
 BeastmasteryUseItemActions()
 #arcane_torrent,if=focus.deficit>=30
 if FocusDeficit() >= 30 Spell(arcane_torrent_focus)
 #berserking,if=buff.bestial_wrath.remains>7
 if BuffRemaining(bestial_wrath_buff) > 7 Spell(berserking)
 #blood_fury,if=buff.bestial_wrath.remains>7
 if BuffRemaining(bestial_wrath_buff) > 7 Spell(blood_fury_ap)

 unless CheckBoxOn(opt_volley) and Spell(volley)
 {
  #potion,if=buff.bestial_wrath.up&buff.aspect_of_the_wild.up
  if BuffPresent(bestial_wrath_buff) and BuffPresent(aspect_of_the_wild_buff) and CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(prolonged_power_potion usable=1)

  unless { SpellCooldown(bestial_wrath) < 3 or SpellCooldown(bestial_wrath) > 30 or target.TimeToDie() < 16 } and Spell(a_murder_of_crows)
  {
   #stampede,if=buff.bloodlust.up|buff.bestial_wrath.up|cooldown.bestial_wrath.remains<=2|target.time_to_die<=14
   if BuffPresent(burst_haste_buff any=1) or BuffPresent(bestial_wrath_buff) or SpellCooldown(bestial_wrath) <= 2 or target.TimeToDie() <= 14 Spell(stampede)

   unless not BuffPresent(bestial_wrath_buff) and Spell(bestial_wrath)
   {
    #aspect_of_the_wild,if=(equipped.call_of_the_wild&equipped.convergence_of_fates&talent.one_with_the_pack.enabled)|buff.bestial_wrath.remains>7|target.time_to_die<12
    if HasEquippedItem(call_of_the_wild) and HasEquippedItem(convergence_of_fates) and Talent(one_with_the_pack_talent) or BuffRemaining(bestial_wrath_buff) > 7 or target.TimeToDie() < 12 Spell(aspect_of_the_wild)
   }
  }
 }
}

AddFunction BeastmasteryDefaultCdPostConditions
{
 CheckBoxOn(opt_volley) and Spell(volley) or { SpellCooldown(bestial_wrath) < 3 or SpellCooldown(bestial_wrath) > 30 or target.TimeToDie() < 16 } and Spell(a_murder_of_crows) or not BuffPresent(bestial_wrath_buff) and Spell(bestial_wrath) or HasEquippedItem(qapla_eredun_war_order) and pet.Present() and not pet.IsIncapacitated() and not pet.IsFeared() and not pet.IsStunned() and Spell(kill_command) or { { not HasEquippedItem(qapla_eredun_war_order) or SpellCooldown(kill_command) >= 1 } and { ArmorSetBonus(T19 2) or not BuffPresent(bestial_wrath_buff) } or SpellFullRecharge(dire_beast) < GCD() or not SpellCooldown(titans_thunder) > 0 or Enemies() > 1 } and Spell(dire_beast) or { pet.BuffRemaining(pet_dire_frenzy_buff) <= GCD() * 1 or SpellFullRecharge(dire_frenzy) < GCD() or target.TimeToDie() < 9 } and Spell(dire_frenzy) or Enemies() > 1 and Spell(barrage) or { Talent(dire_frenzy_talent) and { BuffPresent(bestial_wrath_buff) or SpellCooldown(bestial_wrath) > 35 } or BuffPresent(bestial_wrath_buff) } and Spell(titans_thunder) or Enemies() > 4 and { pet.BuffRemaining(pet_beast_cleave_buff) < GCD() or pet.BuffExpires(pet_beast_cleave_buff) } and Spell(multishot) or pet.Present() and not pet.IsIncapacitated() and not pet.IsFeared() and not pet.IsStunned() and Spell(kill_command) or Enemies() > 1 and { pet.BuffRemaining(pet_beast_cleave_buff) < GCD() or pet.BuffExpires(pet_beast_cleave_buff) } and Spell(multishot) or Focus() < 90 and Spell(chimaera_shot) or { SpellCooldown(kill_command) > TimeToMaxFocus() and SpellCooldown(bestial_wrath) > TimeToMaxFocus() or BuffPresent(bestial_wrath_buff) and { Enemies() == 1 or FocusRegenRate() * SpellCooldown(kill_command) > PowerCost(kill_command) } or target.TimeToDie() < SpellCooldown(kill_command) or HasEquippedItem(parsels_tongue) and BuffRemaining(parsels_tongue_buff) <= GCD() * 2 } and Spell(cobra_shot) or BuffPresent(bestial_wrath_buff) and Spell(dire_beast)
}

### Beastmastery icons.

AddCheckBox(opt_hunter_beast_mastery_aoe L(AOE) default specialization=beast_mastery)

AddIcon checkbox=!opt_hunter_beast_mastery_aoe enemies=1 help=shortcd specialization=beast_mastery
{
 if not InCombat() BeastmasteryPrecombatShortCdActions()
 unless not InCombat() and BeastmasteryPrecombatShortCdPostConditions()
 {
  BeastmasteryDefaultShortCdActions()
 }
}

AddIcon checkbox=opt_hunter_beast_mastery_aoe help=shortcd specialization=beast_mastery
{
 if not InCombat() BeastmasteryPrecombatShortCdActions()
 unless not InCombat() and BeastmasteryPrecombatShortCdPostConditions()
 {
  BeastmasteryDefaultShortCdActions()
 }
}

AddIcon enemies=1 help=main specialization=beast_mastery
{
 if not InCombat() BeastmasteryPrecombatMainActions()
 unless not InCombat() and BeastmasteryPrecombatMainPostConditions()
 {
  BeastmasteryDefaultMainActions()
 }
}

AddIcon checkbox=opt_hunter_beast_mastery_aoe help=aoe specialization=beast_mastery
{
 if not InCombat() BeastmasteryPrecombatMainActions()
 unless not InCombat() and BeastmasteryPrecombatMainPostConditions()
 {
  BeastmasteryDefaultMainActions()
 }
}

AddIcon checkbox=!opt_hunter_beast_mastery_aoe enemies=1 help=cd specialization=beast_mastery
{
 if not InCombat() BeastmasteryPrecombatCdActions()
 unless not InCombat() and BeastmasteryPrecombatCdPostConditions()
 {
  BeastmasteryDefaultCdActions()
 }
}

AddIcon checkbox=opt_hunter_beast_mastery_aoe help=cd specialization=beast_mastery
{
 if not InCombat() BeastmasteryPrecombatCdActions()
 unless not InCombat() and BeastmasteryPrecombatCdPostConditions()
 {
  BeastmasteryDefaultCdActions()
 }
}

### Required symbols
# prolonged_power_potion
# arcane_torrent_focus
# berserking
# bestial_wrath_buff
# blood_fury_ap
# volley
# aspect_of_the_wild_buff
# a_murder_of_crows
# bestial_wrath
# stampede
# aspect_of_the_wild
# call_of_the_wild
# convergence_of_fates
# one_with_the_pack_talent
# kill_command
# qapla_eredun_war_order
# dire_beast
# titans_thunder
# dire_frenzy
# pet_dire_frenzy_buff
# barrage
# dire_frenzy_talent
# multishot
# pet_beast_cleave_buff
# chimaera_shot
# cobra_shot
# parsels_tongue
# parsels_tongue_buff
# revive_pet
# war_stomp
# quaking_palm
# counter_shot
]]
    OvaleScripts:RegisterScript("HUNTER", "beast_mastery", name, desc, code, "script")
end
do
    local name = "sc_hunter_marksmanship_t19"
    local desc = "[7.0] Simulationcraft: Hunter_Marksmanship_T19"
    local code = [[
# Based on SimulationCraft profile "Hunter_Marksmanship_T19P".
#	class=hunter
#	spec=marksmanship
#	talents=1303013

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_hunter_spells)


AddFunction pooling_for_piercing
{
 Talent(piercing_shot_talent) and SpellCooldown(piercing_shot) < 5 and target.DebuffRemaining(vulnerable) > 0 and target.DebuffRemaining(vulnerable) > SpellCooldown(piercing_shot) and { BuffExpires(trueshot_buff) or Enemies() == 1 }
}

AddFunction trueshot_cooldown
{
 if TimeInCombat() > 15 and not SpellCooldown(trueshot) > 0 and 0 == 0 TimeInCombat() * 1
}

AddFunction waiting_for_sentinel
{
 Talent(sentinel_talent) and { BuffPresent(marking_targets_buff) or BuffPresent(trueshot_buff) } and 0
}

AddFunction can_gcd
{
 vuln_window() < CastTime(aimed_shot) or vuln_window() > vuln_aim_casts() * ExecuteTime(aimed_shot) + GCD() + 0
}

AddFunction vuln_aim_casts
{
 if vuln_window() / ExecuteTime(aimed_shot) > 0 and vuln_window() / ExecuteTime(aimed_shot) > { Focus() + FocusCastingRegen(aimed_shot) * { vuln_window() / ExecuteTime(aimed_shot) - 1 } } / PowerCost(aimed_shot) { Focus() + FocusCastingRegen(aimed_shot) * { vuln_window() / ExecuteTime(aimed_shot) - 1 } } / PowerCost(aimed_shot)
 vuln_window() / ExecuteTime(aimed_shot)
}

AddFunction vuln_window
{
 if Talent(sidewinders_talent) and SpellCooldown(sidewinders) < 0 SpellCooldown(sidewinders)
 unless Talent(sidewinders_talent) and SpellCooldown(sidewinders) < 0 target.DebuffPresent(vulnerability_debuff)
}

AddCheckBox(opt_interrupt L(interrupt) default specialization=marksmanship)
AddCheckBox(opt_use_consumables L(opt_use_consumables) default specialization=marksmanship)
AddCheckBox(opt_volley SpellName(volley) default specialization=marksmanship)

AddFunction MarksmanshipInterruptActions
{
 if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting()
 {
  if target.Distance(less 5) and not target.Classification(worldboss) Spell(war_stomp)
  if target.InRange(quaking_palm) and not target.Classification(worldboss) Spell(quaking_palm)
  if target.Distance(less 8) and target.IsInterruptible() Spell(arcane_torrent_focus)
  if target.InRange(counter_shot) and target.IsInterruptible() Spell(counter_shot)
 }
}

AddFunction MarksmanshipUseItemActions
{
 Item(Trinket0Slot text=13 usable=1)
 Item(Trinket1Slot text=14 usable=1)
}

AddFunction MarksmanshipSummonPet
{
 if not Talent(lone_wolf_talent)
 {
  if pet.IsDead()
  {
   if not DebuffPresent(heart_of_the_phoenix_debuff) Spell(heart_of_the_phoenix)
   Spell(revive_pet)
  }
  if not pet.Present() and not pet.IsDead() and not PreviousSpell(revive_pet) Texture(ability_hunter_beastcall help=L(summon_pet))
 }
}

### actions.targetdie

AddFunction MarksmanshipTargetdieMainActions
{
 #windburst
 Spell(windburst)
 #aimed_shot,if=debuff.vulnerability.remains>cast_time&target.time_to_die>cast_time
 if target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and target.TimeToDie() > CastTime(aimed_shot) Spell(aimed_shot)
 #marked_shot
 Spell(marked_shot)
 #arcane_shot
 Spell(arcane_shot)
 #sidewinders
 Spell(sidewinders)
}

AddFunction MarksmanshipTargetdieMainPostConditions
{
}

AddFunction MarksmanshipTargetdieShortCdActions
{
 #piercing_shot,if=debuff.vulnerability.up
 if target.DebuffPresent(vulnerability_debuff) Spell(piercing_shot)
}

AddFunction MarksmanshipTargetdieShortCdPostConditions
{
 Spell(windburst) or target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and target.TimeToDie() > CastTime(aimed_shot) and Spell(aimed_shot) or Spell(marked_shot) or Spell(arcane_shot) or Spell(sidewinders)
}

AddFunction MarksmanshipTargetdieCdActions
{
}

AddFunction MarksmanshipTargetdieCdPostConditions
{
 target.DebuffPresent(vulnerability_debuff) and Spell(piercing_shot) or Spell(windburst) or target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and target.TimeToDie() > CastTime(aimed_shot) and Spell(aimed_shot) or Spell(marked_shot) or Spell(arcane_shot) or Spell(sidewinders)
}

### actions.precombat

AddFunction MarksmanshipPrecombatMainActions
{
 #windburst
 Spell(windburst)
}

AddFunction MarksmanshipPrecombatMainPostConditions
{
}

AddFunction MarksmanshipPrecombatShortCdActions
{
 #flask
 #augmentation
 #food
 #summon_pet
 MarksmanshipSummonPet()
}

AddFunction MarksmanshipPrecombatShortCdPostConditions
{
 Spell(windburst)
}

AddFunction MarksmanshipPrecombatCdActions
{
 #snapshot_stats
 #potion
 if CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(prolonged_power_potion usable=1)
}

AddFunction MarksmanshipPrecombatCdPostConditions
{
 Spell(windburst)
}

### actions.patient_sniper

AddFunction MarksmanshipPatientsniperMainActions
{
 #variable,name=vuln_window,op=setif,value=cooldown.sidewinders.full_recharge_time,value_else=debuff.vulnerability.remains,condition=talent.sidewinders.enabled&cooldown.sidewinders.full_recharge_time<variable.vuln_window
 #variable,name=vuln_aim_casts,op=set,value=floor(variable.vuln_window%action.aimed_shot.execute_time)
 #variable,name=vuln_aim_casts,op=set,value=floor((focus+action.aimed_shot.cast_regen*(variable.vuln_aim_casts-1))%action.aimed_shot.cost),if=variable.vuln_aim_casts>0&variable.vuln_aim_casts>floor((focus+action.aimed_shot.cast_regen*(variable.vuln_aim_casts-1))%action.aimed_shot.cost)
 #variable,name=can_gcd,value=variable.vuln_window<action.aimed_shot.cast_time|variable.vuln_window>variable.vuln_aim_casts*action.aimed_shot.execute_time+gcd.max+0.1
 #call_action_list,name=targetdie,if=target.time_to_die<variable.vuln_window&spell_targets.multishot=1
 if target.TimeToDie() < vuln_window() and Enemies() == 1 MarksmanshipTargetdieMainActions()

 unless target.TimeToDie() < vuln_window() and Enemies() == 1 and MarksmanshipTargetdieMainPostConditions()
 {
  #aimed_shot,if=spell_targets>1&talent.trick_shot.enabled&debuff.vulnerability.remains>cast_time&(buff.sentinels_sight.stack>=spell_targets.multishot*5|buff.sentinels_sight.stack+(spell_targets.multishot%2)>20|buff.lock_and_load.up|(set_bonus.tier20_2pc&!buff.t20_2p_critical_aimed_damage.up&action.aimed_shot.in_flight))
  if Enemies() > 1 and Talent(trick_shot_talent) and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and { BuffStacks(sentinels_sight_buff) >= Enemies() * 5 or BuffStacks(sentinels_sight_buff) + Enemies() / 2 > 20 or BuffPresent(lock_and_load_buff) or ArmorSetBonus(T20 2) and not BuffPresent(t20_2p_critical_aimed_damage_buff) and InFlightToTarget(aimed_shot) } Spell(aimed_shot)
  #marked_shot,if=spell_targets>1
  if Enemies() > 1 Spell(marked_shot)
  #multishot,if=spell_targets>1&(buff.marking_targets.up|buff.trueshot.up)
  if Enemies() > 1 and { BuffPresent(marking_targets_buff) or BuffPresent(trueshot_buff) } Spell(multishot)
  #windburst,if=variable.vuln_aim_casts<1&!variable.pooling_for_piercing
  if vuln_aim_casts() < 1 and not pooling_for_piercing() Spell(windburst)
  #black_arrow,if=variable.can_gcd&(!variable.pooling_for_piercing|(lowest_vuln_within.5>gcd.max&focus>85))
  if can_gcd() and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() and Focus() > 85 } Spell(black_arrow)
  #aimed_shot,if=debuff.vulnerability.up&buff.lock_and_load.up&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
  if target.DebuffPresent(vulnerability_debuff) and BuffPresent(lock_and_load_buff) and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } Spell(aimed_shot)
  #aimed_shot,if=spell_targets.multishot>1&debuff.vulnerability.remains>execute_time&(!variable.pooling_for_piercing|(focus>100&lowest_vuln_within.5>(execute_time+gcd.max)))
  if Enemies() > 1 and target.DebuffRemaining(vulnerability_debuff) > ExecuteTime(aimed_shot) and { not pooling_for_piercing() or Focus() > 100 and target.DebuffRemaining(vulnerable) > ExecuteTime(aimed_shot) + GCD() } Spell(aimed_shot)
  #multishot,if=spell_targets>1&variable.can_gcd&focus+cast_regen+action.aimed_shot.cast_regen<focus.max&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
  if Enemies() > 1 and can_gcd() and Focus() + FocusCastingRegen(multishot) + FocusCastingRegen(aimed_shot) < MaxFocus() and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } Spell(multishot)
  #arcane_shot,if=spell_targets.multishot=1&(!set_bonus.tier20_2pc|!action.aimed_shot.in_flight|buff.t20_2p_critical_aimed_damage.remains>action.aimed_shot.execute_time+gcd)&variable.vuln_aim_casts>0&variable.can_gcd&focus+cast_regen+action.aimed_shot.cast_regen<focus.max&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd)
  if Enemies() == 1 and { not ArmorSetBonus(T20 2) or not InFlightToTarget(aimed_shot) or BuffRemaining(t20_2p_critical_aimed_damage_buff) > ExecuteTime(aimed_shot) + GCD() } and vuln_aim_casts() > 0 and can_gcd() and Focus() + FocusCastingRegen(arcane_shot) + FocusCastingRegen(aimed_shot) < MaxFocus() and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } Spell(arcane_shot)
  #aimed_shot,if=talent.sidewinders.enabled&(debuff.vulnerability.remains>cast_time|(buff.lock_and_load.down&action.windburst.in_flight))&(variable.vuln_window-(execute_time*variable.vuln_aim_casts)<1|focus.deficit<25|buff.trueshot.up)&(spell_targets.multishot=1|focus>100)
  if Talent(sidewinders_talent) and { target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) or BuffExpires(lock_and_load_buff) and InFlightToTarget(windburst) } and { vuln_window() - ExecuteTime(aimed_shot) * vuln_aim_casts() < 1 or FocusDeficit() < 25 or BuffPresent(trueshot_buff) } and { Enemies() == 1 or Focus() > 100 } Spell(aimed_shot)
  #aimed_shot,if=!talent.sidewinders.enabled&debuff.vulnerability.remains>cast_time&(!variable.pooling_for_piercing|lowest_vuln_within.5>execute_time+gcd.max)
  if not Talent(sidewinders_talent) and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > ExecuteTime(aimed_shot) + GCD() } Spell(aimed_shot)
  #marked_shot,if=!talent.sidewinders.enabled&!variable.pooling_for_piercing&!action.windburst.in_flight&(focus>65|buff.trueshot.up|(1%attack_haste)>1.171)
  if not Talent(sidewinders_talent) and not pooling_for_piercing() and not InFlightToTarget(windburst) and { Focus() > 65 or BuffPresent(trueshot_buff) or 1 / { 100 / { 100 + MeleeHaste() } } > 1 } Spell(marked_shot)
  #marked_shot,if=talent.sidewinders.enabled&(variable.vuln_aim_casts<1|buff.trueshot.up|variable.vuln_window<action.aimed_shot.cast_time)
  if Talent(sidewinders_talent) and { vuln_aim_casts() < 1 or BuffPresent(trueshot_buff) or vuln_window() < CastTime(aimed_shot) } Spell(marked_shot)
  #aimed_shot,if=focus+cast_regen>focus.max&!buff.sentinels_sight.up
  if Focus() + FocusCastingRegen(aimed_shot) > MaxFocus() and not BuffPresent(sentinels_sight_buff) Spell(aimed_shot)
  #sidewinders,if=(!debuff.hunters_mark.up|(!buff.marking_targets.up&!buff.trueshot.up))&((buff.marking_targets.up&variable.vuln_aim_casts<1)|buff.trueshot.up|charges_fractional>1.9)
  if { not target.DebuffPresent(hunters_mark_debuff) or not BuffPresent(marking_targets_buff) and not BuffPresent(trueshot_buff) } and { BuffPresent(marking_targets_buff) and vuln_aim_casts() < 1 or BuffPresent(trueshot_buff) or Charges(sidewinders count=0) > 1 } Spell(sidewinders)
  #arcane_shot,if=spell_targets.multishot=1&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
  if Enemies() == 1 and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } Spell(arcane_shot)
  #multishot,if=spell_targets>1&(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)
  if Enemies() > 1 and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } Spell(multishot)
 }
}

AddFunction MarksmanshipPatientsniperMainPostConditions
{
 target.TimeToDie() < vuln_window() and Enemies() == 1 and MarksmanshipTargetdieMainPostConditions()
}

AddFunction MarksmanshipPatientsniperShortCdActions
{
 #variable,name=vuln_window,op=setif,value=cooldown.sidewinders.full_recharge_time,value_else=debuff.vulnerability.remains,condition=talent.sidewinders.enabled&cooldown.sidewinders.full_recharge_time<variable.vuln_window
 #variable,name=vuln_aim_casts,op=set,value=floor(variable.vuln_window%action.aimed_shot.execute_time)
 #variable,name=vuln_aim_casts,op=set,value=floor((focus+action.aimed_shot.cast_regen*(variable.vuln_aim_casts-1))%action.aimed_shot.cost),if=variable.vuln_aim_casts>0&variable.vuln_aim_casts>floor((focus+action.aimed_shot.cast_regen*(variable.vuln_aim_casts-1))%action.aimed_shot.cost)
 #variable,name=can_gcd,value=variable.vuln_window<action.aimed_shot.cast_time|variable.vuln_window>variable.vuln_aim_casts*action.aimed_shot.execute_time+gcd.max+0.1
 #call_action_list,name=targetdie,if=target.time_to_die<variable.vuln_window&spell_targets.multishot=1
 if target.TimeToDie() < vuln_window() and Enemies() == 1 MarksmanshipTargetdieShortCdActions()

 unless target.TimeToDie() < vuln_window() and Enemies() == 1 and MarksmanshipTargetdieShortCdPostConditions()
 {
  #piercing_shot,if=cooldown.piercing_shot.up&spell_targets=1&lowest_vuln_within.5>0&lowest_vuln_within.5<1
  if not SpellCooldown(piercing_shot) > 0 and Enemies() == 1 and target.DebuffRemaining(vulnerable) > 0 and target.DebuffRemaining(vulnerable) < 1 Spell(piercing_shot)
  #piercing_shot,if=cooldown.piercing_shot.up&spell_targets>1&lowest_vuln_within.5>0&((!buff.trueshot.up&focus>80&(lowest_vuln_within.5<1|debuff.hunters_mark.up))|(buff.trueshot.up&focus>105&lowest_vuln_within.5<6))
  if not SpellCooldown(piercing_shot) > 0 and Enemies() > 1 and target.DebuffRemaining(vulnerable) > 0 and { not BuffPresent(trueshot_buff) and Focus() > 80 and { target.DebuffRemaining(vulnerable) < 1 or target.DebuffPresent(hunters_mark_debuff) } or BuffPresent(trueshot_buff) and Focus() > 105 and target.DebuffRemaining(vulnerable) < 6 } Spell(piercing_shot)

  unless Enemies() > 1 and Talent(trick_shot_talent) and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and { BuffStacks(sentinels_sight_buff) >= Enemies() * 5 or BuffStacks(sentinels_sight_buff) + Enemies() / 2 > 20 or BuffPresent(lock_and_load_buff) or ArmorSetBonus(T20 2) and not BuffPresent(t20_2p_critical_aimed_damage_buff) and InFlightToTarget(aimed_shot) } and Spell(aimed_shot) or Enemies() > 1 and Spell(marked_shot) or Enemies() > 1 and { BuffPresent(marking_targets_buff) or BuffPresent(trueshot_buff) } and Spell(multishot) or vuln_aim_casts() < 1 and not pooling_for_piercing() and Spell(windburst) or can_gcd() and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() and Focus() > 85 } and Spell(black_arrow)
  {
   #a_murder_of_crows,if=(!variable.pooling_for_piercing|lowest_vuln_within.5>gcd.max)&(target.time_to_die>=cooldown+duration|target.health.pct<20|target.time_to_die<16)&variable.vuln_aim_casts=0
   if { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } and { target.TimeToDie() >= SpellCooldown(a_murder_of_crows) + BaseDuration(a_murder_of_crows_debuff) or target.HealthPercent() < 20 or target.TimeToDie() < 16 } and vuln_aim_casts() == 0 Spell(a_murder_of_crows)
   #barrage,if=spell_targets>2|(target.health.pct<20&buff.bullseye.stack<25)
   if Enemies() > 2 or target.HealthPercent() < 20 and BuffStacks(bullseye_buff) < 25 Spell(barrage)
  }
 }
}

AddFunction MarksmanshipPatientsniperShortCdPostConditions
{
 target.TimeToDie() < vuln_window() and Enemies() == 1 and MarksmanshipTargetdieShortCdPostConditions() or Enemies() > 1 and Talent(trick_shot_talent) and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and { BuffStacks(sentinels_sight_buff) >= Enemies() * 5 or BuffStacks(sentinels_sight_buff) + Enemies() / 2 > 20 or BuffPresent(lock_and_load_buff) or ArmorSetBonus(T20 2) and not BuffPresent(t20_2p_critical_aimed_damage_buff) and InFlightToTarget(aimed_shot) } and Spell(aimed_shot) or Enemies() > 1 and Spell(marked_shot) or Enemies() > 1 and { BuffPresent(marking_targets_buff) or BuffPresent(trueshot_buff) } and Spell(multishot) or vuln_aim_casts() < 1 and not pooling_for_piercing() and Spell(windburst) or can_gcd() and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() and Focus() > 85 } and Spell(black_arrow) or target.DebuffPresent(vulnerability_debuff) and BuffPresent(lock_and_load_buff) and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } and Spell(aimed_shot) or Enemies() > 1 and target.DebuffRemaining(vulnerability_debuff) > ExecuteTime(aimed_shot) and { not pooling_for_piercing() or Focus() > 100 and target.DebuffRemaining(vulnerable) > ExecuteTime(aimed_shot) + GCD() } and Spell(aimed_shot) or Enemies() > 1 and can_gcd() and Focus() + FocusCastingRegen(multishot) + FocusCastingRegen(aimed_shot) < MaxFocus() and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } and Spell(multishot) or Enemies() == 1 and { not ArmorSetBonus(T20 2) or not InFlightToTarget(aimed_shot) or BuffRemaining(t20_2p_critical_aimed_damage_buff) > ExecuteTime(aimed_shot) + GCD() } and vuln_aim_casts() > 0 and can_gcd() and Focus() + FocusCastingRegen(arcane_shot) + FocusCastingRegen(aimed_shot) < MaxFocus() and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } and Spell(arcane_shot) or Talent(sidewinders_talent) and { target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) or BuffExpires(lock_and_load_buff) and InFlightToTarget(windburst) } and { vuln_window() - ExecuteTime(aimed_shot) * vuln_aim_casts() < 1 or FocusDeficit() < 25 or BuffPresent(trueshot_buff) } and { Enemies() == 1 or Focus() > 100 } and Spell(aimed_shot) or not Talent(sidewinders_talent) and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > ExecuteTime(aimed_shot) + GCD() } and Spell(aimed_shot) or not Talent(sidewinders_talent) and not pooling_for_piercing() and not InFlightToTarget(windburst) and { Focus() > 65 or BuffPresent(trueshot_buff) or 1 / { 100 / { 100 + MeleeHaste() } } > 1 } and Spell(marked_shot) or Talent(sidewinders_talent) and { vuln_aim_casts() < 1 or BuffPresent(trueshot_buff) or vuln_window() < CastTime(aimed_shot) } and Spell(marked_shot) or Focus() + FocusCastingRegen(aimed_shot) > MaxFocus() and not BuffPresent(sentinels_sight_buff) and Spell(aimed_shot) or { not target.DebuffPresent(hunters_mark_debuff) or not BuffPresent(marking_targets_buff) and not BuffPresent(trueshot_buff) } and { BuffPresent(marking_targets_buff) and vuln_aim_casts() < 1 or BuffPresent(trueshot_buff) or Charges(sidewinders count=0) > 1 } and Spell(sidewinders) or Enemies() == 1 and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } and Spell(arcane_shot) or Enemies() > 1 and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } and Spell(multishot)
}

AddFunction MarksmanshipPatientsniperCdActions
{
 #variable,name=vuln_window,op=setif,value=cooldown.sidewinders.full_recharge_time,value_else=debuff.vulnerability.remains,condition=talent.sidewinders.enabled&cooldown.sidewinders.full_recharge_time<variable.vuln_window
 #variable,name=vuln_aim_casts,op=set,value=floor(variable.vuln_window%action.aimed_shot.execute_time)
 #variable,name=vuln_aim_casts,op=set,value=floor((focus+action.aimed_shot.cast_regen*(variable.vuln_aim_casts-1))%action.aimed_shot.cost),if=variable.vuln_aim_casts>0&variable.vuln_aim_casts>floor((focus+action.aimed_shot.cast_regen*(variable.vuln_aim_casts-1))%action.aimed_shot.cost)
 #variable,name=can_gcd,value=variable.vuln_window<action.aimed_shot.cast_time|variable.vuln_window>variable.vuln_aim_casts*action.aimed_shot.execute_time+gcd.max+0.1
 #call_action_list,name=targetdie,if=target.time_to_die<variable.vuln_window&spell_targets.multishot=1
 if target.TimeToDie() < vuln_window() and Enemies() == 1 MarksmanshipTargetdieCdActions()
}

AddFunction MarksmanshipPatientsniperCdPostConditions
{
 target.TimeToDie() < vuln_window() and Enemies() == 1 and MarksmanshipTargetdieCdPostConditions() or not SpellCooldown(piercing_shot) > 0 and Enemies() == 1 and target.DebuffRemaining(vulnerable) > 0 and target.DebuffRemaining(vulnerable) < 1 and Spell(piercing_shot) or not SpellCooldown(piercing_shot) > 0 and Enemies() > 1 and target.DebuffRemaining(vulnerable) > 0 and { not BuffPresent(trueshot_buff) and Focus() > 80 and { target.DebuffRemaining(vulnerable) < 1 or target.DebuffPresent(hunters_mark_debuff) } or BuffPresent(trueshot_buff) and Focus() > 105 and target.DebuffRemaining(vulnerable) < 6 } and Spell(piercing_shot) or Enemies() > 1 and Talent(trick_shot_talent) and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and { BuffStacks(sentinels_sight_buff) >= Enemies() * 5 or BuffStacks(sentinels_sight_buff) + Enemies() / 2 > 20 or BuffPresent(lock_and_load_buff) or ArmorSetBonus(T20 2) and not BuffPresent(t20_2p_critical_aimed_damage_buff) and InFlightToTarget(aimed_shot) } and Spell(aimed_shot) or Enemies() > 1 and Spell(marked_shot) or Enemies() > 1 and { BuffPresent(marking_targets_buff) or BuffPresent(trueshot_buff) } and Spell(multishot) or vuln_aim_casts() < 1 and not pooling_for_piercing() and Spell(windburst) or can_gcd() and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() and Focus() > 85 } and Spell(black_arrow) or { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } and { target.TimeToDie() >= SpellCooldown(a_murder_of_crows) + BaseDuration(a_murder_of_crows_debuff) or target.HealthPercent() < 20 or target.TimeToDie() < 16 } and vuln_aim_casts() == 0 and Spell(a_murder_of_crows) or { Enemies() > 2 or target.HealthPercent() < 20 and BuffStacks(bullseye_buff) < 25 } and Spell(barrage) or target.DebuffPresent(vulnerability_debuff) and BuffPresent(lock_and_load_buff) and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } and Spell(aimed_shot) or Enemies() > 1 and target.DebuffRemaining(vulnerability_debuff) > ExecuteTime(aimed_shot) and { not pooling_for_piercing() or Focus() > 100 and target.DebuffRemaining(vulnerable) > ExecuteTime(aimed_shot) + GCD() } and Spell(aimed_shot) or Enemies() > 1 and can_gcd() and Focus() + FocusCastingRegen(multishot) + FocusCastingRegen(aimed_shot) < MaxFocus() and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } and Spell(multishot) or Enemies() == 1 and { not ArmorSetBonus(T20 2) or not InFlightToTarget(aimed_shot) or BuffRemaining(t20_2p_critical_aimed_damage_buff) > ExecuteTime(aimed_shot) + GCD() } and vuln_aim_casts() > 0 and can_gcd() and Focus() + FocusCastingRegen(arcane_shot) + FocusCastingRegen(aimed_shot) < MaxFocus() and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } and Spell(arcane_shot) or Talent(sidewinders_talent) and { target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) or BuffExpires(lock_and_load_buff) and InFlightToTarget(windburst) } and { vuln_window() - ExecuteTime(aimed_shot) * vuln_aim_casts() < 1 or FocusDeficit() < 25 or BuffPresent(trueshot_buff) } and { Enemies() == 1 or Focus() > 100 } and Spell(aimed_shot) or not Talent(sidewinders_talent) and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > ExecuteTime(aimed_shot) + GCD() } and Spell(aimed_shot) or not Talent(sidewinders_talent) and not pooling_for_piercing() and not InFlightToTarget(windburst) and { Focus() > 65 or BuffPresent(trueshot_buff) or 1 / { 100 / { 100 + MeleeHaste() } } > 1 } and Spell(marked_shot) or Talent(sidewinders_talent) and { vuln_aim_casts() < 1 or BuffPresent(trueshot_buff) or vuln_window() < CastTime(aimed_shot) } and Spell(marked_shot) or Focus() + FocusCastingRegen(aimed_shot) > MaxFocus() and not BuffPresent(sentinels_sight_buff) and Spell(aimed_shot) or { not target.DebuffPresent(hunters_mark_debuff) or not BuffPresent(marking_targets_buff) and not BuffPresent(trueshot_buff) } and { BuffPresent(marking_targets_buff) and vuln_aim_casts() < 1 or BuffPresent(trueshot_buff) or Charges(sidewinders count=0) > 1 } and Spell(sidewinders) or Enemies() == 1 and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } and Spell(arcane_shot) or Enemies() > 1 and { not pooling_for_piercing() or target.DebuffRemaining(vulnerable) > GCD() } and Spell(multishot)
}

### actions.non_patient_sniper

AddFunction MarksmanshipNonpatientsniperMainActions
{
 #aimed_shot,if=spell_targets>1&debuff.vulnerability.remains>cast_time&(talent.trick_shot.enabled|buff.lock_and_load.up)&buff.sentinels_sight.stack=20
 if Enemies() > 1 and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and { Talent(trick_shot_talent) or BuffPresent(lock_and_load_buff) } and BuffStacks(sentinels_sight_buff) == 20 Spell(aimed_shot)
 #aimed_shot,if=spell_targets>1&debuff.vulnerability.remains>cast_time&talent.trick_shot.enabled&set_bonus.tier20_2pc&!buff.t20_2p_critical_aimed_damage.up&action.aimed_shot.in_flight
 if Enemies() > 1 and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and Talent(trick_shot_talent) and ArmorSetBonus(T20 2) and not BuffPresent(t20_2p_critical_aimed_damage_buff) and InFlightToTarget(aimed_shot) Spell(aimed_shot)
 #marked_shot,if=spell_targets>1
 if Enemies() > 1 Spell(marked_shot)
 #multishot,if=spell_targets>1&(buff.marking_targets.up|buff.trueshot.up)
 if Enemies() > 1 and { BuffPresent(marking_targets_buff) or BuffPresent(trueshot_buff) } Spell(multishot)
 #black_arrow,if=talent.sidewinders.enabled|spell_targets.multishot<6
 if Talent(sidewinders_talent) or Enemies() < 6 Spell(black_arrow)
 #windburst
 Spell(windburst)
 #marked_shot,if=buff.marking_targets.up|buff.trueshot.up
 if BuffPresent(marking_targets_buff) or BuffPresent(trueshot_buff) Spell(marked_shot)
 #sidewinders,if=!variable.waiting_for_sentinel&(debuff.hunters_mark.down|(buff.trueshot.down&buff.marking_targets.down))&((buff.marking_targets.up|buff.trueshot.up)|charges_fractional>1.8)&(focus.deficit>cast_regen)
 if not waiting_for_sentinel() and { target.DebuffExpires(hunters_mark_debuff) or BuffExpires(trueshot_buff) and BuffExpires(marking_targets_buff) } and { BuffPresent(marking_targets_buff) or BuffPresent(trueshot_buff) or Charges(sidewinders count=0) > 1 } and FocusDeficit() > FocusCastingRegen(sidewinders) Spell(sidewinders)
 #aimed_shot,if=talent.sidewinders.enabled&debuff.vulnerability.remains>cast_time
 if Talent(sidewinders_talent) and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) Spell(aimed_shot)
 #aimed_shot,if=!talent.sidewinders.enabled&debuff.vulnerability.remains>cast_time&(!variable.pooling_for_piercing|(buff.lock_and_load.up&lowest_vuln_within.5>gcd.max))&(talent.trick_shot.enabled|buff.sentinels_sight.stack=20)
 if not Talent(sidewinders_talent) and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and { not pooling_for_piercing() or BuffPresent(lock_and_load_buff) and target.DebuffRemaining(vulnerable) > GCD() } and { Talent(trick_shot_talent) or BuffStacks(sentinels_sight_buff) == 20 } Spell(aimed_shot)
 #marked_shot
 Spell(marked_shot)
 #aimed_shot,if=focus+cast_regen>focus.max&!buff.sentinels_sight.up
 if Focus() + FocusCastingRegen(aimed_shot) > MaxFocus() and not BuffPresent(sentinels_sight_buff) Spell(aimed_shot)
 #multishot,if=spell_targets.multishot>1&!variable.waiting_for_sentinel
 if Enemies() > 1 and not waiting_for_sentinel() Spell(multishot)
 #arcane_shot,if=spell_targets.multishot=1&!variable.waiting_for_sentinel
 if Enemies() == 1 and not waiting_for_sentinel() Spell(arcane_shot)
}

AddFunction MarksmanshipNonpatientsniperMainPostConditions
{
}

AddFunction MarksmanshipNonpatientsniperShortCdActions
{
 #variable,name=waiting_for_sentinel,value=talent.sentinel.enabled&(buff.marking_targets.up|buff.trueshot.up)&action.sentinel.marks_next_gcd
 #explosive_shot
 Spell(explosive_shot)
 #piercing_shot,if=lowest_vuln_within.5>0&focus>100
 if target.DebuffRemaining(vulnerable) > 0 and Focus() > 100 Spell(piercing_shot)

 unless Enemies() > 1 and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and { Talent(trick_shot_talent) or BuffPresent(lock_and_load_buff) } and BuffStacks(sentinels_sight_buff) == 20 and Spell(aimed_shot) or Enemies() > 1 and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and Talent(trick_shot_talent) and ArmorSetBonus(T20 2) and not BuffPresent(t20_2p_critical_aimed_damage_buff) and InFlightToTarget(aimed_shot) and Spell(aimed_shot) or Enemies() > 1 and Spell(marked_shot) or Enemies() > 1 and { BuffPresent(marking_targets_buff) or BuffPresent(trueshot_buff) } and Spell(multishot)
 {
  #sentinel,if=!debuff.hunters_mark.up
  if not target.DebuffPresent(hunters_mark_debuff) Spell(sentinel)

  unless { Talent(sidewinders_talent) or Enemies() < 6 } and Spell(black_arrow)
  {
   #a_murder_of_crows,if=target.time_to_die>=cooldown+duration|target.health.pct<20
   if target.TimeToDie() >= SpellCooldown(a_murder_of_crows) + BaseDuration(a_murder_of_crows_debuff) or target.HealthPercent() < 20 Spell(a_murder_of_crows)

   unless Spell(windburst)
   {
    #barrage,if=spell_targets>2|(target.health.pct<20&buff.bullseye.stack<25)
    if Enemies() > 2 or target.HealthPercent() < 20 and BuffStacks(bullseye_buff) < 25 Spell(barrage)
   }
  }
 }
}

AddFunction MarksmanshipNonpatientsniperShortCdPostConditions
{
 Enemies() > 1 and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and { Talent(trick_shot_talent) or BuffPresent(lock_and_load_buff) } and BuffStacks(sentinels_sight_buff) == 20 and Spell(aimed_shot) or Enemies() > 1 and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and Talent(trick_shot_talent) and ArmorSetBonus(T20 2) and not BuffPresent(t20_2p_critical_aimed_damage_buff) and InFlightToTarget(aimed_shot) and Spell(aimed_shot) or Enemies() > 1 and Spell(marked_shot) or Enemies() > 1 and { BuffPresent(marking_targets_buff) or BuffPresent(trueshot_buff) } and Spell(multishot) or { Talent(sidewinders_talent) or Enemies() < 6 } and Spell(black_arrow) or Spell(windburst) or { BuffPresent(marking_targets_buff) or BuffPresent(trueshot_buff) } and Spell(marked_shot) or not waiting_for_sentinel() and { target.DebuffExpires(hunters_mark_debuff) or BuffExpires(trueshot_buff) and BuffExpires(marking_targets_buff) } and { BuffPresent(marking_targets_buff) or BuffPresent(trueshot_buff) or Charges(sidewinders count=0) > 1 } and FocusDeficit() > FocusCastingRegen(sidewinders) and Spell(sidewinders) or Talent(sidewinders_talent) and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and Spell(aimed_shot) or not Talent(sidewinders_talent) and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and { not pooling_for_piercing() or BuffPresent(lock_and_load_buff) and target.DebuffRemaining(vulnerable) > GCD() } and { Talent(trick_shot_talent) or BuffStacks(sentinels_sight_buff) == 20 } and Spell(aimed_shot) or Spell(marked_shot) or Focus() + FocusCastingRegen(aimed_shot) > MaxFocus() and not BuffPresent(sentinels_sight_buff) and Spell(aimed_shot) or Enemies() > 1 and not waiting_for_sentinel() and Spell(multishot) or Enemies() == 1 and not waiting_for_sentinel() and Spell(arcane_shot)
}

AddFunction MarksmanshipNonpatientsniperCdActions
{
}

AddFunction MarksmanshipNonpatientsniperCdPostConditions
{
 Spell(explosive_shot) or target.DebuffRemaining(vulnerable) > 0 and Focus() > 100 and Spell(piercing_shot) or Enemies() > 1 and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and { Talent(trick_shot_talent) or BuffPresent(lock_and_load_buff) } and BuffStacks(sentinels_sight_buff) == 20 and Spell(aimed_shot) or Enemies() > 1 and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and Talent(trick_shot_talent) and ArmorSetBonus(T20 2) and not BuffPresent(t20_2p_critical_aimed_damage_buff) and InFlightToTarget(aimed_shot) and Spell(aimed_shot) or Enemies() > 1 and Spell(marked_shot) or Enemies() > 1 and { BuffPresent(marking_targets_buff) or BuffPresent(trueshot_buff) } and Spell(multishot) or not target.DebuffPresent(hunters_mark_debuff) and Spell(sentinel) or { Talent(sidewinders_talent) or Enemies() < 6 } and Spell(black_arrow) or { target.TimeToDie() >= SpellCooldown(a_murder_of_crows) + BaseDuration(a_murder_of_crows_debuff) or target.HealthPercent() < 20 } and Spell(a_murder_of_crows) or Spell(windburst) or { Enemies() > 2 or target.HealthPercent() < 20 and BuffStacks(bullseye_buff) < 25 } and Spell(barrage) or { BuffPresent(marking_targets_buff) or BuffPresent(trueshot_buff) } and Spell(marked_shot) or not waiting_for_sentinel() and { target.DebuffExpires(hunters_mark_debuff) or BuffExpires(trueshot_buff) and BuffExpires(marking_targets_buff) } and { BuffPresent(marking_targets_buff) or BuffPresent(trueshot_buff) or Charges(sidewinders count=0) > 1 } and FocusDeficit() > FocusCastingRegen(sidewinders) and Spell(sidewinders) or Talent(sidewinders_talent) and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and Spell(aimed_shot) or not Talent(sidewinders_talent) and target.DebuffRemaining(vulnerability_debuff) > CastTime(aimed_shot) and { not pooling_for_piercing() or BuffPresent(lock_and_load_buff) and target.DebuffRemaining(vulnerable) > GCD() } and { Talent(trick_shot_talent) or BuffStacks(sentinels_sight_buff) == 20 } and Spell(aimed_shot) or Spell(marked_shot) or Focus() + FocusCastingRegen(aimed_shot) > MaxFocus() and not BuffPresent(sentinels_sight_buff) and Spell(aimed_shot) or Enemies() > 1 and not waiting_for_sentinel() and Spell(multishot) or Enemies() == 1 and not waiting_for_sentinel() and Spell(arcane_shot)
}

### actions.cooldowns

AddFunction MarksmanshipCooldownsMainActions
{
}

AddFunction MarksmanshipCooldownsMainPostConditions
{
}

AddFunction MarksmanshipCooldownsShortCdActions
{
}

AddFunction MarksmanshipCooldownsShortCdPostConditions
{
}

AddFunction MarksmanshipCooldownsCdActions
{
 #arcane_torrent,if=focus.deficit>=30&(!talent.sidewinders.enabled|cooldown.sidewinders.charges<2)
 if FocusDeficit() >= 30 and { not Talent(sidewinders_talent) or SpellCharges(sidewinders) < 2 } Spell(arcane_torrent_focus)
 #berserking,if=buff.trueshot.up
 if BuffPresent(trueshot_buff) Spell(berserking)
 #blood_fury,if=buff.trueshot.up
 if BuffPresent(trueshot_buff) Spell(blood_fury_ap)
 #potion,if=(buff.trueshot.react&buff.bloodlust.react)|buff.bullseye.react>=23|((consumable.prolonged_power&target.time_to_die<62)|target.time_to_die<31)
 if { BuffPresent(trueshot_buff) and BuffPresent(burst_haste_buff any=1) or BuffStacks(bullseye_buff) >= 23 or BuffPresent(prolonged_power_buff) and target.TimeToDie() < 62 or target.TimeToDie() < 31 } and CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(prolonged_power_potion usable=1)
 #variable,name=trueshot_cooldown,op=set,value=time*1.1,if=time>15&cooldown.trueshot.up&variable.trueshot_cooldown=0
 #trueshot,if=variable.trueshot_cooldown=0|buff.bloodlust.up|(variable.trueshot_cooldown>0&target.time_to_die>(variable.trueshot_cooldown+duration))|buff.bullseye.react>25|target.time_to_die<16
 if trueshot_cooldown() == 0 or BuffPresent(burst_haste_buff any=1) or trueshot_cooldown() > 0 and target.TimeToDie() > trueshot_cooldown() + BaseDuration(trueshot_buff) or BuffStacks(bullseye_buff) > 25 or target.TimeToDie() < 16 Spell(trueshot)
}

AddFunction MarksmanshipCooldownsCdPostConditions
{
}

### actions.default

AddFunction MarksmanshipDefaultMainActions
{
 #volley,toggle=on
 if CheckBoxOn(opt_volley) Spell(volley)
 #variable,name=pooling_for_piercing,value=talent.piercing_shot.enabled&cooldown.piercing_shot.remains<5&lowest_vuln_within.5>0&lowest_vuln_within.5>cooldown.piercing_shot.remains&(buff.trueshot.down|spell_targets=1)
 #call_action_list,name=cooldowns
 MarksmanshipCooldownsMainActions()

 unless MarksmanshipCooldownsMainPostConditions()
 {
  #call_action_list,name=patient_sniper,if=talent.patient_sniper.enabled
  if Talent(patient_sniper_talent) MarksmanshipPatientsniperMainActions()

  unless Talent(patient_sniper_talent) and MarksmanshipPatientsniperMainPostConditions()
  {
   #call_action_list,name=non_patient_sniper,if=!talent.patient_sniper.enabled
   if not Talent(patient_sniper_talent) MarksmanshipNonpatientsniperMainActions()
  }
 }
}

AddFunction MarksmanshipDefaultMainPostConditions
{
 MarksmanshipCooldownsMainPostConditions() or Talent(patient_sniper_talent) and MarksmanshipPatientsniperMainPostConditions() or not Talent(patient_sniper_talent) and MarksmanshipNonpatientsniperMainPostConditions()
}

AddFunction MarksmanshipDefaultShortCdActions
{
 unless CheckBoxOn(opt_volley) and Spell(volley)
 {
  #variable,name=pooling_for_piercing,value=talent.piercing_shot.enabled&cooldown.piercing_shot.remains<5&lowest_vuln_within.5>0&lowest_vuln_within.5>cooldown.piercing_shot.remains&(buff.trueshot.down|spell_targets=1)
  #call_action_list,name=cooldowns
  MarksmanshipCooldownsShortCdActions()

  unless MarksmanshipCooldownsShortCdPostConditions()
  {
   #call_action_list,name=patient_sniper,if=talent.patient_sniper.enabled
   if Talent(patient_sniper_talent) MarksmanshipPatientsniperShortCdActions()

   unless Talent(patient_sniper_talent) and MarksmanshipPatientsniperShortCdPostConditions()
   {
    #call_action_list,name=non_patient_sniper,if=!talent.patient_sniper.enabled
    if not Talent(patient_sniper_talent) MarksmanshipNonpatientsniperShortCdActions()
   }
  }
 }
}

AddFunction MarksmanshipDefaultShortCdPostConditions
{
 CheckBoxOn(opt_volley) and Spell(volley) or MarksmanshipCooldownsShortCdPostConditions() or Talent(patient_sniper_talent) and MarksmanshipPatientsniperShortCdPostConditions() or not Talent(patient_sniper_talent) and MarksmanshipNonpatientsniperShortCdPostConditions()
}

AddFunction MarksmanshipDefaultCdActions
{
 #auto_shot
 #counter_shot,if=target.debuff.casting.react
 if target.IsInterruptible() MarksmanshipInterruptActions()
 #use_items
 MarksmanshipUseItemActions()

 unless CheckBoxOn(opt_volley) and Spell(volley)
 {
  #variable,name=pooling_for_piercing,value=talent.piercing_shot.enabled&cooldown.piercing_shot.remains<5&lowest_vuln_within.5>0&lowest_vuln_within.5>cooldown.piercing_shot.remains&(buff.trueshot.down|spell_targets=1)
  #call_action_list,name=cooldowns
  MarksmanshipCooldownsCdActions()

  unless MarksmanshipCooldownsCdPostConditions()
  {
   #call_action_list,name=patient_sniper,if=talent.patient_sniper.enabled
   if Talent(patient_sniper_talent) MarksmanshipPatientsniperCdActions()

   unless Talent(patient_sniper_talent) and MarksmanshipPatientsniperCdPostConditions()
   {
    #call_action_list,name=non_patient_sniper,if=!talent.patient_sniper.enabled
    if not Talent(patient_sniper_talent) MarksmanshipNonpatientsniperCdActions()
   }
  }
 }
}

AddFunction MarksmanshipDefaultCdPostConditions
{
 CheckBoxOn(opt_volley) and Spell(volley) or MarksmanshipCooldownsCdPostConditions() or Talent(patient_sniper_talent) and MarksmanshipPatientsniperCdPostConditions() or not Talent(patient_sniper_talent) and MarksmanshipNonpatientsniperCdPostConditions()
}

### Marksmanship icons.

AddCheckBox(opt_hunter_marksmanship_aoe L(AOE) default specialization=marksmanship)

AddIcon checkbox=!opt_hunter_marksmanship_aoe enemies=1 help=shortcd specialization=marksmanship
{
 if not InCombat() MarksmanshipPrecombatShortCdActions()
 unless not InCombat() and MarksmanshipPrecombatShortCdPostConditions()
 {
  MarksmanshipDefaultShortCdActions()
 }
}

AddIcon checkbox=opt_hunter_marksmanship_aoe help=shortcd specialization=marksmanship
{
 if not InCombat() MarksmanshipPrecombatShortCdActions()
 unless not InCombat() and MarksmanshipPrecombatShortCdPostConditions()
 {
  MarksmanshipDefaultShortCdActions()
 }
}

AddIcon enemies=1 help=main specialization=marksmanship
{
 if not InCombat() MarksmanshipPrecombatMainActions()
 unless not InCombat() and MarksmanshipPrecombatMainPostConditions()
 {
  MarksmanshipDefaultMainActions()
 }
}

AddIcon checkbox=opt_hunter_marksmanship_aoe help=aoe specialization=marksmanship
{
 if not InCombat() MarksmanshipPrecombatMainActions()
 unless not InCombat() and MarksmanshipPrecombatMainPostConditions()
 {
  MarksmanshipDefaultMainActions()
 }
}

AddIcon checkbox=!opt_hunter_marksmanship_aoe enemies=1 help=cd specialization=marksmanship
{
 if not InCombat() MarksmanshipPrecombatCdActions()
 unless not InCombat() and MarksmanshipPrecombatCdPostConditions()
 {
  MarksmanshipDefaultCdActions()
 }
}

AddIcon checkbox=opt_hunter_marksmanship_aoe help=cd specialization=marksmanship
{
 if not InCombat() MarksmanshipPrecombatCdActions()
 unless not InCombat() and MarksmanshipPrecombatCdPostConditions()
 {
  MarksmanshipDefaultCdActions()
 }
}

### Required symbols
# piercing_shot
# vulnerability_debuff
# windburst
# aimed_shot
# marked_shot
# arcane_shot
# sidewinders
# prolonged_power_potion
# sidewinders_talent
# vulnerable
# trueshot_buff
# hunters_mark_debuff
# trick_shot_talent
# sentinels_sight_buff
# lock_and_load_buff
# t20_2p_critical_aimed_damage_buff
# multishot
# marking_targets_buff
# black_arrow
# a_murder_of_crows
# a_murder_of_crows_debuff
# barrage
# bullseye_buff
# sentinel_talent
# sentinel
# explosive_shot
# arcane_torrent_focus
# berserking
# blood_fury_ap
# prolonged_power_buff
# trueshot
# volley
# piercing_shot_talent
# patient_sniper_talent
# lone_wolf_talent
# revive_pet
# war_stomp
# quaking_palm
# counter_shot
]]
    OvaleScripts:RegisterScript("HUNTER", "marksmanship", name, desc, code, "script")
end
do
    local name = "sc_hunter_survival_t19"
    local desc = "[7.0] Simulationcraft: Hunter_Survival_T19"
    local code = [[
# Based on SimulationCraft profile "Hunter_Survival_T19P".
#	class=hunter
#	spec=survival
#	talents=3101031

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_hunter_spells)

AddCheckBox(opt_interrupt L(interrupt) default specialization=survival)
AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=survival)
AddCheckBox(opt_use_consumables L(opt_use_consumables) default specialization=survival)

AddFunction SurvivalInterruptActions
{
 if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting()
 {
  if target.Distance(less 5) and not target.Classification(worldboss) Spell(war_stomp)
  if target.InRange(quaking_palm) and not target.Classification(worldboss) Spell(quaking_palm)
  if target.Distance(less 8) and target.IsInterruptible() Spell(arcane_torrent_focus)
  if target.InRange(muzzle) and target.IsInterruptible() Spell(muzzle)
 }
}

AddFunction SurvivalUseItemActions
{
 Item(Trinket0Slot text=13 usable=1)
 Item(Trinket1Slot text=14 usable=1)
}

AddFunction SurvivalSummonPet
{
 if not Talent(lone_wolf_talent)
 {
  if pet.IsDead()
  {
   if not DebuffPresent(heart_of_the_phoenix_debuff) Spell(heart_of_the_phoenix)
   Spell(revive_pet)
  }
  if not pet.Present() and not pet.IsDead() and not PreviousSpell(revive_pet) Texture(ability_hunter_beastcall help=L(summon_pet))
 }
}

AddFunction SurvivalGetInMeleeRange
{
 if CheckBoxOn(opt_melee_range) and not target.InRange(raptor_strike)
 {
  Texture(misc_arrowlup help=L(not_in_melee_range))
 }
}

### actions.precombat

AddFunction SurvivalPrecombatMainActions
{
 #harpoon
 Spell(harpoon)
}

AddFunction SurvivalPrecombatMainPostConditions
{
}

AddFunction SurvivalPrecombatShortCdActions
{
 #flask
 #augmentation
 #food
 #summon_pet
 SurvivalSummonPet()
 #explosive_trap
 Spell(explosive_trap)
 #steel_trap
 Spell(steel_trap)
 #dragonsfire_grenade
 Spell(dragonsfire_grenade)
}

AddFunction SurvivalPrecombatShortCdPostConditions
{
 Spell(harpoon)
}

AddFunction SurvivalPrecombatCdActions
{
 #snapshot_stats
 #potion
 if CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(prolonged_power_potion usable=1)
}

AddFunction SurvivalPrecombatCdPostConditions
{
 Spell(explosive_trap) or Spell(steel_trap) or Spell(dragonsfire_grenade) or Spell(harpoon)
}

### actions.preBitePhase

AddFunction SurvivalPrebitephaseMainActions
{
 #flanking_strike,if=cooldown.mongoose_bite.charges<3
 if SpellCharges(mongoose_bite) < 3 Spell(flanking_strike)
 #raptor_strike,if=active_enemies=1&talent.serpent_sting.enabled&dot.serpent_sting.refreshable
 if Enemies() == 1 and Talent(serpent_sting_talent) and target.DebuffRefreshable(serpent_sting_debuff) Spell(raptor_strike)
 #lacerate,if=refreshable
 if target.Refreshable(lacerate_debuff) Spell(lacerate)
 #butchery,if=equipped.frizzos_fingertrap&dot.lacerate.refreshable
 if HasEquippedItem(frizzos_fingertrap) and target.DebuffRefreshable(lacerate_debuff) Spell(butchery)
 #carve,if=equipped.frizzos_fingertrap&dot.lacerate.refreshable
 if HasEquippedItem(frizzos_fingertrap) and target.DebuffRefreshable(lacerate_debuff) Spell(carve)
 #mongoose_bite,if=charges=3&cooldown.flanking_strike.remains>=gcd
 if Charges(mongoose_bite) == 3 and SpellCooldown(flanking_strike) >= GCD() Spell(mongoose_bite)
 #caltrops,if=!ticking
 if not target.DebuffPresent(caltrops_debuff) Spell(caltrops)
 #flanking_strike
 Spell(flanking_strike)
 #lacerate,if=remains<14&set_bonus.tier20_2pc
 if target.DebuffRemaining(lacerate_debuff) < 14 and ArmorSetBonus(T20 2) Spell(lacerate)
}

AddFunction SurvivalPrebitephaseMainPostConditions
{
}

AddFunction SurvivalPrebitephaseShortCdActions
{
 unless SpellCharges(mongoose_bite) < 3 and Spell(flanking_strike)
 {
  #spitting_cobra
  Spell(spitting_cobra)
  #dragonsfire_grenade
  Spell(dragonsfire_grenade)

  unless Enemies() == 1 and Talent(serpent_sting_talent) and target.DebuffRefreshable(serpent_sting_debuff) and Spell(raptor_strike)
  {
   #steel_trap
   Spell(steel_trap)
   #a_murder_of_crows
   Spell(a_murder_of_crows)
   #explosive_trap
   Spell(explosive_trap)
  }
 }
}

AddFunction SurvivalPrebitephaseShortCdPostConditions
{
 SpellCharges(mongoose_bite) < 3 and Spell(flanking_strike) or Enemies() == 1 and Talent(serpent_sting_talent) and target.DebuffRefreshable(serpent_sting_debuff) and Spell(raptor_strike) or target.Refreshable(lacerate_debuff) and Spell(lacerate) or HasEquippedItem(frizzos_fingertrap) and target.DebuffRefreshable(lacerate_debuff) and Spell(butchery) or HasEquippedItem(frizzos_fingertrap) and target.DebuffRefreshable(lacerate_debuff) and Spell(carve) or Charges(mongoose_bite) == 3 and SpellCooldown(flanking_strike) >= GCD() and Spell(mongoose_bite) or not target.DebuffPresent(caltrops_debuff) and Spell(caltrops) or Spell(flanking_strike) or target.DebuffRemaining(lacerate_debuff) < 14 and ArmorSetBonus(T20 2) and Spell(lacerate)
}

AddFunction SurvivalPrebitephaseCdActions
{
}

AddFunction SurvivalPrebitephaseCdPostConditions
{
 SpellCharges(mongoose_bite) < 3 and Spell(flanking_strike) or Spell(spitting_cobra) or Spell(dragonsfire_grenade) or Enemies() == 1 and Talent(serpent_sting_talent) and target.DebuffRefreshable(serpent_sting_debuff) and Spell(raptor_strike) or Spell(steel_trap) or Spell(a_murder_of_crows) or Spell(explosive_trap) or target.Refreshable(lacerate_debuff) and Spell(lacerate) or HasEquippedItem(frizzos_fingertrap) and target.DebuffRefreshable(lacerate_debuff) and Spell(butchery) or HasEquippedItem(frizzos_fingertrap) and target.DebuffRefreshable(lacerate_debuff) and Spell(carve) or Charges(mongoose_bite) == 3 and SpellCooldown(flanking_strike) >= GCD() and Spell(mongoose_bite) or not target.DebuffPresent(caltrops_debuff) and Spell(caltrops) or Spell(flanking_strike) or target.DebuffRemaining(lacerate_debuff) < 14 and ArmorSetBonus(T20 2) and Spell(lacerate)
}

### actions.mokMaintain

AddFunction SurvivalMokmaintainMainActions
{
 #raptor_strike,if=(buff.moknathal_tactics.remains<gcd)|(buff.moknathal_tactics.stack<2)
 if BuffRemaining(moknathal_tactics_buff) < GCD() or BuffStacks(moknathal_tactics_buff) < 2 Spell(raptor_strike)
}

AddFunction SurvivalMokmaintainMainPostConditions
{
}

AddFunction SurvivalMokmaintainShortCdActions
{
}

AddFunction SurvivalMokmaintainShortCdPostConditions
{
 { BuffRemaining(moknathal_tactics_buff) < GCD() or BuffStacks(moknathal_tactics_buff) < 2 } and Spell(raptor_strike)
}

AddFunction SurvivalMokmaintainCdActions
{
}

AddFunction SurvivalMokmaintainCdPostConditions
{
 { BuffRemaining(moknathal_tactics_buff) < GCD() or BuffStacks(moknathal_tactics_buff) < 2 } and Spell(raptor_strike)
}

### actions.fillers

AddFunction SurvivalFillersMainActions
{
 #carve,if=active_enemies>1&talent.serpent_sting.enabled&dot.serpent_sting.refreshable
 if Enemies() > 1 and Talent(serpent_sting_talent) and target.DebuffRefreshable(serpent_sting_debuff) Spell(carve)
 #throwing_axes
 Spell(throwing_axes)
 #carve,if=active_enemies>2
 if Enemies() > 2 Spell(carve)
 #raptor_strike,if=(talent.way_of_the_moknathal.enabled&buff.moknathal_tactics.remains<gcd*4)|(focus>((25-focus.regen*gcd)+55))
 if Talent(way_of_the_moknathal_talent) and BuffRemaining(moknathal_tactics_buff) < GCD() * 4 or Focus() > 25 - FocusRegenRate() * GCD() + 55 Spell(raptor_strike)
}

AddFunction SurvivalFillersMainPostConditions
{
}

AddFunction SurvivalFillersShortCdActions
{
}

AddFunction SurvivalFillersShortCdPostConditions
{
 Enemies() > 1 and Talent(serpent_sting_talent) and target.DebuffRefreshable(serpent_sting_debuff) and Spell(carve) or Spell(throwing_axes) or Enemies() > 2 and Spell(carve) or { Talent(way_of_the_moknathal_talent) and BuffRemaining(moknathal_tactics_buff) < GCD() * 4 or Focus() > 25 - FocusRegenRate() * GCD() + 55 } and Spell(raptor_strike)
}

AddFunction SurvivalFillersCdActions
{
}

AddFunction SurvivalFillersCdPostConditions
{
 Enemies() > 1 and Talent(serpent_sting_talent) and target.DebuffRefreshable(serpent_sting_debuff) and Spell(carve) or Spell(throwing_axes) or Enemies() > 2 and Spell(carve) or { Talent(way_of_the_moknathal_talent) and BuffRemaining(moknathal_tactics_buff) < GCD() * 4 or Focus() > 25 - FocusRegenRate() * GCD() + 55 } and Spell(raptor_strike)
}

### actions.bitePhase

AddFunction SurvivalBitephaseMainActions
{
 #lacerate,if=!dot.lacerate.ticking&set_bonus.tier20_4pc&buff.mongoose_fury.duration>cooldown.mongoose_bite.charges*gcd
 if not target.DebuffPresent(lacerate_debuff) and ArmorSetBonus(T20 4) and BaseDuration(mongoose_fury_buff) > SpellCharges(mongoose_bite) * GCD() Spell(lacerate)
 #mongoose_bite,if=charges>=2&cooldown.mongoose_bite.remains<gcd*2
 if Charges(mongoose_bite) >= 2 and SpellCooldown(mongoose_bite) < GCD() * 2 Spell(mongoose_bite)
 #flanking_strike,if=((buff.mongoose_fury.remains>(gcd*(cooldown.mongoose_bite.charges+2)))&cooldown.mongoose_bite.charges<=1)&(!set_bonus.tier19_4pc|(set_bonus.tier19_4pc&!buff.aspect_of_the_eagle.up))
 if BuffRemaining(mongoose_fury_buff) > GCD() * { SpellCharges(mongoose_bite) + 2 } and SpellCharges(mongoose_bite) <= 1 and { not ArmorSetBonus(T19 4) or ArmorSetBonus(T19 4) and not BuffPresent(aspect_of_the_eagle_buff) } Spell(flanking_strike)
 #mongoose_bite,if=buff.mongoose_fury.up
 if BuffPresent(mongoose_fury_buff) Spell(mongoose_bite)
 #flanking_strike
 Spell(flanking_strike)
}

AddFunction SurvivalBitephaseMainPostConditions
{
}

AddFunction SurvivalBitephaseShortCdActions
{
 #fury_of_the_eagle,if=(!talent.way_of_the_moknathal.enabled|buff.moknathal_tactics.remains>(gcd*(8%3)))&buff.mongoose_fury.stack>3&cooldown.mongoose_bite.charges<1&!buff.aspect_of_the_eagle.up,interrupt_if=(talent.way_of_the_moknathal.enabled&buff.moknathal_tactics.remains<=tick_time)|(cooldown.mongoose_bite.charges=3)
 if { not Talent(way_of_the_moknathal_talent) or BuffRemaining(moknathal_tactics_buff) > GCD() * { 8 / 3 } } and BuffStacks(mongoose_fury_buff) > 3 and SpellCharges(mongoose_bite) < 1 and not BuffPresent(aspect_of_the_eagle_buff) Spell(fury_of_the_eagle)
}

AddFunction SurvivalBitephaseShortCdPostConditions
{
 not target.DebuffPresent(lacerate_debuff) and ArmorSetBonus(T20 4) and BaseDuration(mongoose_fury_buff) > SpellCharges(mongoose_bite) * GCD() and Spell(lacerate) or Charges(mongoose_bite) >= 2 and SpellCooldown(mongoose_bite) < GCD() * 2 and Spell(mongoose_bite) or BuffRemaining(mongoose_fury_buff) > GCD() * { SpellCharges(mongoose_bite) + 2 } and SpellCharges(mongoose_bite) <= 1 and { not ArmorSetBonus(T19 4) or ArmorSetBonus(T19 4) and not BuffPresent(aspect_of_the_eagle_buff) } and Spell(flanking_strike) or BuffPresent(mongoose_fury_buff) and Spell(mongoose_bite) or Spell(flanking_strike)
}

AddFunction SurvivalBitephaseCdActions
{
}

AddFunction SurvivalBitephaseCdPostConditions
{
 { not Talent(way_of_the_moknathal_talent) or BuffRemaining(moknathal_tactics_buff) > GCD() * { 8 / 3 } } and BuffStacks(mongoose_fury_buff) > 3 and SpellCharges(mongoose_bite) < 1 and not BuffPresent(aspect_of_the_eagle_buff) and Spell(fury_of_the_eagle) or not target.DebuffPresent(lacerate_debuff) and ArmorSetBonus(T20 4) and BaseDuration(mongoose_fury_buff) > SpellCharges(mongoose_bite) * GCD() and Spell(lacerate) or Charges(mongoose_bite) >= 2 and SpellCooldown(mongoose_bite) < GCD() * 2 and Spell(mongoose_bite) or BuffRemaining(mongoose_fury_buff) > GCD() * { SpellCharges(mongoose_bite) + 2 } and SpellCharges(mongoose_bite) <= 1 and { not ArmorSetBonus(T19 4) or ArmorSetBonus(T19 4) and not BuffPresent(aspect_of_the_eagle_buff) } and Spell(flanking_strike) or BuffPresent(mongoose_fury_buff) and Spell(mongoose_bite) or Spell(flanking_strike)
}

### actions.biteFill

AddFunction SurvivalBitefillMainActions
{
 #butchery,if=equipped.frizzos_fingertrap&dot.lacerate.refreshable
 if HasEquippedItem(frizzos_fingertrap) and target.DebuffRefreshable(lacerate_debuff) Spell(butchery)
 #carve,if=equipped.frizzos_fingertrap&dot.lacerate.refreshable
 if HasEquippedItem(frizzos_fingertrap) and target.DebuffRefreshable(lacerate_debuff) Spell(carve)
 #lacerate,if=refreshable
 if target.Refreshable(lacerate_debuff) Spell(lacerate)
 #raptor_strike,if=active_enemies=1&talent.serpent_sting.enabled&dot.serpent_sting.refreshable
 if Enemies() == 1 and Talent(serpent_sting_talent) and target.DebuffRefreshable(serpent_sting_debuff) Spell(raptor_strike)
 #caltrops,if=!ticking
 if not target.DebuffPresent(caltrops_debuff) Spell(caltrops)
}

AddFunction SurvivalBitefillMainPostConditions
{
}

AddFunction SurvivalBitefillShortCdActions
{
 #spitting_cobra
 Spell(spitting_cobra)

 unless HasEquippedItem(frizzos_fingertrap) and target.DebuffRefreshable(lacerate_debuff) and Spell(butchery) or HasEquippedItem(frizzos_fingertrap) and target.DebuffRefreshable(lacerate_debuff) and Spell(carve) or target.Refreshable(lacerate_debuff) and Spell(lacerate) or Enemies() == 1 and Talent(serpent_sting_talent) and target.DebuffRefreshable(serpent_sting_debuff) and Spell(raptor_strike)
 {
  #steel_trap
  Spell(steel_trap)
  #a_murder_of_crows
  Spell(a_murder_of_crows)
  #dragonsfire_grenade
  Spell(dragonsfire_grenade)
  #explosive_trap
  Spell(explosive_trap)
 }
}

AddFunction SurvivalBitefillShortCdPostConditions
{
 HasEquippedItem(frizzos_fingertrap) and target.DebuffRefreshable(lacerate_debuff) and Spell(butchery) or HasEquippedItem(frizzos_fingertrap) and target.DebuffRefreshable(lacerate_debuff) and Spell(carve) or target.Refreshable(lacerate_debuff) and Spell(lacerate) or Enemies() == 1 and Talent(serpent_sting_talent) and target.DebuffRefreshable(serpent_sting_debuff) and Spell(raptor_strike) or not target.DebuffPresent(caltrops_debuff) and Spell(caltrops)
}

AddFunction SurvivalBitefillCdActions
{
}

AddFunction SurvivalBitefillCdPostConditions
{
 Spell(spitting_cobra) or HasEquippedItem(frizzos_fingertrap) and target.DebuffRefreshable(lacerate_debuff) and Spell(butchery) or HasEquippedItem(frizzos_fingertrap) and target.DebuffRefreshable(lacerate_debuff) and Spell(carve) or target.Refreshable(lacerate_debuff) and Spell(lacerate) or Enemies() == 1 and Talent(serpent_sting_talent) and target.DebuffRefreshable(serpent_sting_debuff) and Spell(raptor_strike) or Spell(steel_trap) or Spell(a_murder_of_crows) or Spell(dragonsfire_grenade) or Spell(explosive_trap) or not target.DebuffPresent(caltrops_debuff) and Spell(caltrops)
}

### actions.aoe

AddFunction SurvivalAoeMainActions
{
 #butchery
 Spell(butchery)
 #caltrops,if=!ticking
 if not target.DebuffPresent(caltrops_debuff) Spell(caltrops)
 #carve,if=(talent.serpent_sting.enabled&dot.serpent_sting.refreshable)|(active_enemies>5)
 if Talent(serpent_sting_talent) and target.DebuffRefreshable(serpent_sting_debuff) or Enemies() > 5 Spell(carve)
}

AddFunction SurvivalAoeMainPostConditions
{
}

AddFunction SurvivalAoeShortCdActions
{
 unless Spell(butchery) or not target.DebuffPresent(caltrops_debuff) and Spell(caltrops)
 {
  #explosive_trap
  Spell(explosive_trap)
 }
}

AddFunction SurvivalAoeShortCdPostConditions
{
 Spell(butchery) or not target.DebuffPresent(caltrops_debuff) and Spell(caltrops) or { Talent(serpent_sting_talent) and target.DebuffRefreshable(serpent_sting_debuff) or Enemies() > 5 } and Spell(carve)
}

AddFunction SurvivalAoeCdActions
{
}

AddFunction SurvivalAoeCdPostConditions
{
 Spell(butchery) or not target.DebuffPresent(caltrops_debuff) and Spell(caltrops) or Spell(explosive_trap) or { Talent(serpent_sting_talent) and target.DebuffRefreshable(serpent_sting_debuff) or Enemies() > 5 } and Spell(carve)
}

### actions.default

AddFunction SurvivalDefaultMainActions
{
 #call_action_list,name=mokMaintain,if=talent.way_of_the_moknathal.enabled
 if Talent(way_of_the_moknathal_talent) SurvivalMokmaintainMainActions()

 unless Talent(way_of_the_moknathal_talent) and SurvivalMokmaintainMainPostConditions()
 {
  #call_action_list,name=CDs
  SurvivalCdsMainActions()

  unless SurvivalCdsMainPostConditions()
  {
   #call_action_list,name=preBitePhase,if=!buff.mongoose_fury.up
   if not BuffPresent(mongoose_fury_buff) SurvivalPrebitephaseMainActions()

   unless not BuffPresent(mongoose_fury_buff) and SurvivalPrebitephaseMainPostConditions()
   {
    #call_action_list,name=aoe,if=active_enemies>=3
    if Enemies() >= 3 SurvivalAoeMainActions()

    unless Enemies() >= 3 and SurvivalAoeMainPostConditions()
    {
     #call_action_list,name=bitePhase
     SurvivalBitephaseMainActions()

     unless SurvivalBitephaseMainPostConditions()
     {
      #call_action_list,name=biteFill
      SurvivalBitefillMainActions()

      unless SurvivalBitefillMainPostConditions()
      {
       #call_action_list,name=fillers
       SurvivalFillersMainActions()
      }
     }
    }
   }
  }
 }
}

AddFunction SurvivalDefaultMainPostConditions
{
 Talent(way_of_the_moknathal_talent) and SurvivalMokmaintainMainPostConditions() or SurvivalCdsMainPostConditions() or not BuffPresent(mongoose_fury_buff) and SurvivalPrebitephaseMainPostConditions() or Enemies() >= 3 and SurvivalAoeMainPostConditions() or SurvivalBitephaseMainPostConditions() or SurvivalBitefillMainPostConditions() or SurvivalFillersMainPostConditions()
}

AddFunction SurvivalDefaultShortCdActions
{
 #auto_attack
 SurvivalGetInMeleeRange()
 #call_action_list,name=mokMaintain,if=talent.way_of_the_moknathal.enabled
 if Talent(way_of_the_moknathal_talent) SurvivalMokmaintainShortCdActions()

 unless Talent(way_of_the_moknathal_talent) and SurvivalMokmaintainShortCdPostConditions()
 {
  #call_action_list,name=CDs
  SurvivalCdsShortCdActions()

  unless SurvivalCdsShortCdPostConditions()
  {
   #call_action_list,name=preBitePhase,if=!buff.mongoose_fury.up
   if not BuffPresent(mongoose_fury_buff) SurvivalPrebitephaseShortCdActions()

   unless not BuffPresent(mongoose_fury_buff) and SurvivalPrebitephaseShortCdPostConditions()
   {
    #call_action_list,name=aoe,if=active_enemies>=3
    if Enemies() >= 3 SurvivalAoeShortCdActions()

    unless Enemies() >= 3 and SurvivalAoeShortCdPostConditions()
    {
     #call_action_list,name=bitePhase
     SurvivalBitephaseShortCdActions()

     unless SurvivalBitephaseShortCdPostConditions()
     {
      #call_action_list,name=biteFill
      SurvivalBitefillShortCdActions()

      unless SurvivalBitefillShortCdPostConditions()
      {
       #call_action_list,name=fillers
       SurvivalFillersShortCdActions()
      }
     }
    }
   }
  }
 }
}

AddFunction SurvivalDefaultShortCdPostConditions
{
 Talent(way_of_the_moknathal_talent) and SurvivalMokmaintainShortCdPostConditions() or SurvivalCdsShortCdPostConditions() or not BuffPresent(mongoose_fury_buff) and SurvivalPrebitephaseShortCdPostConditions() or Enemies() >= 3 and SurvivalAoeShortCdPostConditions() or SurvivalBitephaseShortCdPostConditions() or SurvivalBitefillShortCdPostConditions() or SurvivalFillersShortCdPostConditions()
}

AddFunction SurvivalDefaultCdActions
{
 #muzzle,if=target.debuff.casting.react
 if target.IsInterruptible() SurvivalInterruptActions()
 #use_items
 SurvivalUseItemActions()
 #call_action_list,name=mokMaintain,if=talent.way_of_the_moknathal.enabled
 if Talent(way_of_the_moknathal_talent) SurvivalMokmaintainCdActions()

 unless Talent(way_of_the_moknathal_talent) and SurvivalMokmaintainCdPostConditions()
 {
  #call_action_list,name=CDs
  SurvivalCdsCdActions()

  unless SurvivalCdsCdPostConditions()
  {
   #call_action_list,name=preBitePhase,if=!buff.mongoose_fury.up
   if not BuffPresent(mongoose_fury_buff) SurvivalPrebitephaseCdActions()

   unless not BuffPresent(mongoose_fury_buff) and SurvivalPrebitephaseCdPostConditions()
   {
    #call_action_list,name=aoe,if=active_enemies>=3
    if Enemies() >= 3 SurvivalAoeCdActions()

    unless Enemies() >= 3 and SurvivalAoeCdPostConditions()
    {
     #call_action_list,name=bitePhase
     SurvivalBitephaseCdActions()

     unless SurvivalBitephaseCdPostConditions()
     {
      #call_action_list,name=biteFill
      SurvivalBitefillCdActions()

      unless SurvivalBitefillCdPostConditions()
      {
       #call_action_list,name=fillers
       SurvivalFillersCdActions()
      }
     }
    }
   }
  }
 }
}

AddFunction SurvivalDefaultCdPostConditions
{
 Talent(way_of_the_moknathal_talent) and SurvivalMokmaintainCdPostConditions() or SurvivalCdsCdPostConditions() or not BuffPresent(mongoose_fury_buff) and SurvivalPrebitephaseCdPostConditions() or Enemies() >= 3 and SurvivalAoeCdPostConditions() or SurvivalBitephaseCdPostConditions() or SurvivalBitefillCdPostConditions() or SurvivalFillersCdPostConditions()
}

### actions.CDs

AddFunction SurvivalCdsMainActions
{
}

AddFunction SurvivalCdsMainPostConditions
{
}

AddFunction SurvivalCdsShortCdActions
{
 #snake_hunter,if=cooldown.mongoose_bite.charges=0&buff.mongoose_fury.remains>3*gcd&buff.aspect_of_the_eagle.down
 if SpellCharges(mongoose_bite) == 0 and BuffRemaining(mongoose_fury_buff) > 3 * GCD() and BuffExpires(aspect_of_the_eagle_buff) Spell(snake_hunter)
}

AddFunction SurvivalCdsShortCdPostConditions
{
}

AddFunction SurvivalCdsCdActions
{
 #arcane_torrent,if=focus<=30
 if Focus() <= 30 Spell(arcane_torrent_focus)
 #berserking,if=buff.aspect_of_the_eagle.up
 if BuffPresent(aspect_of_the_eagle_buff) Spell(berserking)
 #blood_fury,if=buff.aspect_of_the_eagle.up
 if BuffPresent(aspect_of_the_eagle_buff) Spell(blood_fury_ap)
 #potion,if=buff.aspect_of_the_eagle.up
 if BuffPresent(aspect_of_the_eagle_buff) and CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(prolonged_power_potion usable=1)

 unless SpellCharges(mongoose_bite) == 0 and BuffRemaining(mongoose_fury_buff) > 3 * GCD() and BuffExpires(aspect_of_the_eagle_buff) and Spell(snake_hunter)
 {
  #aspect_of_the_eagle,if=buff.mongoose_fury.stack>=2&buff.mongoose_fury.remains>3*gcd
  if BuffStacks(mongoose_fury_buff) >= 2 and BuffRemaining(mongoose_fury_buff) > 3 * GCD() Spell(aspect_of_the_eagle)
 }
}

AddFunction SurvivalCdsCdPostConditions
{
 SpellCharges(mongoose_bite) == 0 and BuffRemaining(mongoose_fury_buff) > 3 * GCD() and BuffExpires(aspect_of_the_eagle_buff) and Spell(snake_hunter)
}

### Survival icons.

AddCheckBox(opt_hunter_survival_aoe L(AOE) default specialization=survival)

AddIcon checkbox=!opt_hunter_survival_aoe enemies=1 help=shortcd specialization=survival
{
 if not InCombat() SurvivalPrecombatShortCdActions()
 unless not InCombat() and SurvivalPrecombatShortCdPostConditions()
 {
  SurvivalDefaultShortCdActions()
 }
}

AddIcon checkbox=opt_hunter_survival_aoe help=shortcd specialization=survival
{
 if not InCombat() SurvivalPrecombatShortCdActions()
 unless not InCombat() and SurvivalPrecombatShortCdPostConditions()
 {
  SurvivalDefaultShortCdActions()
 }
}

AddIcon enemies=1 help=main specialization=survival
{
 if not InCombat() SurvivalPrecombatMainActions()
 unless not InCombat() and SurvivalPrecombatMainPostConditions()
 {
  SurvivalDefaultMainActions()
 }
}

AddIcon checkbox=opt_hunter_survival_aoe help=aoe specialization=survival
{
 if not InCombat() SurvivalPrecombatMainActions()
 unless not InCombat() and SurvivalPrecombatMainPostConditions()
 {
  SurvivalDefaultMainActions()
 }
}

AddIcon checkbox=!opt_hunter_survival_aoe enemies=1 help=cd specialization=survival
{
 if not InCombat() SurvivalPrecombatCdActions()
 unless not InCombat() and SurvivalPrecombatCdPostConditions()
 {
  SurvivalDefaultCdActions()
 }
}

AddIcon checkbox=opt_hunter_survival_aoe help=cd specialization=survival
{
 if not InCombat() SurvivalPrecombatCdActions()
 unless not InCombat() and SurvivalPrecombatCdPostConditions()
 {
  SurvivalDefaultCdActions()
 }
}

### Required symbols
# prolonged_power_potion
# explosive_trap
# steel_trap
# dragonsfire_grenade
# harpoon
# flanking_strike
# mongoose_bite
# spitting_cobra
# raptor_strike
# serpent_sting_talent
# serpent_sting_debuff
# a_murder_of_crows
# lacerate
# lacerate_debuff
# butchery
# frizzos_fingertrap
# carve
# caltrops
# caltrops_debuff
# moknathal_tactics_buff
# throwing_axes
# way_of_the_moknathal_talent
# fury_of_the_eagle
# mongoose_fury_buff
# aspect_of_the_eagle_buff
# arcane_torrent_focus
# berserking
# blood_fury_ap
# snake_hunter
# aspect_of_the_eagle
# lone_wolf_talent
# revive_pet
# war_stomp
# quaking_palm
# muzzle
]]
    OvaleScripts:RegisterScript("HUNTER", "survival", name, desc, code, "script")
end
