module BoardGameGem
	class BGGUser < BGGBase

		attr_reader :id, :name, :avatar, :year_registered, :last_login, :state, :trade_rating

		def initialize(xml)
			@id = get_integer(xml, "user", "id")
			@name = get_string(xml, "user", "name")
			@avatar = get_string(xml, "avatarlink", "value")
			@year_registered = get_integer(xml, "yearregistered", "value")
			@last_login = get_string(xml, "lastlogin", "value")
			@state = get_string(xml, "stateorprovince", "value")
			@trade_rating = get_integer(xml, "traderating", "value")
		end

		def get_collection
			return BoardGameGem.get_collection(@name)
		end
	end
end