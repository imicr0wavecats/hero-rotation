--- ============================ HEADER ============================
--- ======= LOCALIZE =======
  -- Addon
  local addonName, addonTable = ...;
  -- HeroLib
  local HL = HeroLib;
  local Cache = HeroCache;
  local Unit = HL.Unit;
  local Player = Unit.Player;
  local Pet = Unit.Pet;
  local Target = Unit.Target;
  local Spell = HL.Spell;
  local Item = HL.Item;
  -- HeroRotation
  local HR = HeroRotation;
  -- Lua

  --- ============================ CONTENT ============================
--- ======= APL LOCALS =======
  local Everyone = HR.Commons.Everyone;
  local DeathKnight = HR.Commons.DeathKnight;
  -- Spells
  if not Spell.DeathKnight then Spell.DeathKnight = {}; end
  Spell.DeathKnight.Unholy = {
    -- Racials
    ArcaneTorrent                 = Spell(50613),
    Berserking                    = Spell(26297),
    BloodFury                     = Spell(20572),
    GiftoftheNaaru                = Spell(59547),
    --Abilities
    ArmyOfTheDead                 = Spell(42650),
    Apocalypse                    = Spell(275699),
    ChainsOfIce                   = Spell(45524),
    ScourgeStrike                 = Spell(55090),
    DarkTransformation            = Spell(63560),
    DeathAndDecay                 = Spell(43265),
    DeathCoil                     = Spell(47541),
    DeathStrike                   = Spell(49998),
    FesteringStrike               = Spell(85948),
    Outbreak                      = Spell(77575),
    SummonPet                     = Spell(46584),
       --Talents
    InfectedClaws                 = Spell(207272),
    AllWillServe                  = Spell(194916),
    ClawingShadows                = Spell(207311),
    PestilentPustules             = Spell(194917),
    BurstingSores                 = Spell(207264),
    EbonFever                     = Spell(207269),
    UnholyBlight                  = Spell(115989),
    HarbringerOfDoom              = Spell(276023),
    SoulReaper                    = Spell(130736),
    Pestilence                    = Spell(277234),
    Defile                        = Spell(152280),
    Epidemic                      = Spell(207317),
    ArmyOfTheDammed               = Spell(276837),
    UnholyFrenzy                  = Spell(207289),
    SummonGargoyle                = Spell(49206),
    --Buffs/Procs
    MasterOfGhouls                = Spell(246995), -- ??
    SuddenDoom                    = Spell(81340),
    UnholyStrength                = Spell(53365),
    DeathAndDecayBuff             = Spell(188290),
    --Debuffs
    FesteringWound                = Spell(194310), --max 8 stacks
    VirulentPlagueDebuff          = Spell(191587), -- 13s debuff from Outbreak
    --Defensives
    AntiMagicShell                = Spell(48707),
    IcebornFortitute              = Spell(48792),
     -- Utility
    ControlUndead                 = Spell(45524),
    DeathGrip                     = Spell(49576),
    MindFreeze                    = Spell(47528),
    PathOfFrost                   = Spell(3714),
    WraithWalk                    = Spell(212552),
    --Legendaries Buffs/SpellIds
    ColdHeartItemBuff             = Spell(235599),
    InstructorsFourthLesson       = Spell(208713),
    KiljaedensBurningWish         = Spell(144259),
    --SummonGargoyle HiddenAura
    SummonGargoyleActive          = Spell(212412), --tbc
    -- Misc
    PoolForResources              = Spell(9999000010)
    };
  local S = Spell.DeathKnight.Unholy;
  --Items
  if not Item.DeathKnight then Item.DeathKnight = {}; end
  Item.DeathKnight.Unholy = {
    --Legendaries WIP
  ConvergenceofFates            = Item(140806, {13, 14}),
  InstructorsFourthLesson       = Item(132448, {9}),
  Taktheritrixs                 = Item(137075, {3}),
  ColdHeart                    = Item(151796, {5}),


  };
  local I = Item.DeathKnight.Unholy;

  --GUI Settings
  local Settings = {
    General = HR.GUISettings.General,
    Commons = HR.GUISettings.APL.DeathKnight.Commons,
    Unholy = HR.GUISettings.APL.DeathKnight.Unholy
  };

  -- Variables
  local function PoolingForGargoyle()
    --(cooldown.summon_gargoyle.remains<5&(cooldown.dark_transformation.remains<5|!equipped.137075))&talent.summon_gargoyle.enabled
    return (S.SummonGargoyle:CooldownRemains() < 5 and (S.DarkTransformation:CooldownRemains() < 5 or not I.Taktheritrixs:IsEquipped())) and S.SummonGargoyle:IsAvailable()
  end

  --- ===== APL =====
  --- ===============
  local function AOE()
  -- death_and_decay,if=cooldown.apocalypse.remains
  if S.DeathAndDecay:IsCastable() and S.Apocalypse:CooldownDown() then
    if HR.Cast(S.DeathAndDecay) then return ""; end
  end
  -- defile
  if S.Defile:IsCastable() then
    if HR.Cast(S.Defile) then return ""; end
  end
  -- epidemic,if=death_and_decay.ticking&rune<2&!variable.pooling_for_gargoyle
  if S.Epidemic:IsUsable() and Player:Buff(S.DeathAndDecayBuff) and Player:Runes() < 2 and not PoolingForGargoyle() then
    if HR.Cast(S.Epidemic) then return ""; end
  end
  -- death_coil,if=death_and_decay.ticking&rune<2&!talent.epidemic.enabled&!variable.pooling_for_gargoyle
  if S.DeathCoil:IsUsable() and Player:Buff(S.DeathAndDecayBuff) and Player:Runes() < 2 and not S.Epidemic:IsAvailable() and not PoolingForGargoyle() then
    if HR.Cast(S.DeathCoil) then return ""; end
  end
  -- scourge_strike,if=death_and_decay.ticking&cooldown.apocalypse.remains
  if S.ScourgeStrike:IsCastable() and Player:Buff(S.DeathAndDecayBuff) and S.Apocalypse:CooldownDown() then
    if HR.Cast(S.ScourgeStrike) then return ""; end
  end
  -- clawing_shadows,if=death_and_decay.ticking&cooldown.apocalypse.remains
  if S.ClawingShadows:IsCastable() and Player:Buff(S.DeathAndDecayBuff) and S.Apocalypse:CooldownDown() then
    if HR.Cast(S.ClawingShadows) then return ""; end
  end
  -- epidemic,if=!variable.pooling_for_gargoyle
  if S.Epidemic:IsUsable() and not PoolingForGargoyle() then
    if HR.Cast(S.Epidemic) then return ""; end
  end
  -- festering_strike,if=talent.bursting_sores.enabled&spell_targets.bursting_sores>=2&debuff.festering_wound.stack<=1
  if S.FesteringStrike:IsCastable() and (S.BurstingSores:IsAvailable() and Cache.EnemiesCount[5] >= 2 and Target:DebuffStackP(S.FesteringWound) <= 1) then
    if HR.Cast(S.FesteringStrike) then return ""; end
  end
  -- death_coil,if=buff.sudden_doom.react&rune.deficit>=4
  if S.DeathCoil:IsUsable() and Player:Buff(S.SuddenDoom) and Player:Runes() <= 2 then
    if HR.Cast(S.DeathCoil) then return ""; end
  end
  return false;
