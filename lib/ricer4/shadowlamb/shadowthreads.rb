module Ricer4::Plugins::Shadowlamb; end
module Ricer4::Plugins::Shadowlamb::Shadowthreads
  
  ## Main Thread
  def factory; Ricer4::Plugins::Shadowlamb::Core::PlayerFactory.instance; end
  def mob_factory; Ricer4::Plugins::Shadowlamb::Core::MobFactory.instance; end
  def shadowverse; Ricer4::Plugins::Shadowlamb::Core::Shadowverse.instance; end
  def map_export; Ricer4::Plugins::Shadowlamb::Core::MapExport.instance; end
  
  def ricer_on_global_startup
    shadowmaps and shadowthreads
  end
  
  def shadowmaps
    bot.log.info("Writing JSON Map files")
    map_export.write_static_files
  end

  def shadowthreads
    bot.log.info("Starting Shadowthreads")
    # Player ticks
    # player_tick_thread('player/tick/minute', 60)
    # player_tick_thread('player/tick/five_minutes', 300)
    # player_tick_thread('player/tick/ten_minutes', 600)
    # Party ticks
    # party_tick_thread('party/tick/minute', 60)
    # party_tick_thread('party/tick/five_minutes', 300)
    # party_tick_thread('party/tick/ten_minutes', 600)
    # World ticks
#    world_tick_thread('world/tick/one_minute', 60)
#    world_tick_thread('world/tick/five_minutes', 300)
#    world_tick_thread('world/tick/ten_minutes', 600)
    # Short gameloop ticks
    shadowthread(4.0, 2.0) do |elapsed|
      shadowverse.mutex.synchronize do
        factory.players.each do |player|
          
        end
        factory.parties.each do |party|
          begin
            party.execute_action(elapsed)
            party.save_party!
          rescue StandardError => e
            bot.log.exception(e)
          end
        end
      end
    end
  end
  
  #####################
  ### Thread helper ###
  #####################
  def shadowthread(tick_time=60, min_sleep=1.0, &block)
    worker_threaded do 
      now = Time.now.to_f
      sleep(tick_time)
      loop do
        elapsed, now = (Time.now.to_f - now), Time.now.to_f
        elapsed = (elapsed * get_setting(:gamespeed)).round
        block.call(increase_shadowtime(elapsed.seconds))
        # Sleep up to tick_time
        sleep [(tick_time - (Time.now.to_f - now)), min_sleep].max
      end
    end
  end
  
  def increase_shadowtime(elapsed)
    save_setting(:shadowtime, get_setting(:shadowtime) + elapsed)
    elapsed
  end
  
  def world_tick_thread(event, tick_time, min_sleep=1.0)
    shadowthread(tick_time) do |elapsed|
      shadowverse.mutex.synchronize do
        begin
          arm_publish(event, elapsed)
        rescue StandardError => e
          bot.log.exception(e)
        end
      end
    end
  end

  # def party_tick_thread(event, tick_time)
    # tick_thread(event, tick_time, factory.parties)
  # end
# 
  # def player_tick_thread(event, tick_time)
    # tick_thread(event, tick_time, factory.players)
  # end
#   
  # def tick_thread(event, tick_time, list)
    # shadowthread(tick_time) do |elapsed|
      # list.each do |object|
        # shadowverse.mutex.synchronize do
          # begin
            # self.class.publish(event, object, elapsed)
          # rescue StandardError => e
            # bot.log.exception(e)
          # end
        # end
      # end
    # end
  # end

end
    