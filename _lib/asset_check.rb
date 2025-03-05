require 'rainbow'
require_relative 'config'
require_relative 'db_control'

class AssetCheck
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def self.do_checks
    last_month = Config.last_month
    last_month_name = Date::MONTHNAMES[last_month[:month]].downcase
    last_month_number_padded_string = last_month[:month].to_s.rjust(2, '0')

    images = get_image_list(last_month, last_month_number_padded_string)
    thumbnails = get_thumbnails_list(last_month, last_month_number_padded_string)
    data = get_data_list(last_month, last_month_name)

    # Ensure count of each is the same
    count_test = images.length == thumbnails.length && images.length == data.length

    puts "Image / Thumbnail / Data counts equal: #{count_output(count_test)}"
    puts "\n"

    # Ensure all three file lists are the same and print any thing that does not appear in all three lists
    intersection = images & thumbnails & data

    puts 'Images missing thumbnails or data entries:'
    (images - intersection).each do |extra|
      puts extra
    end

    puts "\n"
    puts 'Thumbnails missing images or data entries:'
    (thumbnails - intersection).each do |extra|
      puts extra
    end

    puts "\n"
    puts 'Data entries missing images or thumbnails:'
    (data - intersection).each do |extra|
      puts extra
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def self.get_image_list(last_month, last_month_number_padded_string)
    images = Dir["#{Config.image_directory(last_month)}/#{last_month_number_padded_string}*.jpg"]
    images.map! { |path| File.basename(path) }
  end

  def self.get_thumbnails_list(last_month, last_month_number_padded_string)
    thumbnails = Dir["#{Config.thumbnails_directory(last_month)}/#{last_month_number_padded_string}*.jpg"]
    thumbnails.map! { |path| File.basename(path) }
  end

  def self.get_data_list(last_month, last_month_name)
    DbControl.get_month_pictures(last_month_name, last_month[:year]).map { |d| d[1] }
  end

  def self.count_output(count_test)
    if count_test == true
      count_test.to_s.green
    else
      count_test.to_s.red
    end
  end
end
