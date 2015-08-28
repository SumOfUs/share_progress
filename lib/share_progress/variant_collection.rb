require 'share_progress/variant'
require 'share_progress/variant_parser'

module ShareProgress
  class VariantCollection

    def initialize(variants_hash=nil)
      @variants = []
      update_variants(variants_hash) unless variants_hash.nil?
    end

    def update_variants(variants_hash)
      survivors = []
      variants_hash.each_pair do |variant_type, variants_list|
        variants_list.each do |variant_hash|
          added = add_or_update(variant_hash)
          survivors.push(added)
        end
      end
      @variants.select!{ |v| survivors.include? v }
    end

    def serialize
      serialized = {}
      @variants.each do |variant_obj|
        type_name = variant_obj.type.to_sym
        serialized[type_name] ||= []
        serialized[type_name].push variant_obj.serialize
      end
      serialized
    end

    def add_or_update(variant)
      variant_obj = find_variant(variant)
      if variant_obj.nil?
        if variant.is_a? Variant
          @variants.push variant
        else
          variant_obj = create_variant(variant)
          @variants.push(variant_obj)
        end
      else
        variant_obj.update_attributes(variant)
      end
      variant_obj
    end

    def remove(variant)
      target = find_variant(variant)
      @variants.select!{ |v| v != target }
      target
    end

    def variants
      @variants
    end

    private

    def create_variant(variant_hash)
      VariantParser.parse(variant_hash).new(variant_hash)
    end

    # in this implentation, you need id and type, but the ids on SP span
    # type, so I reckon that we just should make it find by id and most of this logic is unnecessary
    def find_variant(mystery_variant)
      if mystery_variant.is_a? Variant
        find_variant_by_obj(mystery_variant)
      elsif mystery_variant.is_a? Hash
        variant_hash = Utils.symbolize_keys(mystery_variant)
        if variant_hash.include? :type
          variant_type = variant_hash[:type]
        else
          variant_type = VariantParser.parse(variant_hash).type
        end
        find_variant_by_id(variant_hash[:id], variant_type)
      end
    end

    def find_variant_by_obj(variant_obj)
      matching = @variants.select{ |candidate| candidate == variant_obj}
      matching.size > 0 ? matching[0] : find_variant_by_id(variant_obj.id, variant_obj.type)
    end

    def find_variant_by_id(id, variant_type)
      matching = @variants.select{ |candidate| candidate.id == id && candidate.type == variant_type}
      matching.size > 0 ? matching[0] : nil
    end

  end
end
