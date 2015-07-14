module SerializerMacros
  def serialize( serializer, object, scope=nil )
    ActiveModel::Serializer.adapter.new( serializer.new object ).to_json
  end

  def serialize_array( serializer, objects, scope=nil )
    serializer = ActiveModel::Serializer::ArraySerializer.new( objects, each_serializer: serializer, scope: scope )
    ActiveModel::Serializer::Adapter::FlattenJson.new(serializer).to_json
  end
end
