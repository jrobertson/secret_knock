#!/usr/bin/env ruby

# secret_knock.rb


class SecretKnock

  attr_reader :h, :message, :listening

  def initialize(verbose: true, external: nil, 
                 short_delay: 0.35, long_delay: 0.9, debug: false)

    @verbose, @external, @debug = verbose, external, debug

    # ranked by frequency. see https://en.wikipedia.org/wiki/Letter_frequency
    keys = ["e", "t", "a", "o", "i", "n", "s", "h", "r", "d", "l", "c", "u", "m",
                        "w", "f", "g", "y", "p", "b", "v", "k", "j", "x", "q", "z"]


    # number the keys including numbers and special functions (i.e. backspace)

    i = 0
    a = ([' '] + keys + ('1'..'9').to_a + ['0','<backspace>']).map do |x|
      i += 1
      i += 1 while i.to_s[-1].to_i > 6 or i.to_s[-1].to_i == 0
      [x, i]
    end

    # create and sort in alphabetical order the 
    #   hash lookup and inverted hash lookup

    @h = (a.take(27).sort_by(&:first) + a[27..-1]).to_h
    @h.merge!({"7" => 7, "8" => 8, "9" => 9})

    #>  h contains the following
    # {
    #    " "=>1, "a"=>4, "b"=>33, "c"=>21, "d"=>15, "e"=>2, "f"=>25, "g"=>26,
    #    "h"=>13, "i"=>6, "j"=>36, "k"=>35, "l"=>16, "m"=>23, "n"=>11, "o"=>5, 
    #    "p"=>32, "q"=>42, "r"=>14, "s"=>12, "t"=>3, "u"=>22, "v"=>34, "w"=>24, 
    #    "x"=>41, "y"=>31, "z"=>43, "1"=>44, "2"=>45, "3"=>46, "4"=>51, "5"=>52, 
    #    "6"=>53, "7"=>7, "8"=>8, "9"=>9, "0"=>61, "<backspace>"=>62
    # }



    @hb = h.invert

    @short_delay, @long_delay = short_delay, long_delay # seconds
    @listening = false

  end

  def autoknock(s)
    playback knockerize(s)
  end
  
  # listens for knocking in the background which allows the control
  def detect(timeout: 2, repeat: true)

    listen
    
    Thread.new do
      
      if @external and @external.respond_to? :on_listening then
        @external.on_listening
      end
      
      sleep 0.2 while @t + timeout > Time.now or @a.length <= 1
      
      if @external and @external.respond_to? :on_processing then
        @external.on_processing
      end
      
      msg = decipher()
      on_timeout msg
      
      begin
        @external.message msg if @external
      rescue
        puts
        puts "\rSecretKnock @external notifier " +  ($!).inspect
      end

      detect(timeout: timeout, repeat: repeat) if repeat
    end
  end

  def knocked()

    t1 = Time.now

    if t1 < @t + @short_delay then

      @i += 1

    else

      @a << ',' if t1 > @t + @long_delay
      puts '' if @verbose
      @i = 1
      @a << 0

    end
    
    print @i.to_s + ' ' if @verbose

    @a[-1] = @i if @a.any?
    
    @t = Time.now

    @external.knock if @external
    
    puts '@a: ' + @a.inspect if @debug
    
  end

  alias knock knocked

  def knocks(n)

    n.times { knocked }
    short_pause

  end

  def knockerize(s)

    s.chars.flat_map do |x| 
      @h[x].to_s.chars.map {|n| [:knocks, n.to_i]}  + [:pause]
    end

  end

  def listen()

    @t = Time.now
    @i = 1
    @a = []    
    
    @listening = true

    if block_given? then
      yield self
      stop_listening
    end

  end

  def long_pause()

    puts "\n*pause*\n\n" if @verbose
    sleep @long_delay + 0.1    

  end
  
  def on_timeout(msg='')
    # override this method if you wish
  end

  alias pause long_pause

  def playback(instructions)

    listen do |x|

      sleep 1

      instructions.each do |action|
        name, args = action
        args ? x.method(name).call(args) : x.method(name).call
      end
      
    end    

  end
  
  def reset()
    @a = []
  end

  def short_pause()
    sleep @short_delay + 0.1
  end

  def stop_listening()

    @listening = false
    @message = decipher()

  end
  
  private
   
  def decipher()
    
    @a.join.gsub(/(\d{2})(\d)/,'\1,\2').split(',').inject([]) do |r, x|
      (x != '42' ? r << @hb[x.to_i] : r[0..-2])
    end.join    

  end
  
end
