-- language_castellano.lua
-- Español castellano
-- por philxyz

CUR = "F" -- Tokens currency in use

TEXT = {}
TEXT.ToolTrust = "confianza_herramienta"
TEXT.PhysTrust = "confianza_phys"
TEXT.PropTrust = "confianza_prop"
TEXT.GravTrust = "confianza_grav"
TEXT.ExtraEffects = "extraefectos"
TEXT.ExtraVehicles = "extravehículos"
TEXT.ExtraProps = "extraprops"
TEXT.ExtraRagdolls = "extramuñecasdetrapo"
TEXT.Admin = "ADMIN"
TEXT.CommandInvalid = "¡Eso no es un comando válido!"
TEXT.NotFromServerConsole = "No se puede ejecutar este comando desde la consola del servidor!"
TEXT.NotForAdminUse = "¡Eres un superadmin! Este comando no es para uso por administradores."
TEXT.SuperAdminOnly = "¡Solo superadmin!"
TEXT.AdminOnly = "¡Solo admin!"
TEXT.XIsNotAValidModel = " no es un modelo válido!"
TEXT.ATMText = "Cajero automático\n\nTab-Click-Derecho para Interactuar"
TEXT.ATMBalanceCommand = "/balancia"
TEXT.ATMWithdrawCommand = "/sacar"
TEXT.ATMDepositCommand = "/depositar"
TEXT.ATMTransferCommand = "/transferir"
TEXT.ATMFrozen = "¡Cajero instalado!"
TEXT.BadInjury = "¡LESIONES GRAVES! ¡LLAMA POR UN MEDICO!"
TEXT.NewATMCommand = "/nuevocajero"
TEXT.FreezeATMCommand = "/fijarcajero"
TEXT.RemoveATMCommand = "/rm"
TEXT.AddSpawnCommand = "/añadirdesove"
TEXT.RemoveSpawnsCommand = "/eliminadesoves"
TEXT.EnableZombiesCommand = "/activarzombis"
TEXT.DisableZombiesCommand = "/desactivarzombis"
TEXT.EnableMeteorStormCommand = "/activartormenta"
TEXT.DisableMeteorStormCommand = "/desactivartormenta"
TEXT.AddJailPosCommand = "/cárcelpos"
TEXT.AddExtraJailPosCommand = "/añadircárcelpos"
TEXT.AddZombieCommand = "/añadirzombi"
TEXT.DropZombiesCommand = "/eliminarzombidesoves"
TEXT.MaxZombiesCommand = "/maxzombis"
TEXT.ShowZombieCommand = "/mostrarzombi"
TEXT.DropWeaponCommand = "/soltararma"
TEXT.PleaseWaitMessage = "Cargando..."
TEXT.MaxCharactersReached = "Limite de personajes alcanzado."
TEXT.FirstCharacterBonus = "Su primer personaje recibe una cantidad inicial de fichas. ¡Invertir sabiamente!"
TEXT.CharacterDeleted = "Personaje eliminado."
TEXT.InvalidDoorEntityOrTargetPlayer = "Entidad de puerta inválida o jugador no encontrado"
TEXT.PlayerAlreadyHasKeys = "Ese jugador ya se le dio las llaves de esta puerta"
TEXT.Drop = "Soltar"
TEXT.ChooseATeamBeforeCreatingSpawns = "Por favor, elija un equipo antes de crear o destruir las posiciones de desove..."
TEXT.RemovedAllSpawns = function(teamID) return "¡Todas posiciones de desove para el equipo: " .. tostring(teamID) .. " eliminadas! Usar " .. TEXT.AddSpawnCommand .. " para crear nuevas." end
TEXT.Amount = "monto"
TEXT.SetSalePrice = "Establecer un precio de venta"
TEXT.RemoveFromSale = "Remover de Venta"
TEXT.ScrapVehicle = "Vender por Chatarra"
TEXT.ForSale = "Se vende"
TEXT.ItIsFree = "¡Es Gratis!"
TEXT.LockVehicle = "Cerrar vehículo"
TEXT.UnlockVehicle = "Abrir vehículo"
TEXT.BuyVehicle = "Comprar vehículo"
TEXT.NotFiniteNumber = "Cantidad que no es finito"
TEXT.Citizen = "Ciudadano"
TEXT.NameOrUserID = "nombre|iddeusuario"
TEXT.Tokens = "Fichas"
TEXT.TimeLeft = "Tiempo Restante"
TEXT.TimeUntilDeath = function(txt) return "Tiempo hasta el muerte: " .. txt end
TEXT.AcceptFate = "Clic izquierda para aceptar su suerte."
TEXT.HowToRespawn = "(Teclar !acceptar para desovar de nuevo)"
TEXT.Typing = "Teclando.."
TEXT.RentDoor = "Alquiler Puerta"
TEXT.Poor = "No tiene suficientes fichas."
TEXT.BoughtVehicleFor = function(amount) return "Usted compró un vehículo por " .. tostring(amount) .. " Fichas" end
TEXT.SoldVehicleFor = function(amount) return "Usted vendió un vehículo por " .. tostring(amount) .. " Fichas" end
TEXT.VehicleScrappedFor = function(amount) return "Vendido por chatarra. Receibe " .. tostring(amount) .. " Fichas por las partes." end
TEXT.UnrentDoor = "Cancelar el alquiler"
TEXT.GiveSomeKeysTo = "Dar llaves a..."
TEXT.DocumentsEnclosed = "Documentos"
TEXT.LockDoor = "Cerrar"
TEXT.UnlockDoor = "Abrir"
TEXT.EnableRenting = "Permitir alquiler"
TEXT.DisableRenting = "Prevenir alquiler"
TEXT.RestrictDoor = "Crear Área Restringida (Solo la policía y el alcalde)"
TEXT.RemoveRestrictionFromDoor = "Quitar la restricción"
TEXT.DoorRestricted = "Área Restringida creado. Solo la policía y el alcalde tienen las llaves para esta puerta."
TEXT.DoorUnrestricted = "Restricción eliminado. Cualquier persona puede alquilar esta puerta."
TEXT.DoorLocked = "Puerta cerrada."
TEXT.DoorUnlocked = "Puerta abierta."
TEXT.VehicleLocked = "Vehículo cerrado."
TEXT.VehicleUnlocked = "Vehículo abierto."
TEXT.RestrictedArea = "Área Restringida"
TEXT.KeysGivenToPlayer = function(name) return "Llaves entregadas al jugador " .. name end
TEXT.NonRentableDoor = "No se puede alquilar"
TEXT.DoorTitleChanged = "Título de la puerta cambió."
TEXT.NotRenting = "¡No estas alquilando esta puerta!"
TEXT.GiveTokens = "Dar Fichas"
TEXT.NumberOfTokensToGive = "Número de fichas para dar"
TEXT.GivePersonTokens = function(person) return "Dar a " .. person .. " Fichas" end
TEXT.Warn = "Advertir" -- (verb)
TEXT.WarnLower = "advertir"
TEXT.Warning = "Advertencia"
TEXT.WARNING = "ADVERTENCIA"
TEXT.Kick = "Botar" -- (verb)
TEXT.KickLower = "botar"
TEXT.Ban = "Prohibir" -- (verb)
TEXT.BanLower = "prohibir"
TEXT.Reason = "Razón"
TEXT.ReasonForBanningName = function(name) return "Razón para prohibir " .. name .. " del servidor" end
TEXT.UseItem = "Usar"
TEXT.TakeAmmo = "Sacar la munición"
TEXT.PlaceInBackpack = "Colocar en Mochila"
TEXT.InventoryFull = "¡Mochila llena!"
TEXT.SoundsNotAllowed = "No está permitido el uso de eso porque un admin decidió que lo estes abusando."
TEXT.SelectModel = "Seleccionar Modelo"
TEXT.Rotate = "Girar"
TEXT.Body = "Cuerpo"
TEXT.Face = "Cara"
TEXT.Far = "Lejano"
TEXT.OK = "OK"
TEXT.PlayerInformation = "Información del Jugador"
TEXT.Name = "Nombre"
TEXT.Title = "Título"
TEXT.Association = "Asociación"
TEXT.PlayerMenu = "Menú del Jugador"
TEXT.GeneralInfo = "Información general."
TEXT.OpenPlayerMenu = "Abrir menú del jugador"
TEXT.PlayerImage = "Quién es ese huevón?"
TEXT.WarningTo = function(name) return "Mandar una advertencia a " .. name end
TEXT.ReasonForKicking = function(reason) return "Razón por botando " .. name end
TEXT.MaxReached = "¡Este equipo está lleno!"
TEXT.MaxIsOne = "¡Este equipo está lleno!"
TEXT.Roles = "Papeles"
TEXT.Backpack = "Mochila"
TEXT.Business = "Negocio"
TEXT.Scoreboard = "Marcador"
TEXT.Help = "Ayuda"
TEXT.HelpLower = "ayuda"
TEXT.QuietLower = "callar"
TEXT.Always = "siempre"
TEXT.ForAlways = "siempre"
TEXT.For = "por"
TEXT.BanFor = "Prohibir por..."
TEXT.OneHour = "una hora"
TEXT.SixHours = "6 horas"
TEXT.OneDay = "1 día"
TEXT.OneWeek = "1 semana"
TEXT.OneMonth = "1 mez"
TEXT.VitalSigns = "Signos Vitales"
TEXT.Dead = "Muerto"
TEXT.Healthy = "Saludable"
TEXT.NearDeath = "Cercano a la muerte"
TEXT.DeathImminent = "La muerte es inminente"
TEXT.NewCharacter = "Nuevo personaje"
TEXT.WelcomeToCakescriptG2 = "CityScript - Un juego por philxyz con base de Cakescript G2"
TEXT.PersonalInformation = "Informacion Personal"
TEXT.First = "Nombre"
TEXT.Last = "Apellido"
TEXT.Unemployed = "Desempleado"
TEXT.Appearance = "Apariencia"
TEXT.SelectModel = "Seleccione el modelo"
TEXT.Apply = "Aplicar" -- (verb)
TEXT.CreateNewCharacter = "Crear Nuevo Personaje"
TEXT.FirstNameLastNameError = "¡Debe ingresar un nombre y apellido!"
TEXT.SelectCharacter = "Seleccione Personaje"
TEXT.CharacterName = "Nombre de Personaje"
TEXT.CharacterMenu = "Menu de Personaje"
TEXT.RoleName = "Nombre de Papel"
TEXT.Salary = "Salario"
TEXT.DeleteCharacter = "Eliminar Personaje"
TEXT.BusinessAccess = "Acceso a Negocio"
TEXT.PublicRole = "Papel Sector-Público?"
TEXT.RoleKey = "Clave del Papel"
TEXT.CharSwitchOrNew = "Cambiar a otro personaje o crear uno nuevo."
TEXT.CommonCommandsOrRole = "Ejecutar algunos comandos comunes o configurar su papel."
TEXT.ViewYourInventory = "Ver su inventario."
TEXT.PurchaseItems = "Comprar."
TEXT.ViewScoreboard = "Ver el marcador."
TEXT.HelpTextMenu = "¡Obtener ayuda con CakeScript!"
TEXT.AdminCommandsMenu = "Unos comandos de admin..."
TEXT.AddedClientsideLuaFilePath = function(path) return "Archivo de lua (cliente) añadido: '" .. path .. "'" end
TEXT.SuicideIsDisabled = "¡El suicidio no está permitido!"
TEXT.LongTitle = "¡El título es demasiado largo! Max 32 caracteres"
TEXT.IncorrectRole = "¡Papel incorrecta!"
TEXT.NoJobChangeWhileDeadInJail = "¡No se puede cambiar de trabajo mientras siendo muerto en la cárcel!"
TEXT.NoJobChangeWhileAliveInJail = "Estás en la cárcel. Conseguir un nuevo trabajo cuando has sido liberado."
TEXT.NewRoleBackpackEmptied = "¡Nuevo papel seleccionado, mochila vaciado!"
TEXT.NotYourDoor = "¡Este no es su puerta!"
TEXT.DoorNotRentable = "¡No se puede alquilar!"
TEXT.DoorRented = "¡Puerta alquilado!"
TEXT.DoorCharged = "¡Hijo de puerta. Has pagado 50 fichas por alquiler de puerta!"
TEXT.DoorLost = "Has perdido una puerta por falta de fondos."
TEXT.DoorRentCancelled = "Alquiler esta puerta se detuvo"
TEXT.DoorAlreadyRented = "¡Esta puerta ya está alquilado por otra persona!"
TEXT.DoorRentingEnabled = "¡Alquilado de puertas habilitado para que esta puerta!"
TEXT.DoorRentingDisabled = "¡Alquilado de puertas deshabilitado para que esta puerta!"
TEXT.WeaponNotDroppable = "¡Esta arma no se puede soltar!"
TEXT.GiveMoneyUsedIncorrectly = "Mensaje GiveMoney utilizado incorectamente."
TEXT.YouGaveX_Y_Tokens = function(name, amount) return "¡Usted le dio a " .. name .. " " .. amount .. " fichas!" end
TEXT.X_GaveYouY_Tokens = function(name, amount) return "¡" .. name .. " le dio a ti " .. amount .. " fichas!" end
TEXT.InvalidAmount = "¡Monto inválido!"
TEXT.TargetNotFound = "¡No encontrado!"
TEXT.FirstJailPosCreated = "¡Primera posición de la cárcel creado!"
TEXT.ExtraJailPosCreated = "¡Posición de la cárcel añadido!"
TEXT.RemovedAllCreatedNew = "Eliminado todas las posiciones de la cárcel y se añade una nueva aquí"
TEXT.Failed = "fallado"
TEXT.FailedWithError = "fallado con error"
TEXT.InvalidErrorCode = "Código de error inválido"
TEXT.Error = {}
TEXT.Error[1] = "Se ha intentado llamar Hook mientras modo de juego no está completamente cargado"
TEXT.Error[2] = "Hook no se encuentra un nombre único"
TEXT.Error[3] = "Hook no se encuentra un callback"
TEXT.Error[4] = "No se pudo recuperar el SteamID del jugador"
TEXT.Error[5] = "Personaje no existe"
TEXT.Error[6] = "Campo inválido"
TEXT.Error[7] = "El campo no se encuentra"
TEXT.Error[8] = "Archivo de datos dañado"
TEXT.RunningTeamHook = "Ejecutando Hook de equipo"
TEXT.AddingTeamHook = "Adding team hook"
TEXT.RunningHook = "Ejecutando Hook"
TEXT.AddingHook = "Añadiendo Hook"
TEXT.PluginsInit = "Inicializando los plugins"
TEXT.SchemasInit = "Inicializando los esquemas"
TEXT.GamemodeInit = "Inicializando modo de juego"
TEXT.PayAnnouncement = function(amount) return "¡Cheque de pago! " .. tostring(amount) .. " fichas recibidos!" end
TEXT.PayDayMissedBecauseArrested = "¡Día de pago de perdido! (detenido)"
TEXT.PlayerHasDiedInJail = function(name) return "¡" .. name .. " ha muerto en la cárcel!" end
TEXT.BankedTokensForNPCKill = function(amount) return "¡Recibido " .. amount .. " Fichas por matar un NPC!" end
TEXT.DeadUntilSentenceComplete = "¡Estas muerto hasta que te sirves tu tiempo en la cárcel!"
TEXT.ScottFree = "¡Ya no estas bajo arresto porque no hay puestos de cárcel establecidos!"
TEXT.Yes = "Sí"
TEXT.No = "No"
TEXT.Purchase = "Comprar"
TEXT.NotEnoughTokens = "¡Falta Fichas!"
TEXT.NoAccessToBusinessTab = "¡No tienes acceso a la pestaña de negocios!"
TEXT.OOCName = "Nombre FDP"
TEXT.LoadingPlayerDataFor = "Cargando datos de jugador para"
TEXT.CreatingNewPlayerDataFor = "Creando nuevos dataos de jugador para"
TEXT.DeathMode = "Iniciando 'modo de muerte' para"
TEXT.ArrestMessage = function(time) return "¡Has sido arrestado por " .. time .. " segundos!" end
TEXT.ArrestMessage2 = function(name, time) return "¡" .. name .. " ha sido arrestado por " .. tostring(time) .. " segundos!" end
TEXT.JailPunishMessage = function(time) return "¡Castigo por desconectar! Encarcelado por: " .. time .. " segundos." end
TEXT.AddingItemToInventory = function(class, str) return "Añadiendo ít '" .. class .. "' a " .. str .. " la mochila" end
TEXT.RemovingItemFromInventory = function(class, str) return "Sacando ít '" .. class .. "' de " .. str .. " la mochila" end
TEXT.LogMoneyChange = function(steamID, uid, amount) return "Cambiando " .. steamID .. "-" .. uid .. " dinero por " .. tostring( amount ) end
TEXT.LogSetMoneyChange = function(steamID, uid, amount) return "Cambiando " .. steamID .. "-" .. uid .. " dinero a " .. tostring( amount ) end
TEXT.SetMoneyChange = function(who, amount) return "Cantidad de fichas para " .. who .. " cambiado a: " .. amount end
TEXT.BadArgumentTokenAmount = "Mal argumento de comando (cantidad de fichas)"
TEXT.LoadingPluginBy = function(name, author, description) return "Cargando plugin " .. name .. " por " .. author .. " ( " .. description .. " )" end
TEXT.InitializingPlugin = "Inicializando Plugin"
TEXT.LoadingSchema = function(schemaname, schemaauthor, schemadescription) return "Cargando esquema " .. schemaname .. " por " .. schemaauthor .. " ( " .. schemadescription .. " )" end
TEXT.AddedTeam = "Equipo añadido"
TEXT.Owner = "Dueño"
TEXT.GroceryStoreOwner = "Dueño de tienda de mercado"
TEXT.GunStoreOwner = "Dueño de tienda de armas"
TEXT.CarDealershipOwner = "Dueño de Concesionario de Vehiculos"
TEXT.BlackMarketDealer = "Distribuidor Mercado Negro"
TEXT.MedicalSpecialist = "Especialista medico"
TEXT.BloodBrothersGangLeader = "Lider de Hermanos de la sangre"
TEXT.BloodBrothersGangMember = "Miembro de Hermanos de la sangre"
TEXT.LaFamigliaVontoriniGangLeader = "Lider de La Famiglia Vontorini"
TEXT.LaFamigliaVontoriniGangMember = "Miembro de La Famiglia Vontorini"
TEXT.TheLegionGangLeader = "Lider de La Legion"
TEXT.TheLegionGangMember = "Miembro de La Legion"
TEXT.CityPolice = "Policía"
TEXT.CityMayor = "Alcalde"
TEXT.MustBeLookingAtDoor = "Debe estar frente a una puerta!"
TEXT.DoorAdded = "Puerta añadida"
TEXT.RPWarnInvalidArgumentCount = "¡Cantidad de argumentos inválido! ( rp_admin " .. TEXT.WarnLower .. " \"nombre\" \"advertencia\" )"
TEXT.RPKickInvalidArgumentCount = "¡Cantidad de argumentos inválido! ( rp_admin " .. TEXT.KickLower .. " \"nombre\" \"razón\" )"
TEXT.RPBanInvalidArgumentCount = "¡Cantidad de argumentos inválido! ( rp_admin " .. TEXT.BanLower .. " \"nombre\" \"razón\" minutos )"
TEXT.SomeoneHasBeenWarned = function(name) return "¡" .. name .. " ha sido advertido!" end
TEXT.CanNotFindPlayer = function(name) return "¡No se encuentra " .. name .. "!" end
TEXT.BanInfo = function(uid, mins, reason) return uid .. " \"Prohibido por " .. mins .. " mins ( " .. reason .. " )\"\n" end
TEXT.BannedName = function(name) return "prohibido a " .. name end
TEXT.ReportAdminChangeMade = function(arg1, arg2) return arg1 .. " se ha cambiado a " .. arg2 end
TEXT.InvalidConvar = function(convar) return "¡" .. convar .. " no es un convar válida! Usar rp_admin " .. TEXT.ListVars end
TEXT.ListVarsHeader = "---Lista de ConVars para Cakescript + CityScript---"
TEXT.ListAdminCmdsHeader = "---Lista de comandos de admin para Cakescript + CityScript---"
TEXT.ListAllAdminCommands = "Lista de todos comandos de admin"
TEXT.ListVars = "listarvares"
TEXT.WarnSomeone = "Advertir a alguien en el servidor"
TEXT.KickSomeone = "Botar alguien del servidor"
TEXT.BanSomeone = "Prohibir alguien del servidor"
TEXT.SetVar = "Cambiar un Convar"
TEXT.SetVarsCmd = "asignarvar"
TEXT.SetVarInvalidArgumentCount = "¡Cantidad de argumentos inválido! ( rp_admin " .. TEXT.SetVarsCmd .. " \"nombredevar\" \"valor\" )"
TEXT.ListConVars = "Listar las ConVars"
TEXT.ItIsATable = "no se puede cambiar - es una tabla."
TEXT.NotValidListVar = "no es un convar válido! Utilizar rp_admin " .. TEXT.ListVars
TEXT.Quiet = "Si a un jugador en particular se permite utilizar los botones del menú de voz."
TEXT.QuietCommandUsageError = "Uso incorecto del comando. Intenta con: rp_admin " .. TEXT.Quiet .. " <nombredeusuario> [1|0]"
TEXT.WaitPlease = function(time) return "¡Por favor espere " .. time .. " segundos antes de usar el chat 'FDP' de nuevo!" end
TEXT.BROADCAST = "EMISIÓN"
TEXT.ADVERT = "ANUNCIO"
TEXT.LackingTokens = function(amount) return "¡No tiene suficientes fichas! Necesitas " .. amount .. " para mandar un anuncio." end
TEXT.AdvertismentsDisabled = "Los anuncios son desactivados"
TEXT.RADIO = "RADIO"
TEXT.SlashMeCommand = "/yo"
TEXT.YellCommand = "/g" -- Gritar
TEXT.WhisperCommand = "/s" -- Susurro
TEXT.AdCommand = "/anuncio"
TEXT.OOCCommand = "/fdp" -- Fuera de papel
TEXT.OOCCommand2 = "//"
TEXT.BroadcastCommand = "/em" -- Emisión
TEXT.RadioCommand = "/radio"
TEXT.SpawnNotAllowed = "¡No se le permite a desovar nada!"
TEXT.LimitReached = function(limit) return "¡Has llegado a tu límite! (" .. limit .. ")" end
TEXT.ExtrapropsCommandBadUsage = "¡Cantidad de argumentos no es válido! ( rp_admin " .. TEXT.ExtraProps .. " \"nombre\" monto )"
TEXT.ExtraStuffAdvice = function(thing, amount, adminName) return "Tus extra " .. thing .. " ha sido cambiado a: " .. amount .. " por " .. adminName end
TEXT.ExtraStuffAdvice2 = function(target, thing, amount) return thing .. " de " .. target .. " ha sido cambiado a: " .. amount end
TEXT.ExtraragdollsCommandBadUsage = "¡Cantidad de argumentos no es válido! ( rp_admin " .. TEXT.ExtraRagdolls .. " \"nombre\" monto )"
TEXT.ExtravehiclesCommandBadUsage = "¡Cantidad de argumentos no es válido! ( rp_admin " .. TEXT.ExtraVehicles .. " \"nombre\" monto )"
TEXT.ExtraeffectsCommandBadUsage = "¡Cantidad de argumentos no es válido! ( rp_admin " .. TEXT.ExtraEffects .. " \"nombre\" monto )"
TEXT.ChangeAnExtraPropsLimit = "Cambiar limite de extra props para alguien"
TEXT.ChangeAnExtraRagdollsLimit = "Cambiar limite de extra muñecas de trapo para alguien"
TEXT.ChangeAnExtraVehiclesLimit = "Cambiar limite de extra vehículos para alguien"
TEXT.ChangeAnExtraEffectsLimit = "Cambiar limite de extra efectos para alguien"
TEXT.IncorrectNumberOfArguments = "¡Cantidad de argumentos no es válido!"

