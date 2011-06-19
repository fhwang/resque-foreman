module Resque
  module Plugins
    module Foreman
      module Job
        def self.included(micro_job_class)
          micro_job_class.extend(ClassMethods)
        end
        
        module ClassMethods
          def after_batch_notify_foreman(batch_id, foreman_id, *other_args)
            foreman = @foreman_class.new(foreman_id)
            after_method = "after_" +
              self.name.gsub(/#{macro_job_name}/, '').underscore + '_batch'
            foreman.send(after_method) if foreman.respond_to?(after_method)
          end
    
          def after_perform_notify_foreman(foreman_id, *other_args)
            foreman = @foreman_class.new(foreman_id)
            after_method = "after_" +
              self.name.gsub(/#{macro_job_name}/, '').underscore
            foreman.send(after_method) if foreman.respond_to?(after_method)
          end
          
          def foreman(foreman_class)
            @foreman_class = foreman_class
          end
          
          def macro_job_name
            @foreman_class.name.split(/::/)[-2]
          end
        end
      end
    end
  end
end
