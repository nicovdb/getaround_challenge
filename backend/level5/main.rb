require 'json'
require 'date'
require_relative 'models/car.rb'
require_relative 'models/rental.rb'
require_relative 'models/option.rb'

class Main
  class << self
    def call
      @data = JSON.parse(File.read('./data/input.json'))
      create_cars
      create_options
      create_rentals
      generate_json
    end

    private

    def create_cars
      $cars = @data["cars"].map { |car_attr| Car.new(car_attr) }
    end

    def create_rentals
      @rentals = @data["rentals"].map { |rental_attr| Rental.new(rental_attr) }
    end

    def create_options
      $options = @data["options"].map { |option_attr| Option.new(option_attr) }
    end

    def generate_json
      rentals_prices = { rentals: @rentals.map(&:price_per_action_with_options_hash) }
      File.write('data/output.json', JSON.pretty_generate(rentals_prices))
    end
  end
end

Main.call
