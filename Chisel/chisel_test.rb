require 'minitest/autorun'
require 'minitest/pride'
require_relative 'chisel'

class ChiselTest < Minitest::Test
  def test_we_can_create_chunk_with_1_char
    chisel = Chisel.new("1")
    assert_equal ['1'], chisel.chunk
  end

  def test_we_can_create_chunk_with_2_chars
    chisel = Chisel.new("ab")
    assert_equal ['ab'], chisel.chunk
  end

  def test_we_can_create_chunk_with_3_chars
    chisel = Chisel.new("wut")
    assert_equal ['wut'], chisel.chunk
  end

  def test_we_can_create_chunk_with_6_chars
    chisel = Chisel.new("omgbbq")
    assert_equal ['omgbbq'], chisel.chunk
  end

  def test_we_can_create_chunk_with_2_words
    chisel = Chisel.new("such wow")
    assert_equal ["such wow"], chisel.chunk
  end

  def test_we_can_create_chunk_with_3_words
    chisel = Chisel.new("peanut butter jealous")
    assert_equal ["peanut butter jealous"], chisel.chunk
  end

  def test_we_can_create_chunk_with_5_words
    chisel = Chisel.new("such car. so amaze. wow.")
    assert_equal ["such car. so amaze. wow."], chisel.chunk
  end

  def test_we_can_create_chunk_with_10_words
    chisel = Chisel.new("this is just getting excessive. i think this part works.")
    assert_equal ["this is just getting excessive. i think this part works."], chisel.chunk
  end

  def test_line_break_is_still_same_chunk
    chisel = Chisel.new("So here we have \n a 2 line chunk.")
    assert_equal ["So here we have \n a 2 line chunk."], chisel.chunk
  end

  def test_two_line_breaks_make_a_new_chunk
    chisel = Chisel.new("This time we have\n\na 2 piece chunk")
    assert_equal ["This time we have", "a 2 piece chunk"], chisel.chunk
  end

  def test_one_line_break_and_two_line_breaks_makes_2_chunks
    chisel = Chisel.new("Now we're going to\ntry having another\n\n2 piece chunk")
    assert_equal ["Now we're going to\ntry having another", "2 piece chunk"], chisel.chunk
  end

  def test_we_can_have_3_chunks
    chisel = Chisel.new("This time we have\n\na 3 piece chunk.\n\nI think it works.")
    assert_equal ["This time we have", "a 3 piece chunk.", "I think it works."], chisel.chunk
  end

  def test_we_can_create_1_level1_header
    chisel = Chisel.new
    assert_equal "<h1>Now time to test headers!</h1>", chisel.header("#Now time to test headers!")
  end

  def test_we_can_create_1_level2_header
    chisel = Chisel.new
    assert_equal "<h2>Now time to test level 2 headers!</h2>", chisel.header("##Now time to test level 2 headers!")
  end

  def test_we_can_create_1_level3_header
    chisel = Chisel.new
    assert_equal "<h3>Now time to test level 3 headers!</h3>", chisel.header("###Now time to test level 3 headers!")
  end

  def test_we_can_create_1_level4_header
    chisel = Chisel.new
    assert_equal "<h4>Now time to test level 4 headers!</h4>", chisel.header("####Now time to test level 4 headers!")
  end

  def test_we_can_create_1_level5_header
    chisel = Chisel.new
    assert_equal "<h5>Now time to test level 5 headers!</h5>", chisel.header("#####Now time to test level 5 headers!")
  end

  def test_we_can_create_1_level6_header
    chisel = Chisel.new
    assert_equal "<h6>Now time to test level 6 headers!</h6>", chisel.header("######Now time to test level 6 headers!")
  end

  def test_there_is_no_level_7_header
    chisel = Chisel.new
    assert_equal "<h6>#Now time to test level 6 headers again!</h6>", chisel.header("#######Now time to test level 6 headers again!")
  end

  def test_no_header_gives_paragraph
    chisel = Chisel.new
    assert_equal "<p>\nNo headers\n</p>", chisel.header("No headers")
  end

  def test_we_can_wrap_1_word_with_em_tags
    chisel = Chisel.new
    assert_equal "Now we're <em>working</em> with em tags.", chisel.format("Now we're *working* with em tags.")
  end

  def test_we_can_wrap_2_words_with_em_tags
    chisel = Chisel.new
    assert_equal "Now we're <em>working with</em> em tags.", chisel.format("Now we're *working with* em tags.")
  end

  def test_we_can_wrap_2_non_adjacent_words_with_em_tags
    chisel = Chisel.new
    assert_equal "<em>Now</em> we're working with <em>em</em> tags.", chisel.format("*Now* we're working with *em* tags.")
  end

  def test_we_can_wrap_1_word_with_strong_tags
    chisel = Chisel.new
    assert_equal "Now we're <strong>working</strong> with strong tags.", chisel.format("Now we're **working** with strong tags.")
  end

  def test_we_can_wrap_2_words_with_strong_tags
    chisel = Chisel.new
    assert_equal "Now we're <strong>working with</strong> strong tags.", chisel.format("Now we're **working with** strong tags.")
  end

  def test_we_can_wrap_2_non_adjacent_words_with_strong_tags
    chisel = Chisel.new
    assert_equal "<strong>Now</strong> we're working with <strong>strong</strong> tags.", chisel.format("**Now** we're working with **strong** tags.")
  end

  def test_we_can_have_1_em_and_1_strong_tag
    chisel = Chisel.new
    assert_equal "Now we have an <em>em</em> and a <strong>strong</strong> tag.", chisel.format("Now we have an *em* and a **strong** tag.")
  end

  def test_we_can_have_1_em_tag_inside_1_strong_tag_
    chisel = Chisel.new
    assert_equal "<strong>Now we have an <em>em</em> tag inside a strong tag.</strong>", chisel.format("**Now we have an *em* tag inside a strong tag.**")
  end

  def test_we_can_have_1_strong_tag_inside_1_em_tag
    chisel = Chisel.new
    assert_equal "<em>Now we have a <strong>strong</strong> tag inside an em tag.</em>", chisel.format("*Now we have a **strong** tag inside an em tag.*")
  end

  def test_we_can_have_unpaired_asterisks
    chisel = Chisel.new
    assert_equal "<strong>Now</strong> testing loose **asterisks.", chisel.format("**Now** testing loose **asterisks.")
  end

  def test_we_can_have_an_unpaired_asterisk
    chisel = Chisel.new
    assert_equal "<em>Now</em> testing loose *asterisks.", chisel.format("*Now* testing loose *asterisks.")
  end

  def test_we_can_make_a_list_with_1_item
    chisel = Chisel.new
    assert_equal "<ul>\n  <li>Cars</li>\n</ul>" , chisel.make_list("* Cars")
  end

  def test_we_can_make_a_list_with_2_items
    skip
    chisel = Chisel.new
    assert_equal "<ul>\n  <li>Cars</li>\n  <li>Planes</li>\n</ul>" , chisel.make_list("* Cars\n* Planes")
  end

  def test_we_can_make_a_list_with_3_items
    skip
    chisel = Chisel.new
    assert_equal "<ul>\n <li>Cars</li>\n</ul>" , chisel.make_list("* Cars\n* Planes\n* Tigers?")
  end

  def test_we_can_make_a_list_with_6_items
    skip
    chisel = Chisel.new
    assert_equal "<ul>\n <li>Cars</li>\n</ul>" , chisel.make_list("* Cars")
  end
end
