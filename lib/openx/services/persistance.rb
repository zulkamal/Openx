module OpenX
  module Services
    module Persistance

      module ClassMethods

        def create!(params = {})
          new(params).save!
        end

        def find(id, *args)
          if id == :all
            responses = remote.call(find_all, *args)
            responses.map do |response|
              new(translate(response))
            end
          else
            response  = remote.call(find_one, id)
            new(translate(response))
          end
        end

        def destroy(id)
          new(:id => id).destroy
        end

        private

          def translate(response)
            params    = {}
            self.translations.each do |k,v|
              params[k] = response[v.to_s] if response[v.to_s]
            end
            params
          end

      end

      module InstanceMethods

        def save!
          params = {}
          self.class.translations.keys.each do |k|
            value = send(:"#{k}")
            params[self.class.translations[k].to_s] = value if value
          end

          if new_record?
            @id = remote.call(self.class.create, params)
          else
            remote.call(self.class.update, params)
          end
          self
        end

        def destroy
          remote.call(self.class.delete, id)
          @id = nil
        end

      end
    end
  end
end