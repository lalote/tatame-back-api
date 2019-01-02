# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

HEROES_URL = 'https://www.bjjheroes.com/a-z-bjj-fighters-list'
HEROES_BASE_URL = 'https://www.bjjheroes.com'


namespace :import do
  
  task heroes: :environment do
     
    begin
        data = Nokogiri::HTML(open(HEROES_URL))

        table = data.at('#tablepress-8')   

        nro = 1
        table.search('tbody/tr').each do |tr|        
          datos = Array.new
          cells = tr.search('td')     

          for i in 0..3
            unless cells[i].nil? || cells[i] == 0
              datos[i] = cells[i].text.strip          
            else 
              datos[i] = ''
            end
          end

          #ID del luchador para ingresar a su perfil
          id_fighter = ''

          unless cells[i].nil? || cells[i] == 0
            id_fighter = cells[0].search('a').attr('href')
          end

          puts HEROES_BASE_URL + id_fighter

          # AHORA SE BUSCA LA IMAGEN EN EL PERFIL DE EL LUCHADOR
          url = ''
          
          #datos de el perfil
          data_perfil = Nokogiri::HTML(open(HEROES_BASE_URL + id_fighter))

          #background imagen css
          style_background_imagen = data_perfil.xpath(".//*[@class='cover']/@style")      

          #clean url (se agrega a url "-514x276.jpg") para thumbs
          unless style_background_imagen.nil? || style_background_imagen.length == 0
            url = style_background_imagen.to_s.split("background-image: url(").last.split(");").first
          end        

          puts "url " + url
          puts '[ Nro : '+ nro.to_s + ' ]  Nombre : ' + datos[0].to_s + ' ' + datos[1].to_s + ' - Alias : '  +datos[2].to_s + '  ' + ' - Team : ' + datos[3].to_s
          puts "creando entrada en BD "

          fighter = create_fighter(datos[0], datos[1],datos[2],datos[3],url)

          puts '-----------------'
          nro = nro + 1
        end
      rescue OpenURI::HTTPError => e
        if e.message == '404 Not Found'
          # handle 404 error
        else
          raise e
        end
      end
  end

  def create_fighter(fname,lname,falias,fteam,url)
    fighter = Fighter.find_or_create_by(:first_name => fname, :last_name => lname, :alias =>falias, :team => fteam, :url_photo =>url)    
    fighter.save
    fighter
  end  
end 