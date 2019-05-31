class Appointment
    def initialize(time, service, client, isRecurring)
        @time = time
        @service = service
        @client = client
        @isRecurring = isRecurring
    end

    def get_time
        @time
    end

    def get_service
      @service
    end

    def get_isRecurring
      @isRecurring
    end
end