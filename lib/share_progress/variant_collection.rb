module ShareProgress
  class VariantCollection

    def initialize
      @variants = []
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
      serialized = Hash.new
      @variants.each do |variant_obj|
        type_name = variant.class.type_name
        serialized[type_name] ||= []
        serialized[type_name].push variant_obj.compile_to_hash
      end
    end

    def add_or_update(variant)
      variant_obj = find_variant(variant)
      if variant_obj.nil?
        variant_obj = create_variant(variant)
        @variants.push(variant_obj)
      else
        variant_obj.update_attributes(variant)
      end

    end

    def remove(variant)
      target = find_variant(variant)
      @variants.select!{ |v| v != target }
      target
    end

    private

    def create_variant(variant_hash)
      VariantParser.parse_to_class(variant_hash).new(variant_hash)
    end

    def find_variant(mystery_variant)
      if mystery_variant.is_a? Variant
        find_variant_by_obj(required)
      elsif mystery_variant.is_a? Hash
        variant_hash = Utils.symbolize_keys(mystery_variant)
        if variant_hash.include? :type
          variant_type = variant_hash[:type]
        else
          variant_type = VariantParser.parse_to_type(variants_hash)
        end
        find_variant_by_id(variant_hash[:id], variant_type)
      end
    end

    def find_variant_by_obj(variant_obj)
      matching = @variants.select{ |candidate| candidate == variant_obj}
      matching.size > 0 ? matching[0] : find_variant_by_id(variant.id, variant.type)
    end

    def find_variant_by_id(id, variant_type)
      matching = @variants.select{ |candidate| candidate.id == id && candidate.type == variant_type}
      matching.size > 0 ? matching[0] : nil
    end

  end
end
