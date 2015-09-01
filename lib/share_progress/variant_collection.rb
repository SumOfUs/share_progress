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
      variant_obj = find(variant)
      if variant_obj.nil?
        if variant.is_a? Variant
          @variants.push variant
          variant_obj = variant
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
      target = find(variant)
      destroyed = target.destroy
      return false if destroyed == false
      @variants.select!{ |v| v.id != target.id }
      destroyed
    end

    def variants
      @variants
    end

    def find(mystery_variant)
      if mystery_variant.is_a? Variant
        find_variant_by_obj(mystery_variant)
      elsif mystery_variant.is_a? Hash
        find_variant_by_id(Utils.symbolize_keys(mystery_variant)[:id])
      elsif mystery_variant.is_a? Fixnum
        find_variant_by_id(mystery_variant)
      end
    end

    private

    def create_variant(variant_hash)
      VariantParser.parse(variant_hash).new(variant_hash)
    end

    def find_variant_by_obj(variant_obj)
      matching = @variants.select{ |candidate| candidate == variant_obj}
      if matching.size > 0
        matching[0]
      elsif variant_obj.id
        find_variant_by_id(variant_obj.id)
      else
        nil
      end
    end

    def find_variant_by_id(id)
      matching = @variants.select{ |candidate| candidate.id == id }
      matching.size > 0 ? matching[0] : nil
    end

  end
end
