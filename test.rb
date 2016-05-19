require_relative 'lib/board-game-gem'
#p BoardGameGem.get_items([15944, 15955, 15956]).to_s

p BoardGameGem.get_items([123260, 123265, 61001], true).map { |x| x.type }


p BoardGameGem.get_item(123260, true)

