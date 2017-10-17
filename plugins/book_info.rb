#  -*- coding: utf-8 -*-
# frozen_string_literal: true

#  book_info.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that gets information about a book from Goodreads.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require "goodreads"

require_relative "yossarian_plugin"

class BookInfo < YossarianPlugin
  include Cinch::Plugin
  use_blacklist

  KEY = ENV["GOODREADS_API_KEY"]

  def initialize(*args)
    super
    @goodreads = Goodreads.new(api_key: KEY)
  end

  def usage
    "!book <book> - Get information about a book from Goodreads."
  end

  def match?(cmd)
    cmd =~ /^(!)?book$/
  end

  match /book (.+)/, method: :book_info, strip_colors: true

  def book_info(m, book)
    if KEY
      begin
        book_info = @goodreads.book_by_title(book)
        book_info.default = "?"

        title = book_info["title"]
        authors = book_info["authors"]["author"]

        authors = if authors.is_a? Array
                    authors.map do |a|
                      a["name"]
                    end.join(", ")
                  else
                    authors["name"]
                  end

        year = book_info["work"]["original_publication_year"] || book_info["publication_year"]
        rating = book_info["average_rating"]
        ratings_count = book_info["ratings_count"]
        link = book_info["link"]

        similar_books = book_info["similar_books"]["book"]

        similar_books = if similar_books
                          similar_books[0...3].map do |b|
                            b["title_without_series"]
                          end.join(", ")
                        else
                          "None"
                        end

        m.reply "#{title} (#{authors}, published #{year}). Rated #{rating}/5 by #{ratings_count} people. Similar books: #{similar_books}. More information at #{link}", true
      rescue Goodreads::NotFound
        m.reply "Goodreads has nothing for '#{book}'.", true
      rescue Exception => e
        m.reply e.to_s, true
      end
    else
      m.reply "#{self.class.name}: Internal error (missing API key)."
    end
  end
end
