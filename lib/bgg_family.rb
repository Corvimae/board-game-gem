module BoardGameGem
	class BGGFamily < BGGBase

		attr_reader :id, :thumbnail, :image, :name, :alternate_names, :description

		def initialize(xml)
			super
			@id = get_integer("item", "id")
			@thumbnail = get_string("thumbnail")
			@image = get_string("image")
			@name = get_string("name[type='primary']", "value")
			@alternate_names = get_strings("name[type='alternate']", "value")
			@description = get_string("description")
		end
	end
end