## VMS

## PreRequisites
- MongoDB
- NodeJs
- Ruby
- ImageMagick

```
  # Mac OS
  brew install imagemagick

  # *NIX
  sudo apt-get install imagemagick libmagickwand-dev
```

> references - Select OS as necessary

  >- [Steps for installing Rails](https://gorails.com/setup/osx/10.13-high-sierra)
  
  >- [Steps for installing MongoDB](https://docs.mongodb.com/manual/installation/)

## Installation

  1. Set up Backend

  ``` 
    bundle install
  ```

  2. Set up the app - 1st time
  
  ```
    rake db:seed
  ```

## Code Rules

- indents at 2 spaces
- Each module is with test cases and automated testing
- Each Pull request is in the form of a card name
  - Card 122 from trello with title "Fix all the X and Y in z" is being worked upon
  - branch name : 122-xy-fixes
  - In case of tasks that aren't a part of a card but need to go into codebase:
    - \<Type of task\>/\<Task name\>
    - Eg: hotfix/bla-working-fix 

- Release Cycle: After first beta (v0.1)
  - Each major with update at first decimal place - Eg: v0.2, v0.3, v0.4
  - each minor with update at 2 decimal places - Eg: v0.2.1 v0.2.2
  - each release to be noted on codebase as a tagged release

## Modules: (TBD)

### 1. Shared

#### 1.1 Image Uploader

Add to your model:

```ruby
  # NO SQL support only - add the field otherwise
  mount_uploader :image, ImageUploader
```

Add to the model's controller for strong parameters:

```ruby
  params(:your_model).permit(:your, :params, :plus, :image)
```

Add to the view add the :image_url, or :image


#### 1.2 Searchable Field

Refer app/models/searchable.rb for usage details
Add to your model:

```ruby
  # NO SQL support only - add the field otherwise
  include Searchable

  # index the automated field
  index({ search_data: "text" })

  # define the fields to index 
  def search_field_set
    [:whitelisted, :fields, :of_document]
  end    
  
```

In the contoller - use mongo's full text index feature

```
  @results = Model.where("$text" => {"$search" => params[:search]})
```

## Indexing
```
Sample
  Model.create_indexes
  Model.all.map{|x| x.save}
  # for removing index
  Model.remove_indexes
```


## Documentation: 

### 1. Users

- Sign In
- Sign Up
- Sign Out
- Update Data