TEXT.ToolTrustInvalidArguments = "¡Cantidad de argumentos no es válido! ( rp_admin " .. TEXT.ToolTrust .. " \"nombre\" 1/0 )"
TEXT.ToolTrustGivenBy = function(adminName) return adminName .. " dio a ti " .. TEXT.ToolTrust end
TEXT.ToolTrustGivenAnnounce = function(targetName) return targetName .. " ha recibido " .. TEXT.ToolTrust end
TEXT.ToolTrustRevokedBy = function(adminName) return "Tu " .. TEXT.ToolTrust .. " ha sido revocado por " .. adminName end
TEXT.ToolTrustRevokedAnnounce = function(targetName) return TEXT.ToolTrust .. "ha sido revocado de " .. targetName end

TEXT.PhysTrustInvalidArguments = "¡Cantidad de argumentos no es válido! ( rp_admin " .. TEXT.PhysTrust .. " \"nombre\" 1/0 )"
TEXT.PhysTrustGivenBy = function(adminName) return adminName .. " dio a ti " .. TEXT.PhysTrust end
TEXT.PhysTrustGivenAnnounce = function(targetName) return targetName .. " ha recibido " .. TEXT.PhysTrust end
TEXT.PhysTrustRevokedBy = function(adminName) return "Tu " .. TEXT.PhysTrust .. " ha sido revocado por " .. adminName end
TEXT.PhysTrustRevokedAnnounce = function(targetName) return TEXT.PhysTrust .. "ha sido revocado de " .. targetName end

