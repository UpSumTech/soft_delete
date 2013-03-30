# SoftDelete

A lightweight gem to allow you to soft delete models.
This gem currently works with Rails and mysql and is tested against the latest
version of Rails (3.2.12)

## Installation

Add this line to your application's Gemfile:

    gem 'soft_delete'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install soft_delete

## Usage

```ruby
class User
  
  include SoftDelete::Archivable

  # You can call the soft delete method on the class with :if or :unless
  # options with the value as a proc/lambda
  # You can also opt to totally skip the soft_delete method
  # In that case the soft delete will happen unconditionally.
  soft_delete :if => proc { |user| user.active? }
end

# This will archive the user and in the process will also run
# all the callbacks for destroy.
# If you have uniqueness constraints in the database,
# you cant create duplicate items even after you have archived the item.
# Once the object is destroyed or archived, the object gets frozen.
user = User.find(1)
user.destroy
User.find(1) # ActiveRecord::RecordNotFound exception will be raised
User.unscoped.where(:id => 1).first # Gives you back the archived user

# If you want to archive the model object without running the callbacks
# Or whithout going through the conditional check for soft delete.
user = User.find(2)
user.archive

# The gem provides a convinience method to find out if the object can be
soft deleted
user = User.find(3)
user.archivable? # evaluates and returns the condition in soft delete
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
