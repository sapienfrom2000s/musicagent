#!/usr/bin/env ruby

require 'thor'
require 'colorize'
require_relative 'lib/music_scheduler'
require_relative 'lib/music_handler'

class MusicAgent < Thor
  desc "play [SONG_NAME]", "Play a song immediately (random Bollywood song if no name provided)"
  def play(song_name = nil)
    scheduler = MusicScheduler.new
    scheduler.play_song(song_name)
  end
  
  desc "random", "Play a random feel-good Bollywood song"
  def random
    scheduler = MusicScheduler.new
    scheduler.play_song
  end
  
  desc "list_songs", "List all available feel-good Bollywood songs"
  def list_songs
    puts "\nFeel-Good Bollywood Songs:".cyan
    puts "-" * 80
    
    MusicHandler::FEEL_GOOD_BOLLYWOOD_SONGS.each_with_index do |song, index|
      puts "#{index + 1}. #{song}".cyan
    end
    
    puts "-" * 80
  end

  desc "at [SONG_NAME] TIME", "Schedule a song to play at a specific time (random if no song name)"
  long_desc <<-LONGDESC
    Schedule a song to play at a specific time.
    
    TIME should be in one of these formats:
    - HH:MM (e.g., 14:30)
    - YYYY/MM/DD HH:MM:SS (e.g., 2023/12/31 23:59:59)
    
    Examples:
      musicagent at 16:30                         # Plays a random Bollywood song at 16:30
      musicagent at "Tum Se Hi - Jab We Met" 16:30 # Plays the specified song at 16:30
      musicagent at "2023/07/15 09:00"            # Plays a random Bollywood song at the specified date/time
  LONGDESC
  def at(*args)
    if args.length == 1
      # Only time provided, use random song
      time = args[0]
      song_name = nil
    else
      # Both song and time provided
      song_name = args[0]
      time = args[1]
    end
    
    scheduler = MusicScheduler.new
    job_id = scheduler.schedule_at_time(song_name, time)
    
    if job_id
      puts "\nKeep this program running for the scheduled music to play.".yellow
      puts "Press Ctrl+C to exit.".yellow
      
      # Keep the program running
      begin
        loop do
          sleep 1
        end
      rescue Interrupt
        puts "\nExiting MusicAgent. Scheduled music will not play.".red
        scheduler.shutdown
      end
    end
  end

  desc "in [SONG_NAME] DURATION", "Schedule a song to play after a duration (random if no song name)"
  long_desc <<-LONGDESC
    Schedule a song to play after a specified duration.
    
    DURATION should be in one of these formats:
    - 10s (10 seconds)
    - 5m (5 minutes)
    - 2h (2 hours)
    - 1d (1 day)
    
    Examples:
      musicagent in 30m                         # Plays a random Bollywood song after 30 minutes
      musicagent in "Tum Se Hi - Jab We Met" 1h  # Plays the specified song after 1 hour
  LONGDESC
  def in(*args)
    if args.length == 1
      # Only duration provided, use random song
      duration = args[0]
      song_name = nil
    else
      # Both song and duration provided
      song_name = args[0]
      duration = args[1]
    end
    
    scheduler = MusicScheduler.new
    job_id = scheduler.schedule_in_duration(song_name, duration)
    
    if job_id
      puts "\nKeep this program running for the scheduled music to play.".yellow
      puts "Press Ctrl+C to exit.".yellow
      
      # Keep the program running
      begin
        loop do
          sleep 1
        end
      rescue Interrupt
        puts "\nExiting MusicAgent. Scheduled music will not play.".red
        scheduler.shutdown
      end
    end
  end

  desc "list", "List all scheduled songs"
  def list
    scheduler = MusicScheduler.new
    scheduler.list_scheduled
  end

  desc "cancel JOB_ID", "Cancel a scheduled song"
  def cancel(job_id)
    scheduler = MusicScheduler.new
    scheduler.cancel_scheduled(job_id)
  end

  desc "search QUERY", "Search for songs in the feel-good Bollywood songs list"
  def search(query)
    matching_songs = MusicHandler::FEEL_GOOD_BOLLYWOOD_SONGS.select do |song|
      song.downcase.include?(query.downcase)
    end
    
    if matching_songs.empty?
      puts "No songs found matching '#{query}'".red
      return
    end
    
    puts "\nSearch Results for '#{query}':".cyan
    puts "-" * 80
    
    matching_songs.each_with_index do |song, index|
      puts "#{index + 1}. #{song}".cyan
    end
    
    puts "-" * 80
  end

  desc "version", "Show version information"
  def version
    puts "MusicAgent v1.0.0"
  end
end

MusicAgent.start(ARGV)