end


 local function Generic()
  -- death_coil,if=buff.sudden_doom.react&!variable.pooling_for_gargoyle|pet.gargoyle.active
  if S.DeathCoil:IsUsable() and Player:Buff(S.SuddenDoom) and not PoolingForGargoyle() or S.SummonGargoyle:TimeSinceLastCast() <= 22 then
    if HR.Cast(S.DeathCoil) then return ""; end
  end
  -- death_coil,if=runic_power.deficit<14&(cooldown.apocalypse.remains>5|debuff.festering_wound.stack>4)&!variable.pooling_for_gargoyle
  if S.DeathCoil:IsUsable() and Player:RunicPowerDeficit() < 14 and (S.Apocalypse:CooldownRemainsP() > 5 or Target:DebuffStackP(S.FesteringWoundDebuff) > 4) and not PoolingForGargoyle() then
    if HR.Cast(S.DeathCoil) then return ""; end
  end
  -- death_and_decay,if=talent.pestilence.enabled&cooldown.apocalypse.remains
  if S.DeathAndDecay:IsCastable() and S.Pestilence:IsAvailable() and S.Apocalypse:CooldownDown() then
    if HR.Cast(S.DeathAndDecay) then return ""; end
  end
  -- defile,if=cooldown.apocalypse.remains
  if S.Defile:IsCastable() and S.Apocalypse:CooldownDown() then
    if HR.Cast(S.Defile) then return ""; end
  end
  -- scourge_strike,if=((debuff.festering_wound.up&cooldown.apocalypse.remains>5)|debuff.festering_wound.stack>4)&cooldown.army_of_the_dead.remains>5
  if S.ScourgeStrike:IsCastable() and (((Target:Debuff(S.FesteringWound) and S.Apocalypse:CooldownRemainsP() > 5) or Target:DebuffStack(S.FesteringWound) > 4) and S.ArmyOfTheDead:CooldownRemainsP() > 5) then
    if HR.Cast(S.ScourgeStrike) then return ""; end
  end
  -- clawing_shadows,if=((debuff.festering_wound.up&cooldown.apocalypse.remains>5)|debuff.festering_wound.stack>4)&cooldown.army_of_the_dead.remains>5
  if S.ClawingShadows:IsCastable() and (((Target:Debuff(S.FesteringWound) and S.Apocalypse:CooldownRemainsP() > 5) or Target:DebuffStack(S.FesteringWound) > 4) and S.ArmyOfTheDead:CooldownRemainsP() > 5) then
    if HR.Cast(S.ClawingShadows) then return ""; end
  end
  -- death_coil,if=runic_power.deficit<20&!variable.pooling_for_gargoyle
  if S.DeathCoil:IsUsable() and Player:RunicPowerDeficit() < 20 and not PoolingForGargoyle() then
    if HR.Cast(S.DeathCoil) then return ""; end
  end
  -- festering_strike,if=((((debuff.festering_wound.stack<4&!buff.unholy_frenzy.up)|debuff.festering_wound.stack<3)&cooldown.apocalypse.remains<3)|debuff.festering_wound.stack<1)&cooldown.army_of_the_dead.remains>5
  if S.FesteringStrike:IsCastable() and (((((Target:DebuffStack(S.FesteringWound) < 4 and not Player:Buff(S.UnholyFrenzy)) or Target:DebuffStack(S.FesteringWound) < 3) and S.Apocalypse:CooldownRemainsP() < 3) or Target:DebuffStack(S.FesteringWound) < 1) and S.ArmyOfTheDead:CooldownRemainsP() > 5) then
    if HR.Cast(S.FesteringStrike) then return ""; end
  end
  -- death_coil,if=!variable.pooling_for_gargoyle
  if S.DeathCoil:IsUsable() and not PoolingForGargoyle() then
    if HR.Cast(S.DeathCoil) then return ""; end
  end
  if HR.Cast(S.PoolForResources) then return "Pooling";end
  return false;
