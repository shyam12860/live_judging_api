module SerializerMacros
  def serialize( serializer, object, scope=nil )
    serializer.new( object, scope: scope ).to_json
  end

  def serialize_array( serializer, objects, scope=nil )
    ActiveModel::ArraySerializer.new( objects, each_serializer: serializer, scope: scope ).to_json
  end
end
