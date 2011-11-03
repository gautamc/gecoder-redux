

module Rust

module Cpp

class IfaceParser
  def initialize
  end
  
  def parseFile(path)
    lines = ""
    File.open(path) { |f|
      lines = f.readlines.join
    }
    
    parse(lines)
  end
  
  def parse(cpph)
    classes = []
    
    ignore = true
    
    # FIXME: remove \n and split by ";" and "*/"
    
    cpph.to_s.split(/$/).each { |line|
      line = line.split("//").first
      if line =~ /\/\*/ # open comment
        ignore = true
      end
      
      if line =~ /\*\// # close comment
        ignore = false
      end
      
      if line =~ /public:/
        ignore = false
      elsif line =~ /private:|protected:/
        ignore = true
      elsif line =~ /class\s+(\w+\s+){0,1}(\w+)/ # function
        if not classes.last.nil?
          if classes.last[:name] == $2
            next
          end
        end
        
        classes << {:name => $2, :methods => [], :constructors => [] }
      elsif line =~ /namespace\s+(\w+)\s+\{{0,1}/
        $stderr << "Warning: Namespace will be ignore.\n"
      end
      
      if not ignore and classes.last
        parseEntity(line, classes.last)
      end
    }
    
    classes.delete_if { |klass|
      klass[:methods].empty?
    }
    
    classes
  end
  
  private
  def parseEntity(line, klass)
    if line =~ /((\w+::)*\w+)\s+(const\s+){0,1}(\*{0,3}|&){0,1}\s*(\w+)\s*\((.*)\)/
      type = "#{$1}#{$4}"
      fname = $5
      params = []
      
      if not $6.nil?
        $6.strip!
        if not $6.empty?
          params = parseParams($6)
        end
      end
      
      klass[:methods] << { :name => fname, :type => type, :params => params }
    elsif line =~ /^\s*#{klass[:name]}\s*\((.*)\)/ #constructor
      params = parseParams($1)
      klass[:constructors] << { :params => params }
    end
  end
  
  def parseParams(params)
    result = []
    params.split(",").each { |param|
      param = param.split("=").first
      param.strip!
      
      if param =~ /((\w+::)*\w+)\s*(const){0,1}(\*{0,3}|&){0,1}(const\s+){0,1}\s*(\w*)\s*$/
        type = "#{$1}#{$2}#{$4}"
        
        name = $6
        if name.empty?
          name = "par#{result.size}"
        end
        result << {:type => type, :name => name}
      end
    }
    
    result
  end
end

end # Cpp

end # Rust

if __FILE__ == $0
  parser = Rust::Cpp::IfaceParser.new
  
  classes = parser.parseFile(ARGV[0].to_s)
  
  classes.each { |klass|
    puts "Class: #{klass[:name]}"
    klass[:methods].each { |method|
      params = "("
      
      method[:params].each { |par|
        params += "#{par[:type]} #{par[:name]}, "
      }
      params += ")"
      puts "Method: #{method[:type]} #{method[:name]} #{params};"
    }
  }
end

