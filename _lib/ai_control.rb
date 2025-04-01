require_relative 'ai'

class AiControl
  # DELETE THIS
  def self.analyse_image
    images = ['images/2025/02-tim_blair.jpg', 'images/2025/02-sheena.jpg', 'images/2025/02-tom.jpg']
    ai = AI.new

    images.each do |image|
      ai.analyse_image_update_keywords(image)
    end
  end

  # Convenience method
  def self.analyse_missing_images_current_year
    analyse_missing_images_for(Date.today.year)
  end

  def self.analyse_missing_images_for(year)
    ai = AI.new
    # Get pics for given year - weird arg is to reuse method call
    pics = Dir["#{Config.image_directory({ year: year })}/*.jpg"]
    # Iterate through all the images, saving output
    pics.each do |pic|
      ai.analyse_image_update_keywords(pic)
    end
  end
end
