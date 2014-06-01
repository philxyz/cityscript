-------------------------------
-- CakeScript Generation 2
-- Author: LuaBanana ( Aka Jake )
-- Project Start: 5/24/2008
--
-- schema.lua
-- Loads and configures the schema
-------------------------------

CAKE.Schemas = {  };

function CAKE.LoadSchema( schema )

	local path = "schemas/" .. schema .. ".lua";
	
	SCHEMA = {  };
	
	include( path );
	
	CAKE.DayLog( "script.txt", TEXT.LoadingSchema(SCHEMA.Name, SCHEMA.Author, SCHEMA.Description) );
	
	table.insert( CAKE.Schemas, SCHEMA );
	
	-- Load the plugins
	
	local list = file.Find( "cityscript/gamemode/schemas/" .. schema .. "/plugins/*.lua", "lsv" );
	
	for k, v in pairs( list ) do
	
		CAKE.LoadPlugin( schema, v );
		
	end
	
	-- Load the items
	local list = file.Find( "cityscript/gamemode/schemas/" .. schema .. "/items/*.lua", "lsv" );
	
	for k, v in pairs( list ) do
	
		CAKE.LoadItem( schema, v );
		
	end
	
	if( SCHEMA.Base != nil ) then
	
		CAKE.LoadSchema( SCHEMA.Base )
		
	end
	
end

function CAKE.InitSchemas( )

	for _, SCHEMA in pairs( CAKE.Schemas ) do
		
		CAKE.CallHook( "InitSchema", SCHEMA );
		SCHEMA.SetUp( );
		
	end
	
end

CAKE.ValidModels = {};

function CAKE.AddModels(mdls)

	if(type(mdls) == "table") then
	
		for k, v in pairs(mdls) do

			table.insert(CAKE.ValidModels, v)

		end
		
	else
	
		table.insert(CAKE.ValidModels, mdls)
		
	end
	
end
