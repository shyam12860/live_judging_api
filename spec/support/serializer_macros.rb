module SerializerMacros
  def serialize( serializer, object )
    serializer.new( object ).to_json
  end

  def serialize_array( serializer, objects )
    ActiveModel::ArraySerializer.new( objects, each_serializer: serializer ).to_json
  end
end
