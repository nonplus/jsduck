
module JsDuck

  # Calculates all kinds of statistics for classes
  class Stats
    # Maps array of classes into array of stats per class
    def create(classes)
      @classes = classes

      classes.map do |cls|
        {
          :name => cls[:name],
          :members => cls.all_members.length,
          :localMembers => cls.all_local_members.length,
          :fanIn => fan_in(cls),
          :fanOut => fan_out(cls),
          :wordCount => class_wc(cls),
        }
      end
    end

    # How many classes depend on this class
    def fan_in(cls)
      fan_in_table[cls[:name]] || 0
    end

    # On how many classes this class depends on
    def fan_out(cls)
      dependencies(cls).length
    end

    # list of class names the class depends on
    def dependencies(cls)
      [
        cls[:extends],
        cls[:mixins],
        cls[:requires],
        cls[:uses],
      ].compact.flatten.sort.uniq
    end

    # Returns map of class names to its fan-in number.
    def fan_in_table
      return @fi_table if @fi_table

      @fi_table = {}
      @classes.each do |cls|
        dependencies(cls).each do |d|
          @fi_table[d] = (@fi_table[d] || 0) + 1
        end
      end
      @fi_table
    end

    # Counts nr of words in class documentation
    def class_wc(cls)
      cnt = wc(cls[:doc])
      cls.all_local_members.each do |m|
        cnt += wc(m[:doc])
        (m[:params] || []).each {|p| cnt += property_wc(p) }
        (m[:properties] || []).each {|p| cnt += property_wc(p) }
        cnt += wc(m[:return][:doc]) if m[:return]
      end
      cnt
    end

    def property_wc(property)
      cnt = wc(property[:doc] || "")
      (property[:properties] || []).each {|p| cnt += property_wc(p) }
      cnt
    end

    # Strips HTML and counts words in text
    def wc(str)
      str.gsub(/<\/?[^>]*>/, "").scan(/\w+/).length
    end

  end

end
