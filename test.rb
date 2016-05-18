require_relative 'lib/board-game-gem'
collection =	BoardGameGem.get_collection("AcceptableIce")

p collection.status_of(68448)
