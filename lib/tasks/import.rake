# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

HEROES_URL = 'https://www.bjjheroes.com/a-z-bjj-fighters-list'.freeze
HEROES_BASE_URL = 'https://www.bjjheroes.com'


namespace :import do
  task heroes: :environment do
    data = Nokogiri::HTML(open(HEROES_URL))
    table = data.at('#tablepress-8')

    nro = 1
    datos = Array.new

    table.search('tr').each do |tr|
      
      cells = tr.search('td')

      

      for i in 0..3
        unless cells[i].nil? || cells[i] == 0
          datos[i] = cells[i].text.strip          
          else 
            datos[i] = ''
          end
      end

      id_fighter = ''

      unless cells[i].nil? || cells[i] == 0
        id_fighter = cells[0].search('a').attr('href')

      end

      URL_PERFIL = HEROES_BASE_URL + id_fighter

      puts URL_PERFIL

      # AHORA SE BUSCA LA IMAGEN EN EL PERFIL DE EL LUCHADOR

      data_perfil = Nokogiri::HTML(open(URL_PERFIL))
      #alt_tags = data_perfil.css('img')
      alt_tags = doc.xpath("//div/a/h4").collect {|node| node.text.strip}

      puts alt_tags

      puts '[ Nro : '+ nro.to_s + ' ]  Nombre : ' + datos[0].to_s + ' ' + datos[1].to_s + ' - Alias : '  +datos[2].to_s + '  ' + ' - Team : ' + datos[3].to_s


      puts '-----------------'


    end

   # puts table

    #rows = data.css("td[valign='top'] table tr") # All the <tr>this is a line</tr>

    #puts rows

    #rows.each do |row|
      #puts row.text # Will print all the 'this is a line'
    #end

    #puts doc

   # books = doc.xpath('//*[@itemtype="http://schema.org/Book"]')

    #books.each { |book| book_from_xml(book) }
  end

  def book_from_xml(book)
    title, author_name = book.xpath('.//*[@itemprop="name"]').map(&:content)
    author = Author.find_or_create_by(name: author_name)

    book = create_book(author, title)

    puts "#{book.author} - #{book} for #{book.price}"
  end

  def create_fighter(fname,lname,falias,fteam)
    #fighter = Fighter.find_or_create_by(:first_name:fname,:last_name:lname)    
    #fighter.save
    #fighter
  end
end