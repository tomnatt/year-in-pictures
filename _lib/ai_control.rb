require_relative 'ai'

class AiControl
  def self.analyse_image
    images = ['images/2025/02-tim_blair.jpg', 'images/2025/02-sheena.jpg', 'images/2025/02-tom.jpg']
    ai = AI.new

    images.each do |image|
      ai.analyse_image_update_keywords(image)
    end
  end
end
