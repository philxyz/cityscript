-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- configuration.lua
-- Set up the script here.
-------------------------------

-- You can change these in the schema definition file as well.

CAKE.ConVars = {}

CAKE.ConVars.DefaultHealth = 100 -- How much health do players start with
CAKE.ConVars.WalkSpeed = 125 -- How fast do players walk
CAKE.ConVars.RunSpeed = 275 -- How fast do players run
CAKE.ConVars.TalkRange = 300 -- This is the range of talking.
CAKE.ConVars.SuicideEnabled = "1" -- Can players compulsively suicide by using kill
CAKE.ConVars.SalaryEnabled = "1" -- Is salary enabled
CAKE.ConVars.SalaryInterval = "20" -- How often is salary given ( Minutes ) -- This cannot be changed after it has been set
CAKE.ConVars.Default_Gravgun = "0" -- Are players banned from the gravity gun when players first start.
CAKE.ConVars.Default_Physgun = "0" -- Are players banned from the physics gun when players first start.
CAKE.ConVars.Default_Money = "500" -- How much money the characters start out with.
CAKE.ConVars.Default_Bank = "0" -- How much bank money the characters start out with.
CAKE.ConVars.Default_Interest_Percentage = 2.5 -- How much interest players earn on deposits.
CAKE.ConVars.Default_Interest_Period = 5 -- Minutes
CAKE.ConVars.Default_Title = "Citizen" -- What is their title when players create their character.
CAKE.ConVars.Default_Flags = {} -- What flags can the character select when it is first made. ( This does not include public flags ) This cannot be setconvar'd
CAKE.ConVars.Default_Inventory = {} -- What inventory do characters start out with when they are first created. This cannot be setconvar'd
CAKE.ConVars.Jail_Time = 120 -- How long in jail?
CAKE.ConVars.NPC_Kill_Pay = 5 -- How much you receive for killing an NPC
CAKE.ConVars.Allow_Cash_Looting = true -- Players drop tokens on death
CAKE.ConVars.Max_Cash_Drop_On_Death = 2000 -- Max tokens dropped when killed
CAKE.ConVars.Schema = "cityscript" -- What folder is schema data being loaded from?

-- MAX PERCENTAGE OF TOTAL PLAYERS PER TEAM
-- YOU CAN ALWAYS HAVE AT LEAST ONE, BUT THIS DEFINES THE MAX
CAKE.ConVars.GroceryStoreOwnerPcnt = 20
CAKE.ConVars.GunStoreOwnerPcnt = 18
CAKE.ConVars.CarDealershipOwnerPcnt = 18
CAKE.ConVars.BlackMarketDealerPcnt = 16
CAKE.ConVars.MedicalSpecialistPcnt = 22
CAKE.ConVars.BloodBrothersGangPcnt = 28
CAKE.ConVars.VontoriniGangPcnt = 28
CAKE.ConVars.HellsAngelsGangPcnt = 28
CAKE.ConVars.SkinHeadsGangPcnt = 28
CAKE.ConVars.LegionGangPcnt = 28
CAKE.ConVars.WIGangPcnt = 28
CAKE.ConVars.PolicePcnt = 30

CAKE.ConVars.CakeVersion = "1.0.4" -- Don't change this plzkthx. This is for LuaBanana's usage only.