end

local function ColdHeart()
  -- chains_of_ice,if=buff.unholy_strength.remains<gcd&buff.unholy_strength.react&buff.cold_heart_item.stack>16
  if S.ChainsOfIce:IsCastable() and (Player:BuffRemainsP(S.UnholyStrength) < Player:GCD() and Player:Buff(S.UnholyStrength) and Player:BuffStack(S.ColdHeartItemBuff) > 16) then
    if HR.Cast(S.ChainsOfIce) then return ""; end
  end
  -- chains_of_ice,if=buff.master_of_ghouls.remains<gcd&buff.master_of_ghouls.up&buff.cold_heart_item.stack>17
  if S.ChainsOfIce:IsCastable() and (Player:BuffRemains(S.MasterOfGhouls) < Player:GCD() and Player:Buff(S.MasterOfGhouls) and Player:BuffStack(S.ColdHeartItemBuff) > 17) then
    if HR.Cast(S.ChainsOfIce) then return ""; end
  end
  -- chains_of_ice,if=buff.cold_heart_item.stack=20&buff.unholy_strength.react
  if S.ChainsOfIce:IsCastable() and Player:BuffStack(S.ColdHeartItemBuff) == 20 and Player:Buff(S.UnholyStrength) then
    if HR.Cast(S.ChainsOfIce) then return ""; end
  end
  return;
