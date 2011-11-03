
require 'rust/cppifaceparser'


if __FILE__ == $0
  def usage
    puts "Use: #{File.basename($0)} [header] [module name] [output file]"
  end
  
  parser = Rust::Cpp::IfaceParser.new
  
  if ARGV.size != 3 or not File.exists?(ARGV[0].to_s)
    usage
    exit 0
  end
  
  header = ARGV[0]
  namespace = ARGV[1]
  outputfile = ARGV[2]
  outputfile += ".rb" if not outputfile =~ /\.rb$/
  
  classes = parser.parseFile(header)
  
  rust = %@
require 'rust'

Rust::Bindings::create_bindings Rust::Bindings::LangCxx, "#{namespace}" do |b|
  b.include_header '#{header}', Rust::Bindings::HeaderGlobal
  b.add_namespace "#{namespace}", "" do |ns|
@
  classes.each { |klass|
    rust += %@  ns.add_cxx_class "#{klass[:name]}" do |klass|\n@
    klass[:constructors].each { |constructor|
      rust += "    klass.add_constructor "
      if not constructor[:params].empty? and not constructor[:params].detect { |p| p[:type] =~ /void/ }
        rust += "do |method|\n"
        constructor[:params].each { |param|
          rust += %@      method.add_parameter "#{param[:type]}", "#{param[:name]}"\n@
        }
        rust += "    end"
      end
      rust += "\n"
    }
    
    klass[:methods].each { |method|
      comment_method = false
      if method[:params].detect { |p| p[:type] =~ /\s*\*\s*\*/ }
        $stderr << "Ignoring method: #{method[:name]}\n"
        comment_method = true
      end
      
      rust += "# " if comment_method
      rust += %@    klass.add_method "#{method[:name]}", "#{method[:type]}"@
      if not method[:params].empty? and not method[:params].detect { |p| p[:type] =~ /void/ }
        rust += " do |method|\n" if not method[:params].empty?
        
        
        method[:params].each { |param|
          rust += "# " if comment_method
          rust += %@      method.add_parameter "#{param[:type]}", "#{param[:name]}"\n@
        }
        rust += "# " if comment_method
        rust += "    end"
      end
      
      rust += "\n"
    }
    rust += "    end\n" 
  }
  
  rust += %@
  end
end
@
  
  File.open( outputfile, "w" ) { |f|
    f << rust << "\n"
  }
  
  # Create configure.rb
  File.open( File.dirname(outputfile)+"/configure.rb", "w" ) { |f|
    f << %@
require 'mkmf'
find_header("rust_conversions.hh", "./include" )
eval File.open("#{File.basename(outputfile)}").readlines.to_s
create_makefile("#{namespace}")
    @
  }
  
end



