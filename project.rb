require 'tty-prompt'
require_relative "files/Appointment"
require_relative "files/DateTime"
require_relative "files/Organization"
require_relative "files/Service"
require_relative "files/ServiceProvider"

prompt = TTY::Prompt.new
org = Organization.new(prompt)
response = prompt.ask("Enter a command (use 'close' to exit): ")
while (response != "close".downcase)
    case response.downcase
    when "add_service"
        org.add_service()
    when "remove_service"
        org.remove_service()
    when "list_services"
        org.list_services()
    when "add_service_provider"
        org.add_service_provider()
    when "remove_service_provider"
        org.remove_service_provider()
    when "list_service_providers"
        org.list_service_providers()
    when "schedule_appointment"
        org.schedule_appointment()
    else
        puts "\nInvalid command!\n"
        org.list_commands()
    end

    response = prompt.ask("Enter a command (use 'close' to exit): ")
end