end
local function Cooldowns()
  if HR.CDsON() then
    -- call_action_list,name=cold_heart,if=equipped.cold_heart&buff.cold_heart_item.stack>10
    if (I.ColdHeart:IsEquipped() and Player:BuffStack(S.ColdHeartItemBuff) > 10) then
      local ShouldReturn = ColdHeart(); if ShouldReturn then return ShouldReturn; end
    end
    -- army_of_the_dead
    if S.ArmyOfTheDead:IsCastable() then
      if HR.Cast(S.ArmyOfTheDead) then return ""; end
    end
    -- apocalypse,if=debuff.festering_wound.stack>=4
    if S.Apocalypse:IsCastable() and Target:DebuffStack(S.FesteringWound) >= 4 then
      if HR.Cast(S.Apocalypse) then return ""; end
    end
    -- dark_transformation,if=(equipped.137075&cooldown.summon_gargoyle.remains>40)|(!equipped.137075|!talent.summon_gargoyle.enabled)
    if S.DarkTransformation:IsCastable() and ((I.Taktheritrixs:IsEquipped() and S.SummonGargoyle:CooldownRemainsP() > 40) or (not I.Taktheritrixs:IsEquipped() or not S.SummonGargoyle:IsAvailable())) then
      if HR.Cast(S.DarkTransformation) then return ""; end
    end
    -- summon_gargoyle,if=runic_power.deficit<14
    if S.SummonGargoyle:IsCastable() and Player:RunicPowerDeficit() < 14 then
      if HR.Cast(S.SummonGargoyle) then return ""; end
    end
    -- unholy_frenzy,if=debuff.festering_wound.stack<4
    if S.UnholyFrenzy:IsCastable() and Target:DebuffStack(S.FesteringWound) < 4 then
      if HR.Cast(S.UnholyFrenzy) then return ""; end
    end
    -- unholy_frenzy,if=active_enemies>=2&((cooldown.death_and_decay.remains<=gcd&!talent.defile.enabled)|(cooldown.defile.remains<=gcd&talent.defile.enabled))
    if S.UnholyFrenzy:IsCastable() and (Cache.EnemiesCount[10] >= 2 and ((S.DeathandDecay:CooldownRemainsP() <= Player:GCD() and not S.Defile:IsAvailable()) or (S.Defile:CooldownRemainsP() <= Player:GCD() and S.Defile:IsAvailable()))) then
      if HR.Cast(S.UnholyFrenzy, Settings.DeathKnight.Unholy.GCDasOffGCD.UnholyFrenzy) then return ""; end
    end
    -- soul_reaper,target_if=(target.time_to_die<8|rune<=2)&!buff.unholy_frenzy.up
    if S.SoulReaper:IsCastable() then
      if HR.Cast(S.SoulReaper) then return ""; end
    end
    -- unholy_blight
    if S.UnholyBlight:IsCastable() then
      if HR.Cast(S.UnholyBlight) then return ""; end
    end
    return;
  end
end

local function APL()
    --UnitUpdate
  HL.GetEnemies(10);
  Everyone.AoEToggleEnemiesUpdate();
  --Defensives
  --OutOf Combat
    -- Reset Combat Variables
    -- Flask
      -- Food
      -- Rune
      -- Army w/ Bossmod Countdown
      -- Volley toggle
      -- Opener

    if not Player:AffectingCombat() then
    --check if we have our lovely pet with us
    if not Pet:IsActive() and S.SummonPet:IsCastable() then
    if HR.Cast(S.SummonPet) then return ""; end
    end
  --army suggestion at pull
    if Everyone.TargetIsValid() and Target:IsInRange(30) and S.ArmyOfTheDead:CooldownUp() and HR.CDsON() then
          if HR.Cast(S.ArmyOfTheDead, Settings.Unholy.GCDasOffGCD.ArmyOfTheDead) then return ""; end
    end
  -- outbreak if virulent_plague is not  the target and we are not in combat
    if Everyone.TargetIsValid() and Target:IsInRange(30) and not Target:Debuff(S.VirulentPlagueDebuff)then
      if HR.Cast(S.Outbreak) then return ""; end
    end
      return;
    end
    --InCombat
      --actions+=/outbreak,target_if=(dot.virulent_plague.tick_time_remains+tick_time<=dot.virulent_plague.remains)&dot.virulent_plague.remains<=gcd
    if S.Outbreak:IsUsable() and not Target:Debuff(S.VirulentPlagueDebuff) or Target:DebuffRemainsP(S.VirulentPlagueDebuff) < Player:GCD()*1.5 then
      if HR.Cast(S.Outbreak) then return ""; end
    end
    --Lets call specific APLs
    if Everyone.TargetIsValid()  then
        ShouldReturn = Cooldowns();
        if ShouldReturn then return ShouldReturn;
    end
    if Cache.EnemiesCount[10] >= 2 then
      ShouldReturn = AOE();
      if ShouldReturn then return ShouldReturn; end
    end
    if (S.SummonGargoyle:IsAvailable() and  S.SummonGargoyle:TimeSinceLastCast() > 22) or S.ArmyOfTheDammed:IsAvailable() or S.UnholyFrenzy:IsAvailable() then
    ShouldReturn = Generic();
    if ShouldReturn then return ShouldReturn; end
    end
    return
  end
