# Introducing the Secret_knock gem

To get started you will need to refer to the secret knock lookup table as show below:

<pre>
a: 4     f: 25    k: 35    p: 32    u: 22    z: 43    5: 52  0: 61   
b: 33    g: 26    l: 16    q: 42    v: 34    1: 44    6: 53  [space]: 1
c: 21    h: 13    m: 23    r: 14    w: 24    2: 45    7: 54  &lt;backspace&gt;: 62
d: 15    i: 6     n: 11    s: 12    x: 41    3: 46    8: 55
e: 2     j: 36    o: 5     t: 3     y: 31    4: 51    9: 56
</pre>     


A letter with 2 numbers means that you must knock the specified number of times, then pause for roughly half a second. There is no time limit on how long you take before knocking out your next letter.

    require 'io/console'
    require 'secret_knock'


    c = ' '

    sk = SecretKnock.new

    sk.listen do |x|

      puts 'press the space bar to knock, or any other key to exit'
      x.knock while (c = $stdin.getch ) == ' '

    end

    puts "Your message was " + sk.message

Note: While knocking, if you discover that you have knocked out the wrong letter, there is a special knock that acts as a backspace.

## Example output

<pre>
press the space bar to knock, or any other key to exit

1 
1 2 3 
1 2 
1 
1 2 3 4 5 6 
1 
1 2 3 4 5 6 
1 2 3 4 5 => "hello"
</pre>


## Resources

* secret_knock https://rubygems.org/gems/

secretknock gem 
