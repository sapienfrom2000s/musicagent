require 'json'
require 'colorize'

class MusicHandler
  # List of feel-good Bollywood songs
  FEEL_GOOD_BOLLYWOOD_SONGS = [
    "Kabhi Kabhi Aditi - Jaane Tu Ya Jaane Na",
    "Aahun Aahun - Love Aaj Kal",
    "Gal Mitthi Mitthi - Aisha",
    "Ude Dil Befikre - Befikre",
    "Senorita - Zindagi Na Milegi Dobara",
    "Tera Hone Laga Hoon - Ajab Prem Ki Ghazab Kahani",
    "Tum Se Hi - Jab We Met",
    "Zehnaseeb - Hasee Toh Phasee",
    "Kya Mujhe Pyar Hai - Woh Lamhe",
    "Subha Hone Na De - Desi Boyz",
    "Desi Girl - Dostana",
    "Jab Mila Tu - Kaminey",
    "Woh Dekhne Mein - London Dreams",
    "Tera Mujhse Hai Pehle Ka - Aa Dekhen Zara",
    "Tera Hone Laga Hoon - Ajab Prem Ki Ghazab Kahani",
    "Mauja Hi Mauja - Jab We Met",
    "Tareefan - Veere Di Wedding",
    "Badtameez Dil - Yeh Jawaani Hai Deewani",
    "Ilahi - Yeh Jawaani Hai Deewani",
    "Gallan Goodiyan - Dil Dhadakne Do",
    "Koi Kahe Kehta Rahe - Dil Chahta Hai",
    "Jaane Kyun - Dostana",
    "Kya Karoon - Wake Up Sid",
    "Oh Gujariya - Queen",
    "London Thumakda - Queen",
    "Kar Gayi Chull - Kapoor & Sons",
    "Matargashti - Tamasha",
    "Safarnama - Tamasha",
    "Phir Se Ud Chala - Rockstar",
    "Yun Hi - Tanu Weds Manu",
    "Aye Udi Udi - Saathiya",
    "Khalbali - Rang De Basanti",
    "Patakha Guddi - Highway",
    "Nazm Nazm - Bareilly Ki Barfi",
    "Cutiepie - Ae Dil Hai Mushkil",
    "Ullu Ka Pattha - Jagga Jasoos",
    "Galti Se Mistake - Jagga Jasoos",
    "Saddi Galli - Tanu Weds Manu",
    "Ainvayi Ainvayi - Band Baaja Baaraat",
    "Tarkeebein - Band Baaja Baaraat",
    "Radha - Student of the Year",
    "Balam Pichkari - Yeh Jawaani Hai Deewani",
    "Saudagar Sauda Kar - Saudagar",
    "Yeh Ishq Hai - Jab We Met",
    "Aashiyaan - Barfi!",
    "Main Kya Karoon - Barfi!",
    "Tune Maari Entriyaan - Gunday",
    "Sooraj Dooba Hain - Roy",
    "Tu Meri - Bang Bang!",
    "Zinda - Bhaag Milkha Bhaag",
    "Zinda Hoon Yaar - Lootera",
    "Khoon Chala - Rang De Basanti",
    "Kya Karoon - Barfi!",
    "Roobaroo - Rang De Basanti",
    "Agar Main Kahoon - Lakshya",
    "Hey Shona - Ta Ra Rum Pum",
    "O Humdum Suniyo Re - Saathiya",
    "Chamak Challo - Ra.One",
    "Sau Aasmaan - Baar Baar Dekho",
    "Nashe Si Chadh Gayi - Befikre",
    "Swag Se Swagat - Tiger Zinda Hai",
    "Socha Hai - Rock On!!",
    "Senorita - Zindagi Na Milegi Dobara",
    "Jaane Kyun - Dostana",
    "Pee Loon - Once Upon A Time in Mumbaai",
    "Suno Aisha - Aisha",
    "Tu Jaane Na - Ajab Prem Ki Ghazab Kahani",
    "Tera Ban Jaunga - Kabir Singh",
    "Paani Da Rang - Vicky Donor",
    "Dil Dhadakne Do - Zindagi Na Milegi Dobara",
    "Hawa Hawa - Mubarakan",
    "Kala Chashma - Baar Baar Dekho",
    "High Heels - Ki & Ka",
    "Dil Diyan Gallan - Tiger Zinda Hai",
    "Love You Zindagi - Dear Zindagi",
    "Jab Tak - M.S. Dhoni",
    "Ik Junoon (Paint It Red) - ZNMD",
    "Meherbaan - Bang Bang!",
    "Tune Jo Na Kaha - New York",
    "Tujh Mein Rab Dikhta Hai - Rab Ne Bana Di Jodi",
    "Phir Le Aaya Dil - Barfi!",
    "Raabta - Agent Vinod",
    "Dil Ibadat - Tum Mile",
    "Pyaar Ki Yeh Kahani - Honeymoon Travels Pvt. Ltd.",
    "Ek Main Aur Ekk Tu - Ek Main Aur Ekk Tu",
    "Aashiq Banaya Aapne - Aashiq Banaya Aapne",
    "Jeene Ke Hain Chaar Din - Mujhse Shaadi Karogi",
    "Salaam Namaste - Salaam Namaste",
    "Desi Girl - Dostana",
    "Soni De Nakhre - Partner",
    "Just Chill - Maine Pyaar Kyun Kiya",
    "Dus Bahane - Dus",
    "Woh Lamhe Woh Baatein - Zeher",
    "Be Intehaan - Race 2",
    "Tum Hi Ho Bandhu - Cocktail",
    "Main Tera Hero - Main Tera Hero",
    "Saturday Saturday - Humpty Sharma Ki Dulhania",
    "Raat Bhar - Heropanti",
    "Lat Lag Gayee - Race 2",
    "Tumhi Ho Bandhu - Cocktail",
    "Dil Hai Chota Sa - Roja (Revived)"
  ]

  def initialize
    # Nothing to initialize
  end

  def get_random_song
    FEEL_GOOD_BOLLYWOOD_SONGS.sample
  end

  def download_song(song_name, output_dir = 'downloads')
    begin
      # Ensure the downloads directory exists
      Dir.mkdir(output_dir) unless Dir.exist?(output_dir)

      puts "Downloading song: #{song_name}".cyan
      
      # Use spotdl to download the song
      # --output: Specify the output directory
      cmd = "spotdl \"#{song_name}\" --output \"#{output_dir}\""
      
      puts "Running: #{cmd}"
      result = system(cmd)
      
      # Find the downloaded file (most recent mp3 in the directory)
      downloaded_file = Dir.glob("#{output_dir}/*.mp3").max_by { |f| File.mtime(f) }
      
      if result && downloaded_file && File.exist?(downloaded_file)
        puts "Download complete: #{downloaded_file}".green
        return downloaded_file
      else
        puts "Failed to download song".red
        return get_fallback_audio(output_dir)
      end
    rescue => e
      puts "Error downloading song: #{e.message}".red
      get_fallback_audio(output_dir)
    end
  end
  
  private
  
  def get_fallback_audio(output_dir = 'downloads')
    puts "Using fallback sample audio file..."
    sample_file = "#{output_dir}/sample_music.mp3"
    
    # Check if we already have a sample file, if not create a simple one
    unless File.exist?(sample_file)
      # Try to download a known working short audio file
      system("curl -s -L -o #{sample_file} https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
    end
    
    if File.exist?(sample_file)
      puts "Using sample audio file: #{sample_file}".yellow
      return sample_file
    end
    
    nil
  end
end
