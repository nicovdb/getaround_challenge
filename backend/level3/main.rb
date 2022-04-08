require 'json'
require 'date'
require_relative 'models/car.rb'
require_relative 'models/rental.rb'

class Main
  class << self
    def call
      @data = JSON.parse(File.read('data/input.json'))
      create_cars
      create_rentals
      generate_json
    end

    private

    def create_cars
      $cars = @data["cars"].map { |car| Car.new(car) }
    end

    def create_rentals
      @rentals = @data["rentals"].map { |rental| Rental.new(rental) }
    end

    def generate_json
      rentals_prices = { rentals: @rentals.map(&:price_with_commission_hash) }
      File.write('data/output.json', JSON.pretty_generate(rentals_prices))
    end
  end
end

Main.call