end

HR.SetAPL(252, APL);
--- ====27/11/2017======
--- ======= SIMC =======
--# Default consumables
--potion=prolonged_power
----flask=countless_armies
--food=azshari_salad
--augmentation=defiled

--# This default action priority list is automatically created based on your character.
--# It is a attempt to provide you with a action list that is both simple and practicable,
--# while resulting in a meaningful and good simulation. It may not result in the absolutely highest possible dps.
--# Feel free to edit, adapt and improve it to your own needs.
--# SimulationCraft is always looking for updates and improvements to the default action lists.

--# Executed before combat begins. Accepts non-harmful actions only.
--actions.precombat=flask
--actions.precombat+=/food
--actions.precombat+=/augmentation
--# Snapshot raid buffed stats before combat begins and pre-potting is done.
--actions.precombat+=/snapshot_stats
--actions.precombat+=/potion
--actions.precombat+=/raise_dead
--actions.precombat+=/army_of_the_dead
--actions.precombat+=/blighted_rune_weapon

--# Executed every time the actor is available.
--actions=auto_attack
--actions+=/mind_freeze
--# Racials, Items, and other ogcds
--actions+=/arcane_torrent,if=runic_power.deficit>20
--actions+=/blood_fury
--actions+=/berserking
--actions+=/use_items
--actions+=/use_item,name=feloiled_infernal_machine,if=pet.valkyr_battlemaiden.active|!talent.dark_arbiter.enabled
--actions+=/use_item,name=ring_of_collapsing_futures,if=(buff.temptation.stack=0&target.time_to_die>60)|target.time_to_die<60
--actions+=/potion,if=buff.unholy_strength.react
--actions+=/blighted_rune_weapon,if=debuff.festering_wound.stack<=4
--# Maintain Virulent Plague
--actions+=/outbreak,target_if=(dot.virulent_plague.tick_time_remains+tick_time<=dot.virulent_plague.remains)&dot.virulent_plague.remains<=gcd
--actions+=/call_action_list,name=cooldowns
--actions+=/run_action_list,name=valkyr,if=pet.valkyr_battlemaiden.active&talent.dark_arbiter.enabled
--actions+=/call_action_list,name=generic

--# AoE rotation
--actions.aoe=death_and_decay,if=spell_targets.death_and_decay>=2
--actions.aoe+=/epidemic,if=spell_targets.epidemic>4
--actions.aoe+=/scourge_strike,if=spell_targets.scourge_strike>=2&(death_and_decay.ticking|defile.ticking)
--actions.aoe+=/clawing_shadows,if=spell_targets.clawing_shadows>=2&(death_and_decay.ticking|defile.ticking)
--actions.aoe+=/epidemic,if=spell_targets.epidemic>2

--# Cold Heart legendary
--actions.cold_heart=chains_of_ice,if=buff.unholy_strength.remains<gcd&buff.unholy_strength.react&buff.cold_heart.stack>16
--actions.cold_heart+=/chains_of_ice,if=buff.master_of_ghouls.remains<gcd&buff.master_of_ghouls.up&buff.cold_heart.stack>17
--actions.cold_heart+=/chains_of_ice,if=buff.cold_heart.stack=20&buff.unholy_strength.react

