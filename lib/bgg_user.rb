module BoardGameGem
	class BGGUser < BGGBase

		attr_reader :id, :name, :avatar, :year_registered, :last_login, :state, :trade_rating

		def initialize(xml)
			if !xml.nil?
				@id = get_integer(xml, "user", "id")
				@name = get_string(xml, "user", "name")
				@avatar = get_string(xml, "avatarlink", "value")
				@year_registered = get_integer(xml, "yearregistered", "value")
				@last_login = get_string(xml, "lastlogin", "value")
				@state = get_string(xml, "stateorprovince", "value")
				@trade_rating = get_integer(xml, "traderating", "value")
			else
				@id = -1
				@name = ""
				@avatar = ""
				@year_registered = -1
				@last_login = "0000-00-00 00:00:00"
				@state = ""
				@trade_rating = -1
			end
		end

		def get_collection
			return BoardGameGem.get_collection(@name)
		end
	end
end