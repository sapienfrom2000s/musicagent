require 'rufus-scheduler'
require_relative 'music_handler'
require_relative 'player'
require 'colorize'

class MusicScheduler
  attr_reader :scheduler

  def initialize
    @scheduler = Rufus::Scheduler.new
    @music = MusicHandler.new
    @player = Player.new
    @scheduled_jobs = {}
  end

  def schedule_at_time(query, time_str)
    begin
      job = @scheduler.at time_str do
        play_song(query)
      end

      job_id = job.object_id.to_s
      @scheduled_jobs[job_id] = {
        query: query,
        time: time_str,
        job: job
      }

      puts "✓ Scheduled to play '#{query}' at #{time_str}".green
      job_id
    rescue => e
      puts "Error scheduling song: #{e.message}".red
      nil
    end
  end

  def schedule_in_duration(query, duration_str)
    begin
      job = @scheduler.in duration_str do
        play_song(query)
      end

      job_id = job.object_id.to_s
      @scheduled_jobs[job_id] = {
        query: query,
        duration: duration_str,
        job: job
      }

      puts "✓ Scheduled to play '#{query}' in #{duration_str}".green
      job_id
    rescue => e
      puts "Error scheduling song: #{e.message}".red
      nil
    end
  end

  def list_scheduled
    if @scheduled_jobs.empty?
      puts "No songs scheduled.".yellow
      return []
    end

    puts "\nScheduled Songs:".cyan
    puts "-" * 80

    @scheduled_jobs.each_with_index do |(id, job_info), index|
      time_info = job_info[:time] ? "at #{job_info[:time]}" : "in #{job_info[:duration]}"
      puts "#{index + 1}. #{job_info[:query]} (#{time_info})".cyan
    end

    puts "-" * 80
    @scheduled_jobs.keys
  end

  def cancel_scheduled(job_id)
    if @scheduled_jobs[job_id]
      @scheduled_jobs[job_id][:job].unschedule
      job_info = @scheduled_jobs.delete(job_id)
      puts "✓ Canceled scheduled song: #{job_info[:query]}".green
      true
    else
      puts "Job ID not found".red
      false
    end
  end

  def play_song(query = nil)
    # If no query is provided, select a random song from the list
    song_name = query || @music.get_random_song

    puts "\n▶ Playing music: '#{song_name}'".green

    # Download the song
    audio_file = @music.download_song(song_name)

    if audio_file
      # Play the audio
      @player.play(audio_file)
      true
    else
      puts "Failed to download audio for '#{song_name}'".red
      false
    end
  end

  def shutdown
    @scheduler.shutdown
  end
end
