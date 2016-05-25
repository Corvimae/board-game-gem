require_relative 'lib/board-game-gem'
p BoardGameGem.get_collection("sos1", subtype: "boardgame,videogame,rpgitem").items.select { |x| x.type == "videogame" }
