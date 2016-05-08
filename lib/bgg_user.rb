module BoardGameGem
	class BGGUser < BGGBase

		attr_reader :id, :name, :avatar, :year_registered, :last_login, :state, :trade_rating

		def initialize(xml)
			super
			@id = get_integer("user", "id")
			@name = get_string("user", "name")
			@avatar = get_string("avatarlink", "value")
			@year_registered = get_integer("yearregistered", "value")
			@last_login = get_string("lastlogin", "value")
			@state = get_string("stateorprovince", "value")
			@trade_rating = get_integer("traderating", "value")
		end

		def get_collection
			return BoardGameGem.get_collection(@name)
		end
	end
end