TEXT.GravTrustInvalidArguments = "¡Cantidad de argumentos no es válido! ( rp_admin " .. TEXT.GravTrust .. " \"nombre\" 1/0 )"
TEXT.GravTrustGivenBy = function(adminName) return adminName .. " dio a ti " .. TEXT.GravTrust end
TEXT.GravTrustGivenAnnounce = function(targetName) return targetName .. " ha recibido " .. TEXT.GravTrust end
TEXT.GravTrustRevokedBy = function(adminName) return "Tu " .. TEXT.GravTrust .. " ha sido revocado por " .. adminName end
TEXT.GravTrustRevokedAnnounce = function(targetName) return TEXT.GravTrust .. "ha sido revocado de " .. targetName end

TEXT.PropTrustInvalidArguments = "¡Cantidad de argumentos no es válido! ( rp_admin " .. TEXT.PropTrust .. " \"nombre\" 1/0 )"
TEXT.PropTrustGivenBy = function(adminName) return adminName .. " dio a ti " .. TEXT.PropTrust end
TEXT.PropTrustGivenAnnounce = function(targetName) return targetName .. " ha recibido " .. TEXT.PropTrust end
TEXT.PropTrustRevokedBy = function(adminName) return "Tu " .. TEXT.PropTrust .. " ha sido revocado por " .. adminName end
TEXT.PropTrustRevokedAnnounce = function(targetName) return TEXT.PropTrust .. "ha sido revocado de " .. targetName end

