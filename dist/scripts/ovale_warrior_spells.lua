local __exports = LibStub:NewLibrary("ovale/scripts/ovale_warrior_spells", 10000)
if not __exports then return end
local __Scripts = LibStub:GetLibrary("ovale/Scripts")
local OvaleScripts = __Scripts.OvaleScripts
__exports.register = function()
    local name = "ovale_warrior_spells"
    local desc = "[7.3.2] Ovale: Warrior spells"
    local code = [[
ItemRequire(shifting_cosmic_sliver unusable 1=oncooldown,!shield_wall,buff,!shield_wall_buff)	
	
# Warrior spells and functions.

# Learned spells.
Define(meat_cleaver 12950)
	SpellInfo(meat_cleaver learn=1 level=58 specialization=fury)
Define(unwavering_sentinel 29144)
	SpellInfo(unwavering_sentinel learn=1 level=10 specialization=protection)
Define(avatar 107574)
	SpellInfo(avatar cd=90 gcd=0)
Define(avatar_buff 107574)
	SpellInfo(avatar_buff duration=20)
Define(battle_cry 1719)
	SpellInfo(battle_cry cd=60 tag=cd gcd=0 offgcd=1)
	SpellAddBuff(battle_cry battle_cry_buff=1)
	SpellAddBuff(battle_cry battle_cry_deadly_calm_buff=1 specialization=arms talent=deadly_calm_talent)
Define(battle_cry_buff 1719)
	SpellInfo(battle_cry_buff duration=5)
Define(battle_cry_deadly_calm_buff -1719)
	SpellInfo(battle_cry_deadly_calm_buff duration=5)
Define(berserker_rage 18499)
	SpellInfo(berserker_rage cd=60 gcd=0)
	SpellInfo(berserker_rage cd=45 talent=warlords_challenge_talent specialization=protection)
	SpellInfo(berserker_rage rage=-20 itemset=T20 itemcount=2 specialization=protection)
	SpellAddBuff(berserker_rage berserker_rage_buff=1)
	SpellAddBuff(berserker_rage enrage_buff=1 talent=outburst_talent specialization=fury)
Define(berserker_rage_buff 18499)
	SpellInfo(berserker_rage_buff duration=6)
Define(bladestorm_arms 227847)
	SpellInfo(bladestorm_arms cd=90 channel=6 haste=melee)
Define(bladestorm_fury 46924)
	SpellInfo(bladestorm_fury cd=90 channel=6 haste=melee)
Define(bloodbath 12292)
	SpellInfo(bloodbath cd=30 gcd=0 tag=main)
	SpellAddBuff(bloodbath bloodbath_buff=1)
Define(bloodbath_buff 12292)
	SpellInfo(bloodbath_buff duration=10)
Define(bloodthirst 23881)
	SpellInfo(bloodthirst cd=4.5 rage=-10)
	SpellAddBuff(bloodthirst meat_cleaver_buff=-1)
Define(charge 100)
	SpellInfo(charge cd=20 gcd=0 offgcd=1 rage=-20 travel_time=1 charges=1)
	SpellInfo(charge add_cd=-3 charges=2 talent=double_time_talent)
	SpellAddTargetDebuff(charge charge_debuff=1)
Define(charge_debuff 100)	# OvaleWarriorCharge
Define(cleave 845)
	SpellInfo(cleave cd=6 cd_haste=melee rage=10)
	SpellInfo(cleave rage_percent=90 talent=dauntless_talent specialization=arms)
	SpellRequire(cleave rage_percent 25=buff,battle_cry_buff talent=deadly_calm_talent specialization=arms)
Define(cleave_buff 188923)
Define(colossus_smash 167105)
	SpellInfo(colossus_smash cd=20)
	SpellInfo(colossus_smash cd=12 talent=titanic_might_talent specialization=arms)
	SpellAddTargetDebuff(colossus_smash colossus_smash_debuff=1)
	SpellAddBuff(colossus_smash in_for_the_kill_buff=1 talent=in_for_the_kill_talent)
Define(colossus_smash_debuff 208086)
	SpellInfo(colossus_smash_debuff duration=8)
	SpellInfo(colossus_smash_debuff add_duration=8 talent=titanic_might_talent specialization=arms)
Define(commanding_shout 97462)
	SpellInfo(commanding_shout cd=180 gcd=0 offgcd=1)
	SpellAddBuff(commanding_shout commanding_shout_buff=1)
Define(commanding_shout_buff 97463)
	SpellInfo(commanding_shout_buff duration=10)
Define(deep_wounds 115768)
Define(deep_wounds_debuff 115767)
	SpellInfo(deep_wounds_debuff duration=15 tick=3)
Define(demoralizing_shout 1160)
	SpellInfo(demoralizing_shout cd=90 gcd=0 offgcd=1)
	SpellAddTargetDebuff(demoralizing_shout demoralizing_shout_debuff=1)
Define(demoralizing_shout_debuff 1160)
	SpellInfo(demoralizing_shout_debuff duration=8)
Define(devastate 20243)
	SpellInfo(devastate unusable=1 talent=devastatator_talent)
	SpellAddTargetDebuff(devastate deep_wounds_debuff=1 if_spell=deep_wounds)
Define(dragon_roar 118000)
	SpellInfo(dragon_roar cd=25)
	SpellAddBuff(dragon_roar dragon_roar_buff=1)
Define(dragon_roar_buff 118000)
	SpellInfo(dragon_roar_buff duration=6)
Define(enrage_buff 184362)
	SpellInfo(enrage_buff duration=4 enrage=1)
Define(enraged_regeneration 184364)
	SpellInfo(enraged_regeneration cd=120 gcd=0 offgcd=1)
Define(enraged_regeneration_buff 184364)
	SpellInfo(enraged_regeneration_buff duration=8)
Define(execute 5308)
	SpellInfo(execute rage=25 target_health_pct=20)
	SpellRequire(execute rage_percent 0=buff,stone_heart_buff)
	SpellRequire(execute target_health_pct 100=buff,stone_heart_buff)
Define(execute_arms 163201)
	SpellInfo(execute_arms rage=10 max_rage=40 target_health_pct=20)
	SpellInfo(execute_arms rage_percent=90 talent=dauntless_talent specialization=arms)
	SpellRequire(execute_arms rage_percent 25=buff,battle_cry_buff talent=deadly_calm_talent specialization=arms)
	SpellRequire(execute_arms rage_percent 0=buff,stone_heart_buff)
	SpellRequire(execute_arms target_health_pct 100=buff,stone_heart_buff)
	SpellAddTargetDebuff(execute_arms executioners_precision_buff=1 trait=executioners_precision)
Define(executioners_precision 238147)
Define(executioners_precision_buff 242188)
	SpellInfo(executioners_precision_buff duration=30)
Define(focused_rage 207982)
	SpellInfo(focused_rage cd=1.5 cd_haste=melee gcd=0 offgcd=1 rage=20)
	SpellInfo(focused_rage rage_percent=90 talent=dauntless_talent specialization=arms)
	SpellRequire(focused_rage rage_percent 25=buff,battle_cry_buff talent=deadly_calm_talent specialization=arms)
	SpellAddBuff(focused_rage focused_rage_buff=1)
	SpellInfo(focused_rage replace=focused_rage_protection specialization=protection)
Define(focused_rage_buff 207982)
	SpellInfo(focused_rage_buff duration=30)
Define(focused_rage_protection 204488)
	SpellInfo(focused_rage_protection cd=1.5 cd_haste=melee rage=30)
	SpellAddBuff(focused_rage_protection focused_rage_protection_buff=1)
Define(focused_rage_protection_buff 204488)
	SpellInfo(focused_rage_protection_buff duration=30)
Define(frenzy_buff 202539)
	SpellInfo(frenzy_buff duration=10)
Define(frothing_berserker_buff 215572)
Define(furious_slash 100130)
	SpellAddBuff(furious_slash frenzy_buff=1 talent=frenzy_talent)
Define(hamstring 1715)
	SpellInfo(hamstring cd=1 gcd=0 offgcd=1 rage=10)
	SpellAddTargetDebuff(hamstring hamstring_debuff=1)
Define(hamstring_debuff 1715)
	SpellInfo(hamstring_debuff duration=15)
Define(heroic_leap 6544)
	SpellInfo(heroic_leap cd=45 gcd=0 offgcd=1 travel_time=1)
	SpellInfo(heroic_leap add_cd=-15 talent=bounding_stride_talent)
	SpellAddBuff(heroic_leap heroic_leap_buff=1 talent=bounding_stride_talent)
Define(heroic_leap_buff 202164)
Define(heroic_throw 57755)
	SpellInfo(heroic_throw cd=6 travel_time=1)
	SpellInfo(heroic_throw add_cd=-6 specialization=protection)
Define(ignore_pain 190456)
	SpellInfo(ignore_pain cd=1 gcd=0 offgcd=1 rage=20 max_rage=60)
	SpellAddBuff(ignore_pain ignore_pain_buff=1)
	SpellAddBuff(ignore_pain renewed_fury_buff=1 talent=renewed_fury_talent)
Define(ignore_pain_buff 190456)
	SpellInfo(ignore_pain duration=15)
Define(impending_victory 202168)
	SpellInfo(impending_victory rage=10 cd=30)
	SpellRequire(impending_victory cd_percent 0=victorious_buff)
	SpellAddBuff(impending_victory victorious_buff=0)
Define(in_for_the_kill_buff 248622)
	SpellInfo(in_for_the_kill_buff duration=8)
Define(intercept 198304)
	SpellInfo(intercept cd=20 rage=-20)
Define(intimidating_shout 5246)
Define(juggernaut 200875)
	SpellAddBuff(execute juggernaut_buff=1 if_spell=juggernaut)
Define(juggernaut_buff 201009)
Define(last_stand 12975)
	SpellInfo(last_stand cd=180 gcd=0 offgcd=1)
	SpellAddBuff(last_stand last_stand_buff=1)
Define(last_stand_buff 12975)
	SpellInfo(last_stand_buff duration=15)
Define(massacre_buff 206316)
Define(meat_cleaver_buff 85739)
	SpellInfo(meat_cleaver_buff duration=10)
Define(mortal_strike 12294)
	SpellInfo(mortal_strike cd=6 cd_haste=melee rage=20)
	SpellInfo(mortal_strike rage_percent=90 talent=dauntless_talent specialization=arms)
	SpellInfo(mortal_strike charges=2 talent=mortal_combo_talent specialization=arms)
	SpellRequire(mortal_strike rage_percent 25=buff,battle_cry_buff talent=deadly_calm_talent specialization=arms)
	SpellAddTargetDebuff(mortal_strike mortal_wounds_debuff=1)
	SpellAddTargetDebuff(mortal_strike executioners_precision_buff=0)
Define(mortal_wounds_debuff 115804)
	SpellInfo(mortal_wounds_debuff duration=10)
Define(odyns_fury 205545)
	SpellInfo(odyns_fury cd=45 tag=main)
Define(overpower 7384)
	SpellAddBuff(overpower overpower_buff=0)
	SpellRequire(overpower unusable 1=buff,!overpower_buff)
Define(overpower_buff 60503)
	SpellInfo(overpower_buff duration=12)
Define(precise_strikes_buff 164323)
Define(pummel 6552)
	SpellInfo(pummel cd=15 gcd=0 interrupt=1 offgcd=1)
Define(raging_blow 85288)
	SpellInfo(raging_blow rage=-5)
	SpellInfo(raging_blow cd=4.5 cd_haste=melee talent=inner_rage_talent)
	SpellRequire(raging_blow unusable 1=buff,!enrage_buff talent=!inner_rage_talent)
Define(rampage 184367)
	SpellInfo(rampage gcd=1.5 cd_haste=none rage=85)
	SpellInfo(rampage addrage=-15 talent=carnage_talent specialization=fury)
	SpellAddBuff(rampage enrage_buff=1)
	SpellAddBuff(rampage meat_cleaver_buff=-1)
	SpellRequire(rampage rage_percent 0=buff,massacre_buff talent=massacre_talent)
Define(rampage_buff 166588) #T17 4 piece
	SpellInfo(rampage_buff duration=5)
Define(ravager 152277)
	SpellInfo(ravager cd=60)
	SpellInfo(ravager ravager_buff=1)
	SpellInfo(ravager replace=ravager_protection specialization=protection)
Define(ravager_buff 152277)
	SpellInfo(ravager_buff duration=10)
Define(ravager_protection 228920)
	SpellAddBuff(ravager_protection ravager_protection_buff=1)
Define(ravager_protection_buff 227744)
	SpellInfo(ravager_protection_buff duration=10)
Define(rend 772)
	SpellInfo(rend rage=30)
	SpellInfo(rend rage_percent=90 talent=dauntless_talent specialization=arms)
	SpellRequire(rend rage_percent 25=buff,battle_cry_buff talent=deadly_calm_talent specialization=arms)
Define(rend_debuff 772)
	SpellInfo(rend_debuff duration=15 tick=3)
Define(renewed_fury_buff 202289)
	SpellInfo(renewed_fury_buff duration=6)
Define(revenge 6572)
	SpellInfo(revenge cd=9 rage=30 cd_haste=melee)
	SpellRequire(revenge rage_percent 0=buff,revenge_buff)
	SpellAddTargetDebuff(devastate deep_wounds_debuff=1 if_spell=deep_wounds)
	SpellAddBuff(revenge revenge_buff=0)
Define(revenge_buff 5302)
	SpellInfo(revenge_buff duration=6)
Define(sense_death_buff 200979)
	SpellRequire(execute rage_percent 0=buff,sense_death_buff)
	SpellRequire(execute_arms rage_percent 0=buff,sense_death_buff)
Define(shattered_defenses_buff 209706)
Define(shield_block 2565)
	SpellInfo(shield_block cd=13 cd_haste=melee gcd=0 offgcd=1 rage=15)
Define(shield_block_buff 132404)
	SpellInfo(shield_block_buff duration=6)
Define(shield_slam 23922)
	SpellInfo(shield_slam cd=9 cd_haste=melee rage=-15)
Define(shield_wall 871)
	SpellInfo(shield_wall cd=240 gcd=0 offgcd=1)
	SpellAddBuff(shield_wall shield_wall_buff=1)
Define(shield_wall_buff 871)
	SpellInfo(shield_wall duration=8)
Define(shockwave 46968)
	SpellInfo(shockwave cd=40)
Define(slam 1464)
	SpellInfo(slam rage=20)
	SpellInfo(slam rage_percent=90 talent=dauntless_talent specialization=arms)
	SpellRequire(slam rage_percent 25=buff,battle_cry_buff talent=deadly_calm_talent specialization=arms)
Define(spell_reflection 23920)
	SpellInfo(spell_reflection cd=25)
Define(storm_bolt 107570)
	SpellInfo(storm_bolt cd=30)
Define(t18_class_trinket 124523)
Define(taunt 355)
	SpellInfo(taunt cd=8)
	SpellInfo(taunt cd=0 if_buff=berserker_rage_buff talent=warlords_challenge_talent specialization=protection)
Define(thunder_clap 6343)
	SpellInfo(thunder_clap cd=6 cd_haste=melee)
Define(ultimatum_buff 122510)
	SpellInfo(ultimatum_buff duration=10)
Define(unquenchable_thirst 169683)
Define(unyielding_strikes 169685)
Define(unyielding_strikes_buff 169686)
	SpellInfo(unyielding_strikes_buff duration=5 max_stacks=6 stacking=1)
Define(vengeance_revenge_buff 202573)
	SpellRequire(revenge rage_percent 65=buff,vengeance_revenge_buff)
Define(vengeance_ignore_pain_buff 202574)
	SpellRequire(ignore_pain rage_percent 65=buff,vengeance_ignore_pain_buff)
Define(victorious_buff 32216)
	SpellInfo(victorious_buff duration=20)
Define(victory_rush 34428)
	SpellRequire(victory_rush unusable 1=buff,!victorious_buff)
	SpellAddBuff(victory_rush victorious_buff=0)
Define(warbreaker 209577)
	SpellInfo(warbreaker cd=60 tag=main)
Define(whirlwind 190411)
	SpellInfo(whirlwind rage=30 specialization=arms)
	SpellInfo(whirlwind rage_percent=90 talent=dauntless_talent specialization=arms)
	SpellAddBuff(whirlwind meat_cleaver_buff=1)
	SpellAddBuff(whirlwind wrecking_ball_buff=0)
Define(wrecking_ball_buff 215570)
	SpellInfo(wrecking_ball_buff duration=12)

# Artifacts
Define(corrupted_blood_of_zakajz_buff 209567)
	SpellInfo(corrupted_blood_of_zakajz_buff duration=5)
Define(neltharions_fury 203524)
	SpellInfo(neltharions_fury cd=45)
Define(neltharions_fury_buff 203524)
	SpellInfo(neltharions_fury_buff duration=3)

# Legion legendary items
Define(archavons_heavy_hand 137060)
Define(archavons_heavy_hand_spell 205144)
	# TODO Mortal strike refunds 15 rage
Define(fujiedas_fury_buff 207776)
	SpellAddBuff(bloodthirst fujiedas_fury_buff=1 if_spell=fujiedas_fury_buff)
Define(stone_heart_buff 225947)
	SpellAddBuff(execute_arms stone_heart_buff=0)
	SpellAddBuff(execute stone_heart_buff=0)
Define(the_great_storms_eye 151823)
Define(weight_of_the_earth 137077)

# Talents
Define(anger_management_talent 19)
Define(avatar_talent 9)
Define(bloodbath_talent 16)
Define(booming_voice_talent 18)
Define(bounding_stride_talent 11)
Define(carnage_talent 15)
Define(dauntless_talent 1)
Define(deadly_calm_talent 16)
Define(devastatator_talent 13)
Define(double_time_talent 6)
Define(dragon_roar_talent 21)
Define(fervor_of_battle_talent 13)
Define(frenzy_talent 17)
Define(frothing_berserker_talent 14)
Define(focused_rage_talent 18)
Define(heavy_repercussions_talent 20)
Define(inner_rage_talent 18)
Define(in_for_the_kill_talent 17)
Define(massacre_talent 13)
Define(mortal_combo_talent 14)
Define(outburst_talent 8)
Define(ravager_talent 21)
Define(rend_talent 8)
Define(renewed_fury_talent 7)
Define(sweeping_strikes_talent 3)
Define(titanic_might_talent 15)
Define(vengeance_talent 16)
Define(warbringer_talent 3)
Define(warlords_challenge_talent 10)


# Non-default tags for OvaleSimulationCraft.
	SpellInfo(heroic_throw tag=main)
	SpellInfo(impending_victory tag=main)
	SpellInfo(colossus_smash tag=main)
	SpellInfo(hamstring tag=shortcd)
	SpellInfo(avatar tag=cd)
	SpellInfo(intercept tag=misc)
]]
    OvaleScripts:RegisterScript("WARRIOR", nil, name, desc, code, "include")
end
