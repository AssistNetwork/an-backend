module FlowHelper

  def self.symbolify(obj)

    if obj.respond_to? :to_sym
      obj.to_sym

    elsif obj.is_a? Array
      obj.map {|item| symbolify item }

    elsif obj.is_a? Hash
      obj.merge( obj ) {|k, val| symbolify val }

    else
      obj

    end
  end

end