TEXT.ChangeATrust = function(kind) return "Cambiar '" .. kind .. "' para alguien" end -- e.g: proptrust where kind = "prop"
TEXT.SoundDoesNotExist = "No existe este sonido. Utilizar rp_listvoices"
TEXT.ListOfVoicesHeader = "---Lista de voces para CakeScript + CityScript---"
TEXT.NoteRoleSpecific = "Tenga en cuenta que voces pertenecen a sus papeles"
TEXT.FireShock = function(amount) return "¡Santos humos! Acabamos de perder " .. tostring(amount) .. " Fichas a fuego!" end
TEXT.MeteorStormApproaching = "ADVERTENCIA: ¡Acercamiento de tormenta de meteoros!"
TEXT.MeteorStormPassing = "VAYA: ¡Tormenta de meteoros pasando!"
TEXT.MeteorStormEnabled = "Tormenta de meteoros activado"
TEXT.MeteorStormDisabled = "Tormenta de meteoros desactivado"
TEXT.INCOMING = "¡ENTRANTE!"
TEXT.EnableMeteorCommand = "/activartormentas"
TEXT.DisableMeteorCommand = "/desactivartormentas"
TEXT.RemoveItemCommand = "/rm"
TEXT.NothingToRemove = "¡No hay nada que quitar!"
TEXT.ItemRemoved = "¡Se eliminó el elemento!"
TEXT.ATMRemoved = "¡Cajero eliminado!"
TEXT.TitleCommand = "/etiquetar"
TEXT.MustBeAtLeast1Token = "¡Monto invalido. Debe ser al menos 1 ficha!"
TEXT.ToRemoveThisATM = "Para eliminar este cajero, mirarlo y teclar " .. TEXT.RemoveItemCommand
TEXT.QueryBalance = function(amount) return "Saldo bancario: " .. tostring(amount) .. " Fichas" end
TEXT.ConfirmDeposit = function(amount) return tostring(amount) .. " fichas depositadas. ¡Gracias!" end
TEXT.NotEnoughInBank = "¡No tienes esa cantidad en el banco!"
TEXT.ConfirmWithdrawal = function(amount) return tostring(amount) .. " fichas sacadas. ¡Gracias!" end
TEXT.TransferCorrection = "Debe ser: " .. TEXT.ATMTransferCommand .. " <" .. TEXT.Amount .. ">\\" .. "[" .. TEXT.NameOrUserID .. "]"
TEXT.X_HasGiven_Y_Tokens_YourBank = function(giver, amount) return "¡" .. giver .. " ha transferido " .. tostring(amount) .. " fichas a tu cuenta bancaria!" end
TEXT.X_Tokens_Transferred_to_Y = function(amount, target) return tostring(amount) .. " tokens transferidos a la cuenta bancaria de: " .. target .. ". ¡Gracias!" end
TEXT.BankInterestReceived = function(amount) return "¡Has recibido " .. tostring(amount) .. " fichas in intereses!" end
TEXT.GiveCommand = "/dar"
TEXT.DropTokensCommand = "/soltarfichas"
TEXT.DropTokensCommand2 = "/soltardinero"
TEXT.DropTokensCommand3 = "/dinerosoltar"
TEXT.DropTokensCommand4 = "/fichasoltar"
TEXT.SetMoneyUsedIncorrectly = "¡Comando utilizado incorectamente! Debe ser: rp_setmoney (name) (token amount)"
TEXT.SetMoneyCommandAbout = "Comando para dar fichas a jugadores."
TEXT.NewSpawnPointCreated = function(teamID) return "Nuevo punto de desove para equipo: " .. tostring(teamID) .. " creado! Para eliminar, utilizar " .. TEXT.RemoveSpawnsCommand end
TEXT.BoxLabelUpdated = "Etiqueta de caja actualizada!"
TEXT.ZombiesApproaching = "¡Zombis están viniendo! (por supuesto)"
TEXT.ZombiesLeaving = "¡Zombis están saliendo!"
TEXT.ClearedAllZombiePositions = "¡Se han eliminado todas las posiciones de desove zombi!"
TEXT.ZombieSpawnPosAdded = "Has añadido una posición de desove zombi."
TEXT.InvalidMaxZombies = "Comando no valido! Vuelve a intentar con: " .. TEXT.MaxZombiesCommand .. " <numero positivo>"
TEXT.SetMaxZombiesTo = "Max Zombis establecidos como"
TEXT.ZombiesNowEnabled = "¡Los zombis están activadas!"
TEXT.ZombiesNowDisabled = "¡Los zombis están desactivadas!"
TEXT.ShowBalance = "Mostrar saldo"
TEXT.AdminFreezeATM = "Instalar Cajero"
TEXT.AdminRemoveATM = "Eliminar Cajero"
TEXT.WithdrawTokens = "Retirar Fichas"
TEXT.MakeAWithdrawal = "Hacer un retiro"
TEXT.HowManyTokens = "Cuantas fichas?"
TEXT.DepositTokens = "Depositar Fichas"
TEXT.MakeADeposit = "Hacer un Deposito"
TEXT.TransferTokens = "Transferir Fichas"
TEXT.ToWhichPlayer = "¿A quien?"
TEXT.Weakling = "Esto es demasiado pesada para tu lo muevas, débilucho!"
TEXT.ATM = "Cajero Automatico"
TEXT.SpawnNewATM = "Generar un nuevo cajero automático"
TEXT.FreezeAnATM = "Instalar un Cajero (miralo primero)"
TEXT.AddCustomPosForCurrentRole = "Añadir posición de desove, para el equipo del papel actual de tu jugador"
TEXT.CustomSpawnPositions = "Eliminar todas las posiciones de desove, para el equipo del papel actual de tu jugador"
TEXT.EnableZombies = "Habilitar Zombies"
TEXT.DisableZombies = "Deshabilitar Zombies"
TEXT.AddZombieSpawnPosHere = "Añadir posición de desove zombi aquí"
TEXT.DropZombies = "Quitar Zombis"
TEXT.EnableMeteorStorm = "Habilitar tormenta de meteoros"
TEXT.DisableMeteorStorm = "Deshabilitar tormenta de meteoros"
TEXT.ClearJailPositions = "Borrar todas las posiciones de cárcel y establecer una aquí"
TEXT.AddJailPosHere = "Añadir posición de la cárcel aquí"
TEXT.Toxics = "Sustancias ilegales"
TEXT.PaidForSellingToxics = "¡Recibido 45 fichas para la venta de sustancias ilegales!"
TEXT.TooPoorForToxics = "¡Eres demasiado pobre para comprar sustancias ilegales!"
TEXT.FreeToxicsForYou = "¡Sustancias ilegales gratis para ti!"
TEXT.BoughtToxics = "Compraste sustancias ilegales por 45 fichas!"
TEXT.SoldToxics = "¡Vendiste sustancias ilegales por 45 fichas!"
TEXT.ToxicCongrats = "¡Felicitaciones! Usted es el nuevo propietario de esta cosa altamente ilegal! La posesión es nueve decimos de la ley."
TEXT.ToxicLab = "Laboratorio de Sustancias Ilegales"
TEXT.ItemProp = "Una vaina"
TEXT.Meteor = "Meteorito"
TEXT.Shipment = "Envío"
TEXT.StorageBox = "Caja de Almacenaje"
TEXT.UseTitleToLabel = "Utilizar " .. TEXT.Title .. " <texto> to para etiquetar"
TEXT.AnnouncePlacedInBox = function(text) return text .. " colocado en la caja" end
TEXT.BoxFull = "¡Esta caja está llena!"
TEXT.StandCloserToTheBox = "¡Acercate más a la caja!"
TEXT.OpeningTheBox = "Abriendo la caja..."
TEXT.WontFitInBackpack = "Este artículo no cabe en tu mochila. Es demasiado grande!"
TEXT.SelectUseItemToPickUpTokens = "Seleccionar \"" .. TEXT.UseItem .. "\" para llevar estas fichas."
TEXT.MePocketsABundleOfTokens = function(amt) return "¡" .. TEXT.SlashMeCommand .. " rellena su bolsillo con " .. tostring(amt) .. " fichas!" end
TEXT.TokenBundle = "Conjunto de fichas"
TEXT.TokenPrinter = "Impresora de Fichas"
TEXT.PrintWhenIAmReady = "Voy a imprimir cuando estoy lista, gracias..."
TEXT.NoJailPositionsExist = "No hay posiciones establecidas para la cárcel!"
TEXT.ArrestedBy = function(name) return "Has sido detenido por " .. name end
TEXT.SignalFlare = "Bengala de señales"
TEXT.CallForHelp = "Llamar por ayuda!"
TEXT.SignalFlareInstructions = "Primario para lanzar un cohete.\nSecundaria para hacer un zoom."
TEXT.Hands = "Manos"
TEXT.ComboFists = "Combo-Puños"
TEXT.ComboFistsInstructions = "Botón izquierdo para jab izquierdo\nBotón derecho para cross de derecha"
TEXT.LockPick = "Selección de la cerradura"
TEXT.LockPickInstructions = "Botón izquierdo para abrir una cerradura"
TEXT.UnarrestStick = "La Batuta de la Libertad"
TEXT.UnarrestStickInstructions = "Clic para librerar alguien"
TEXT.NukePack = "Detonador Paquete Nuclear"
TEXT.NukeDetInstructions = "Apuntar hacia afuera de la cara"
TEXT.DetonationTime = function(time) return "¡Cuenta atrás para la detonacion: ".. tostring(time) .." segundos!" end
TEXT.ItemsHelpHintText = "- Utilizar shift + clic-derecho para interactuar con objecos, puertas, vehículos y jugadores."
TEXT.MainHelpHintText = "- Presionar F1 y haz click en la pestaña de Ayuda para info completo."
TEXT.HideHelpHintsCheckText = "No mostrar en futuro."
TEXT.HelpHintCloseBtn = "Cerrar"
TEXT.FirstTimeHelpTitle = "Ayuda de primer uso"
TEXT.HelpLong = {
	"Bienvenido a CityScript por philxyz - Con base de CakeScript G2 por Nori",
	"",
	"",
	"JUEGO:",
	"Para interactuar con los jugadores, los elementos o puertas, mantenga TAB a continuación, ",
	"haga clic derecho en el objeto con que desea interactuar.",
	"Se puede alquilar puertas, dar dinero a jugadores, recoger cosas y más por medio de este menú.",
	"",
	"F1 para acceder este mismo menú.",
	"Crear un personaje cuando usando el lado izquierdo de la pestaña '" .. TEXT.PlayerMenu .. "'",
	"Una vez creado, tu personaje aparecerá en la lista a la derecha.",
	"Haz clic-doble en un personaje en la lista para empezar.",
	"",
	"Con tiempo, ganarás 'fichas' segun tu rol seleccionado. Estos roles estan en la pestaña \"Roles\".",
	"",
	"Crea una empresa, haz dinero, diviertate!",
	"Cada personaje tiene una pestaña de negocios bajo el menú de F1 con una selección",
	"de elementos que se pueden comprar para su reventa.",
	"",
	"ALGUNOS COMANDOS ÚTILES",
	TEXT.GiveCommand .. " al mirar un jugador para darselo dinero (fichas). Alternativamente, ",
	"Tab-Haga clic en el jugador.",
	TEXT.DropTokensCommand .. " <" .. TEXT.Amount .. "> para sacar dinero de tu billetera.",
	TEXT.TitleCommand .. " <etiqueta> (al mirar a una puerta alquilado por ti).",
	TEXT.TitleCommand .. " <etiqueta> (al mirar a una caja de almacenaje)",
	TEXT.ATMBalanceCommand .. " (mientras frente de un cajero automático) Revisar su saldo bancario.",
	TEXT.ATMWithdrawCommand .. " <" .. TEXT.Amount .. "> (mientras frente de un cajero automático)",
	" Retirar fichas del banco.",
	TEXT.ATMDepositCommand .. " <" .. TEXT.Amount .. "> (mientras frente de un cajero automático) ",
	"Depositar fichas en tu cuenta bancaria",
	TEXT.ATMTransferCommand .. " <" .. TEXT.Amount .. ">\\[" .. TEXT.NameOrUserID .. "] ",
	"(mientras frente de un cajero automático) Transferir fichas bancarias a otro jugador.",
	TEXT.SlashMeCommand .. " - Hablar en tercera persona.",
	TEXT.YellCommand .. " - Hablar un poco más alto que otros puedan escuchar (Gritar).",
	TEXT.WhisperCommand .. " - Hablar en voz baja a la persona a tu lado (Susurro).",
	TEXT.AdCommand .. " - Anunciar sus mercancías.",
	TEXT.OOCCommand .. " o " .. TEXT.OOCCommand2 .. " - Hablar fuera de papel.",
	TEXT.BroadcastCommand .. " - Hacer un anuncio a través de las ondas.",
	TEXT.RadioCommand .. " - Hablar por la radio.",
	TEXT.TitleCommand .. " <etiqueta> (al mirar una puerta no-alquilable) - (superadmin)",
	TEXT.NewATMCommand .. " Crear un nuevo cajero automático para este mapa. - (superadmin)",
	TEXT.FreezeATMCommand .. " Guardar la posición de un cajero automático para este mapa. - (superadmin)",
	TEXT.AddSpawnCommand .. " - Remover un punto de desove aquí para el equipo actual. (admin / superadmin)",
	TEXT.RemoveSpawnsCommand .. " - Remover todos los punto de desove aquí para el equipo actual. (admin / superadmin)",
	TEXT.EnableZombiesCommand .. " - Habilitar Zombis. (admin / superadmin)",
	TEXT.DisableZombiesCommand .. " - Deshabilitar Zombis. (admin / superadmin)",
	TEXT.MaxZombiesCommand .. " - Limite para la presencia de zombis (cantidad). (admin / superadmin)",
	TEXT.AddZombieCommand .. " - Añade una nueva posición de desove para los zombis en este mapa. (admin / superadmin)",
	TEXT.DropZombiesCommand .. " - Suelta todas las posiciones de desove de zombi para este mapa (de la base de datos). (admin / superadmin)",
	TEXT.EnableMeteorStormCommand .. " - Habilitar tormenta de meteoros. (admin / superadmin)",
	TEXT.DisableMeteorStormCommand .. " - Deshabilitar tormenta de meteoros. (admin / superadmin)",
	TEXT.AddJailPosCommand .. " - Borrar todas las posiciones de la cárcel y hacer uno aquí. (admin / superadmin)",
	TEXT.AddExtraJailPosCommand .. " - Añadir una posición adicional de cárcel. (admin / superadmin)",
	"",
	"COMANDOS ADMIN",
	"rp_admin " .. TEXT.ToolTrust .. " <nombre_del_jugador> [1|0]          Dar o Revocar Toolgun.",
	"rp_admin " .. TEXT.PhysTrust .. " <nombre_del_jugador> [1|0]          Dar o Revocar Physgun.",
	"rp_admin " .. TEXT.PropTrust .. " <nombre_del_jugador> [1|0]          Dar or Revocar capacidad de desovar props.",
	"",
	"rp_admin " .. TEXT.ExtraEffects .. " <nombre> <monto>           Permitir que un jugador tiene <monto> efectos adicionales.",
	"rp_admin " .. TEXT.ExtraVehicles .. " <nombre> <monto>          Permitir que un jugador tiene <monto> vehículos adicionales.",
	"rp_admin " .. TEXT.ExtraProps .. " <nombre> <monto>             Permitir que un jugador tiene <monto> props adicionales.",
	"rp_admin " .. TEXT.ExtraRagdolls .. " <nombre> <monto>          Permitir que un jugador tiene <monto> muñecas de trapo adicionales.",
	"",
	"rp_admin " .. TEXT.ListVars .. "                               Lista de configuraciónes disponibles al admin.",
	"rp_admin " .. TEXT.SetVarsCmd .. " <valor>                         Cambiar una de las configuraciónes.",
	"",
	"rp_admin " .. TEXT.HelpLower .. "                        Lista de opciónes para rp_admin",
	"rp_admin " .. TEXT.QuietLower .. " <nombre> [1|0]            Prevenir que un jugador utilice chat-voces. (no se refiere al mic!).",
	"rp_admin " .. TEXT.BanLower .. " <nombre> <razón> <minutos>          Botar un jugador de manera que no se vuelvan a conectar.",
	"rp_admin " .. TEXT.KickLower .. " <nombre> <razón>                   Botar un jugador del servidor.",
	"rp_admin " .. TEXT.WarnLower .. " <nombre> <mensajedeadvertencia>           Advertir a un jugador.",
	"",
	"rp_createitem <nombre_de_clase_de_objeto>                 Desovar un objeto del clase especificado.",
	"rp_setmoney <nombre> <monto>              Configurar la cantidad de dinero que tiene un jugador",
	"",
	"rp_listvoices                                   Lista de todos voces disponibles.",
	"",
	"PROTECCIóN DE PROPS",
	"Jugadores pueden manejar sus listas de jugadores confiables y borrar sus props via El menú \"Protección de Props\"",
	"- es una pestaña en la area a la derecha de la lista de desove.",
	"",
	"Administradores del servidor pueden configurar aquí el tiempo hasta limpieza al desconectar.",
	"",
	"Todos los props permitidos en CityScript deben aparecer en la lista de props permitidos. Esto se guarda",
	"en la base de datos y puede ser editado por admins del servidor desde la misma lista de desove.",
	"",
	"Para permitir un prop, haz clic-derecho en el icono del prop en la lista y clic o 'Permitir desovar' o",
	"'Prohibir desovar'. Los cambios toman su efecto instantáneamente.",
	"",
	"ELEMENTOS DEL WORKSHOP NECESARIOS PARA TENER LA EXPERIENCIA COMPLETA:",
	"",
	"CSS Weapons on M9K Base (108720350)",
	"M9K Assault Rifles (128089118)",
	"M9K Small Arms Pack (128093075)",
	"M9K Heavy Weapons (128091208)",
	"M9K Specialities (144982052)",
	"Nuke (106565409)",
	"",
	"Debieras crear una colección de Workshop que contiene los paquetes mencionados",
	"y el número de su colección necesita ser especificado en la línea de comandos -",
	" por ejemplo: +host_workshop_collection <id>",
	"",
	"Si tienes addons de vehículo para su servidor (para que se vende en el juego),",
	"por favor dale una mirada al archivo: cityscript/gamemode/schemas/cityscript/items/car_buggy.lua",
	"para saber cómo añadir más.",
	"",
	"Se puede copiar nomas este archivo y editarlo para cada vehículo que quiere añadir.",
	"",
	"CRÉDITOS:",
	"Nori / LuaBanana for Cakescript G2",
	"philxyz for CityScript schema",
	"SB Spy for Combo Fists",
	"philxyz for Fire Extinguisher",
	"Rick Dark, Botman"
}
