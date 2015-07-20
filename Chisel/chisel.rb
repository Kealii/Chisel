  # input_filename = ARGV[0]
  # output_filename = ARGV[1]
  # markdown_in = File.read(input_filename)
  # writer = File.open(output_filename, "w")
  # writer.close

class Chisel
  attr_accessor :markdown_string

  def initialize (markdown_string = '')
    @markdown_string = markdown_string
  end

  def chunk
    @all_chunks = []
    @all_chunks = markdown_string.split("\n\n")
  end

  def header(chunked_thing)
    if chunked_thing.include? "######"
      chunked_thing.sub!("######", "<h6>").concat("</h6>")
    elsif chunked_thing.include? "#####"
      chunked_thing.sub!("#####", "<h5>").concat("</h5>")
    elsif chunked_thing.include? "####"
      chunked_thing.sub!("####", "<h4>").concat("</h4>")
    elsif chunked_thing.include? "###"
      chunked_thing.sub!("###", "<h3>").concat("</h3>")
    elsif chunked_thing.include? "##"
      chunked_thing.sub!("##", "<h2>").concat("</h2>")
    elsif chunked_thing.include? "#"
      chunked_thing.sub!("#", "<h1>").concat("</h1>")
    else
      "<p>\n#{chunked_thing}\n</p>"
    end
  end

  def format(chunked_thing)
    chunked_array = chunked_thing.chars
    formatted_string = ""
    need_to_close_em = false
    need_to_close_strong = false
    chunked_array.each_index do |index|
      char = chunked_array[index]
      next_char = chunked_array[index+1]
      previous_char = chunked_array[index-1]
      remaining_strong = chunked_array[index+1..-1].join.include? '**'
      remaining_em = chunked_array[index+1..-1].include? '*'

      if char == "*" && previous_char == "*" && index != 0
      elsif char == "*" && next_char == "*"
        if need_to_close_strong == false && remaining_strong == true
          need_to_close_strong = true
          formatted_string << "<strong>"
        elsif need_to_close_strong == true
          need_to_close_strong = false
          formatted_string << "</strong>"
        else
          formatted_string << '**'
        end
      elsif char == "*" && need_to_close_em == false && remaining_em == true
        need_to_close_em = true
        formatted_string << "<em>"
      elsif char == "*" && need_to_close_em == true
        need_to_close_em = false
        formatted_string << "</em>"
      else
        formatted_string << char
      end
    end
    formatted_string
  end

  def make_list(chunked_thing)
    if chunked_thing.start_with? "* "
      chunked_thing.sub("* ", "<ul>\n  <li>").concat("</li>\n</ul>")
    end
  end
end




# markdown_in = "# My Life in Desserts\n\n## Chapter 1: The Beginning"
