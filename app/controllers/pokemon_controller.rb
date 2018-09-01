class PokemonController < ApplicationController
  def show
    response = HTTParty.get("http://pokeapi.co/api/v2/pokemon/#{params[:id]}/")
    body = JSON.parse(response.body)
    name = body["name"]
    id = body["id"]
    types = find_types(body)

    gif_response = HTTParty.get("https://api.giphy.com/v1/gifs/search?api_key=#{ENV["GIPHY_KEY"]}&q=#{name}&rating=g")
    gif_body = JSON.parse(gif_response.body)
    gif_url = generate_gif(gif_body).sample

    respond_to do |format|
      format.json do
        render json: { name: name, id: id, types: types, gif: gif_url}
      end
    end
  end

  def find_types(body)
    type_arr = []
    body["types"].map do |t|
      t["type"]["name"]
    end
  end

  def generate_gif(body)
    body["data"].map do |g|
      g["url"]
    end
  end
end
