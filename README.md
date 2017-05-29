# SchoolOfNet - Avancando com Ruby On Rails

Resumo do curso:

https://www.schoolofnet.com/curso-avancando-com-ruby-rails

---

## <a name="indice">Índice</a>

- [Introdução](#parte1)
- [Relações entre model - one to many](#parte2)
- [Relações entre model - one to one](#parte3)
- [Nested routes e resource](#parte4)
- [Trabalhado com form helper](#parte5)
- [Layouts](#parte6)
- [Layouts helpes uteis](#parte7)
- [Internacionalização](#parte8)
- [Gems e Bootstrap](#parte9)
- [Trabalhando com AJAX](#parte10)
- [Paginação](#parte11)
- [Finalizando](#parte12)


---

## <a name="parte1">Introdução</a>

Referências:

[Desenv. Ágil para Web com Ruby on Rails](https://www.caelum.com.br/apostila-ruby-on-rails/)

[Ruby on Rails Guides](http://guides.rubyonrails.org/)

[Livro - Ruby on Rails coloque sua aplicação web nos trilhos](https://www.casadocodigo.com.br/products/livro-ruby-on-rails)

[Voltar ao Índice](#indice)

---

## <a name="parte2">Relações entre model - one to many</a>

-> rails generate model book title:string page:integer
```ruby
class Book < ApplicationRecord
  belongs_to :author
end

```

-> rails generate model author name:string
```ruby
class Author < ApplicationRecord
  has_many :books
end

```

Ajustando migration

```ruby
class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :page

      t.timestamps

      t.belongs_to :author, index: true
    end
  end
end

```

-> rails db:migrate
```
== 20170527114158 CreateBooks: migrating ======================================
-- create_table(:books)
   -> 0.0029s
== 20170527114158 CreateBooks: migrated (0.0037s) =============================

== 20170527114439 CreateAuthors: migrating ====================================
-- create_table(:authors)
   -> 0.0022s
== 20170527114439 CreateAuthors: migrated (0.0029s) ===========================

```

-> rails console
```
Author.create(:name => "Jose Malcher")
   (0.0ms)  begin transaction
  SQL (2.0ms)  INSERT INTO "authors" ("name", "created_at", "updated_at") VALUES (?, ?, ?)  [["name", "Jose Malcher"], ["created_at", "2017-05-27
 11:59:44.691326"], ["updated_at", "2017-05-27 11:59:44.691326"]]
   (963.7ms)  commit transaction
=> #<Author id: 1, name: "Jose Malcher", created_at: "2017-05-27 11:59:44", updated_at: "2017-05-27 11:59:44">

```

```
Book.create(:title => "Book 1", :page => 200, :author_id => 1)
   (0.0ms)  begin transaction
  Author Load (0.0ms)  SELECT  "authors".* FROM "authors" WHERE "authors"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  SQL (1.7ms)  INSERT INTO "books" ("title", "page", "created_at", "updated_at", "author_id") VALUES (?, ?, ?, ?, ?)  [["title", "Book 1"], ["pag
e", 200], ["created_at", "2017-05-27 12:03:10.102135"], ["updated_at", "2017-05-27 12:03:10.102135"], ["author_id", 1]]
   (40.6ms)  commit transaction
=> #<Book id: 1, title: "Book 1", page: 200, created_at: "2017-05-27 12:03:10", updated_at: "2017-05-27 12:03:10", author_id: 1>

```

```
Book.all()
  Book Load (0.0ms)  SELECT  "books".* FROM "books" LIMIT ?  [["LIMIT", 11]]
=> #<ActiveRecord::Relation [#<Book id: 1, title: "Book 1", page: 200, created_at: "2017-05-27 12:03:10", updated_at: "2017-05-27 12:03:10", auth
or_id: 1>]>

```


[7.6 - Criando Modelos](https://www.caelum.com.br/apostila-ruby-on-rails/active-record/#7-6-criando-modelos)


[Voltar ao Índice](#indice)

---

## <a name="parte3">Relações entre model - one to one</a>

-> rails generate model Person name:string
```ruby
class Person < ApplicationRecord
  has_many :passaports
end

```

-> rails generate model Passaport country:string 

```ruby
class CreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.string :name

      t.timestamps

      t.belongs_to :passaports, index: true
    end
  end
end

```
-> rails db:migrate
```
== 20170527123005 CreatePeople: migrating =====================================
-- create_table(:people)
   -> 0.0027s
== 20170527123005 CreatePeople: migrated (0.0031s) ============================

== 20170527123022 CreatePassaports: migrating =================================
-- create_table(:passaports)
   -> 0.0024s
== 20170527123022 CreatePassaports: migrated (0.0027s) ========================

```

Verificação

[http://www.sqlite.org/download.html](http://www.sqlite.org/download.html)

-> rails dbconsole
```sql
sqlite> .schema people
CREATE TABLE IF NOT EXISTS "people" ("id" INTEGER PRIMARY KEY AUTOIN
CREMENT NOT NULL, "name" varchar, "created_at" datetime NOT NULL, "u
pdated_at" datetime NOT NULL, "passaports_id" integer);
CREATE INDEX "index_people_on_passaports_id" ON "people" ("passaport
s_id");

sqlite> .schema books
CREATE TABLE IF NOT EXISTS "books" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar, "page" integer, "created_at" datetime NOT N
ULL, "updated_at" datetime NOT NULL, "author_id" integer);
CREATE INDEX "index_books_on_author_id" ON "books" ("author_id");

sqlite> .schema authors
CREATE TABLE IF NOT EXISTS "authors" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "created_at" datetime NOT NULL, "updated_a
t" datetime NOT NULL);


```




[Voltar ao Índice](#indice)

---

## <a name="parte4">Nested routes e resource</a>

-> rails generate scaffold album title:string

-> rails generate scaffold song name:string

Gerando apenas resources: (não cria views)

-> rails generate resource address # apenas exemplo

Relacionando:

```ruby
Rails.application.routes.draw do
  resources :songs
  resources :albums
end

```
```ruby
class Song < ApplicationRecord
  belongs_to :album
end
```
```ruby
class Album < ApplicationRecord
  has_many :songs
end

```
```ruby
class CreateSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :songs do |t|
      t.string :name

      t.timestamps
      t.belongs_to :album, index: true 
    end
  end
end

```

-> rails db:migrate

-> rails s (testar)

Listar todas as rotas

-> rails routes
```
rails routes
    Prefix Verb   URI Pattern                Controller#Action
     songs GET    /songs(.:format)           songs#index
           POST   /songs(.:format)           songs#create
  new_song GET    /songs/new(.:format)       songs#new
 edit_song GET    /songs/:id/edit(.:format)  songs#edit
      song GET    /songs/:id(.:format)       songs#show
           PATCH  /songs/:id(.:format)       songs#update
           PUT    /songs/:id(.:format)       songs#update
           DELETE /songs/:id(.:format)       songs#destroy
    albums GET    /albums(.:format)          albums#index
           POST   /albums(.:format)          albums#create
 new_album GET    /albums/new(.:format)      albums#new
edit_album GET    /albums/:id/edit(.:format) albums#edit
     album GET    /albums/:id(.:format)      albums#show
           PATCH  /albums/:id(.:format)      albums#update
           PUT    /albums/:id(.:format)      albums#update
           DELETE /albums/:id(.:format)      albums#destroy

```

Rotas alinhadas
```ruby
Rails.application.routes.draw do
  resources :albums do
    resources :songs
  end
end

```
```
rails routes
         Prefix Verb   URI Pattern                                Controller#Action
    album_songs GET    /albums/:album_id/songs(.:format)          songs#index
                POST   /albums/:album_id/songs(.:format)          songs#create
 new_album_song GET    /albums/:album_id/songs/new(.:format)      songs#new
edit_album_song GET    /albums/:album_id/songs/:id/edit(.:format) songs#edit
     album_song GET    /albums/:album_id/songs/:id(.:format)      songs#show
                PATCH  /albums/:album_id/songs/:id(.:format)      songs#update
                PUT    /albums/:album_id/songs/:id(.:format)      songs#update
                DELETE /albums/:album_id/songs/:id(.:format)      songs#destroy
         albums GET    /albums(.:format)                          albums#index
                POST   /albums(.:format)                          albums#create
      new_album GET    /albums/new(.:format)                      albums#new
     edit_album GET    /albums/:id/edit(.:format)                 albums#edit
          album GET    /albums/:id(.:format)                      albums#show
                PATCH  /albums/:id(.:format)                      albums#update
                PUT    /albums/:id(.:format)                      albums#update
                DELETE /albums/:id(.:format)                      albums#destroy


```

Ajustes nos Controllers




[8.6 - Para Saber Mais - Nested Resources](https://www.caelum.com.br/apostila-ruby-on-rails/rotas/#8-6-para-saber-mais-nested-resources)

[http://guides.rubyonrails.org/routing.html](http://guides.rubyonrails.org/routing.html)

[Voltar ao Índice](#indice)

---

## <a name="parte5">Trabalhado com form helper</a>

Criado "search.html.erb"
```ruby
<%= form_tag(action: 'searchAlbum', method: 'get', controller: 'albums') do %>

  <%= label_tag(:name, "Search for album name:") %>
  <%= text_field_tag(:name) %>
  <%= submit_tag("Do serach") %>
  
  <%= check_box_tag(:colors) %>
  <%= label_tag(:colors, "Color") %>
  
  <%= radio_button_tag(:gender, "gender") %>
  <%= label_tag(:gender, "Gender") %>

<% end %>
```

Para Renderizar -> albums_controller.rb
```ruby
# (...)
  # GET /search
  def search
    render "search"
  end

  def searchAlbum
    @album = Album.find_by(title: params[:name])
    respond_to do |format|
      format.html { redirect_to @album }
      format.json { render :json => @album }
    end
  end
# (...)
```

Rotas
```ruby
Rails.application.routes.draw do

  get '/albums/search' => 'albums#search'
  post '/album/searchAlbum' => 'albums#searchAlbum'

  resources :albums do
    resources :songs
  end
end
```




[9.14 - Helpers para formulários](https://www.caelum.com.br/apostila-ruby-on-rails/controllers-e-views/#9-14-helpers-para-formularios)

[Voltar ao Índice](#indice)

---

## <a name="parte6">Layouts</a>

[Voltar ao Índice](#indice)

---

## <a name="parte7">Layouts helpes uteis</a>

[Voltar ao Índice](#indice)

---

## <a name="parte8">Internacionalização</a>

[Voltar ao Índice](#indice)

---

## <a name="parte9">Gems e Bootstrap</a>

[Voltar ao Índice](#indice)

---

## <a name="parte10">Trabalhando com AJAX</a>

[Voltar ao Índice](#indice)

---

## <a name="parte11">Paginação</a>

[Voltar ao Índice](#indice)

---

## <a name="parte12">Finalizando</a>

[Voltar ao Índice](#indice)

---