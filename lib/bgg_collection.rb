module BoardGameGem
	class BGGCollection < BGGBase

		attr_accessor :count, :items

		def initialize(xml)
			if !xml.nil?
				@count = get_integer(xml, "items", "totalitems")
				@items = []
				xml.css("item").each do |item|
					@items.push(BGGCollectionItem.new(item))
				end
			else
				@count = -1
				@items = []
			end
		end

		def status_of(id)
			item = @items.find { |x| x.id == id}
			item ? item.status : nil
		end

		def get_owned
			return filter_by(:own)
		end

		def get_previously_owned
			return filter_by(:prev_owned)
		end

		def get_wants
			return filter_by(:want)
		end

		def get_want_to_play
			return filter_by(:want_to_play)
		end

		def get_want_to_buy
			return filter_by(:want_to_buy)
		end

		def get_wishlist
			return filter_by(:wishlist)
		end

		def get_preordered
			return filter_by(:preordered)
		end

		def get_for_trade
			return filter_by(:for_trade)
		end
		
		private

		def filter_by(key)
			return @items.select { |x| x.status[key] }
		end
	end
end