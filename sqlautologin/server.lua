-------------------------------
sql = {
	host = '127.0.0.1',
	port = '3306',
	user = 'mta',
	pass = 'mtasa123',
	database = 'mta'
}
-------------------------------
local db = {}
db.connection = dbConnect('mysql','dbname='..sql.database..';host='..sql.host..';charset=utf8',sql.user,sql.pass,'share=0')


function checkPlayer(player)
	local plr = source or player
end

addEventHandler('onPlayerJoin',root,checkPlayer)

addEventHandler('onResourceStart',resourceRoot,function()
	for i,v in pairs(getElementsByType('player')) do
		checkPlayer(v)
	end
end)

function callback(data)
	local result = dbPoll(data,0)
end

function db.query(query)
	if query and type(query) == 'string' and db.connection then
		dbQuery(callback,db.connection,query)
	end
end

function db.exec(query,...)
	if query and type(query) == 'string' and db.connection and arg[1] then
		print(db.connection,query,unpack(arg))
		dbExec(db.connection,query,unpack(arg))
	end
end

setTimer(function()
	db.exec('CREATE TABLE `??` (`??` VARCHAR(255),`??` VARCHAR(255))','player','blah','eh')
end,1000,1)