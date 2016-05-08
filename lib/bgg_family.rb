module BoardGameGem
	class BGGFamily < BGGBase

		attr_reader :id, :thumbnail, :image, :name, :alternate_names, :description

		def initialize(xml)
			@id = get_integer(xml, "item", "id")
			@thumbnail = get_string(xml, "thumbnail")
			@image = get_string(xml, "image")
			@name = get_string(xml, "name[type='primary']", "value")
			@alternate_names = get_strings(xml, "name[type='alternate']", "value")
			@description = get_string(xml, "description")
		end
	end
end