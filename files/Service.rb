class Service
    def initialize(name, price, length)
        @name = name
        @price = price
        @length = length
    end

    def get_name()
      @name
    end

    def get_duration()
      @length
    end
end