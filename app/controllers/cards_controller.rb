require 'net/http'

class CouldNotFetch < StandardError; end

class CardsController < ApplicationController
  def index
    @cards = fetch_cards

    render 'index', status: :ok

  rescue CouldNotFetch
    render 'index', status: :unprocessable_entity
  end

  private

  def fetch_cards
    uri = URI("https://api.scryfall.com/cards/search?format=json&include_extras=false&include_multilingual=false&include_variations=false&order=name&q=c%3Awhite+mv%3D1&unique=cards&page=1&per_page=1")
    # uri = URI("https://api.scryfall.com/hi")
    response = JSON.parse(Net::HTTP.get(uri))

    raise CouldNotFetch if !response["status"].nil?

    response["data"].map do |data|
      name, image_uris, mana_cost, type_line, power, toughness, colors, oracle_text = data.values_at("name", "image_uris", "mana_cost", "type_line", "power", "toughness", "colors", "oracle_text")

      card_info = { name: name, mana_cost: mana_cost, type_line: type_line, power: power, toughness: toughness, colors: colors, oracle_text: oracle_text }

      if image_uris.present?
        image_uris = [image_uris["small"]]
      else
        image_uri = data["card_faces"].map { |card| card["small"] }
      end

      card_info[:image_uris] = image_uris

      card_info
    end
  end
end
