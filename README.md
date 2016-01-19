# Introducing the Secret_knock gem

To get started you will need to refer to the secret knock lookup table as show below:


<pre>
a: 4     f: 18    k: 25    p: 22    u: 15    z: 29    5: 35           0: 41
b: 23    g: 19    l: 13    q: 28    v: 24    1: 31    6: 36     [space]: 1
c: 14    h: 9     m: 16    r: 11    w: 17    2: 32    7: 37 &lt;backspace&gt;: 42
d: 12    i: 6     n: 7     s: 8     x: 27    3: 33    8: 38    
e: 2     j: 26    o: 5     t: 3     y: 21    4: 34    9: 39 
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

1 2 3 4 5 6 7 8 9 
1 2 
1 
1 2 3 4 
1 2 3 4 
1 2 
1 
1 2 3 
1 
1 2 3 
1 2 3 4 5 => "hello"
</pre>

You can see above that I used the special knock to correct the previous letter which should have been 3 knocks instead of 4.

## Resources

* secret_knock https://rubygems.org/gems/

secretknock gem 
