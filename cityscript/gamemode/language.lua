-- language.lua
-- UK English
-- by philxyz

CUR = "T" -- Tokens currency in use

TEXT = {}
TEXT.Admin = "ADMIN"
TEXT.CommandInvalid = "That is not a valid command!"
TEXT.NotFromServerConsole = "You can not run this command from server console!"
TEXT.NotForAdminUse = "You are a superadmin. This command is not for admin use!"
TEXT.SuperAdminOnly = "Super-Admin Only!"
TEXT.AdminOnly = "Admin Only!"
TEXT.XisNotAValidModel = " is not a valid model!"
TEXT.ATMText = "Bank ATM"
TEXT.ATMBalanceCommand = "/balance"
TEXT.ATMWithdrawCommand = "/withdraw"
TEXT.ATMDepositCommand = "/deposit"
TEXT.ATMTransferCommand = "/transfer"
TEXT.ATMFrozen = "ATM frozen!"
TEXT.NewATMCommand = "/newatm"
TEXT.FreezeATMCommand = "/freezeatm"
TEXT.AddSpawnCommand = "/addspawn"
TEXT.RemoveSpawnsCommand = "/removespawns"
TEXT.EnableZombiesCommand = "/enablezombie"
TEXT.DisableZombiesCommand = "/disablezombie"
TEXT.EnableMeteorStormCommand = "/enablestorm"
TEXT.DisableMeteorStormCommand = "/disablestorm"
TEXT.AddJailPosCommand = "/jailpos"
TEXT.AddExtraJailPosCommand = "/addjailpos"
TEXT.AddZombieCommand = "/addzombie"
TEXT.DropZombiesCommand = "/dropzombies"
TEXT.MaxZombiesCommand = "/maxzombies"
TEXT.ShowZombieCommand = "/showzombie"
TEXT.ChooseATeamBeforeCreatingSpawns = "Please choose a team before creating or destroying spawn positions..."
TEXT.RemovedAllSpawns = function(teamID) return "All custom spawn positions for team: " .. tostring(teamID) .. " removed! Use " .. TEXT.AddSpawnCommand .. " to create new ones." end
TEXT.Amount = "amount"
TEXT.NotFiniteNumber = "Amount given is not a finite number"
TEXT.Citizen = "Citizen"
TEXT.NameOrUserID = "name|userid"
TEXT.Tokens = "Tokens"
TEXT.TimeLeft = "Time Left"
TEXT.HowToRespawn = "(Type !acceptdeath to respawn)"
TEXT.Typing = "Typing.."
TEXT.RentUnrent = "Rent/Unrent Door"
TEXT.Lock = "Lock"
TEXT.Unlock = "Unlock"
TEXT.EnableRenting = "Enable Renting"
TEXT.DisableRenting = "Disable Renting"
TEXT.NotRenting = "You aren't renting this door!"
TEXT.GiveTokens = "Give Tokens"
TEXT.GivePersonTokens = function(person) return "Give " .. person .. " Tokens" end
TEXT.Warn = "Warn" -- (verb)
TEXT.Warning = "Warning"
TEXT.WARNING = "BE WARNED"
TEXT.Kick = "Kick" -- (verb)
TEXT.Ban = "Ban" -- (verb)
TEXT.Reason = "Reason"
TEXT.ReasonForBanningName = function(name) return "Reason for banning " .. name end
TEXT.UseItem = "Use Item"
TEXT.TakeAmmo = "Take Ammo"
TEXT.PlaceInBackpack = "Place in Backpack"
TEXT.SelectModel = "Select Model"
TEXT.Rotate = "Rotate"
TEXT.Body = "Body"
TEXT.Face = "Face"
TEXT.Far = "Far"
TEXT.OK = "OK"
TEXT.PlayerInformation = "Player Information"
TEXT.Name = "Name"
TEXT.Title = "Title"
TEXT.Association = "Association"
TEXT.PlayerMenu = "Player Menu"
TEXT.GeneralInfo = "General information."
TEXT.OpenPlayerMenu = "Open Player Menu"
TEXT.PlayerImage = "Who's that Mingebag?"
TEXT.WarningTo = function(name) return "Issue a warning to " .. name end
TEXT.ReasonForKicking = function(reason) return "Reason for kicking " .. name end
TEXT.MaxReached = "This team is full!"
TEXT.MaxIsOne = "This team is full!"
TEXT.Roles = "Roles"
TEXT.Backpack = "Backpack"
TEXT.Business = "Business"
TEXT.Scoreboard = "Scoreboard"
TEXT.Help = "Help"
TEXT.Always = "ever"
TEXT.ForAlways = "forever"
TEXT.For = "for"
TEXT.BanFor = "Ban for..."
TEXT.OneHour = "1 hour"
TEXT.SixHours = "6 hours"
TEXT.OneDay = "1 day"
TEXT.OneWeek = "1 week"
TEXT.OneMonth = "1 month"
TEXT.VitalSigns = "Vital Signs"
TEXT.Dead = "Dead"
TEXT.Healthy = "Healthy"
TEXT.NearDeath = "Near Death"
TEXT.DeathImminent = "Death Imminent"
TEXT.NewCharacter = "New Character"
TEXT.WelcomeToCakescriptG2 = "Welcome to CityScript! (based on CakeScript G2)"
TEXT.PersonalInformation = "Personal Information"
TEXT.First = "First"
TEXT.Last = "Last"
TEXT.Unemployed = "Unemployed"
TEXT.Appearance = "Appearance"
TEXT.SelectModel = "Select Model"
TEXT.Apply = "Apply" -- (verb)
TEXT.CreateNewCharacter = "Create New Character"
TEXT.FirstNameLastNameError = "You must enter a first and last name!"
TEXT.SelectCharacter = "Select Character"
TEXT.CharacterName = "Character Name"
TEXT.CharacterMenu = "Character Menu"
TEXT.FlagName = "Flag Name"
TEXT.Salary = "Salary"
TEXT.BusinessAccess = "Business Access"
TEXT.PublicFlag = "Public Flag?"
TEXT.FlagKey = "Flag Key"
TEXT.CharSwitchOrNew = "Switch to another character or create a new one."
TEXT.CommonCommandsOrFlag = "Execute some common commands or set your flag."
TEXT.ViewYourInventory = "View your inventory."
TEXT.PurchaseItems = "Purchase Items."
TEXT.ViewScoreboard = "View the scoreboard."
TEXT.HelpTextMenu = "Get some help with CakeScript!"
TEXT.AdminCommandsMenu = "A few admin commands..."
TEXT.AddedClientsideLuaFilePath = function(path) return "Added clientside lua file '" .. path .. "'" end
TEXT.SuicideIsDisabled = "Suicide is disabled!"
TEXT.LongTitle = "Title is too long! Max 32 characters"
TEXT.IncorrectFlag = "Incorrect Flag!"
TEXT.NoJobChangeWhileDeadInJail = "Can not change your job while dead in jail."
TEXT.NoJobChangeWhileAliveInJail = "You are in Jail. Get a new job when you have been released."
TEXT.NewRoleBackpackEmptied = "New role selected, backpack emptied!"
TEXT.YouNotHaveThisFlag = "You do not have this flag!"
TEXT.NotYourDoor = "This is not your door!"
TEXT.DoorNotRentable = "This is not a rentable door!"
TEXT.DoorRented = "Door Rented!"
TEXT.DoorCharged = "You have been charged 50 tokens for a door!"
TEXT.DoorLost = "You have lost a door due to insufficient funds."
TEXT.DoorRentCancelled = "Door Rental Cancelled"
TEXT.DoorAlreadyRented = "This door is already rented by someone else!"
TEXT.DoorRentingEnabled = "Door renting enabled for this door!"
TEXT.DoorRentingDisabled = "Door renting disabled for this door!"
TEXT.DoorRentCommandUsedIncorrectly = "Command used incorrectly - rp_doorrenting ent_index [0|1]"
TEXT.WeaponNotDroppable = "This weapon cannot be dropped!"
TEXT.GiveMoneyUsedIncorrectly = "GiveMoney message used incorrectly."
TEXT.YouGaveX_Y_Tokens = function(name, amount) return "You gave " .. name .. " " .. amount .. " tokens!" end
TEXT.X_GaveYouY_Tokens = function(name, amount) return name .. " gave you " .. amount .. " tokens!" end
TEXT.InvalidAmount = "Invalid Amount!"
TEXT.TargetNotFound = "Target not found!"
TEXT.FirstJailPosCreated = "First jail position created!"
TEXT.ExtraJailPosCreated = "Extra jail position added!"
TEXT.RemovedAllCreatedNew = "Removed all jail positions and added a new one here"
TEXT.Failed = "failed"
TEXT.FailedWithError = "failed with error"
TEXT.InvalidErrorCode = "Invalid Error Code"
TEXT.Error = {}
TEXT.Error[1] = "Attempted to call hook while gamemode is not fully loaded"
TEXT.Error[2] = "Hook is missing a unique name"
TEXT.Error[3] = "Hook is missing a callback"
TEXT.Error[4] = "Could not retrieve player SteamID"
TEXT.Error[5] = "Character does not exist"
TEXT.Error[6] = "Invalid field"
TEXT.Error[7] = "Field not found"
TEXT.Error[8] = "Data file corrupted"
TEXT.RunningTeamHook = "Running team hook"
TEXT.AddingTeamHook = "Adding team hook"
TEXT.RunningHook = "Running hook"
TEXT.AddingHook = "Adding hook"
TEXT.PluginsInit = "Plugins Initializing"
TEXT.SchemasInit = "Schemas Initializing"
TEXT.GamemodeInit = "Gamemode Initializing"
TEXT.PayAnnouncement = function(amount) return "Paycheck! " .. tostring(amount) .. " tokens banked!" end
TEXT.PayDayMissedBecauseArrested = "Pay day missed! (arrested)"
TEXT.PlayerHasDiedInJail = function(name) return name .. " has died in jail!" end
TEXT.BankedTokensForNPCKill = function(amount) return "Banked " .. amount .. " Tokens for killing an NPC!" end
TEXT.DeadUntilSentenceComplete = "You now are dead until your jail time is up!"
TEXT.ScottFree = "You're no longer under arrest because no jail positions are set!"
TEXT.Yes = "Yes"
TEXT.No = "No"
TEXT.Purchase = "Purchase"
TEXT.NotEnoughTokens = "Not Enough Tokens!"
TEXT.NoAccessToBusinessTab = "You do not have access to the Business tab!"
TEXT.OOCName = "OOC Name"
TEXT.AddDataField = function(fieldname, default) return "Adding player data field " .. fieldname .. " with default value of " .. tostring(default) end
TEXT.AddCharDataField = function(fieldname, default) return "Adding character data field " .. fieldname .. " with default value of " .. tostring(default) end
TEXT.LoadingPlayerDataFileFor = "Loading player data file for"
TEXT.InvalidPlayerDataField = function(arg1, arg2) return "Invalid player data field '" .. tostring( arg1 ) .. "' in " .. arg2 .. ", removing." end
TEXT.MissingPlayerDataField = function(arg1, arg2, arg3) return "Missing player data field '" .. tostring( arg1 ) .. "' in " .. arg2 .. ", inserting with default value of '" .. tostring(arg3) .. "'" end
TEXT.InvalidCharacterDataField = function(arg1, arg2) return "Invalid character data field '" .. tostring( arg1 ) .. "' in character " .. arg2 .. "-" .. tostring(arg1) .. ", removing." end
TEXT.MissingCharacterDataField = function(arg1, arg2, arg3, arg4) return "Missing character data field '" .. tostring( arg1 ) .. "' in character " .. arg2 .. "-" .. tostring(arg3) .. ", inserting with default value of '" .. tostring(arg4) .. "'" end
TEXT.CreatingNewDataFileFor = "Creating new data file for"
TEXT.DeathMode = "Starting death mode for"
TEXT.ArrestMessage = function(time) return "You have been arrested for " .. time .. " seconds!" end
TEXT.ArrestMessage2 = function(name, time) return name .. " has been arrested for " .. tostring(time) .. " seconds!" end
TEXT.JailPunishMessage = function(time) return "Punishment for disconnecting! Jailed for: " .. time .. " seconds." end
TEXT.AddingItemToInventory = function(class, str) return "Adding item '" .. class .. "' to " .. str .. " inventory" end
TEXT.RemovingItemFromInventory = function(class, str) return "Removing item '" .. class .. "' from " .. str .. " inventory" end
TEXT.LogMoneyChange = function(steamID, uid, amount) return "Changing " .. steamID .. "-" .. uid .. " money by " .. tostring( amount ) end
TEXT.LogSetMoneyChange = function(steamID, uid, amount) return "Setting " .. steamID .. "-" .. uid .. " money to " .. tostring( amount ) end
TEXT.SetMoneyChange = function(who, amount) return "Token count of " .. who .. " changed to: " .. amount end
TEXT.BadArgumentTokenAmount = "Bad argument to command (token amount)"
TEXT.LoadingPluginBy = function(name, author, description) return "Loading plugin " .. name .. " by " .. author .. " ( " .. description .. " )" end
TEXT.InitializingPlugin = "Initializing Plugin"
TEXT.LoadingSchema = function(schemaname, schemaauthor, schemadescription) return "Loading schema " .. schemaname .. " by " .. schemaauthor .. " ( " .. schemadescription .. " )" end
TEXT.AddedTeam = "Added team"
TEXT.GroceryStoreOwner = "Grocery Store Owner"
TEXT.GunStoreOwner = "Gun Store Owner"
TEXT.CarDealershipOwner = "Car Dealership Owner"
TEXT.BlackMarketDealer = "Black Market Dealer"
TEXT.MedicalSpecialist = "Medical Specialist"
TEXT.BloodBrothersGangLeader = "Blood Brothers Gang Leader"
TEXT.BloodBrothersGangMember = "Blood Brothers Gang Member"
TEXT.LaFamigliaVontoriniGangLeader = "La Famiglia Vontorini Gang Leader"
TEXT.LaFamigliaVontoriniGangMember = "La Famiglia Vontorini Gang Member"
TEXT.TheLegionGangLeader = "The Legion Gang Leader"
TEXT.TheLegionGangMember = "The Legion Gang Member"
TEXT.CityPolice = "City Police"
TEXT.CityMayor = "City Mayor"
TEXT.MustBeLookingAtDoor = "You must be looking at a door!"
TEXT.SpecifyADoorGroup = "Specify a doorgroup!"
TEXT.DoorAdded = "Door added"
TEXT.RPWarnInvalidArgumentCount = "Invalid number of arguments! ( rp_admin warn \"name\" \"warning\" )"
TEXT.RPKickInvalidArgumentCount = "Invalid number of arguments! ( rp_admin kick \"name\" \"reason\" )"
TEXT.RPBanInvalidArgumentCount = "Invalid number of arguments! ( rp_admin ban \"name\" \"reason\" minutes )"
TEXT.SomeoneHasBeenWarned = function(name) return name .. " has been warned!" end
TEXT.CanNotFindPlayer = function(name) return "Can not find " .. name .. "!" end
TEXT.BanInfo = function(uid, mins, reason) return uid .. " \"Banned for " .. mins .. " mins ( " .. reason .. " )\"\n" end
TEXT.BannedName = function(name) return "banned " .. name end
TEXT.SetVarInvalidArgumentCount = "Invalid number of arguments! ( rp_admin setvar \"varname\" \"value\" )"
TEXT.ReportAdminChangeMade = function(arg1, arg2) return arg1 .. " set to " .. arg2 end
TEXT.InvalidConvar = function(convar) return convar .. " is not a valid convar! Use rp_admin listvars" end
TEXT.ListVarsHeader = "---List of Cakescript + CityScript ConVars---"
TEXT.ListAdminCmdsHeader = "---List of Cakescript + CityScript Admin Commands---"
TEXT.SetFlagsResponse = function(targetName, flags) return targetName .. "'s flags were set to \"" .. flags .. "\"" end
TEXT.SetFlagsResponse2 = function(adminName, flags) return "Your flags were set to \"" .. flags .. "\" by " .. adminName end
TEXT.ListAllAdminCommands = "List of all admin commands"
TEXT.WarnSomeone = "Warn someone on the server"
TEXT.KickSomeone = "Kick someone from the server"
TEXT.BanSomeone = "Ban someone from the server"
TEXT.SetVar = "Set a Convar"
TEXT.ListConVars = "List Convars"
TEXT.SetFlags = "Set a player's flags"
TEXT.AddDoorToDoorGroup = "Add a door to a doorgroup"
TEXT.WaitPlease = function(time) return "Please wait " .. time .. " seconds before using OOC chat again!" end
TEXT.BROADCAST = "BROADCAST"
TEXT.ADVERT = "ADVERT"
TEXT.LackingTokens = function(amount) return "You do not have enough tokens! You need " .. amount .. " to send an advertisement." end
TEXT.AdvertismentsDisabled = "Advertisements are disabled"
TEXT.RADIO = "RADIO"
TEXT.SlashMeCommand = "/me"
TEXT.YellCommand = "/y"
TEXT.WhisperCommand = "/w"
TEXT.AdCommand = "/ad"
TEXT.OOCCommand = "/ooc"
TEXT.OOCCommand2 = "//"
TEXT.BroadcastCommand = "/bc"
TEXT.RadioCommand = "/radio"
TEXT.SpawnNotAllowed = "You are not allowed to spawn anything!"
TEXT.LimitReached = function(limit) return "You have reached your limit! (" .. limit .. ")" end
TEXT.ExtrapropsCommandBadUsage = "Invalid number of arguments! ( rp_admin extraprops \"name\" amount )"
TEXT.ExtraStuffAdvice = function(thing, amount, adminName) return "Your extra " .. thing .. " has been set to: " .. amount .. " by " .. adminName end
TEXT.ExtraStuffAdvice2 = function(target, thing, amount) return target .. "'s " .. thing .. " has been set to: " .. amount end
TEXT.ExtraragdollsCommandBadUsage = "Invalid number of arguments! ( rp_admin extraragdolls \"name\" amount )"
TEXT.ExtravehiclesCommandBadUsage = "Invalid number of arguments! ( rp_admin extravehicles \"name\" amount )"
TEXT.ExtraeffectsCommandBadUsage = "Invalid number of arguments! ( rp_admin extraeffects \"name\" amount )"
TEXT.ChangeAnExtraPropsLimit = "Change someone's extra props limit"
TEXT.ChangeAnExtraRagdollsLimit = "Change someone's extra ragdolls limit"
TEXT.ChangeAnExtraVehiclesLimit = "Change someone's extra vehicles limit"
TEXT.ChangeAnExtraEffectsLimit = "Change someone's extra effects limit"
TEXT.IncorrectNumberOfArguments = "Incorrect number of arguments!"
TEXT.PermaFlagSetTo = "Permaflag set to"
TEXT.ToolTrustInvalidArguments = "Invalid number of arguments! ( rp_admin tooltrust \"name\" 1/0 )"
TEXT.ToolTrustGivenBy = function(adminName) return "You have been given tooltrust by " .. adminName end
TEXT.ToolTrustGivenAnnounce = function(targetName) return targetName .. " has been given tooltrust" end
TEXT.ToolTrustRevokedBy = function(adminName) return "Your tooltrust has been revoked by " .. adminName end
TEXT.ToolTrustRevokedAnnounce = function(targetName) return "tooltrust has been revoked from " .. targetName end
TEXT.PhysTrustInvalidArguments = "Invalid number of arguments! ( rp_admin phystrust \"name\" 1/0 )"
TEXT.PhysTrustGivenBy = function(adminName) return "You have been given phystrust by " .. adminName end
TEXT.PhysTrustGivenAnnounce = function(targetName) return targetName .. " has been given phystrust" end
TEXT.PhysTrustRevokedBy = function(adminName) return "Your phystrust has been revoked by " .. adminName end
TEXT.PhysTrustRevokedAnnounce = function(targetName) return "phystrust has been revoked from " .. targetName end
TEXT.GravTrustInvalidArguments = "Invalid number of arguments! ( rp_admin gravtrust \"name\" 1/0 )"
TEXT.GravTrustGivenBy = function(adminName) return "You have been given gravtrust by " .. adminName end
TEXT.GravTrustGivenAnnounce = function(targetName) return targetName .. " has been given gravtrust" end
TEXT.GravTrustRevokedBy = function(adminName) return "Your gravtrust has been revoked by " .. adminName end
TEXT.GravTrustRevokedAnnounce = function(targetName) return "gravtrust has been revoked from " .. targetName end
TEXT.PropTrustInvalidArguments = "Invalid number of arguments! ( rp_admin proptrust \"name\" 1/0 )"
TEXT.PropTrustGivenBy = function(adminName) return "You have been given proptrust by " .. adminName end
TEXT.PropTrustGivenAnnounce = function(targetName) return targetName .. " has been given proptrust" end
TEXT.PropTrustRevokedBy = function(adminName) return "Your proptrust has been revoked by " .. adminName end
TEXT.PropTrustRevokedAnnounce = function(targetName) return "proptrust has been revoked from " .. targetName end
TEXT.ChangeATrust = function(kind) return "Change someone's " .. kind .. "trust" end -- e.g: proptrust where kind = "prop"
TEXT.SoundDoesNotExist = "This sound does not exist. Use rp_listvoices"
TEXT.ListOfVoicesHeader = "---List of CakeScript + CityScript Voices---"
TEXT.NoteFlagSpecific = "Please note that these are flag-specific"
TEXT.FireShock = function(amount) return "Holy smokes! We just lost " .. tostring(amount) .. " Tokens to fire!" end
TEXT.MeteorStormApproaching = "WARNING: Meteor Storm Approaching!"
TEXT.MeteorStormPassing = "PHEW: Meteor Storm Passing!"
TEXT.MeteorStormEnabled = "Meteor Storm Enabled"
TEXT.MeteorStormDisabled = "Meteor Storm Disabled"
TEXT.INCOMING = "INCOMING"
TEXT.EnableMeteorCommand = "/enablestorm"
TEXT.DisableMeteorCommand = "/disablestorm"
TEXT.RemoveItemCommand = "/rm"
TEXT.NothingToRemove = "Nothing to remove!"
TEXT.ItemRemoved = "Item removed!"
TEXT.ATMRemoved = "ATM removed!"
TEXT.TitleCommand = "/title"
TEXT.MustBeAtLeast1Token = "Invalid amount. Must be at least 1 token!"
TEXT.ToRemoveThisATM = "To remove this ATM, look at it and type " .. TEXT.RemoveItemCommand
TEXT.QueryBalance = function(amount) return "Bank Balance: " .. amount .. " Tokens" end
TEXT.ConfirmDeposit = function(amount) return tostring(amount) .. " tokens deposited. Thank you!" end
TEXT.NotEnoughInBank = "You don't have that much money in the bank!"
TEXT.ConfirmWithdrawal = function(amount) return tostring(amount) .. " tokens withdrawn. Thank you!" end
TEXT.TransferCorrection = "It's meant to be: " .. TEXT.ATMTransferCommand .. " <" .. TEXT.Amount .. ">\\" .. "[" .. TEXT.NameOrUserID .. "]"
TEXT.X_HasGiven_Y_Tokens_YourBank = function(giver, amount) return giver .. " has transferred " .. tostring(amount) .. " tokens to your bank account!" end
TEXT.X_Tokens_Transferred_to_Y = function(amount, target) return tostring(amount) .. " tokens transferred to bank account of: " .. target .. ". Thank You!" end
TEXT.BankInterestReceived = function(amount) return "You have banked " .. tostring(amount) .. " tokens in interest!" end
TEXT.GiveCommand = "/give"
TEXT.DropTokensCommand = "/droptokens"
TEXT.DropTokensCommand2 = "/dropmoney"
TEXT.DropTokensCommand3 = "/moneydrop"
TEXT.DropTokensCommand4 = "/tokendrop"
TEXT.SetMoneyUsedIncorrectly = "Command used incorrecty! Must be: rp_admin setmoney (name) (token amount)"
TEXT.SetMoneyCommandAbout = "Command for giving tokens to players."
TEXT.NewSpawnPointCreated = function(teamID) return "New Spawn Point for team: " .. tostring(teamID) .. " created! To remove this team's spawns, use " .. TEXT.RemoveSpawnsCommand end
TEXT.BoxLabelUpdated = "Box label updated!"
TEXT.ZombiesApproaching = "Zombies are approaching!"
TEXT.ZombiesLeaving = "Zombies are leaving."
TEXT.ClearedAllZombiePositions = "You have cleared all zombie spawn positions!"
TEXT.ZombieSpawnPosAdded = "You have added a zombie spawn position."
TEXT.InvalidMaxZombies = "Invalid command! Try " .. TEXT.MaxZombiesCommand .. " <positive number>"
TEXT.SetMaxZombiesTo = "Max Zombies set to"
TEXT.ZombiesNowEnabled = "Zombies are now enabled!"
TEXT.ZombiesNowDisabled = "Zombies are now disabled!"
TEXT.ShowBalance = "Show Balance"
TEXT.WithdrawTokens = "Withdraw Tokens"
TEXT.MakeAWithdrawal = "Make a Withdrawal"
TEXT.HowManyTokens = "How many tokens?"
TEXT.DepositTokens = "Deposit Tokens"
TEXT.MakeADeposit = "Make a Deposit"
TEXT.TransferTokens = "Transfer Tokens"
TEXT.ToWhichPlayer = "To which player?"
TEXT.Weakling = "This is way too heavy for you to move, weakling!"
TEXT.ATM = "ATM"
TEXT.Toxics = "Illegal Substances"
TEXT.PaidForSellingToxics = "Paid 45 tokens for selling illegal substances!"
TEXT.TooPoorForToxics = "You are too poor to buy illegal substances!"
TEXT.FreeToxicsForYou = "Free illegal substances for you!"
TEXT.BoughtToxics = "You bought illegal substances for 45 Tokens!"
TEXT.SoldToxics = "You sold illegal substances for 45 Tokens!"
TEXT.ToxicCongrats = "Congratulations! You are the new owner of this highly illegal thing! Posession is 9/10ths of the law."
TEXT.ToxicLab = "Illegal Substance Lab"
TEXT.ItemProp = "Item Prop"
TEXT.Meteor = "Meteor"
TEXT.Shipment = "Shipment"
TEXT.StorageBox = "Storage Box"
TEXT.UseTitleToLabel = "Use /title <title> to label"
TEXT.AnnouncePlacedInBox = function(text) return text .. " placed in box" end
TEXT.BoxFull = "This box is full!"
TEXT.StandCloserToTheBox = "Stand nearer to the box!"
TEXT.OpeningTheBox = "Opening the box..."
TEXT.WontFitInBackpack = "This item won't fit in your backpack. It's way too big!"
TEXT.SelectUseItemToPickUpTokens = "Select \"Use Item\" to pick up these tokens."
TEXT.MePocketsABundleOfTokens = function(amt) return "/me stuffs " .. tostring(amt) .. " tokens into their pocket!" end
TEXT.TokenBundle = "Token Bundle"
TEXT.TokenPrinter = "Token Printer"
TEXT.PrintWhenIAmReady = "I'll print when I'm ready to, thanks..."
TEXT.NoJailPositionsExist = "There are no Jail Positions set!"
TEXT.ArrestedBy = function(name) return "You have been arrested by " .. name end
TEXT.SignalFlare = "Signal flare"
TEXT.CallForHelp = "Call for help!"
TEXT.SignalFlareInstructions = "Primary fire to launch a rocket.\nSecondary fire to zoom."
TEXT.Hands = "Hands"
TEXT.ComboFists = "Combo-Fists"
TEXT.ComboFistsInstructions = "Left click for a left-hand swing \nRight click for a right-hand swing."
TEXT.LockPick = "Lock Pick"
TEXT.LockPickInstructions = "Left click to pick a lock"
TEXT.UnarrestStick = "Unarrest Baton"
TEXT.UnarrestStickInstructions = "Left or right click to unarrest"
TEXT.NukePack = "Nuclear Detonator Pack"
TEXT.NukeDetInstructions = "Aim away from face"
TEXT.DetonationTime = function(time) return "Detonation countdown: ".. tostring(time) .." seconds!" end
TEXT.ItemsHelpHintText = "- Use shift + right-click to interact with items, doors and players."
TEXT.MainHelpHintText = "- Press F1 in-game and click the Help tab for full info."
TEXT.HideHelpHintsCheckText = "Don't show this next time."
TEXT.HelpHintCloseBtn = "Close"
TEXT.FirstTimeHelpTitle = "First Time Help"
TEXT.HelpLong = {
	"Welcome to CityScript by philxyz - Based on CakeScript by Nori",
	"",
	"",
	"GAMEPLAY:",
	"To interact with players, items or doors, hold TAB then right-click whatever you want to interact with.",
	"You can purchase doors, give players money, pick up items, and other things from this menu.",
	"",
	"Press F1 to access this menu (do'h; you've found it now, anyway!)",
	"Create a character when you join by using the left hand side of the 'Character Create' tab",
	"Once created, your character will appear on the right hand column in the list of your characters.",
	"Double-click a character in the list, then click on the picture of that character to start",
	"",
	"You will earn tokens over time based upon your selected flag (role). These roles are listed in the \"Roles\" tab.",
	"Start a business, make some money, have fun!",
	"Each character has a Business tab under the F1 menu with a selection",
	"of items that they can buy for resale.",
	"",
	"SOME USEFUL COMMANDS",
	TEXT.GiveCommand .. " when looking at a player to give money",
	TEXT.DropTokensCommand .. " <" .. TEXT.Amount .. "> to drop some money",
	TEXT.TitleCommand .. " <title> (when looking at a door) rented by you",
	TEXT.TitleCommand .. " <title> (when looking at a storage box)",
	TEXT.ATMBalanceCommand .. " (while looking at an ATM) Query your bank balance",
	TEXT.ATMWithdrawCommand .. " <" .. TEXT.Amount .. "> (while looking at an ATM) Withdraw tokens from the bank",
	TEXT.ATMDepositCommand .. " <" .. TEXT.Amount .. "> (while looking at an ATM) Deposit tokens with the bank",
	TEXT.ATMTransferCommand .. " <" .. TEXT.Amount .. ">\\[" .. TEXT.NameOrUserID .. "] (while looking at an ATM) Transfer bank tokens to another player",
	TEXT.SlashMeCommand .. " - Talk in third-person",
	TEXT.YellCommand .. " - Talk a little louder so others can hear",
	TEXT.WhisperCommand .. " - Talk quietly to the person next to you",
	TEXT.AdCommand .. " - Advertise your wares",
	TEXT.OOCCommand .. " or " .. TEXT.OOCCommand2 .. " - Talk Out of Character",
	TEXT.BroadcastCommand .. " - Make an announcement via the airwaves",
	TEXT.RadioCommand .. " - Talk over the radio",
	TEXT.TitleCommand .. " <title> (when looking at a non-rentable door) - (superadmin)",
	TEXT.NewATMCommand .. " Create a new ATM for this map - (superadmin)",
	TEXT.FreezeATMCommand .. " Store an ATM for this map - (superadmin)",
	TEXT.AddSpawnCommand .. " - Add a spawn point right here for the team you are currently set to. (admin / superadmin)",
	TEXT.RemoveSpawnsCommand .. " - Remove all spawn points for the team you are currently set to. (admin / superadmin)",
	TEXT.EnableZombiesCommand .. " - Enable Zombies. (admin / superadmin)",
	TEXT.DisableZombiesCommand .. " - Disable Zombies. (admin / superadmin)",
	TEXT.MaxZombiesCommand .. " - Zombies-in-one-go Limit. (admin / superadmin)",
	TEXT.AddZombieCommand .. " - Adds a new Zombie Spawn Position for this map. (admin / superadmin)",
	TEXT.DropZombiesCommand .. " - Drops all Zombie Spawn Positions for this map (from the database). (admin / superadmin)",
	TEXT.EnableMeteorStormCommand .. " - Enable Meteor Storm. (admin / superadmin)",
	TEXT.DisableMeteorStormCommand .. " - Disable Meteor Storm. (admin / superadmin)",
	TEXT.AddJailPosCommand .. " - Clear all jail positions and make ONE here. (admin / superadmin)",
	TEXT.AddExtraJailPosCommand .. " - Add an extra jail position. (admin / superadmin)",
	"",
	"",
	"REQUIRED WORKSHOP ADDONS FOR 100% FUNCTIONALITY:",
	"",
	"CSS Weapons on M9K Base (108720350)",
	"M9K Assault Rifles (128089118)",
	"M9K Small Arms Pack (128093075)",
	"M9K Heavy Weapons (128091208)",
	"M9K Specialities (144982052)",
	"Nuke (106565409)",
	"",
	"Please note that for a server installation, you should copy these addons",
	"from your client game\'s addons folder to your server\'s addons folder.",
	"On the server, they should be named \"ds_<id>.gma\" where <id> is the id",
	"of the workshop package.",
	"",
	"You should also create a Workshop Collection containing the above packages",
	"and supply it on the srcds command line - e.g. +host_workshop_collection <id>",
	"",
	"",
	"CREDITS:",
	"Nori / LuaBanana for Cakescript G2",
	"philxyz for CityScript schema",
	"SB Spy for Combo Fists",
	"philxyz for Fire Extinguisher",
	"Rick Dark, Botman"
}
