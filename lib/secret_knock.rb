#!/usr/bin/env ruby

# secret_knock.rb


class SecretKnock

  attr_reader :h, :message

  def initialize(verbose: true, external: nil)

    @verbose, @external = verbose, external

    # ranked by frequency. see https://en.wikipedia.org/wiki/Letter_frequency
    keys = ["e", "t", "a", "o", "i", "n", "s", "h", "r", "d", "l", "c", "u", "m",
                        "w", "f", "g", "y", "p", "b", "v", "k", "j", "x", "q", "z"]


    # number the keys including numbers and special functions (i.e. backspace)

    i = 0
    a = ([' '] + keys + ('1'..'9').to_a + ['0','<backspace>']).map do |x|
      i += 1
      i += 1 if i.to_s[-1] == '0'
      [x, i]
    end

    # create and sort in alphabetical order the 
    #   hash lookup and inverted hash lookup

    @h = (a.take(27).sort_by(&:first) + a[27..-1]).to_h

    #=> h contains the following
    # {
    #   " "=>1, "a"=>4, "b"=>23, "c"=>14, "d"=>12, "e"=>2, "f"=>18, "g"=>19,
    #   "h"=>9, "i"=>6, "j"=>26, "k"=>25, "l"=>13, "m"=>16, "n"=>7, "o"=>5, 
    #   "p"=>22, "q"=>28, "r"=>11, "s"=>8, "t"=>3, "u"=>15, "v"=>24, "w"=>17, 
    #   "x"=>27, "y"=>21, "z"=>29, "1"=>31, "2"=>32, "3"=>33, "4"=>34, "5"=>35,
    #   "6"=>36, "7"=>37, "8"=>38, "9"=>39, "0"=>41, "<backspace>"=>42
    # }

    @hb = h.invert

    @short_delay, @long_delay = 0.35, 0.9 # seconds

  end

  def autoknock(s)
    playback knockerize(s)
  end

  def knocked()

    t1 = Time.now

    if t1 < @t + @short_delay then

      @i += 1

    else

      @a << ',' if t1 > @t + @long_delay
      @i = 1
      @a << 0

    end

    @a[-1] = @i

    @t = Time.now

    @external.knock if @external
  end

  alias knock knocked

  def knocks(n)

    n.times { knocked }

    puts (['knock'] * n).join ', ' if @verbose
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
    @a = [0]

    if block_given? then
      yield self
      stop_listening
    end

  end

  def long_pause()

    puts "\n*pause*\n\n" if @verbose
    sleep @long_delay + 0.1    

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

  def short_pause()
    sleep @short_delay + 0.1
  end

  def stop_listening()

    @message = @a[2..-1].join.gsub(/(\d{2})(\d)/,'\1,\2').split(',')\
                                                          .inject([]) do |r, x|
      (x != '42' ? r << @hb[x.to_i] : r[0..-2])
    end.join

  end
end

