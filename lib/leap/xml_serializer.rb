require 'builder'
require 'active_support/inflector'

module Leap
  module XmlSerializer
    def to_xml(options = {})
      options[:indent] ||= 2
      xml = options[:builder] ||= Builder::XmlMarkup.new(options)
      xml.instruct! unless options[:skip_instruct]
      yield xml
      xml.to_s
    end

    def array_to_xml(xml, name, array, singular_name = name.to_s.singularize)
      xml.send name, :type => 'array' do |subblock|
        array.each do |item|
          if item.is_a? Symbol or !item.respond_to?(:to_xml)
            item = item.to_s if item.is_a?(Symbol)
            subblock.send singular_name, item, :type => 'string'
          else
            item.to_xml(:builder => subblock, :skip_instruct => true)
          end
        end
      end
    end
  end
end
