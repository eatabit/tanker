module Tanker

  module Utilities

    class << self
      def get_model_classes
        Tanker.included_in
      end

      def get_available_indexes
        get_model_classes.map{|model| model.index_name}.uniq.compact
      end

      def clear_all_indexes
        get_available_indexes.each do |index_name|
          index = Tanker.api.get_index(index)

          if index.exists?
            puts "Deleting #{index_name} index"
            index.delete_index()
          end
          puts "Creating #{index_name} index"
          index.create_index()
          puts "Waiting for the index to be ready"
          while not index.running?
            sleep 0.5
          end
        end
      end

      def reindex_all_models
        clear_all_indexes

        get_model_classes.each do |klass|
          klass.all.each do |model_instance|
            model_instance.update_tank_indexes
          end
        end
      end

    end

  end

end
