  # input_filename = ARGV[0]
  # output_filename = ARGV[1]
  # markdown_in = File.read(input_filename)
  # writer = File.open(output_filename, "w")
  # writer.close

class Chisel
  attr_accessor :markdown_input

  def initialize (markdown_input = '')
    @markdown_input = markdown_input
  end

  def chunk
    @all_chunks = []
    @all_chunks = markdown_input.split("\n\n")
  end

  def header(chunk)
    if chunk.include? "######"
      chunk.sub!("######", "<h6>").concat("</h6>")
    elsif chunk.include? "#####"
      chunk.sub!("#####", "<h5>").concat("</h5>")
    elsif chunk.include? "####"
      chunk.sub!("####", "<h4>").concat("</h4>")
    elsif chunk.include? "###"
      chunk.sub!("###", "<h3>").concat("</h3>")
    elsif chunk.include? "##"
      chunk.sub!("##", "<h2>").concat("</h2>")
    elsif chunk.include? "#"
      chunk.sub!("#", "<h1>").concat("</h1>")
    else
      "<p>\n#{chunk}\n</p>"
    end
  end

  def format(chunk)
    whole_chunk = chunk.chars
    formatted = ""
    need_to_close_em = false
    need_to_close_strong = false
    whole_chunk.each_index do |index|
      char = whole_chunk[index]
      next_char = whole_chunk[index+1]
      previous_char = whole_chunk[index-1]
      remaining_strong_tag = whole_chunk[index+1..-1].join.include? '**'
      remaining_em_tag = whole_chunk[index+1..-1].include? '*'

      if char == "*" && previous_char == "*" && index != 0
      elsif char == "*" && next_char == "*"
        if need_to_close_strong == false && remaining_strong_tag == true
          need_to_close_strong = true
          formatted << "<strong>"
        elsif need_to_close_strong == true
          need_to_close_strong = false
          formatted << "</strong>"
        else
          formatted << '**'
        end
      elsif char == "*" && need_to_close_em == false && remaining_em_tag == true
        need_to_close_em = true
        formatted << "<em>"
      elsif char == "*" && need_to_close_em == true
        need_to_close_em = false
        formatted << "</em>"
      else
        formatted << char
      end
    end
    formatted
  end

  def make_list(chunk)
    if chunk.start_with? "* "
      chunk.sub("* ", "<ul>\n  <li>").concat("</li>\n</ul>")
    end
  end
end




# markdown_in = "# My Life in Desserts\n\n## Chapter 1: The Beginning"
