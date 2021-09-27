# Simple Poker Parser

This web application was initially based off of my Base Ruby on Rails Template (original README.md still intact below).
It was updated with Material Design Bootstrap 5 but remains mostly unchanged.  Includes linters, RSpec installation, and
configuration for CircleCI.  Any issues with getting the application to run on your machine is addressed in the base template
documentation.

## Basic Form and Web App

Keeping it simple, there is only one page which is root or welcome#index.  A post route was added that utilizes AJAX and
injects the response into the page.  The application utilizes a Facade and a Poker Parser library file.  In the Facade
the process_hand method is executed:

```ruby
    def process_hand
      return 'Invalid hand' unless validates_uniqueness_and_count

      separate_face_and_suit
      create_poker_cards
      poker_hand.any?(&:nil?) ? 'Invalid hand' : hand_score(poker_hand)
    end
```

First the method checks that all entries are unique and that there are only 5 entries with the method validates_uniqueness_and_count:

```ruby
    def validates_uniqueness_and_count
      raw_data.count == 5 && raw_data.uniq.count == 5
    end
```

It checks to see if there are only 5 entries if there are not it short circuits with && and returns false.  Otherwise it
checks for 5 unique entries.  Why?  If one enters AH AH QC KD JD there are five entries and it would process.  By processing
the entry with .uniq the entry becomes AH QC KD JD and fails.  Why not .uniq on the entry first?  Well if the entry is
AH AH QC QC QC KD JD 10C it would compress to AH QC KD JD 10C and would be considered a valid entry when it is not.
Passing both a normal count and a .uniq.count insures that duplicate entries cannot be used to short circuit the system.

After passing a basic validation check, it separates the face rank of the card from the suit of the card with 
separate_face_and_suit.

```ruby
    def separate_face_and_suit
      raw_data.each do |data|
        processed_data << (data.length == 2 ? [data.first, data.last] : [data.first(2), data.last])
      end
    end
```

It processes the array using the Enumerable .each on the params from the user.  Originally, I still had a .uniq on the 
 params in case there was a way to get an invalid entry past the original screen but decided to remove it (This is
note to add .uniq back if a way is found around the first screen).  It checks the length of the entry, if it is two 
characters it adds an array to the processed_data array comprised of the first and last characters.  If it is not then
it adds an array comprised of the first two characters and the last character.  Why?  Simply because we are working with
a 10.  This catches the 10 and separates it.  What if the entry is ABC?  It will create an Array that is ['AB', 'C']
which will not pass validation in the next method create_poker_cards.

```ruby
    def create_poker_cards
      processed_data.each do |data|
        poker_hand << (validates_face_and_suit(data) ? PokerParser::Card.new(data.last, data.first) : nil)
      end
    end

    def validates_face_and_suit(card)
      faces.any?(card.first) && suits.any?(card.last)
    end
```

This method takes the processed entries which should now be an array of arrays comprised of 1 - 2 characters in the first
position and 1 character in the last and validates them with the method validates_face_and_suit.  The validates_face_and_suit
method verifies that the characters exist in the RANKS and SUITS constant in the PokerParser Module.  If they do,
the create_poker_cards method creates a Card based off the Card Struct in the PokerParser Module and inserts it into
the Array poker_hand.  If not, it inserts a nil value.

The final line of the process_hand method will catch any nil values and return 'Invalid hand', otherwise if there are no
nil values in the hand it utilizes the hand_score method from the PokerParser module which is mixed in to the Facade.

```ruby
  poker_hand.any?(&:nil?) ? 'Invalid hand' : hand_score(poker_hand)
```

```ruby
  def hand_score(unsorted_hand)
    hand = Hand[unsorted_hand].sort_by_rank.cards

    return SCORES[:straight_flush] if straight_flush?(hand)
    return SCORES[:four_of_a_kind] if four_of_a_kind?(hand)
    return SCORES[:full_house] if full_house?(hand)
    return SCORES[:flush] if flush?(hand)
    return SCORES[:straight] if straight?(hand)
    return SCORES[:three_of_a_kind] if three_of_a_kind?(hand)
    return SCORES[:two_pair] if two_pair?(hand)
    return SCORES[:one_pair] if one_pair?(hand)

    SCORES[:high_card]
  end
```

