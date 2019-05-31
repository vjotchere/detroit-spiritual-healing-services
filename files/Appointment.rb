class Appointment
    attr_reader :time, :service, :clinet, :is_recurring

    def initialize(time, service, client, is_recurring)
        @time = time
        @service = service
        @client = client
        @is_recurring = is_recurring
    end
end
