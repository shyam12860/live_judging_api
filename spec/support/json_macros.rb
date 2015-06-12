module JSONMacros
  def json_to_hash( body )
    JSON.parse( body, symbolize_names: true )
  end

  def json_at_key( body, key )
    JSON.parse( body )[key].to_json
  end
end
