#!/usr/bin/lua
-- zdyndns_srv.lua, Petit serveur DynDNS minimaliste en Lua
-- En fait cela écoute un socket et mémorise ou affiche l'adresse IP de l'appelant
-- christian@zufferey.com, zf150707.0817,zf161116.1137

--s maman 192.168.0.12, set le nom de l'appelant avec son IP  internet & intranet
--s maman, set seulement le nom de l'appelant avec son IP  internet
--g maman, get la ou les adresse ip internet & intranet du nom de l'appelant mémorisé
--c maman, clear le nom de l'appelant mémorisé
--d, display tous les appelants mémorisés


--Listes des fonctions
function zget_word(line,p1)
	local word
	local p2 = string.find(line, " ", p1)
	if p2 then word = string.sub(line, p1, p2-1) else word = "null" ; p2 = p1 end
	return word,p2
end

function zdisplay_zdb_table(client,zdb_table)
	print("zdisplay_zdb_table......."..os.date("%Y%m%d.%H%M%S"))
	local zkey, zvalue
	for zkey, zvalue in pairs(zdb_table) do
---		print(zkey,zvalue[1],zvalue[2],zvalue[3])
		client:send(zkey.." "..zvalue[1].." "..zvalue[2].." "..zvalue[3].."\n")
	end
end


--main program
print('\nStart...')

local socket = require("socket")
local host = "*" ; local port = 3318
local zdb_table = {}

--zdb_table["maman"] = {"128.178.1.10", "192.168.0.10", "20161115.092226"}
--zdb_table["papa"] = {"128.178.1.11", "192.168.0.11", "20161115.092226"}
--zdb_table["meli"] = {"128.178.1.12", "192.168.0.12", "20161115.092226"}

local server = socket.try(socket.bind(host, port))
print("Please telnet to localhost on port " .. port)

while 1 do
	local client = server:accept()
-- le timout ne fonctionne plus sur Ubuntu et je ne sais pas pourquoi ?, zf 161114.1617
--	client:settimeout(20)
	local line, err = client:receive()
	if not err then 
		z_cli_ip = client:getpeername()
		if string.sub(line,-1) ~= " " then line = line.." " end
		local zcmd = string.sub(line, 1, 1) ; p1 = 2
		if zcmd == "s" then
			zname,p1 = zget_word(line,p1+1)
			z_intra_ip,p1 = zget_word(line,p1+1)
			zdb_table[zname] = {z_cli_ip, z_intra_ip, os.date("%Y%m%d.%H%M%S")}
			print(zname.." "..zdb_table[zname][1].." "..zdb_table[zname][2].." "..zdb_table[zname][3])
			client:send(zname.." "..zdb_table[zname][1].." "..zdb_table[zname][2].." "..zdb_table[zname][3].."\n")
		elseif zcmd == "g" then
			zname,p1 = zget_word(line,p1+1)
			print("."..zname..".")
			if zdb_table[zname] then client:send(zdb_table[zname][1].." "..zdb_table[zname][2].. "\n") end
		elseif zcmd == "d" then
			zdisplay_zdb_table(client,zdb_table)
		elseif zcmd == "c" then
			zname,p1 = zget_word(line,p1+1)
			print("."..zname..".")
			zdb_table[zname] = nil
			zdisplay_zdb_table(client,zdb_table)
		end
	end
	client:close()
end