The hand_score method receives the poker_hand from the IndexFacade and sorts the cards by rank for pattern matching.  It
then descends through the possible outcomes from highest to lowest.  The referenced methods use one line case methods for pattern matching as follows:

```ruby
  def straight?(hand)
    return true if hand in [
      Card[*, rank],
      Card[*, "#{add_rank(rank, 1)}"],
      Card[*, "#{add_rank(rank, 2)}"],
      Card[*, "#{add_rank(rank, 3)}"],
      Card[*, "#{add_rank(rank, 4)}"]
    ]

    hand in [
      Card[*, '2'],
      Card[*, '3'],
      Card[*, '4'],
      Card[*, '5'],
      Card[*, 'A']
    ]
  end

  def flush?(hand)
    hand in [
      Card[suit, *],
      Card[^suit, *],
      Card[^suit, *],
      Card[^suit, *],
      Card[^suit, *]
    ]
  end
```

This is shorthand for:

```ruby
  def straight?(hand)
    case hand
    in [Card[*, rank], Card[*, "#{add_rank(rank, 1)}"], Card[*, "#{add_rank(rank, 2)}"], Card[*, "#{add_rank(rank, 3)}"], Card[*, "#{add_rank(rank, 4)}"]]
     true
    in [Card[*, '2'], Card[*, '3'], Card[*, '4'], Card[*, '5'], Card[*, 'A']]
     true
    else
     false
    end
  end

  def flush?(hand)
   case hand
   in [Card[suit, *],Card[^suit, *],Card[^suit, *],Card[^suit, *],Card[^suit, *]]
    true
   else
    false
   end
  end
```

The straight? method accepts any suit then takes the first rank (since the hand has been sorted by rank) and then uses
the add_rank method to check to see if the cards are sequential.  The second case for straight? is to account for a 
low ace straight.  The flush? method matches the suit and accepts and rank.  From here the rest of the hand parsing is
fairly straight forward.  The methods look for matching ranks of the cards within the array until it finally gets down
to high card.

## Testing

Testing coverage is at 90% and utilizes a system test to test the examples given in the tech test document and a handful
of other examples to test all branches.  The PokerParser and IndexFacade are both 100% tested and 100% conditional tested.

# Base Ruby on Rails Template

As the title says, this is a base ruby on rails template.  It is ready for Heroku which is easily removed if it is not
needed.  Several code linters are installed: Prettier, Reek, and Rubocop.  These are probably minimums for keeping
code clean and in an agreed upon format.  RSpec is installed for Testing along with SimpleCov for Coverage.  Includes
Cuprite, Capybara, and VCR for Systems Specs and HTTP Request responses.  Factory Bot and Faker are included for data
creation.  An installation of Bootstrap 4 is present, although easily removed as well.

## Getting Started

```shell
bundle install / bundle update
```

```shell
yarn install --check-files / yarn upgrade
```

## Running lint and tests

```shell script
rubocop -A
```

```shell script
reek
```

```shell script
bundle exec rspec --format documentation
```

## Deployment

Should easily deploy to Heroku. Instructions for that at a later date if needed.

## Built With