--# Cold heart and other on-gcd cooldowns
--actions.cooldowns=call_action_list,name=cold_heart,if=equipped.cold_heart&buff.cold_heart.stack>10&!debuff.soul_reaper.up
--actions.cooldowns+=/army_of_the_dead
--actions.cooldowns+=/apocalypse,if=debuff.festering_wound.stack>=6
--actions.cooldowns+=/dark_arbiter,if=(!equipped.137075|cooldown.dark_transformation.remains<2)&runic_power.deficit<30
--actions.cooldowns+=/summon_gargoyle,if=(!equipped.137075|cooldown.dark_transformation.remains<10)&rune.time_to_4>=gcd
--actions.cooldowns+=/soul_reaper,if=(debuff.festering_wound.stack>=6&cooldown.apocalypse.remains<=gcd)|(debuff.festering_wound.stack>=3&rune>=3&cooldown.apocalypse.remains>20)
--actions.cooldowns+=/call_action_list,name=dt,if=cooldown.dark_transformation.ready

--# Dark Transformation List
--actions.dt=dark_transformation,if=equipped.137075&talent.dark_arbiter.enabled&(talent.shadow_infusion.enabled|cooldown.dark_arbiter.remains>52)&cooldown.dark_arbiter.remains>30&!equipped.140806
--actions.dt+=/dark_transformation,if=equipped.137075&(talent.shadow_infusion.enabled|cooldown.dark_arbiter.remains>(52*1.333))&equipped.140806&cooldown.dark_arbiter.remains>(30*1.333)
--actions.dt+=/dark_transformation,if=equipped.137075&target.time_to_die<cooldown.dark_arbiter.remains-8
--actions.dt+=/dark_transformation,if=equipped.137075&(talent.shadow_infusion.enabled|cooldown.summon_gargoyle.remains>55)&cooldown.summon_gargoyle.remains>35
--actions.dt+=/dark_transformation,if=equipped.137075&target.time_to_die<cooldown.summon_gargoyle.remains-8
--actions.dt+=/dark_transformation,if=!equipped.137075&rune.time_to_4>=gcd

--# Default rotation
--actions.generic=scourge_strike,if=debuff.soul_reaper.up&debuff.festering_wound.up
--actions.generic+=/clawing_shadows,if=debuff.soul_reaper.up&debuff.festering_wound.up
--actions.generic+=/death_coil,if=runic_power.deficit<22&(talent.shadow_infusion.enabled|(!talent.dark_arbiter.enabled|cooldown.dark_arbiter.remains>5))
--actions.generic+=/death_coil,if=!buff.necrosis.up&buff.sudden_doom.react&((!talent.dark_arbiter.enabled&rune<=3)|cooldown.dark_arbiter.remains>5)
--actions.generic+=/festering_strike,if=debuff.festering_wound.stack<6&cooldown.apocalypse.remains<=6
--actions.generic+=/defile
--# Switch to aoe
--actions.generic+=/call_action_list,name=aoe,if=active_enemies>=2
--# Wounds management
--actions.generic+=/festering_strike,if=(buff.blighted_rune_weapon.stack*2+debuff.festering_wound.stack)<=2|((buff.blighted_rune_weapon.stack*2+debuff.festering_wound.stack)<=4&talent.castigator.enabled)&(cooldown.army_of_the_dead.remains>5|rune.time_to_4<=gcd)
--actions.generic+=/death_coil,if=!buff.necrosis.up&talent.necrosis.enabled&rune.time_to_4>=gcd
--actions.generic+=/scourge_strike,if=(buff.necrosis.up|buff.unholy_strength.react|rune>=2)&debuff.festering_wound.stack>=1&(debuff.festering_wound.stack>=3|!(talent.castigator.enabled|equipped.132448))&(cooldown.army_of_the_dead.remains>5|rune.time_to_4<=gcd)
--actions.generic+=/clawing_shadows,if=(buff.necrosis.up|buff.unholy_strength.react|rune>=2)&debuff.festering_wound.stack>=1&(debuff.festering_wound.stack>=3|!equipped.132448)&(cooldown.army_of_the_dead.remains>5|rune.time_to_4<=gcd)
--actions.generic+=/death_coil,if=(talent.dark_arbiter.enabled&cooldown.dark_arbiter.remains>10)|!talent.dark_arbiter.enabled

--# Val'kyr rotation
--actions.valkyr=death_coil
--actions.valkyr+=/festering_strike,if=debuff.festering_wound.stack<6&cooldown.apocalypse.remains<3
--actions.valkyr+=/call_action_list,name=aoe,if=active_enemies>=2
--actions.valkyr+=/festering_strike,if=debuff.festering_wound.stack<=4
--actions.valkyr+=/scourge_strike,if=debuff.festering_wound.up
--actions.valkyr+=/clawing_shadows,if=debuff.festering_wound.up
