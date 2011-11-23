require 'jsduck/json_duck'
require 'jsduck/icons'
require 'jsduck/search_data'
require 'jsduck/stats'
require 'jsduck/class'

module JsDuck

  # Creates big JS file with data for Docs app.
  class AppData
    attr_accessor :guides
    attr_accessor :videos
    attr_accessor :examples

    def initialize(relations, opts)
      @relations = relations
      @opts = opts
    end

    # Writes classes, guides, videos, and search data to one big .js file
    def write(filename)
      js = "Docs = " + JsonDuck.generate({
        :data => {
          :classes => Icons.new.create(@relations.classes),
          :guides => @guides.to_array,
          :videos => @videos.to_array,
          :examples => @examples.to_array,
          :search => SearchData.new.create(@relations.classes),
          :stats => @opts.stats ? Stats.new.create(@relations.classes) : [],
          :signatureAttributes => Class.signature_attributes,
          :localStorageDb => @opts.local_storage_db,
          :showPrintButton => @opts.seo,
          :touchExamplesUi => @opts.touch_examples_ui,
        }
      }) + ";\n"
      File.open(filename, 'w') {|f| f.write(js) }
    end

  end

end
