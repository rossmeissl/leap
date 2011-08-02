# Leap

See also: [RDoc](http://rubydoc.info/github/rossmeissl/leap/master/frames).

Leap is a system for:

1. describing decision-making strategies used to determine a potentially non-obvious attribute of an object
2. computing that attribute by choosing appropriate strategies given a specific set of input information

At [Brighter Planet](http://brighterplanet.com), we use Leap to determine the carbon footprint of activities like flights that produce some quantity of CO2 emissions. Given, for example, an arbitrary real-life flight, for which we know some subset of its real-life details, Leap uses the most appropriate methodology to arrive at a result.

## Quick start and silly example

``` console
$ gem install leap
```

``` ruby
class Person
  # attributes: name, age, gender

  include Leap
  decide :lucky_number do
    committee :lucky_number do
      quorum 'look it up in the magic book', :needs => [:name, :age] do |characteristics|
        MagicBook.lookup(characteristics[:name], characteristics[:age]).lucky_number
      end
      quorum 'from lucky color', :needs => :lucky_color do |characteristics|
        characteristics[:lucky_color].chars.first.unpack('C')
      end
    end

    committee :lucky_color do
      quorum 'guess by gender', :needs => :gender do |characteristics|
        case characteristics[:gender].to_sym
        when :male
          'blue'
        when :female
          'pink'
        end
      end
      quorum 'guess by age', :needs => :age do |characteristics|
        if 14..17.include? characteristics[:age]
          'black'
        elsif characteristics[:age] < 5
          'rainbow'
        end
      end
    end
    
    committee :gender do
      quorum 'look up in a name book', :needs => :name do |characteristics|
        NameBook.lookup(characteristics[:name]).gender
      end
    end
  end
end
```

``` irb
> Person.new(:age => 28).lucky_number
 => 42
```


## Extended example

Let's say that somewhere in our Ruby application we need to figure out what time of day it is. Because time of day depends on a frame of reference, we'll consider it as a computable property of a Person.

``` ruby
class Person < ActiveRecord::Base # using Rails, which is totally optional
  has_one :watch
end
```

Obviously if you have a watch, this is a pretty straightforward problem:

``` ruby
class Person
  has_one :watch
  
  include Leap
  decide :time do
    committee :time do
      quorum 'look at your watch', :needs => :watch do |characteristics|
        characteristics[:watch].time
      end
    end
  end
end
```

``` irb
> Person.new(:watch => Watch.new).time
 => 3:02pm
```

The `decide :time do . . . end` block is called the *decision*. In this case, we're describing how to decide *time* for a given Person; we say that time is the *goal* of the decision. Leap will define a method on the object named after the decision (in this case, `Person#time`). Calling this method computes the decision.

The `committee :time do . . . end` block is called a *committee*. Committees represent a set of methodologies, all of which are appropriate means of determining its namesake property, in this case *time*. Most decision blocks provide a committee named the same as the goal; this is implicitly the *master committee*. Typically Leap decisions will involve many more committees, each of which is tasked with determining some intermediate result necessary for the master committee to arrive at a conclusion.

The `quorum 'look at your watch' . . . end` block is called a *quorum*. Quorums describe *one particular way* of reaching the committee's conclusion, along with a list (`:needs`) of what they need to be employed. The `characteristics` blockvar is a curated subset of the object's attributes presented to the quorum (which is in this sense a *closure*) for consideration.

The `Person#time` method, which is created dynamically by Leap, is called the *goal method*---it actually performs the decision on the object.

Back to the example. Having a watch does indeed make telling time easy. Complexities arise when you don't; you have to fallback to more intuitive methods.

For example, we can look at the angle of the sun. (I'm going to start abbreviating the code blocks at this point.)

``` ruby
decide :time do
  committee :time do
    quorum 'look at your watch', :needs => :watch do |characteristics|
      characteristics[:watch].time
    end
    quorum 'use a sun chart', :needs => [:solar_elevation, :location] do |characteristics|
      SunChart.for(characteristics[:location]).solar_elevation_to_time(characteristics[:solar_elevation])
    end
  end
end
```

But how do we know solar elevation? Or location for that matter? Committees! (Note that committees are always convened in reverse order, from last to first.)

``` ruby
decide :time do
  committee :time do
    quorum 'look at your watch', :needs => :watch # . . .
    quorum 'use a sun chart', :needs => [:solar_elevation, :location] # . . .
  end
  committee :solar_elevation do
    quorum 'use a solar angle gauge', :needs => :solar_angle_gauge # . . .
    quorum 'ask a friend', :needs => :friend # . . .
  end
  committee :location do
    quorum 'find out from your GPS', :needs => :gps_device # . . .
    quorum 'geocode it', :needs => :current_address # . . .
  end
end
```

Surely there is more than one way of determining the Person's current address, so, as you can see, a dozen or more committees, each with several quorums, would be necessary to completely describe the intuitive process that we humans use to figure out something as simple as the likely time of day. This is a useful way to think about Leap: it's a non-learning artifical intelligence system that attempts to model human intuition by describing heuristic strategies.

Now that we've looked at an overview of the Leap system, let's look at each component in depth, starting with the goal method and proceeding from the inside (characteristics) out (decisions).

## Goal method

Since Leap helps determine non-obvious attributes of objects, its decisions are made using methods that look and behave like attribute accessors:

``` ruby
@person.time # Makes the "time" decision (as defined on Person) using @person's characteristics
```

If there is a master commitee, the goal method returns its report; if not, it returns a hash of all the committees' reports.

## Characteristics

The computation of a Leap decision requires a curated set of properties of the host object. In the examples above, you'll see that each quorum receives a `characteristics` hash. Where does this come from?

By default, Leap will dynamically construct a characteristics hash out of the object's instance variables. This is definitely a stopgap solution though; much better is to provide a method on the object that returns a *curated* set of properties ("characteristics") and specify it to Leap using the `:with` option on the `decide` block:

``` ruby
class Person < ActiveRecord::Base
  def characteristics
    attributes.slice :name, :age, :gender
  end
  
  include Leap
  decide :lucky_number, :with => :characteristics
    # . . .
  end
end
```

Even better is to use a library like [Charisma](http://github.com/brighterplanet/charisma) that does the curation for you:

``` ruby
class Person < ActiveRecord::Base
  include Charisma
  characterize do
    has :name
    has :age
    has :gender
  end
  
  include Leap
  decide :lucky_number, :with => :characteristics
    # . . .
  end
end
```

When it comes time to compute your decision block, Leap will call your characteristics method, duplicate the resulting hash, and send it into the decision. The hash gets handed from one committee to the next, with each committee inserting its conclusion. In this way, the hash accumulates increasing knowledge about the object until it reaches the master committee for final determination.

It's worth noting that often a decision block will have committees that correspond exactly (by name) with attributes in the characteristics hash. That's because there's never a guarantee that all of the object's attributes will be non-nil. If an attribute is directly provided by the object, the corresponding committee will never be called.

## Defining quorums

Quorums are encapsulated methodologies for determining something, given a
specific set of inputs.

``` ruby
class Automobile
  include Leap
  decide :total_cost_of_ownership do
    # . . .
    committee :annual_insurance_premium do
      # . . .
      quorum 'from type of automobile', :needs => [:make, :model], :appreciates => :color do |characteristics|
        premium = Automobile.scoped(:make => characteristics[:make], :model => characteristics[:model]).average(:annual_claims_total) * 1.2 # profit!
        premium += 100 if characteristics[:color] == 'red'
        premium
      end
      # . . .
    end
    # . . .
  end
end
```

This is an example from a total cost of ownership model. In this case, the annual insurance premium can, among other ways, be calculated from the type of automobile. In order for this methodology to be employable, we need to know, or Leap must have already determined (by a prior committee) the automobile's make and model. If it's available, the automobile's color will also help.

The quorum block gets stored as a closure for later use; the `:needs` act as a gatekeeper. If, during computation, available characteristics satisfy the quorum's requirements, then the *subset* of those characteristics that are actually *asked for* (via `:needs` or `:appreciates`) is provided to the block.

## Committees

Committees are charged with producing a single value, as defined by its name, and, in pursuit of this value, identifying and acknowledging its most appropriate quorum to return this value, given available input information.

Quorums are always considered top-to-bottom. When called, the committee assesses each quorum, checking to see if its needs are satisfied by available information. The first satisfied quorum is acknowledged. If its conclusion is non-nil, it becomes the committee's conclusion; if it is nil, then the committee continues to the next satisfied quorum. If no conclusion is possible, the committee returns a nil result.

## Decisions

Decisions are ordered groups of committees fashioned to provide a number of pathways to a single result (the goal). Committees are always called bottom-to-top, so that progressively more information becomes known about the object, ultimately reaching the master committee that provides the result of the decision. Leap begins with the curated characteristics hash described above. It submits this hash to the first committee (the bottom one), which produces some result. This result is added to the characteristics hash, which is then submitted to the next committee, and so on, until the final (top) committee is called, benefiting from all of the intermediate committee conclusions.

## Compliance

Leap is all about providing numerous methods for arriving at a conclusion. But inevitably that means that some <del>unsavory</del> unorthodox quorums will make their way into your committees, and sometimes you'll want to restrict your decisions to conventional approaches. Leap supports this with its *compliance system*.

Just mark certain quorums as complying with certain protocols:

``` ruby
quorum 'outside the box', :needs => :type do |characteristics|
  # . . .
end
quorum 'mind the red tape', :needs => :type, :complies => :the_rules do |characteristics|
  # . . .
end
```

and then perform your decision with a protocol constraint:

``` irb
> Person.lucky_number :comply => :the_rules
 => 99
```

You can name your protocols how ever you want; they just have to match between the quorum assertions and the decision option.

## Internals

Normally you'll construct your decision strategies using `decide :foo . . . end` blocks and perform them using the resulting `#foo` methods, but sometimes you'll want access to Leap's internals.

* All decisions are stored as Leap::Decision objects in the host class's `@decisions` variable. Leap provides a `#decisions` accessor.
* When a decision is *computed* for a specific instance, it is stored as a Leap::Deliberation in the instance's `@deliberations` variable. Leap provides a `#deliberations` accessor. 

## Copyright

Copyright (c) 2010 Andy Rossmeissl.