- [Bootstrap](https://getbootstrap.com) - UI Framework
- [Factory Bot](https://github.com/thoughtbot/factory_bot_rails) - For Data Creation
- [Faker](https://github.com/faker-ruby/faker) - For Data Creation
- [Heroku](https://iexcloud.io/) - Cloud Application Platform
- [PostgreSQL](https://www.postgresql.org) - Database on Heroku
- [Prettier](https://github.com/prettier/plugin-ruby) - Opinionated Code Formatter (Linter)
- [Reek](https://github.com/troessner/reek) - Code Smell Detector for Ruby (Linter)
- [RSpec for Rails](https://github.com/rspec/rspec-rails) - RSpec Testing for Rails
- [RuboCop](https://github.com/rubocop-hq/rubocop) - Ruby Static Code Analyzer (Linter)
- [RuboCop Performance](https://github.com/rubocop/rubocop-performance) - Additional RuboCop Library (Linter) 
- [RuboCop RSpec](https://github.com/rubocop-hq/rubocop-rspec) - RSpec-specific Analysis (Linter)
- [RuboCop Rails](https://github.com/rubocop-hq/rubocop-rails) - RuboCop Extension Enforcing Rails Best Practices (Linter)
- [Ruby](https://www.ruby-lang.org/en/) - Language
- [Ruby on Rails](https://rubyonrails.org) - MVC Framework
- [RubyMine](https://www.jetbrains.com/ruby/) - IDE
- [SimpleCov](https://github.com/simplecov-ruby/simplecov) - Testing Code Coverage Analysis

## FOR REFERENCE (Step by step building of application):

### Setup Application

Create New Rails Application without Testing Installed. Update Gemfile to pull Ruby version from .ruby-version file:

```ruby
ruby File.read('.ruby-version').chomp
```

### Install RSpec for Testing

Install RSpec in Gemfile Development and Test Environments:

```ruby
group :development, :test do
  gem 'rspec-rails', '~> 4.0.1' # https://github.com/rspec/rspec-rails (Rspec Tests)
end
```

Install RSpec through terminal:

```shell
rails generate rspec:install
```

Add request spec helper in spec/rails_helper.rb:
```ruby
  config.include RequestSpecHelper, type: :request
```

### Install SimpleCov for Testing Coverage Analysis

Install SimpleCov in Gemfile Test Environments:

```ruby
group :test do
  gem 'simplecov', require: false
end
```

Add a the file /spec/support/simplecov.rb containing:

```ruby
require 'simplecov'
SimpleCov.start 'rails' do
  enable_coverage :branch
  # minimum_coverage 90

  add_group 'Policies', 'app/policies'
  add_group 'Services', 'app/services'

  add_filter '/channels/'

  # add_filter do |source_file|
  #   source_file.lines.count < 5
  # end
end
```

Add to /spec/rails_helper.rb at top of file:

```ruby
require 'support/simplecov'
```

### Install Gems for Headless Web Driver System Specs and HTTP Requests

```ruby
  ### Installed for Project
gem 'capybara' # https://github.com/teamcapybara/capybara
gem 'cuprite' # https://github.com/rubycdp/cuprite
gem 'vcr', require: false # https://github.com/vcr/vcr
gem 'webmock', require: false
```

Check files for Helpers

### Install Factory Bot and Faker for Testing Data Creation

```ruby
group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
end
```

Uncomment line in /spec/rails_helper.rb:

```ruby
# Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }
```
### Install Linters to Keep Code Clean

Install Code Linters in Gemfile Development and Test Environments:

```ruby
group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'reek' # https://github.com/troessner/reek (Linter)
  gem 'rubocop', '~> 0.9', require: false # https://github.com/rubocop-hq/rubocop (Linter)
  gem 'rubocop-performance', require: false # https://github.com/rubocop/rubocop-performance
  gem 'rubocop-rails' # https://github.com/rubocop-hq/rubocop-rails (Linter)
  gem 'rubocop-rspec' # https://github.com/rubocop-hq/rubocop-rspec (Linter)
end
```

Create Reek Configuration File .reek.yml in Root Directory:

```shell script
---
detectors:
  IrresponsibleModule:
    enabled: false
  LongParameterList:
    max_params: 5
  NestedIterators:
    max_allowed_nesting: 2
  TooManyStatements:
    max_statements: 10
  TooManyInstanceVariables:
    max_instance_variables: 5
  UncommunicativeModuleName:
    enabled: false
  UncommunicativeVariableName:
    accept:
      - '/^e$/'
directories:
  app/controllers:
    InstanceVariableAssumption:
      enabled: false
  app/facades:
    InstanceVariableAssumption:
      enabled: false
  app/helpers:
    UtilityFunction:
      enabled: false
  lib/billing/chargify/api/params:
    UtilityFunction:
      enabled: false
exclude_paths:
  - db
  - node_modules
  - tmp
```

Create RuboCop Configuration File .rubocop.yml in Root Directory:

```shell script
inherit_from: .rubocop_todo.yml

require:
  - rubocop-performance
  - rubocop-rspec
  - rubocop-rails

AllCops:
  Exclude:
    - bin/**/*
    - config/spring.rb
    - db/**/*
    - node_modules/**/*
    - tmp/**/*
  AllowSymlinksInCacheRootDirectory: true
  NewCops: enable
Metrics/MethodLength:
  Max: 10
Metrics/BlockLength:
  Exclude:
    - spec/**/*
Rails/DynamicFindBy:
  Whitelist:
    - find_by_id
Rails/UniqueValidationWithoutIndex:
  Enabled: false
RSpec/EmptyExampleGroup:
  Enabled: false
RSpec/NestedGroups:
  Max: 4
Style/FrozenStringLiteralComment:
  Enabled: false
Style/Documentation:
  Enabled: false
Rails/SkipsModelValidations:
  AllowedMethods:
    - toggle!
Rails/UnknownEnv:
  Environments:
    - development
    - test
    - production
    - staging
```

Install Prettier

```shell script
yarn add --dev prettier @prettier/plugin-ruby
```

Add .prettierrc.json file

```json
{
  "trailingComma": "none",
  "tabWidth": 2,
  "semi": true,
  "singleQuote": true,
  "printWidth": 120
}
```

Add to .rubocop.yml

```yaml
inherit_from:
  - node_modules/@prettier/plugin-ruby/rubocop.yml
```

Run Prettier

```shell script
./node_modules/.bin/prettier --write 'app'
```

### Setup PostgreSQL for Heroku

Add gem 'pg' to Production environment in Gemfile for Heroku:

```ruby
group :production do
  gem 'pg'
end
```

### Setup Circle CI to Test and Build Pull Requests before Merging

Setup for Circle CI by updating .circleci/config.yml:

```shell script
version: 2.1
orbs:
  ruby: circleci/ruby@1.1.2

jobs:
  build:
    docker:
      - image: circleci/ruby:3.0.0-node-browsers
    steps:
      - checkout
      - ruby/install-deps
  test:
    parallelism: 1
    docker:
      - image: circleci/ruby:3.0.0-node-browsers
    environment:
      BUNDLE_JOBS: "3"
      BUNDLE_RETRY: "3"
      RAILS_ENV: test
      COVERAGE: '1'
    steps:
      - checkout
      - ruby/install-deps
      - run:
          name: Compile Assets
          command: COVERGE=0 bundle exec rails assets:precompile
      - ruby/rspec-test
workflows:
  version: 2
  build_and_test:
    jobs:
      - build
      - test:
          requires:
            - build
```

Add rspec_junit_formatter gem to Gemfile for CircleCI tests:

```ruby
gem 'rspec_junit_formatter'
```

### Initial Controller and Root Route

Generate a new controller called welcome with the action index:

```shell
rails g controller welcome index
```

Update config > routes.rb with root path directing to welcome#index:

```ruby
root 'welcome#index'
```

### Setup Bootstrap

Install Bootstrap, jquery, and popper.js via yarn:

```shell
yarn add bootstrap jquery popper.js
```

Update config > webpack > environment.js so Rails understands jquery and popper.js syntax:

```javascript
const { environment } = require("@rails/webpacker");

const webpack = require("webpack");

environment.plugins.append(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
    Popper: ["popper.js", "default"],
  })
);

module.exports = environment;
```

Import bootstrap into app > javascript > packs > application.js:

```javascript
import "bootstrap";
```

Update app > assets > stylesheets > application.css to use Bootstrap.  Change to application.scss and add:

```scss
/*
 *= require_self
 */

@import 'bootstrap/scss/bootstrap';
```

### Handle Flash Messages

Handle Flash Messages in app > views > layouts > application.html.erb:

```html
<p class="notice"><%= notice %></p>
<p class="alert"><%= alert %></p>
```

## Author

- **Jeremy Hastings** - _Initial work_ - [Jeremy Hastings](https://github.com/jeremyhastings/)

## License

This project is licensed under the GNU General Public License 3.0 License - see the [LICENSE.md](LICENSE.md) file for details
