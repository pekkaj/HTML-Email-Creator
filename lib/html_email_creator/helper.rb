module HtmlEmailCreator
  
  module Helper
    
    class << self
      
      # Find recursively starting from start_from_dir and continues towards a root.
      def find_recursively(start_from_dir, dir_or_file, default_if_not_found = nil)
        current_file = File.join(start_from_dir, dir_or_file)
        if File.exists?(current_file)
          current_file
        else
          next_file = File.dirname(start_from_dir)
          if start_from_dir == next_file
            return default_if_not_found
          end
        
          # continue searching
          find_recursively(next_file, dir_or_file, default_if_not_found)
        end
      end
      
    end    
  end
end