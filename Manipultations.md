#########################################################################################
#
# Manipulations du livre Railstutorials par Michel Hartl
# A partir du chapitre 3
# https://www.railstutorial.org/book
#
# MAnipulations réalisées et documentées par
# Philippe IRAUD (phgiraud@cogitium.com)
# 
# Cette manipulation est faite sur :
# => Ordinateur portable ASUS EeePC 1215B avec 4 Go de Ram
# => Windows 7 Edition familiale Premium 64 bits
# => ruby 2.2.3p173 (2015-08-18 revision 51636) [x64-mingw32]
# => Rails 4.2.2
#
# La seule manipulation non réalisée par choix est l'utilisation du Cloud Amazon S3
# pour stocker les images uploadées au chapitre 11
# Le système fonctionne parfaitement mais les images stockées en local
# disparaissent régulièrement lors de la mise en veille du serveur
# Ne soyez donc pas surpris
# 
#########################################################################################

#########################################################################################
#########################################################################################
### Chapter 3 : Mostly static pages
#########################################################################################
#########################################################################################

### Listing 3.1 Sample app setup

# 3.1: Generating a new sample app.
# Après s'être positionné dans la zone de travail
# Il faut créer une nouvelle application
$ rails new railstutorials
$ cd railstutorials

# Listing 3.2: A Gemfile for the sample app.
# Changer le contenu du Gemfile par ceci :
source 'https://rubygems.org'

gem 'rails',        '4.2.2'
gem 'sass-rails',   '5.0.2'
gem 'uglifier',     '2.5.3'
gem 'coffee-rails', '4.1.0'
gem 'jquery-rails', '4.0.3'
gem 'turbolinks',   '2.3.0'
gem 'jbuilder',     '2.2.3'
gem 'sdoc',         '0.4.0', group: :doc

group :development, :test do
  gem 'sqlite3',     '1.3.9'
  gem 'byebug',      '3.4.0'
  gem 'web-console', '2.0.0.beta3'
  gem 'spring',      '1.1.3'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

group :production do
  gem 'pg',             '0.17.1'
  gem 'rails_12factor', '0.0.2'
end

# Bundle install sans la production
$ bundle install --without production
$ bundle update

# Initialiser le dépôt
$ git init
$ git add -A
$ git commit -m "Initialize repository"

# Renommer le readme.rdoc en .md
$ git mv README.rdoc README.md

# Listing 3.3: An improved README file for the sample app.
# Compléter le readme
# Ruby on Rails Tutorial: sample application
This is the sample application for the
[*Ruby on Rails Tutorial:
Learn Web Development with Rails*](http://www.railstutorial.org/)
by [Michael Hartl](http://www.michaelhartl.com/).

# Valider la modif du readme
$ git commit -am "Improve the README"

# Créer un dépôt sur Bitbucket ou Github 
# Puis pousser le projet dedans
$ git remote add origin git@bitbucket.org:<username>/sample_app.git
$ git push -u origin --all 

# Si vous ne voulez pas être obligé dinstaller une clé SSH 
# indiquer plutôt ladresse https du dépôt
# Le système vous demandera un login et password
$ git remote add origin https://bitbucket.org:<username>/sample_app.git
$ git push -u origin --all # pushes up the repo and its refs for the first time

# Faites tout de suite une mise en production pour valider la chaine de développement
$ git commit -am "Add hello"
$ heroku create
$ git push heroku master

# Pour linstant, il ny a rien dans lapplication

### 3.2 Static pages

# Créer une nouvelle branche pour travailler
$ git checkout master
$ git checkout -b static-pages

# 3.2.1 Generated static pages

# Listing 3.4: Generating a Static Pages controller.
$ rails generate controller StaticPages home help

# A ce moment là il y a plein derreur dans la console sur Windows tout au moins
# Il faut changer des ligne dans le Gemfile
  gem 'sqlite3',     '1.3.9'  -->>  gem 'sqlite3', '>= 1.3.9'
  gem 'web-console', '2.0.0.beta3'  -->>  gem 'web-console', '~> 2.0'
# Et ajouter
  gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Faire bundle update puis le generate doit fonctionner

# Lancer le serveur local et tester les 2 pages statiques
# http://localhost:3000/static_pages/home
# http://localhost:3000/static_pages/help

# Mettre à jour le dépôt
$ git status
$ git add -A
$ git commit -m "Add a Static Pages controller"
$ git push -u origin static-pages

# Listing 3.5: The routes for the home and help actions in the Static Pages controller.
# config/routes.rb
Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/help'
  .
  .
  .
end

### 3.2.2 Custom static pages

# Listing 3.9: Custom HTML for the Home page.
# app/views/static_pages/home.html.erb
<h1>Sample App</h1>
<p>
  This is the home page for the
  <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
  sample application.
</p>

# Listing 3.10: Custom HTML for the Help page.
# app/views/static_pages/help.html.erb
<h1>Help</h1>
<p>
  Get help on the Ruby on Rails Tutorial at the
  <a href="http://www.railstutorial.org/#help">Rails Tutorial help section</a>.
  To get help on this sample app, see the
  <a href="http://www.railstutorial.org/book"><em>Ruby on Rails Tutorial</em>
  book</a>.
</p>

### 3.3 Getting started with testing

### 3.3.1 Our first test

# Listing 3.12: green 
# Vérifier le script de test test/controller/static_pages_controller_test.rb
# Lancer le test
$ bundle exec rake test

# En lançant ce test il y a une message qui précise que web-console
# devarit n'être que dans l'environnement de dev
# il faut modifier le Gemfile comme ceci 
group :development do
#  gem 'web-console', '2.0.0.beta3'
  gem 'web-console', '~> 2.0'
end

# Le test doit fonctionner
# Un message précise que sur Windows, il est possible d'avoir les couleurs
gem install win32console
# Mais ça ne semble pas fonctionner

### 3.3.2 Red

# Listing 3.13: A test for the About page. red
# test/controllers/static_pages_controller_test.rb
# Ajouter un test qui ne  fonctionnera pas
  test "should get about" do
    get :about
    assert_response :success
  end

# Relancer le test
# Il doit y avoir une erreur qui décèle une erreur de route
# Listing 3.14: red
$ bundle exec rake test
3 tests, 2 assertions, 0 failures, 1 errors, 0 skips

### 3.3.3 Green

# Ajouter la route manquante
# Listing 3.16: Adding the about route. red
# config/routes.rb
  get 'static_pages/about'

# Relancer le test
# Listing 3.17: red
$ bundle exec rake test
AbstractController::ActionNotFound:
The action 'about' could not be found for StaticPagesController

# Il y a toujours une erreur qui décèle une action non trouvée
# Ajouter l'action about dans StaticPagesController
# Listing 3.18: The Static Pages controller with added about action. red
# app/controllers/static_pages_controller.rb
  def about
  end

# Relancer le test
# Il y a toujours une erreur qui décèle une vue non trouvée
# Créer la vue about.html.erb
# Listing 3.19: Code for the About page. green
# app/views/static_pages/about.html.erb
<h1>About</h1>
<p>
  The <a href="http://www.railstutorial.org/"><em>Ruby on Rails
  Tutorial</em></a> is a
  <a href="http://www.railstutorial.org/book">book</a> and
  <a href="http://screencasts.railstutorial.org/">screencast series</a>
  to teach web development with
  <a href="http://rubyonrails.org/">Ruby on Rails</a>.
  This is the sample application for the tutorial.
</p>

# Relancer le test
# Listing 3.20: green
$ bundle exec rake test
3 tests, 3 assertions, 0 failures, 0 errors, 0 skips

# Il n'y a plus d'erreur
# Cette façon de faire s'appelle : Test Driven Development
# Vérifier l'adresse http://localhost:3000/static_pages/about

### 3.3.4 Refactor

### 3.4 Slightly dynamic pages

# Renommer la layout par defaut
application.html..erb  -->>  layout_file

### 3.4.1 Testing titles (Red)

# Mofifier le test comme ceci
# Listing 3.22: The Static Pages controller test with title tests. red
# test/controllers/static_pages_controller_test.rb
require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Home | Ruby on Rails Tutorial Sample App"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About | Ruby on Rails Tutorial Sample App"
  end
end

# Relancer le test
# Il y a 3 failures
# Listing 3.23: red
$ bundle exec rake test
3 tests, 6 assertions, 3 failures, 0 errors, 0 skips

### 3.4.2 Adding page titles (Green)

# Modifier la vue home
# Listing 3.24: The view for the Home page with full HTML structure. red
# app/views/static_pages/home.html.erb
<!DOCTYPE html>
<html>
  <head>
    <title>Home | Ruby on Rails Tutorial Sample App</title>
  </head>
  <body>
    <h1>Sample App</h1>
    <p>
      This is the home page for the
      <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
      sample application.
    </p>
  </body>
</html>

# Modifier la vue help
# Listing 3.25: The view for the Help page with full HTML structure. red
# app/views/static_pages/help.html.erb
<!DOCTYPE html>
<html>
  <head>
    <title>Help | Ruby on Rails Tutorial Sample App</title>
  </head>
  <body>
    <h1>Help</h1>
    <p>
      Get help on the Ruby on Rails Tutorial at the
      <a href="http://www.railstutorial.org/#help">Rails Tutorial help
      section</a>.
      To get help on this sample app, see the
      <a href="http://www.railstutorial.org/book"><em>Ruby on Rails
      Tutorial</em> book</a>.
    </p>
  </body>
</html>

# Modifier la vue about
# Listing 3.26: The view for the About page with full HTML structure. green
# app/views/static_pages/about.html.erb
<!DOCTYPE html>
<html>
  <head>
    <title>About | Ruby on Rails Tutorial Sample App</title>
  </head>
  <body>
    <h1>About</h1>
    <p>
      The <a href="http://www.railstutorial.org/"><em>Ruby on Rails
      Tutorial</em></a> is a
      <a href="http://www.railstutorial.org/book">book</a> and
      <a href="http://screencasts.railstutorial.org/">screencast series</a>
      to teach web development with
      <a href="http://rubyonrails.org/">Ruby on Rails</a>.
      This is the sample application for the tutorial.
    </p>
  </body>
</html>

# Relancer le test
# Plus d'erreur, les title sont conformes aux tests
# Listing 3.27: green
$ bundle exec rake test
3 tests, 6 assertions, 0 failures, 0 errors, 0 skips

### 3.4.3 Layout and embedded Ruby (Refactor)

# Modifier la vue home
# Listing 3.28: The view for the Home page with an embedded Ruby title. green
# app/views/static_pages/home.html.erb
<% provide(:title, "Home") %>
<!DOCTYPE html>
<html>
  <head>
    <title><%= yield(:title) %> | Ruby on Rails Tutorial Sample App</title>
  </head>
  <body>
    <h1>Sample App</h1>
    <p>
      This is the home page for the
      <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
      sample application.
    </p>
  </body>
</html>

# Relancer le test, toujours bon
# Listing 3.29: green
$ bundle exec rake test
3 tests, 6 assertions, 0 failures, 0 errors, 0 skips

# Modifier la vue help
# Listing 3.30: The view for the Help page with an embedded Ruby title. green
# app/views/static_pages/help.html.erb
<% provide(:title, "Help") %>
<!DOCTYPE html>
<html>
  <head>
    <title><%= yield(:title) %> | Ruby on Rails Tutorial Sample App</title>
  </head>
  <body>
    <h1>Help</h1>
    <p>
      Get help on the Ruby on Rails Tutorial at the
      <a href="http://www.railstutorial.org/#help">Rails Tutorial help
      section</a>.
      To get help on this sample app, see the
      <a href="http://www.railstutorial.org/book"><em>Ruby on Rails
      Tutorial</em> book</a>.
    </p>
  </body>
</html>

# Modifier la vue about
# Listing 3.31: The view for the About page with an embedded Ruby title. green
# app/views/static_pages/about.html.erb
<% provide(:title, "About") %>
<!DOCTYPE html>
<html>
  <head>
    <title><%= yield(:title) %> | Ruby on Rails Tutorial Sample App</title>
  </head>
  <body>
    <h1>About</h1>
    <p>
      The <a href="http://www.railstutorial.org/"><em>Ruby on Rails
      Tutorial</em></a> is a
      <a href="http://www.railstutorial.org/book">book</a> and
      <a href="http://screencasts.railstutorial.org/">screencast series</a>
      to teach web development with
      <a href="http://rubyonrails.org/">Ruby on Rails</a>.
      This is the sample application for the tutorial.
    </p>
  </body>
</html>

# Après avoir constaté les répétitions de code entre les 3 vues
# Recréer le layout application.html.erb
# Listing 3.32: The sample application site layout. green
# app/views/layouts/application.html.erb
<!DOCTYPE html>
<html>
  <head>
    <title><%= yield(:title) %> | Ruby on Rails Tutorial Sample App</title>
    <%= stylesheet_link_tag    'application', media: 'all',
                                              'data-turbolinks-track' => true %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
    <%= csrf_meta_tags %>
  </head>
  <body>
    <%= yield %>
  </body>
</html>

# Nettoyer la vue home
# Listing 3.33: The Home page with HTML structure removed. green
# app/views/static_pages/home.html.erb
<% provide(:title, "Home") %>
<h1>Sample App</h1>
<p>
  This is the home page for the
  <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
  sample application.
</p>

# Nettoyer la vue help
# Listing 3.34: The Help page with HTML structure removed. green
# app/views/static_pages/help.html.erb
<% provide(:title, "Help") %>
<h1>Help</h1>
<p>
  Get help on the Ruby on Rails Tutorial at the
  <a href="http://www.railstutorial.org/#help">Rails Tutorial help section</a>.
  To get help on this sample app, see the
  <a href="http://www.railstutorial.org/book"><em>Ruby on Rails Tutorial</em>
  book</a>.
</p>

# Nettoyer la vue about
# Listing 3.35: The About page with HTML structure removed. green
# app/views/static_pages/about.html.erb
<% provide(:title, "About") %>
<h1>About</h1>
<p>
  The <a href="http://www.railstutorial.org/"><em>Ruby on Rails
  Tutorial</em></a> is a
  <a href="http://www.railstutorial.org/book">book</a> and
  <a href="http://screencasts.railstutorial.org/">screencast series</a>
  to teach web development with
  <a href="http://rubyonrails.org/">Ruby on Rails</a>.
  This is the sample application for the tutorial.
</p>

# Relancer le test, pas d'erreur
# Listing 3.36: green
$ bundle exec rake test
3 tests, 6 assertions, 0 failures, 0 errors, 0 skips

### 3.4.4 Setting the root route

# Dans le fichier des routes, modifier ainsi
# Listing 3.37: Setting the root route to the Home page.
# config/routes.rb
Rails.application.routes.draw do
  root 'static_pages#home'
  get  'static_pages/help'
  get  'static_pages/about'
end

# L'adresse http://localhost:3000/static_pages/home ne marche plus
# Mais http://localhost:3000 amène à la page home

### 3.5 Conclusion

# Valider les modifications
$ git add -A
$ git commit -m "Finish static pages"

# Fusionner les branches
$ git checkout master
$ git merge static-pages

# Pousser sur le dépôt
$ git push

# Refaire le test et déployer en prod
$ bundle exec rake test
$ git push heroku

# Vérifier sur le serveur de prod

#########################################################################################
#########################################################################################
### Chapter 4 Rails-flavored Ruby
#########################################################################################
#########################################################################################

### 4.1 Motivation

# Listing 4.2: Defining a full_title helper.
# app/helpers/application_helper.rb
module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end

# Listing 4.3: The site layout with the full_title helper. green
# app/views/layouts/application.html.erb
<!DOCTYPE html>
<html>
  <head>
    <title><%= full_title(yield(:title)) %></title>
    <%= stylesheet_link_tag    'application', media: 'all',
                                              'data-turbolinks-track' => true %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
    <%= csrf_meta_tags %>
  </head>
  <body>
    <%= yield %>
  </body>
</html>

# Listing 4.4: An updated test for the Home page’s title. red
# test/controllers/static_pages_controller_test.rb
require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Ruby on Rails Tutorial Sample App"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About | Ruby on Rails Tutorial Sample App"
  end
end

# Listing 4.5: red
$ bundle exec rake test
3 tests, 6 assertions, 1 failures, 0 errors, 0 skips

# En enlevant le provide de la vue home le test doit passer
# Listing 4.6: The Home page with no custom page title. green
# app/views/static_pages/home.html.erb
 <h1>Sample App</h1>
<p>
  This is the home page for the
  <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
  sample application.
</p>

# Listing 4.7: green
$ bundle exec rake test

### 4.2 Strings and methods

### 4.3 Other data structures

### 4.4 Ruby classes

# Une grosse partie théorique ici

### 4.5 Conclusion

# Valider les modifications
$ git status
$ git commit -am "Add a full_title helper"
$ git push
$ bundle exec rake test
$ git push heroku

#########################################################################################
#########################################################################################
### Chapter 5 Filling in the layout
#########################################################################################
#########################################################################################

### 5.1 Adding some structure

# Créer une nouvelle branche
$ git checkout master
$ git checkout -b filling-in-layout

### 5.1.1 Site navigation

# Listing 5.1: The site layout with added structure.
# app/views/layouts/application.html.erb
<!DOCTYPE html>
<html>
  <head>
    <title><%= full_title(yield(:title)) %></title>
    <%= stylesheet_link_tag 'application', media: 'all',
                                           'data-turbolinks-track' => true %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
    <%= csrf_meta_tags %>
    <!--[if lt IE 9]>
      <script src="//cdnjs.cloudflare.com/ajax/libs/html5shiv/r29/html5.min.js">
      </script>
    <![endif]-->
  </head>
  <body>
    <header class="navbar navbar-fixed-top navbar-inverse">
      <div class="container">
        <%= link_to "sample app", '#', id: "logo" %>
        <nav>
          <ul class="nav navbar-nav navbar-right">
            <li><%= link_to "Home",   '#' %></li>
            <li><%= link_to "Help",   '#' %></li>
            <li><%= link_to "Log in", '#' %></li>
          </ul>
        </nav>
      </div>
    </header>
    <div class="container">
      <%= yield %>
    </div>
  </body>
</html>

# Tester la home

# Listing 5.2: The Home page with a link to the signup page.
# app/views/static_pages/home.html.erb
<div class="center jumbotron">
  <h1>Welcome to the Sample App</h1>

  <h2>
    This is the home page for the
    <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
    sample application.
  </h2>

  <%= link_to "Sign up now!", '#', class: "btn btn-lg btn-primary" %>
</div>

<%= link_to image_tag("rails.png", alt: "Rails logo"),
            'http://rubyonrails.org/' %>

# Récupérer limage à ladresse http://railstutorial.org/rails.png
# Et l'enregistrer dans app/assets/images

# Sur un système Linux
Listing 5.3: Downloading an image.
$ curl -OL railstutorial.org/rails.png
$ mv rails.png app/assets/images/

# Tester la home
# En cas d'erreur, suivre les indication
# Ajouter
Rails.application.config.assets.precompile += %w( rails.png )
# Dans config/initializers/assets.rb

# Redémarrer le serveur et tester la home

### 5.1.2 Bootstrap and custom CSS

# Listing 5.4: Adding the bootstrap-sass gem to the Gemfile.
source 'https://rubygems.org'

gem 'rails',                '4.2.2'
gem 'bootstrap-sass',       '3.2.0.0'

# Bundle install
$ bundle install

# Créer un fichier pour le css custom dans assets/stylesheets/custom.css.screencasts

# Listing 5.5: Adding Bootstrap CSS.
# app/assets/stylesheets/custom.css.scss
@import "bootstrap-sprockets";
@import "bootstrap";

# Tester la home, le design Bootstrap doit apparaitre

# Listing 5.6: Adding CSS for some universal styling applying to all pages.
# app/assets/stylesheets/custom.css.scss
@import "bootstrap-sprockets";
@import "bootstrap";

/* universal */

body {
  padding-top: 60px;
}

section {
  overflow: auto;
}

textarea {
  resize: vertical;
}

.center {
  text-align: center;
}

.center h1 {
  margin-bottom: 10px;
}

# Tester la home, les éléments sont maintenant centrés

# Listing 5.7: Adding CSS for nice typography.
# app/assets/stylesheets/custom.css.scss
@import "bootstrap-sprockets";
@import "bootstrap";
.
.
.
/* typography */

h1, h2, h3, h4, h5, h6 {
  line-height: 1;
}

h1 {
  font-size: 3em;
  letter-spacing: -2px;
  margin-bottom: 30px;
  text-align: center;
}

h2 {
  font-size: 1.2em;
  letter-spacing: -1px;
  margin-bottom: 30px;
  text-align: center;
  font-weight: normal;
  color: #777;
}

p {
  font-size: 1.1em;
  line-height: 1.7em;
}

# Tester la home, les éléments sont maintenant centrés

# Listing 5.8: Adding CSS for the site logo.
# app/assets/stylesheets/custom.css.scss
@import "bootstrap-sprockets";
@import "bootstrap";
.
.
.
/* header */

#logo {
  float: left;
  margin-right: 10px;
  font-size: 1.7em;
  color: #fff;
  text-transform: uppercase;
  letter-spacing: -1px;
  padding-top: 9px;
  font-weight: bold;
}

#logo:hover {
  color: #fff;
  text-decoration: none;
}

# Tester la home, le logo est stylisé

### 5.1.3 Partials

# Listing 5.9: The site layout with partials for the stylesheets and header.
# app/views/layouts/application.html.erb
<!DOCTYPE html>
<html>
  <head>
    <title><%= full_title(yield(:title)) %></title>
    <%= stylesheet_link_tag "application", media: "all",
                                           "data-turbolinks-track" => true %>
    <%= javascript_include_tag "application", "data-turbolinks-track" => true %>
    <%= csrf_meta_tags %>
    <%= render 'layouts/shim' %>
  </head>
  <body>
    <%= render 'layouts/header' %>
    <div class="container">
      <%= yield %>
      <%= render 'layouts/footer' %>
    </div>
  </body>
</html>

# Dans app/views/layout créer le fichier _shim.html.erb
# Listing 5.10: A partial for the HTML shim.
# app/views/layouts/_shim.html.erb
<!--[if lt IE 9]>
  <script src="//cdnjs.cloudflare.com/ajax/libs/html5shiv/r29/html5.min.js">
  </script>
<![endif]-->

# Créer aussi _header.html.erb
# Listing 5.11: A partial for the site header.
# app/views/layouts/_header.html.erb
<header class="navbar navbar-fixed-top navbar-inverse">
  <div class="container">
    <%= link_to "sample app", '#', id: "logo" %>
    <nav>
      <ul class="nav navbar-nav navbar-right">
        <li><%= link_to "Home",   '#' %></li>
        <li><%= link_to "Help",   '#' %></li>
        <li><%= link_to "Log in", '#' %></li>
      </ul>
    </nav>
  </div>
</header>

# Créer aussi _footer.html.erb
# Listing 5.12: A partial for the site footer.
# app/views/layouts/_footer.html.erb
<footer class="footer">
  <small>
    The <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
    by <a href="http://www.michaelhartl.com/">Michael Hartl</a>
  </small>
  <nav>
    <ul>
      <li><%= link_to "About",   '#' %></li>
      <li><%= link_to "Contact", '#' %></li>
      <li><a href="http://news.railstutorial.org/">News</a></li>
    </ul>
  </nav>
</footer>

# Listing 5.13: The site layout with a footer partial.
# app/views/layouts/application.html.erb
 <!DOCTYPE html>
<html>
  <head>
    <title><%= full_title(yield(:title)) %></title>
    <%= stylesheet_link_tag "application", media: "all",
                                           "data-turbolinks-track" => true %>
    <%= javascript_include_tag "application", "data-turbolinks-track" => true %>
    <%= csrf_meta_tags %>
    <%= render 'layouts/shim' %>
  </head>
  <body>
    <%= render 'layouts/header' %>
    <div class="container">
      <%= yield %>
      <%= render 'layouts/footer' %>
    </div>
  </body>
</html>

## Compléter le custom.css
# Listing 5.14: Adding the CSS for the site footer.
# app/assets/stylesheets/custom.css.scss
.
.
.
/* footer */

footer {
  margin-top: 45px;
  padding-top: 5px;
  border-top: 1px solid #eaeaea;
  color: #777;
}

footer a {
  color: #555;
}

footer a:hover {
  color: #222;
}

footer small {
  float: left;
}

footer ul {
  float: right;
  list-style: none;
}

footer ul li {
  float: left;
  margin-left: 15px;
}

# Tester la home

### 5.2 Sass and the asset pipeline

### 5.2.1 The asset pipeline

### 5.2.2 Syntactically awesome stylesheets

# Changer le contenu de custom.css.scss pour exploiter sass
# Listing 5.16: The initial SCSS file converted to use nesting and variables.
# app/assets/stylesheets/custom.css.scss
@import "bootstrap-sprockets";
@import "bootstrap";

/* mixins, variables, etc. */

$gray-medium-light: #eaeaea;

/* universal */

body {
  padding-top: 60px;
}

section {
  overflow: auto;
}

textarea {
  resize: vertical;
}

.center {
  text-align: center;
  h1 {
    margin-bottom: 10px;
  }
}

/* typography */

h1, h2, h3, h4, h5, h6 {
  line-height: 1;
}

h1 {
  font-size: 3em;
  letter-spacing: -2px;
  margin-bottom: 30px;
  text-align: center;
}

h2 {
  font-size: 1.2em;
  letter-spacing: -1px;
  margin-bottom: 30px;
  text-align: center;
  font-weight: normal;
  color: $gray-light;
}

p {
  font-size: 1.1em;
  line-height: 1.7em;
}


/* header */

#logo {
  float: left;
  margin-right: 10px;
  font-size: 1.7em;
  color: white;
  text-transform: uppercase;
  letter-spacing: -1px;
  padding-top: 9px;
  font-weight: bold;
  &:hover {
    color: white;
    text-decoration: none;
  }
}

/* footer */

footer {
  margin-top: 45px;
  padding-top: 5px;
  border-top: 1px solid $gray-medium-light;
  color: $gray-light;
  a {
    color: $gray;
    &:hover {
      color: $gray-darker;
    }
  }
  small {
    float: left;
  }
  ul {
    float: right;
    list-style: none;
    li {
      float: left;
      margin-left: 15px;
    }
  }
}

### 5.3 Layout links

### 5.3.1 Contact page

# Ajouter dans le test la page contact
# Listing 5.17: A test for the Contact page. red
# test/controllers/static_pages_controller_test.rb
require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Ruby on Rails Tutorial Sample App"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About | Ruby on Rails Tutorial Sample App"
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact | Ruby on Rails Tutorial Sample App"
  end
end

# Listing 5.18: red
$ bundle exec rake test

# Listing 5.19: Adding a route for the Contact page. red
# config/routes.rb
Rails.application.routes.draw do
  root 'static_pages#home'
  get  'static_pages/help'
  get  'static_pages/about'
  get  'static_pages/contact'
end

# Listing 5.20: Adding an action for the Contact page. red
# app/controllers/static_pages_controller.rb
class StaticPagesController < ApplicationController
  .
  .
  .
  def contact
  end
end

# Ajouter la vue contact.html.erb
# Listing 5.21: The view for the Contact page. green
# app/views/static_pages/contact.html.erb
<% provide(:title, 'Contact') %>
<h1>Contact</h1>
<p>
  Contact the Ruby on Rails Tutorial about the sample app at the
  <a href="http://www.railstutorial.org/#contact">contact page</a>.
</p>

# Listing 5.22: green
$ bundle exec rake test

### 5.3.2 Rails routes

# Changer les routes au format controller#action
# Listing 5.23: Routes for static pages.
# config/routes.rb
Rails.application.routes.draw do
  root             'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
end

### 5.3.3 Using named routes

# Changer les liens dans le partial _header
# Listing 5.24: Header partial with links.
# app/views/layouts/_header.html.erb
<header class="navbar navbar-fixed-top navbar-inverse">
  <div class="container">
    <%= link_to "sample app", root_path, id: "logo" %>
    <nav>
      <ul class="nav navbar-nav navbar-right">
        <li><%= link_to "Home",    root_path %></li>
        <li><%= link_to "Help",    help_path %></li>
        <li><%= link_to "Log in", '#' %></li>
      </ul>
    </nav>
  </div>
</header>

# Changer les liens dans le partial _footer
# Listing 5.25: Footer partial with links.
# app/views/layouts/_footer.html.erb
<footer class="footer">
  <small>
    The <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
    by <a href="http://www.michaelhartl.com/">Michael Hartl</a>
  </small>
  <nav>
    <ul>
      <li><%= link_to "About",   about_path %></li>
      <li><%= link_to "Contact", contact_path %></li>
      <li><a href="http://news.railstutorial.org/">News</a></li>
    </ul>
  </nav>
</footer>

### 5.3.4 Layout link tests

# Générer un test d'intégration
$ rails generate integration_test site_layout
      invoke  test_unit
      create    test/integration/site_layout_test.rb

# Modifier app/test/integration/site_layout_test.rb
# Listing 5.26: A test for the links on the layout. green
# test/integration/site_layout_test.rb
require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end
end

# Listing 5.27: green
$ bundle exec rake test:integration

# Relancer le test global pour surveiller les régression
# Listing 5.28: green
$ bundle exec rake test

### 5.4 User signup: A first step

### 5.4.1 Users controller

# Générer un controller Users avec une action new
# Listing 5.29: Generating a Users controller (with a new action).
$ rails generate controller Users new
      create  app/controllers/users_controller.rb
       route  get 'users/new'
      invoke  erb
      create    app/views/users
      create    app/views/users/new.html.erb
      invoke  test_unit
      create    test/controllers/users_controller_test.rb
      invoke  helper
      create    app/helpers/users_helper.rb
      invoke    test_unit
      create      test/helpers/users_helper_test.rb
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/users.js.coffee
      invoke    scss
      create      app/assets/stylesheets/users.css.scss

# Vérifier le test
# Listing 5.30: green
$ bundle exec rake test

### 5.4.2 Signup URL

# Modifier la route
# Listing 5.34: A route for the signup page.
# config/routes.rb
Rails.application.routes.draw do
  root             'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup'  => 'users#new'
end

# Modifier la vue home
# Listing 5.35: Linking the button to the signup page.
# app/views/static_pages/home.html.erb
<div class="center jumbotron">
  <h1>Welcome to the Sample App</h1>

  <h2>
    This is the home page for the
    <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
    sample application.
  </h2>

  <%= link_to "Sign up now!", signup_path, class: "btn btn-lg btn-primary" %>
</div>

<%= link_to image_tag("rails.png", alt: "Rails logo"),
            'http://rubyonrails.org/' %>

# Modifier la vue app/views/users/new.html.erb
# Listing 5.36: The initial (stub) signup page.
# app/views/users/new.html.erb
<% provide(:title, 'Sign up') %>
<h1>Sign up</h1>
<p>This will be a signup page for new users.</p>

### 5.5 Conclusion

# Valider les modifications
$ bundle exec rake test
$ git add -A
$ git commit -m "Finish layout and routes"
$ git checkout master
$ git merge filling-in-layout

# Pousser dns le dépôt
$ git push

# Déployer en production
$ git push heroku

# Vérifier le fonctionnement en production

#########################################################################################
#########################################################################################
### Chapter 6 Modeling users
#########################################################################################
#########################################################################################

### 6.1 User Modeling

# Pour commencer, créer une branche
$ git checkout master
$ git checkout -b modeling-users

### 6.1.1 Database migrations

# Générer le model User
# Listing 6.1: Generating a User model.
$ rails generate model User name:string email:string
      invoke  active_record
      create    db/migrate/20140724010738_create_users.rb
      create    app/models/user.rb
      invoke    test_unit
      create      test/models/user_test.rb
      create      test/fixtures/users.yml

# Migrer la BD
$ bundle exec rake db:migrate

### 6.1.2 The model file

### 6.1.3 Creating user objects

### 6.1.4 Finding user objects

### 6.1.5 Updating user objects

### 6.2 User validations

### 6.2.1 A validity test

# Enrichir le test test/models/user_test.rb
# Listing 6.5: A test for an initially valid user. green
# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end
end

# Listing 6.6: green
$ bundle exec rake test:models

# Le test ne passe pas car le système cherche la BD en mode test et elle n'est pas générée
# L'erreur propose de faire
$ rake db:migrate RAILS_ENV=test

# Le test passe

### 6.2.2 Validating presence

# Modifier le fichier pour tester la validation
# Listing 6.7: A test for validation of the name attribute. red
# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end
end

# relancer le test
# RED car il n'y a pas de règle de validation de données
# Listing 6.8: red
$ bundle exec rake test:models

# Modifier le model User
# Listing 6.9: Validating the presence of a name attribute. green
## app/models/user.rb
class User < ActiveRecord::Base
  validates :name, presence: true
end

# relancer le test GREEN
# Listing 6.10: green
$ bundle exec rake test:models

# Enrichir le test
# Listing 6.11: A test for validation of the email attribute. red
# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
end

# Dans le model USer ajouter la présence de l'email
# Listing 6.12: Validating the presence of an email attribute. green
# app/models/user.rb
class User < ActiveRecord::Base
  validates :name,  presence: true
  validates :email, presence: true
end

# Listing 6.13: green
$ bundle exec rake test

#### 6.2.3 Length validation

# Dans le test ajouter cela :
# Listing 6.14: A test for name length validation. red
# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end
  .
  .
  .
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
end

# Listing 6.15: red
$ bundle exec rake test

# Modifier le model
# Listing 6.16: Adding a length validation for the name attribute. green
# app/models/user.rb
class User < ActiveRecord::Base
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }
end

# Listing 6.17: green
$ bundle exec rake test

### 6.2.4 Format validation

# Ajouter cela au test :
# Listing 6.18: Tests for valid email formats. green
# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end
  .
  .
  .
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
end

# Puis ceci :
# Listing 6.19: Tests for email format validation. red
# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end
  .
  .
  .
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
end

# Le test doit être RED
# Listing 6.20: red
$ bundle exec rake test

# Modifier le model pour ajouter la validation du mail
# Listing 6.21: Validating the email format with a regular expression. green
# app/models/user.rb
class User < ActiveRecord::Base
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
end

# Listing 6.22: green
$ bundle exec rake test:models

### 6.2.5 Uniqueness validation

# Ajouter dans le test :
# Listing 6.23: A test for the rejection of duplicate email addresses. red
# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end
  .
  .
  .
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end
end

# Puis modifier le model
# Listing 6.24: Validating the uniqueness of email addresses. green
# app/models/user.rb
class User < ActiveRecord::Base
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
end

# Listing 6.25: Testing case-insensitive email uniqueness. red
# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end
  .
  .
  .
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
end

# Listing 6.26: Validating the uniqueness of email addresses, ignoring case. green
# app/models/user.rb
class User < ActiveRecord::Base
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
end

# Listing 6.27: green
$ bundle exec rake test

# Ajouter un index sur le mail
$ rails generate migration add_index_to_users_email

# Renseigner dans db/migrate/[timestamp]_add_index_to_users_email.rb
# Listing 6.28: The migration for enforcing email uniqueness.
# db/migrate/[timestamp]_add_index_to_users_email.rb
class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    add_index :users, :email, unique: true
  end
end

# Lancer la migration
$ bundle exec rake db:migrate

# Le test doit être RED

# Il faut vider le fichier test/fixtures/users.yml
# Listing 6.30: An empty fixtures file. green
# test/fixtures/users.yml
 # empty

# Il faut aussi regénérer la BD en test
$ rake db:migrate RAILS_ENV=test

# Cette commande ne passait pas, il y avait une erreur que je ne comprenais pas
# En fait j'ai trouvé l'erreur, il y avait des données dans la BD avec des mails identiques
# et donc le système ne peut pas créer d'index unique

# Modifier le model
# Listing 6.31: Ensuring email uniqueness by downcasing the email attribute. green
# app/models/user.rb
class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
end

### 6.3 Adding a secure password

### 6.3.1 A hashed password

# Générer une migration pour ajouter une colonne
$ rails generate migration add_password_digest_to_users password_digest:string

# Ajouter ceci dans db/migrate/[timestamp]_add_password_digest_to_users.rb
# Listing 6.32: The migration to add a password_digest column to the users table.
# db/migrate/[timestamp]_add_password_digest_to_users.rb
class AddPasswordDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
  end
end

# Lancer la migration
$ bundle exec rake db:migrate

# Ajouter bcrypt dans le Gemfile
# Listing 6.33: Adding bcrypt to the Gemfile.
source 'https://rubygems.org'

gem 'rails',                '4.2.2'
gem 'bcrypt',               '3.1.7'
.
.
.

# Il y a de gros problèmes sur Windows avec les versions antérieures
# J'ai donc mis cette version car cela ne foctionnait pas en local
gem 'bcrypt', '~> 3.1.11', require: false

# Lancer le bundle install
$ bundle install

### 6.3.2 User has secure password

# Modifier le model pour ajouter le password crypté
# Listing 6.34: Adding has_secure_password to the User model. red
# app/models/user.rb
class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
end

# Listing 6.35: red
$ bundle exec rake test

# Modifier le test pour ajouter un password
# Modifier la méthode def method_name
# Listing 6.36: Adding a password and its confirmation. green
# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  .
  .
  .
end

# Listing 6.37: green
$ bundle exec rake test

### 6.3.3 Minimum password standards

# Le password ne peut être vide et moins de 6 car
# Modifier le test
# Listing 6.38: Testing for a minimum password length. red
# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  .
  .
  .
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end

# Modifier le model user pour ajouter la règle
# Listing 6.39: The complete implementation for secure passwords. green
# app/models/user.rb
class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end

# Listing 6.40: green
$ bundle exec rake test:models

### 6.3.4 Creating and authenticating a user

# Lancer la console
$ rails console

## Créer un user
>> User.create(name: "Michael Hartl", email: "mhartl@example.com",
?>             password: "foobar", password_confirmation: "foobar")

# Regarder les données dans DB Browser for SQLite

### 6.4 Conclusion

# Valider les modifications
$ bundle exec rake test
$ git add -A
$ git commit -m "Make a basic User model (including secure passwords)"

# Pousser sur le dépôt
$ git checkout master
$ git merge modeling-users
$ git push

# Déployer en prod
$ git push heroku
$ heroku run rake db:migrate

# Lancer la console sur la prod
$ heroku run console --sandbox

# Créer un user
$ User.create(name: "Michael Hartl", email: "michael@example.com", password: "foobar", password_confirmation: "foobar")
# Ce user sera rollbacked lors de l'exit sur la console

#########################################################################################
#########################################################################################
### Chapter 7 Sign up
#########################################################################################
#########################################################################################

### 7.1 Showing users

# Créer une branche
$ git checkout master
$ git checkout -b sign-up

### 7.1.1 Debug and Rails environments

# Modifier le layout 
# Listing 7.1: Adding some debug information to the site layout.
# app/views/layouts/application.html.erb
<!DOCTYPE html>
<html>
  .
  .
  .
  <body>
    <%= render 'layouts/header' %>
    <div class="container">
      <%= yield %>
      <%= render 'layouts/footer' %>
      <%= debug(params) if Rails.env.development? %>
    </div>
  </body>
</html>

# Modifier le custom.css.scss
# Listing 7.2: Adding code for a pretty debug box, including a Sass mixin.
# app/assets/stylesheets/custom.css.scss
@import "bootstrap-sprockets";
@import "bootstrap";

/* mixins, variables, etc. */

$gray-medium-light: #eaeaea;

@mixin box_sizing {
  -moz-box-sizing:    border-box;
  -webkit-box-sizing: border-box;
  box-sizing:         border-box;
}
.
.
.
/* miscellaneous */

.debug_dump {
  clear: both;
  float: left;
  width: 100%;
  margin-top: 45px;
  @include box_sizing;
}

# Tester en local

### 7.1.2 A Users resource

# Ajouter dans le fichier des routes
# Listing 7.3: Adding a Users resource to the routes file.
# config/routes.rb
Rails.application.routes.draw do
  root             'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup'  => 'users#new'
  resources :users
end

# Créer un fichier app/views/users/show.html.erb
# Minimaliste en attendant mieux
# Listing 7.4: A stub view for showing user information.
# app/views/users/show.html.erb
<%= @user.name %>, <%= @user.email %>

# Créer une action show dans le controller user
# Listing 7.5: The Users controller with a show action.
# app/controllers/users_controller.rb
class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
  end
end

### 7.1.3 Debugger

# Utiliser la gem byebug
# ajouter dans l'action
# Listing 7.6: The Users controller with a debugger.
# app/controllers/users_controller.rb
class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    debugger
  end

  def new
  end
end

# Lors de l'accès à la page, un prompt est présent dans la console
# On peut tracer des variables
# Exemple :
(byebug) @user.name
"Example User"
(byebug) @user.email
"example@railstutorial.org"
(byebug) params[:id]
"1"

# Quitter byebug en tapant "q"

# Puis mettre en commentaire la ligne "debugger"

### 7.1.4 A Gravatar image and a sidebar

# modifier la vue show
# Listing 7.8: The user show view with name and Gravatar.
# app/views/users/show.html.erb
<% provide(:title, @user.name) %>
<h1>
  <%= gravatar_for @user %>
  <%= @user.name %>
</h1>

# Créer un helper app/helpers/users_helper.rb
# Listing 7.9: Defining a gravatar_for helper method.
# app/helpers/users_helper.rb
module UsersHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end

# Ajouter la sidebar dans la vue show user
# Listing 7.10: Adding a sidebar to the user show view.
# app/views/users/show.html.erb
<% provide(:title, @user.name) %>
<div class="row">
  <aside class="col-md-4">
    <section class="user_info">
      <h1>
        <%= gravatar_for @user %>
        <%= @user.name %>
      </h1>
    </section>
  </aside>
</div>

# Ajouter le style de la sidebar dans custom.css
# Listing 7.11: SCSS for styling the user show page, including the sidebar.
app/assets/stylesheets/custom.css.scss
 .
.
.
/* sidebar */

aside {
  section.user_info {
    margin-top: 20px;
  }
  section {
    padding: 10px 0;
    margin-top: 20px;
    &:first-child {
      border: 0;
      padding-top: 0;
    }
    span {
      display: block;
      margin-bottom: 3px;
      line-height: 1;
    }
    h1 {
      font-size: 1.4em;
      text-align: left;
      letter-spacing: -1px;
      margin-bottom: 3px;
      margin-top: 0px;
    }
  }
}

.gravatar {
  float: left;
  margin-right: 10px;
}

.gravatar_edit {
  margin-top: 15px;
}

### 7.2 Signup form

# Si vous avez créé un user dans la BD, faire le reset
$ bundle exec rake db:migrate:reset

### 7.2.1 Using form_for

# Modifier l'action new
# Listing 7.12: Adding an @user variable to the new action.
# app/controllers/users_controller.rb
class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
end

# Remplacer le code de la vue new
# Listing 7.13: A form to sign up new users.
# app/views/users/new.html.erb
<% provide(:title, 'Sign up') %>
<h1>Sign up</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(@user) do |f| %>
      <%= f.label :name %>
      <%= f.text_field :name %>

      <%= f.label :email %>
      <%= f.email_field :email %>

      <%= f.label :password %>
      <%= f.password_field :password %>

      <%= f.label :password_confirmation, "Confirmation" %>
      <%= f.password_field :password_confirmation %>

      <%= f.submit "Create my account", class: "btn btn-primary" %>
    <% end %>
  </div>
</div>

# Ajouter le style du formulaire dans custom.css
# Listing 7.14: CSS for the signup form.
# app/assets/stylesheets/custom.css.scss
.
.
.
/* forms */

input, textarea, select, .uneditable-input {
  border: 1px solid #bbb;
  width: 100%;
  margin-bottom: 15px;
  @include box_sizing;
}

input {
  height: auto !important;
}

### 7.2.2 Signup form HTML

### 7.3 Unsuccessful signups

### 7.3.1 A working form

# Ajouter une action create
# Listing 7.16: A create action that can handle signup failure.
# app/controllers/users_controller.rb
class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])    # Not the final implementation!
    if @user.save
      # Handle a successful save.
    else
      render 'new'
    end
  end
end

### 7.3.2 Strong parameters

# Modifier l'action create et ajouter le controle des parametres
# Listing 7.17: Using strong parameters in the create action.
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  .
  .
  .
  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end

### 7.3.3 Signup error messages

# Modifier la vue new
# Listing 7.18: Code to display error messages on the signup form.
# app/views/users/new.html.erb
<% provide(:title, 'Sign up') %>
<h1>Sign up</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(@user) do |f| %>
      <%= render 'shared/error_messages' %>

      <%= f.label :name %>
      <%= f.text_field :name, class: 'form-control' %>

      <%= f.label :email %>
      <%= f.email_field :email, class: 'form-control' %>

      <%= f.label :password %>
      <%= f.password_field :password, class: 'form-control' %>

      <%= f.label :password_confirmation, "Confirmation" %>
      <%= f.password_field :password_confirmation, class: 'form-control' %>

      <%= f.submit "Create my account", class: "btn btn-primary" %>
    <% end %>
  </div>
</div>

# Créer un dossier pour ranger les partials
$ mkdir app/views/shared

# Créer un partials app/views/shared/_error_messages.html.erb
# Listing 7.19: A partial for displaying form submission error messages.
# app/views/shared/_error_messages.html.erb
<% if @user.errors.any? %>
  <div id="error_explanation">
    <div class="alert alert-danger">
      The form contains <%= pluralize(@user.errors.count, "error") %>.
    </div>
    <ul>
    <% @user.errors.full_messages.each do |msg| %>
      <li><%= msg %></li>
    <% end %>
    </ul>
  </div>
<% end %>

# Ajouter au style du formulaire
# Listing 7.20: CSS for styling error messages.
# app/assets/stylesheets/custom.css.scss
 .
.
.
/* forms */
.
.
.
#error_explanation {
  color: red;
  ul {
    color: red;
    margin: 0 0 30px 0;
  }
}

.field_with_errors {
  @extend .has-error;
  .form-control {
    color: $state-danger-text;
  }
}

### 7.3.4 A test for invalid submission

# Générer un test d'intégration pour le sign up
$ rails generate integration_test users_signup
      invoke  test_unit
      create    test/integration/users_signup_test.rb

# Editer le fichier de test test/integration/users_signup_test.rb
# Listing 7.21: A test for an invalid signup. green
# test/integration/users_signup_test.rb
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
  end
end

# Listing 7.22: green
$ bundle exec rake test

### 7.4 Successful signups

### 7.4.1 The finished signup form

# Remplacer l'action create de user
# Listing 7.23: The user create action with a save and a redirect.
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  .
  .
  .
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end

### 7.4.2 The flash

# Ajouter le message flash dans l'action create
# Listing 7.24: Adding a flash message to user signup.
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  .
  .
  .
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end

# Modifier le layout pour faire apparaitre le message flash
# Listing 7.25: Adding the contents of the flash variable to the site layout.
# app/views/layouts/application.html.erb
<!DOCTYPE html>
<html>
  .
  .
  .
  <body>
    <%= render 'layouts/header' %>
    <div class="container">
      <% flash.each do |message_type, message| %>
        <div class="alert alert-<%= message_type %>"><%= message %></div>
      <% end %>
      <%= yield %>
      <%= render 'layouts/footer' %>
      <%= debug(params) if Rails.env.development? %>
    </div>
    .
    .
    .
  </body>
</html>

### 7.4.3 The first signup

### 7.4.4 A test for valid submission

# Ajouter dans test/integration/users_signup_test.rb
# Listing 7.26: A test for a valid signup. green
# test/integration/users_signup_test.rb
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  .
  .
  .
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name:  "Example User",
                                            email: "user@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    assert_template 'users/show'
  end
end

### 7.5 Professional-grade deployment

# Valider les modifications
$ git add -A
$ git commit -m "Finish user signup"
$ git checkout master
$ git merge sign-up

### 7.5.1 SSL in production

# Configurer SSL en production
# Listing 7.27: Configuring the application to use SSL in production.
# config/environments/production.rb
Rails.application.configure do
  .
  .
  .
  # Force all access to the app over SSL, use Strict-Transport-Security,
  # and use secure cookies.
  config.force_ssl = true
  .
  .
  .
end

### 7.5.2 Production webserver

# Ajouter dans le Gemfile
# Listing 7.28: Adding Puma to the Gemfile.
source 'https://rubygems.org'
.
.
.
group :production do
  gem 'pg',             '0.17.1'
  gem 'rails_12factor', '0.0.2'
  gem 'puma',           '2.11.1'
end

# Faire le Bundle install
$ bundle install

# Définir la configuration de puma
# Listing 7.29: The configuration file for the production webserver.
# config/puma.rb
workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/
  # deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end

# Définir le fichier .Profile pour Heroku, à la racine
# Listing 7.30: Defining a Procfile for Puma.
# ./Procfile
web: bundle exec puma -C config/puma.rb

# Finaliser l'étape de mise en production
$ bundle exec rake test
$ git add -A
$ git commit -m "Use SSL and the Puma webserver in production"
$ git push
$ git push heroku
$ heroku run rake db:migrate

#########################################################################################
#########################################################################################
### Chapter 8 Log in, log out
#########################################################################################
#########################################################################################

### 8.1 Sessions

# Pour commencer, créer une branche
$ git checkout master
$ git checkout -b log-in-log-out

### 8.1.1 Sessions controller

# Générer un controller Sessions
$ rails generate controller Sessions new

# Modifier les routes
# Listing 8.1: Adding a resource to get the standard RESTful actions for sessions.
# config/routes.rb
Rails.application.routes.draw do
  root                'static_pages#home'
  get    'help'    => 'static_pages#help'
  get    'about'   => 'static_pages#about'
  get    'contact' => 'static_pages#contact'
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users
end

# Vérifier les routes
$ bundle exec rake routes

# Constater les routes suivantes
 Prefix Verb   URI Pattern               Controller#Action
     root GET    /                         static_pages#home
     help GET    /help(.:format)           static_pages#help
    about GET    /about(.:format)          static_pages#about
  contact GET    /contact(.:format)        static_pages#contact
   signup GET    /signup(.:format)         users#new
    login GET    /login(.:format)          sessions#new
          POST   /login(.:format)          sessions#create
   logout DELETE /logout(.:format)         sessions#destroy
    users GET    /users(.:format)          users#index
          POST   /users(.:format)          users#create
 new_user GET    /users/new(.:format)      users#new
edit_user GET    /users/:id/edit(.:format) users#edit
     user GET    /users/:id(.:format)      users#show
          PATCH  /users/:id(.:format)      users#update
          PUT    /users/:id(.:format)      users#update
          DELETE /users/:id(.:format)      users#destroy

### 8.1.2 Login form

# Créer la vue app/views/sessions/new.html.erb
# Listing 8.2: Code for the login form.
# app/views/sessions/new.html.erb
<% provide(:title, "Log in") %>
<h1>Log in</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(:session, url: login_path) do |f| %>

      <%= f.label :email %>
      <%= f.email_field :email, class: 'form-control' %>

      <%= f.label :password %>
      <%= f.password_field :password, class: 'form-control' %>

      <%= f.submit "Log in", class: "btn btn-primary" %>
    <% end %>

    <p>New user? <%= link_to "Sign up now!", signup_path %></p>
  </div>
</div>

# On doit pouvoir tester en local mais
# S'il n'est pas possible de tester en local, tester sur Heroku sans attendre la fin du chapitre
$ git add -A
$ git commit -m "8.1.2 Login form"
$ git checkout master
$ git merge log-in-log-out
$ git push heroku
$ git checkout log-in-log-out

### 8.1.3 Finding and authenticating a user

# Modifier le controller sessions
# Listing 8.4: A preliminary version of the Sessions create action.
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController

  def new
  end

  def create
    render 'new'
  end

  def destroy
  end
end

# Modifier l'action create
# Listing 8.5: Finding and authenticating a user.
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
    else
      # Create an error message.
      render 'new'
    end
  end

  def destroy
  end
end

### 8.1.4 Rendering with a flash message

# Modifier l'action create
# Listing 8.6: An (unsuccessful) attempt at handling failed login.
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
  end
end

### 8.1.5 A flash test

# Générer un test d'intégration
$ rails generate integration_test users_login
      invoke  test_unit
      create    test/integration/users_login_test.rb

# Ecrire le test test/integration/users_login_test.rb
# Listing 8.7: A test to catch unwanted flash persistence. red
# test/integration/users_login_test.rb
require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end

# Lancer le test (1 seul test)
# Listing 8.8: red
$ bundle exec rake test TEST=test/integration/users_login_test.rb

# Modifier l'action create
# Listing 8.9: Correct code for failed login. green
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  end
end

# Listing 8.10: green
$ bundle exec rake test TEST=test/integration/users_login_test.rb
$ bundle exec rake test

### 8.2 Logging in

# Modifier app/controllers/application_controller.rb
# Pour inclure le helper session
# Listing 8.11: Including the Sessions helper module into the Application controller.
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
end

### 8.2.1 The log_in method

# dans app/helpers/sessions_helper.rb ajouter
# Listing 8.12: The log_in function.
# app/helpers/sessions_helper.rb
module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end
end

# Modifier l'action create
# Listing 8.13: Logging in a user.
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  end
end

### 8.2.2 Current user

# Modifier le helper sessions
# Listing 8.14: Finding the current user in the session.
# app/helpers/sessions_helper.rb
module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end

### 8.2.3 Changing the layout links

# 8.15 Modifier le session helper
# Listing 8.15: The logged_in? helper method.
# app/helpers/sessions_helper.rb
module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
end

# Listing 8.16 Modifier app/views/layouts/_header.html.erb
# app/views/layouts/_header.html.erb
<header class="navbar navbar-fixed-top navbar-inverse">
  <div class="container">
    <%= link_to "sample app", root_path, id: "logo" %>
    <nav>
      <ul class="nav navbar-nav navbar-right">
        <li><%= link_to "Home", root_path %></li>
        <li><%= link_to "Help", help_path %></li>
        <% if logged_in? %>
          <li><%= link_to "Users", '#' %></li>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              Account <b class="caret"></b>
            </a>
            <ul class="dropdown-menu">
              <li><%= link_to "Profile", current_user %></li>
              <li><%= link_to "Settings", '#' %></li>
              <li class="divider"></li>
              <li>
                <%= link_to "Log out", logout_path, method: "delete" %>
              </li>
            </ul>
          </li>
        <% else %>
          <li><%= link_to "Log in", login_path %></li>
        <% end %>
      </ul>
    </nav>
  </div>
</header>

# Listing 8.17 Ajouter dans app/assets/javascripts/application.js bootstrap
# app/assets/javascripts/application.js
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

# S'il n'est pas possible de tester en local, tester sur Heroku
$ git add -A
$ git commit -m "8.2.3 Changing the layout links"
$ git checkout master
$ git merge log-in-log-out
$ git push heroku
$ git checkout log-in-log-out

### 8.2.4 Testing layout changes

# Listing 8.18: Adding a digest method for use in fixtures.
# app/models/user.rb
class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end

# Listing 8.19: A fixture for testing user login.
# test/fixtures/users.yml
michael:
  name: Michael Example
  email: michael@example.com
  password_digest: <%= User.digest('password') %>

# Listing 8.20: A test for user logging in with valid information. green
# test/integration/users_login_test.rb
require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
  .
  .
  .
  test "login with valid information" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end

# Listing 8.21: green
$ bundle exec rake test TEST=test/integration/users_login_test.rb \
>                       TESTOPTS="--name test_login_with_valid_information"

# Listing 8.22: Logging in the user upon signup.
# Modifier action create dans app/controllers/users_controller.rb
class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end

# Listing 8.23: A boolean method for login status inside tests.
# test/test_helper.rb
ENV['RAILS_ENV'] ||= 'test'
.
.
.
class ActiveSupport::TestCase
  fixtures :all

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end
end

# Listing 8.24: A test of login after signup. green
# Ajouter ceci à test/integration/users_signup_test.rb
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name:  "Example User",
                                            email: "user@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    assert_template 'users/show'
    assert is_logged_in?
  end

# Listing 8.25: green
$ bundle exec rake test

### 8.3 Logging out

# Listing 8.26: The log_out method.
# Ajouter logout dans app/helpers/sessions_helper.rb
  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

# Listing 8.27: Destroying a session (user logout).
# Ajouter destroy dans app/controllers/sessions_controller.rb  
  def destroy
    log_out
    redirect_to root_url
  end

# Listing 8.28: A test for user logout. green
# Ajouter le test dans test/integration/users_login_test.rb
  test "login with valid information followed by logout" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

# Listing 8.29: green
$ bundle exec rake test

### 8.4 Remember me

### 8.4.1 Remember token and digest

# Générer une migration pour ajouter une colonne
$ rails generate migration add_remember_digest_to_users remember_digest:string

# Migrer la BD
$ bundle exec rake db:migrate

# Listing 8.31: Adding a method for generating tokens.
# app/models/user.rb
  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

# Listing 8.32: Adding a remember method to the User model. green
# app/models/user.rb  
class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
end

### 8.4.2 Login with remembering

# Listing 8.33: Adding an authenticated? method to the User model.
# app/models/user.rb  
  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

# Listing 8.34: Logging in and remembering a user.
# app/controllers/sessions_controller.rb  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

# Listing 8.35: Remembering the user.
# app/helpers/sessions_helper.rb  
module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end

# Listing 8.36: Updating current_user for persistent sessions. red
# app/helpers/sessions_helper.rb
module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end

# Listing 8.37: red
$ bundle exec rake test

### 8.4.3 Forgetting users

# Listing 8.38: Adding a forget method to the User model.
# app/models/user.rb
class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
end

# Listing 8.39: Logging out from a persistent session.
# app/helpers/sessions_helper.rb
  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

### 8.4.4 Two subtle bugs

# Listing 8.40: A test for user logout. red
# test/integration/users_login_test.rb  
  test "login with valid information followed by logout" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

# Listing 8.41: red
$ bundle exec rake test

# Listing 8.42: Only logging out if logged in. green
# app/controllers/sessions_controller.rb
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

# Listing 8.43: A test of authenticated? with a nonexistent digest. red
# test/models/user_test.rb  
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  .
  .
  .
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
end

# Listing 8.44: red
$ bundle exec rake test

# Listing 8.45: Updating authenticated? to handle a nonexistent digest. green
# app/models/user.rb
 class User < ActiveRecord::Base
  .
  .
  .
  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end

# Listing 8.46: green
$ bundle exec rake test

### 8.4.5 “Remember me” checkbox

# Listing 8.47: Adding a “remember me” checkbox to the login form.
# app/views/sessions/new.html.erb
<% provide(:title, "Log in") %>
<h1>Log in</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(:session, url: login_path) do |f| %>

      <%= f.label :email %>
      <%= f.email_field :email, class: 'form-control' %>

      <%= f.label :password %>
      <%= f.password_field :password, class: 'form-control' %>

      <%= f.label :remember_me, class: "checkbox inline" do %>
        <%= f.check_box :remember_me %>
        <span>Remember me on this computer</span>
      <% end %>

      <%= f.submit "Log in", class: "btn btn-primary" %>
    <% end %>

    <p>New user? <%= link_to "Sign up now!", signup_path %></p>
  </div>
</div>

# Listing 8.48: CSS for the “remember me” checkbox.
# app/assets/stylesheets/custom.css.scss
 .
.
.
/* forms */
.
.
.
.checkbox {
  margin-top: -10px;
  margin-bottom: 10px;
  span {
    margin-left: 20px;
    font-weight: normal;
  }
}

#session_remember_me {
  width: auto;
  margin-left: 0;
}

# Listing 8.49: Handling the submission of the “remember me” checkbox.
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end

### 8.4.6 Remember tests

# Listing 8.50: Adding a log_in_as helper.
# test/test_helper.rb
 ENV['RAILS_ENV'] ||= 'test'
.
.
.
class ActiveSupport::TestCase
  fixtures :all

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Logs in a test user.
  def log_in_as(user, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: { email:       user.email,
                                  password:    password,
                                  remember_me: remember_me }
    else
      session[:user_id] = user.id
    end
  end

  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end
end

# Listing 8.51: A test of the “remember me” checkbox. green
# test/integration/users_login_test.rb
require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
  .
  .
  .
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end

# Listing 8.52: green
$ bundle exec rake test

# Listing 8.53: Raising an exception in an untested branch. green
# app/helpers/sessions_helper.rb
module SessionsHelper
  .
  .
  .
  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      raise       # The tests still pass, so this branch is currently untested.
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  .
  .
  .
end

# Listing 8.54: green
$ bundle exec rake test

# Créer un ficher
# Listing 8.55: A test for persistent sessions.
# test/helpers/sessions_helper_test.rb
require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end

# Listing 8.56: red
$ bundle exec rake test TEST=test/helpers/sessions_helper_test.rb

# Listing 8.57: Removing the raised exception. green
# app/helpers/sessions_helper.rb
module SessionsHelper
  .
  .
  .
  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  .
  .
  .
end

# Listing 8.58: green
$ bundle exec rake test

### 8.5 Conclusion

# Valider les modifications
$ bundle exec rake test
$ git add -A
$ git commit -m "Finish log in/log out"
$ git checkout master
$ git merge log-in-log-out

# Mettre en production
$ bundle exec rake test
$ git push
$ git push heroku
$ heroku run rake db:migrate

# Si votre site est en production, il faudrait mieux le mettre
# en mode maintenance pendant la mise à jour
$ heroku maintenance:on
$ git push heroku
$ heroku run rake db:migrate
$ heroku maintenance:off

#########################################################################################
#########################################################################################
### Chapter 9 Updating, showing, and deleting users
#########################################################################################
#########################################################################################

### 9.1 Updating users

# Créer une branche
$ git checkout master
$ git checkout -b updating-users

### 9.1.1 Edit form

# Listing 9.1: The user edit action.
# app/controllers/users_controller.rb
class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end

# Listing 9.2: The user edit view.
# app/views/users/edit.html.erb
<% provide(:title, "Edit user") %>
<h1>Update your profile</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(@user) do |f| %>
      <%= render 'shared/error_messages' %>

      <%= f.label :name %>
      <%= f.text_field :name, class: 'form-control' %>

      <%= f.label :email %>
      <%= f.email_field :email, class: 'form-control' %>

      <%= f.label :password %>
      <%= f.password_field :password, class: 'form-control' %>

      <%= f.label :password_confirmation, "Confirmation" %>
      <%= f.password_field :password_confirmation, class: 'form-control' %>

      <%= f.submit "Save changes", class: "btn btn-primary" %>
    <% end %>

    <div class="gravatar_edit">
      <%= gravatar_for @user %>
      <a href="http://gravatar.com/emails" target="_blank">change</a>
    </div>
  </div>
</div>

# Tester l'adresse http://localhost:3000/users/1/edit

# Modifier le header pour avoir le lien Settings
# Listing 9.4: Adding a URL to the “Settings” link in the site layout.
# app/views/layouts/_header.html.erb
<header class="navbar navbar-fixed-top navbar-inverse">
  <div class="container">
    <%= link_to "sample app", root_path, id: "logo" %>
    <nav>
      <ul class="nav navbar-nav navbar-right">
        <li><%= link_to "Home", root_path %></li>
        <li><%= link_to "Help", help_path %></li>
        <% if logged_in? %>
          <li><%= link_to "Users", '#' %></li>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              Account <b class="caret"></b>
            </a>
            <ul class="dropdown-menu">
              <li><%= link_to "Profile", current_user %></li>
              <li><%= link_to "Settings", edit_user_path(current_user) %></li>
              <li class="divider"></li>
              <li>
                <%= link_to "Log out", logout_path, method: "delete" %>
              </li>
            </ul>
          </li>
        <% else %>
          <li><%= link_to "Log in", login_path %></li>
        <% end %>
      </ul>
    </nav>
  </div>
</header>

# 9.1.2 Unsuccessful edits

# Listing 9.5: The initial user update action.
# app/controllers/users_controller.rb
class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end

# 9.1.3 Testing unsuccessful edits

# Générer un test d'intégration
$ rails generate integration_test users_edit
      invoke  test_unit
      create    test/integration/users_edit_test.rb

# Listing 9.6: A test for an unsuccessful edit. green
# test/integration/users_edit_test.rb
require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name:  "",
                                    email: "foo@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    assert_template 'users/edit'
  end
end

# Listing 9.7: green
$ bundle exec rake test

### 9.1.4 Successful edits (with TDD)

# Listing 9.8: A test of a successful edit. red
# test/integration/users_edit_test.rb
require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
  .
  .
  .
  test "successful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name:  name,
                                    email: email,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end

# Listing 9.9: The user update action. red
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  .
  .
  .
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  .
  .
  .
end

# Listing 9.10: Allowing empty passwords on update. green
# app/models/user.rb
class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  .
  .
  .
end
# ATTENTION, il y a une erreur sur le site, il manque une virgule à la fin de 
# validates :email, presence: true, length: { maximum: 255 }

# Listing 9.11: green
$ bundle exec rake test

### 9.2 Authorization

### 9.2.1 Requiring logged-in users

# Listing 9.12: Adding a logged_in_user before filter. red
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  .
  .
  .
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end

# Listing 9.13: red
$ bundle exec rake test

# Listing 9.14: Logging in a test user. green
# test/integration/users_edit_test.rb
require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    .
    .
    .
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    .
    .
    .
  end
end

# Listing 9.15: green
$ bundle exec rake test

# Listing 9.16: Commenting out the before filter to test our security model. green
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  # before_action :logged_in_user, only: [:edit, :update]
  .
  .
  .
end

# Listing 9.17: Testing that edit and update are protected. red
# test/controllers/users_controller_test.rb
require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end

# Le test doit maintenant être RED
# Enlever le commentaire pour revenir à un test GREEN
# Listing 9.18: Uncommenting the before filter. green
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  .
  .
  .
end

# Listing 9.19: green
$ bundle exec rake test

### 9.2.2 Requiring the right user

# Listing 9.20: Adding a second user to the fixture file.
# test/fixtures/users.yml
michael:
  name: Michael Example
  email: michael@example.com
  password_digest: <%= User.digest('password') %>

archer:
  name: Sterling Archer
  email: duchess@example.gov
  password_digest: <%= User.digest('password') %>

# Listing 9.21: Tests for trying to edit as the wrong user. red
# test/controllers/users_controller_test.rb
require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end
end

# Listing 9.22: A correct_user before filter to protect the edit/update pages. green
# app/controllers/users_controller.rb
 class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  .
  .
  .
  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  .
  .
  .
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end
end

# Listing 9.23: green
$ bundle exec rake test

# Listing 9.24: The current_user? method.
# app/helpers/sessions_helper.rb
module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end
  .
  .
  .
end

# Listing 9.25: The final correct_user before filter. green
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  .
  .
  .
  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  .
  .
  .
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end

### 9.2.3 Friendly forwarding

# Listing 9.26: A test for friendly forwarding. red
# test/integration/users_edit_test.rb
require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
  .
  .
  .
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name:  name,
                                    email: email,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end

# Listing 9.27: Code to implement friendly forwarding.
# app/helpers/sessions_helper.rb
module SessionsHelper
  .
  .
  .
  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end

# Listing 9.28: Adding store_location to the logged-in user before filter.
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  .
  .
  .
  def edit
  end
  .
  .
  .
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end

# Listing 9.29: The Sessions create action with friendly forwarding.
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  .
  .
  .
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  .
  .
  .
end

# Listing 9.30: green
$ bundle exec rake test

### 9.3 Showing all users

### 9.3.1 Users index

# Listing 9.31: Testing the index action redirect. red
# test/controllers/users_controller_test.rb
require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end
  .
  .
  .
end

# Listing 9.32: Requiring a logged-in user for the index action. green
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def index
  end

  def show
    @user = User.find(params[:id])
  end
  .
  .
  .
end

# Listing 9.33: The user index action.
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  .
  .
  .
  def index
    @users = User.all
  end
  .
  .
  .
end

# Listing 9.34: The users index view.
# app/views/users/index.html.erb
<% provide(:title, 'All users') %>
<h1>All users</h1>

<ul class="users">
  <% @users.each do |user| %>
    <li>
      <%= gravatar_for user, size: 50 %>
      <%= link_to user.name, user %>
    </li>
  <% end %>
</ul>

# A cette étape de la manip la ligne 
#       <%= gravatar_for user, size: 50 %>
# Ne fonctionne pas car le helper gravatar_for n'a qu'un seul paramètre

# Il faut mettre à jour avec
# Listing 7.31: Adding an options hash in the gravatar_for helper.
# app/helpers/users_helper.rb
module UsersHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end

# Listing 9.35: CSS for the users index.
# app/assets/stylesheets/custom.css.scss
.
.
.
/* Users index */

.users {
  list-style: none;
  margin: 0;
  li {
    overflow: auto;
    padding: 10px 0;
    border-bottom: 1px solid $gray-lighter;
  }
}

# Listing 9.36: Adding the URL to the users link.
# app/views/layouts/_header.html.erb
<header class="navbar navbar-fixed-top navbar-inverse">
  <div class="container">
    <%= link_to "sample app", root_path, id: "logo" %>
    <nav>
      <ul class="nav navbar-nav navbar-right">
        <li><%= link_to "Home", root_path %></li>
        <li><%= link_to "Help", help_path %></li>
        <% if logged_in? %>
          <li><%= link_to "Users", users_path %></li>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              Account <b class="caret"></b>
            </a>
            <ul class="dropdown-menu">
              <li><%= link_to "Profile", current_user %></li>
              <li><%= link_to "Settings", edit_user_path(current_user) %></li>
              <li class="divider"></li>
              <li>
                <%= link_to "Log out", logout_path, method: "delete" %>
              </li>
            </ul>
          </li>
        <% else %>
          <li><%= link_to "Log in", login_path %></li>
        <% end %>
      </ul>
    </nav>
  </div>
</header>

# Listing 9.37: green
$ bundle exec rake test

### 9.3.2 Sample users

# Listing 9.38: Adding the Faker gem to the Gemfile.
source 'https://rubygems.org'

gem 'rails',                '4.2.2'
gem 'bcrypt',               '3.1.7'
gem 'faker',                '1.4.2'
.
.
.

# Bundle install
$ bundle install

# Listing 9.39: A Rake task for seeding the database with sample users.
# db/seeds.rb
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar")

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

# Lancer le reset puis la génération des données
$ bundle exec rake db:migrate:reset
$ bundle exec rake db:seed

# ATTENTION : sur certains systèmes, c'est mon cas, il faut arrêter le serveur
# Pour faire le reset de la BD
# Le db:seed peut être assez long

# Tester l'adresse http://localhost:3000/users

### 9.3.3 Pagination

# Listing 9.40: Including will_paginate in the Gemfile.
source 'https://rubygems.org'

gem 'rails',                   '4.2.2'
gem 'bcrypt',                  '3.1.7'
gem 'faker',                   '1.4.2'
gem 'will_paginate',           '3.0.7'
gem 'bootstrap-will_paginate', '0.0.10'
.
.
.

# Bundle install
$ bundle install

# Listing 9.41: The users index with pagination.
# app/views/users/index.html.erb
<% provide(:title, 'All users') %>
<h1>All users</h1>

<%= will_paginate %>

<ul class="users">
  <% @users.each do |user| %>
    <li>
      <%= gravatar_for user, size: 50 %>
      <%= link_to user.name, user %>
    </li>
  <% end %>
</ul>

<%= will_paginate %>

# Listing 9.42: Paginating the users in the index action.
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  .
  .
  .
  def index
    @users = User.paginate(page: params[:page])
  end
  .
  .
  .
end

# Tester l'adresse http://localhost:3000/users

### 9.3.4 Users index test

# Listing 9.43: Adding 30 extra users to the fixture.
# test/fixtures/users.yml
michael:
  name: Michael Example
  email: michael@example.com
  password_digest: <%= User.digest('password') %>

archer:
  name: Sterling Archer
  email: duchess@example.gov
  password_digest: <%= User.digest('password') %>

lana:
  name: Lana Kane
  email: hands@example.gov
  password_digest: <%= User.digest('password') %>

malory:
  name: Malory Archer
  email: boss@example.gov
  password_digest: <%= User.digest('password') %>

<% 30.times do |n| %>
user_<%= n %>:
  name:  <%= "User #{n}" %>
  email: <%= "user-#{n}@example.com" %>
  password_digest: <%= User.digest('password') %>
<% end %>

# Générer un test d'intégration
$ rails generate integration_test users_index
      invoke  test_unit
      create    test/integration/users_index_test.rb

# Listing 9.44: A test of the users index, including pagination. green
# test/integration/users_index_test.rb
require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end
end      

# Listing 9.45: green
$ bundle exec rake test

# Pour pouvoir faire le test le système demande de mettre à jour la BD de test
$ rake db:migrate RAILS_ENV=test

### 9.3.5 Partial refactoring

# Listing 9.46: The first refactoring attempt in the index view.
# app/views/users/index.html.erb
<% provide(:title, 'All users') %>
<h1>All users</h1>

<%= will_paginate %>

<ul class="users">
  <% @users.each do |user| %>
    <%= render user %>
  <% end %>
</ul>

<%= will_paginate %>

# Listing 9.47: A partial to render a single user.
# app/views/users/_user.html.erb
<li>
  <%= gravatar_for user, size: 50 %>
  <%= link_to user.name, user %>
</li>

# Listing 9.48: The fully refactored users index. green
# app/views/users/index.html.erb
<% provide(:title, 'All users') %>
<h1>All users</h1>

<%= will_paginate %>

<ul class="users">
  <%= render @users %>
</ul>

<%= will_paginate %>

# Listing 9.49: green
$ bundle exec rake test

### 9.4 Deleting users

### 9.4.1 Administrative users

# Générer une migration pour ajouter une colonne admin
$ rails generate migration add_admin_to_users admin:boolean

# Procéder à la migration
$ bundle exec rake db:migrate

# Listing 9.51: The seed data code with an admin user.
# db/seeds.rb
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

# Regénérer la BD en arrêtant le serveur
$ bundle exec rake db:migrate:reset
$ bundle exec rake db:seed

### 9.4.2 The destroy action

# Listing 9.52: User delete links (viewable only by admins).
# app/views/users/_user.html.erb
<li>
  <%= gravatar_for user, size: 50 %>
  <%= link_to user.name, user %>
  <% if current_user.admin? && !current_user?(user) %>
    | <%= link_to "delete", user, method: :delete,
                                  data: { confirm: "You sure?" } %>
  <% end %>
</li>

# Se connecter avec example@railstutorial.org/foobar (c'est l'admin)
# Aller dans la liste users, vous devez avoir les liens delete
# Se déconnecter, puis créer un compte
# Aller dans la liste users, vous n'avez pas les liens delete

# Listing 9.53: Adding a working destroy action.
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  .
  .
  .
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  .
  .
  .
end

# Listing 9.54: A before filter restricting the destroy action to admins.
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  .
  .
  .
  private
    .
    .
    .
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end

# ### 9.4.3 User destroy tests

# Listing 9.55: Making one of the fixture users an admin.
# test/fixtures/users.yml
michael:
  name: Michael Example
  email: michael@example.com
  password_digest: <%= User.digest('password') %>
  admin: true

archer:
  name: Sterling Archer
  email: duchess@example.gov
  password_digest: <%= User.digest('password') %>

lana:
  name: Lana Kane
  email: hands@example.gov
  password_digest: <%= User.digest('password') %>

malory:
  name: Malory Archer
  email: boss@example.gov
  password_digest: <%= User.digest('password') %>

<% 30.times do |n| %>
user_<%= n %>:
  name:  <%= "User #{n}" %>
  email: <%= "user-#{n}@example.com" %>
  password_digest: <%= User.digest('password') %>
<% end %>

# Listing 9.56: Action-level tests for admin access control. green
# test/controllers/users_controller_test.rb
require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
  end
  .
  .
  .
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end
end

# Listing 9.57: An integration test for delete links and destroying users. green
# test/integration/users_index_test.rb
require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end

# Après avoir migré la BD de test
$ rake db:migrate RAILS_ENV=test

# Listing 9.58: green
$ bundle exec rake test

### 9.5 Conclusion

# Valider les modifications
$ git add -A
$ git commit -m "Finish user edit, update, index, and destroy actions"
$ git checkout master
$ git merge updating-users
$ git push

# Déployer sur le serveur de production
$ bundle exec rake test
$ git push heroku
$ heroku pg:reset DATABASE
$ heroku run rake db:migrate
$ heroku run rake db:seed
$ heroku restart

#########################################################################################
#########################################################################################
### Chapter 10 Account activation and password reset
#########################################################################################
#########################################################################################

### 10.1 Account activation

# Créer une branche
$ git checkout master
$ git checkout -b account-activation-password-reset

### 10.1.1 Account activations resource

# Générer un controleur sans le controller test
$ rails generate controller AccountActivations --no-test-framework

# Listing 10.1: Adding a resource for account activations.
# config/routes.rb
Rails.application.routes.draw do
  root                'static_pages#home'
  get    'help'    => 'static_pages#help'
  get    'about'   => 'static_pages#about'
  get    'contact' => 'static_pages#contact'
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]
end

# Générer une migration pour ajouter 3 colonnes
$ rails generate migration add_activation_to_users \
> activation_digest:string activated:boolean activated_at:datetime

# Faire la migration
$ bundle exec rake db:migrate

# Listing 10.3: Adding account activation code to the User model. green
# app/models/user.rb
class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  .
  .
  .
  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end

# Listing 10.4: Activating seed users by default.
# db/seeds.rb
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

# Listing 10.5: Activating fixture users.
# test/fixtures/users.yml
michael:
  name: Michael Example
  email: michael@example.com
  password_digest: <%= User.digest('password') %>
  admin: true
  activated: true
  activated_at: <%= Time.zone.now %>

archer:
  name: Sterling Archer
  email: duchess@example.gov
  password_digest: <%= User.digest('password') %>
  activated: true
  activated_at: <%= Time.zone.now %>

lana:
  name: Lana Kane
  email: hands@example.gov
  password_digest: <%= User.digest('password') %>
  activated: true
  activated_at: <%= Time.zone.now %>

malory:
  name: Malory Archer
  email: boss@example.gov
  password_digest: <%= User.digest('password') %>
  activated: true
  activated_at: <%= Time.zone.now %>

<% 30.times do |n| %>
user_<%= n %>:
  name:  <%= "User #{n}" %>
  email: <%= "user-#{n}@example.com" %>
  password_digest: <%= User.digest('password') %>
  activated: true
  activated_at: <%= Time.zone.now %>
<% end %>

# Resetter la BD et la regénérer en arrêtant le serveur
$ bundle exec rake db:migrate:reset
$ bundle exec rake db:seed

### 10.1.2 Account activation mailer method

# Générer un mailer
$ rails generate mailer UserMailer account_activation password_reset

# Constater les vues générées

# Listing 10.10: The application mailer with a new default from address.
# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  default from: "noreply@example.com"
  layout 'mailer'
end

# Listing 10.11: Mailing the account activation link.
# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end

# Listing 10.12: The account activation text view.
# app/views/user_mailer/account_activation.text.erb
Hi <%= @user.name %>,

Welcome to the Sample App! Click on the link below to activate your account:

<%= edit_account_activation_url(@user.activation_token, email: @user.email) %>

# Listing 10.13: The account activation HTML view.
# app/views/user_mailer/account_activation.html.erb
<h1>Sample App</h1>

<p>Hi <%= @user.name %>,</p>

<p>
Welcome to the Sample App! Click on the link below to activate your account:
</p>

<%= link_to "Activate", edit_account_activation_url(@user.activation_token,
                                                    email: @user.email) %>

# Listing 10.14: Email settings in development.
# config/environments/development.rb
Rails.application.configure do
  .
  .
  .
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :test
  host = 'example.com'
  config.action_mailer.default_url_options = { host: host }
  .
  .
  .
end

# Changer host en fonction de votre adresse de test
# pour moi localhost:3000

# Listing 10.16: A working preview method for account activation.
#test/mailers/previews/user_mailer_preview.rb
# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    UserMailer.password_reset
  end
end

# Prévisaliser les emails aux adresses :
# http://localhost:3000/rails/mailers/user_mailer/account_activation

# Listing 10.17: The User mailer test generated by Rails.
# test/mailers/user_mailer_test.rb
require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    mail = UserMailer.account_activation
    assert_equal "Account activation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "password_reset" do
    mail = UserMailer.password_reset
    assert_equal "Password reset", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end
end

# Listing 10.18: A test of the current email implementation. red
# test/mailers/user_mailer_test.rb
require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end
end

# Listing 10.19: Setting the test domain host.
# config/environments/test.rb
Rails.application.configure do
  .
  .
  .
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = { host: 'example.com' }
  .
  .
  .
end

# Migrer la BD de test
$ rake db:migrate RAILS_ENV=test

# Listing 10.20: green
$ bundle exec rake test:mailers

# Listing 10.21: Adding account activation to user signup. red
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  .
  .
  .
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  .
  .
  .
end

# Listing 10.22: Temporarily commenting out failing tests. green
# test/integration/users_signup_test.rb
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name:  "Example User",
                                            email: "user@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    # assert_template 'users/show'
    # assert is_logged_in?
  end
end

# Tester la création d'un compte
# Regarder dans le log l'envoi du mail

### 10.1.3 Activating the account

# Listing 10.24: A generalized authenticated? method. red
# app/models/user.rb
class User < ActiveRecord::Base
  .
  .
  .
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  .
  .
  .
end

# Listing 10.25: red
$ bundle exec rake test

# Listing 10.26: Using the generalized authenticated? method in current_user.
# app/helpers/sessions_helper.rb
module SessionsHelper
  .
  .
  .
  # Returns the current logged-in user (if any).
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  .
  .
  .
end

# Listing 10.27: Using the generalized authenticated? method in the User test. green
# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  .
  .
  .
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
end

# Listing 10.28: green
$ bundle exec rake test

# Listing 10.29: An edit action to activate accounts.
# app/controllers/account_activations_controller.rb
class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end

# Listing 10.30: Preventing unactivated users from logging in.
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end

### 10.1.4 Activation test and refactoring

# Listing 10.31: Adding account activation to the user signup test. green
# test/integration/users_signup_test.rb
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: { name:  "Example User",
                               email: "user@example.com",
                               password:              "password",
                               password_confirmation: "password" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end

# Listing 10.32: green
$ bundle exec rake test

# Listing 10.33: Adding user activation methods to the User model.
# app/models/user.rb
class User < ActiveRecord::Base
  .
  .
  .
  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private
    .
    .
    .
end

# Listing 10.34: Sending email via the user model object.
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  .
  .
  .
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  .
  .
  .
end

# Listing 10.35: Account activation via the user model object.
# app/controllers/account_activations_controller.rb
class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end

# Listing 10.36: green
$ bundle exec rake test

# Activer le compte créé en récupérant l'url dans le fichier log où on peut voir
# le html du mail et donc le lien d'activation

# Valider les modifications
$ git add -A
$ git commit -m "Add account activations"

### 10.2 Password reset

### 10.2.1 Password resets resource

# Générer un controller
$ rails generate controller PasswordResets new edit --no-test-framework

# Listing 10.37: Adding a resource for password resets.
# config/routes.rb
Rails.application.routes.draw do
  root                'static_pages#home'
  get    'help'    => 'static_pages#help'
  get    'about'   => 'static_pages#about'
  get    'contact' => 'static_pages#contact'
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end

# Listing 10.38: Adding a link to password resets.
# app/views/sessions/new.html.erb
<% provide(:title, "Log in") %>
<h1>Log in</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(:session, url: login_path) do |f| %>

      <%= f.label :email %>
      <%= f.email_field :email, class: 'form-control' %>

      <%= f.label :password %>
      <%= link_to "(forgot password)", new_password_reset_path %>
      <%= f.password_field :password, class: 'form-control' %>

      <%= f.label :remember_me, class: "checkbox inline" do %>
        <%= f.check_box :remember_me %>
        <span>Remember me on this computer</span>
      <% end %>

      <%= f.submit "Log in", class: "btn btn-primary" %>
    <% end %>

    <p>New user? <%= link_to "Sign up now!", signup_path %></p>
  </div>
</div>

# Générer une migration pour ajouter 2 colonnes
$ rails generate migration add_reset_to_users reset_digest:string \
> reset_sent_at:datetime

# Migrer la BD
$ bundle exec rake db:migrate

### 10.2.2 Password resets controller and form

# Listing 10.39: Reviewing the code for the login form.
# app/views/sessions/new.html.erb
<% provide(:title, "Log in") %>
<h1>Log in</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(:session, url: login_path) do |f| %>

      <%= f.label :email %>
      <%= f.email_field :email, class: 'form-control' %>

      <%= f.label :password %>
      <%= f.password_field :password, class: 'form-control' %>

      <%= f.label :remember_me, class: "checkbox inline" do %>
        <%= f.check_box :remember_me %>
        <span>Remember me on this computer</span>
      <% end %>

      <%= f.submit "Log in", class: "btn btn-primary" %>
    <% end %>

    <p>New user? <%= link_to "Sign up now!", signup_path %></p>
  </div>
</div>

# Listing 10.40: A new password reset view.
# app/views/password_resets/new.html.erb
<% provide(:title, "Forgot password") %>
<h1>Forgot password</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(:password_reset, url: password_resets_path) do |f| %>
      <%= f.label :email %>
      <%= f.email_field :email, class: 'form-control' %>

      <%= f.submit "Submit", class: "btn btn-primary" %>
    <% end %>
  </div>
</div>

# Listing 10.41: A create action for password resets.
# app/controllers/password_resets_controller.rb
class PasswordResetsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end
end

# Listing 10.42: Adding password reset methods to the User model.
# app/models/user.rb
class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  .
  .
  .
  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end

### 10.2.3 Password reset mailer method

# Listing 10.43: Mailing the password reset link.
# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end

# Listing 10.44: The password reset plain-text email template.
# app/views/user_mailer/password_reset.text.erb
To reset your password click the link below:

<%= edit_password_reset_url(@user.reset_token, email: @user.email) %>

This link will expire in two hours.

If you did not request your password to be reset, please ignore this email and
your password will stay as it is.

# Listing 10.45: The password reset HTML email template.
# app/views/user_mailer/password_reset.html.erb
<h1>Password reset</h1>

<p>To reset your password click the link below:</p>

<%= link_to "Reset password", edit_password_reset_url(@user.reset_token,
                                                      email: @user.email) %>

<p>This link will expire in two hours.</p>

<p>
If you did not request your password to be reset, please ignore this email and
your password will stay as it is.
</p>

# Listing 10.46: A working preview method for password reset.
# test/mailers/previews/user_mailer_preview.rb
# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end
end

# Listing 10.47: Adding a test of the password reset mailer method. green
# test/mailers/user_mailer_test.rb
require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  test "password_reset" do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end
end

# Migrer la BD de test
$ rake db:migrate RAILS_ENV=test

# Listing 10.48: green
$ bundle exec rake test

### 10.2.4 Resetting the password

# Listing 10.50: The form to reset a password.
#app/views/password_resets/edit.html.erb
<% provide(:title, 'Reset password') %>
<h1>Reset password</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(@user, url: password_reset_path(params[:id])) do |f| %>
      <%= render 'shared/error_messages' %>

      <%= hidden_field_tag :email, @user.email %>

      <%= f.label :password %>
      <%= f.password_field :password, class: 'form-control' %>

      <%= f.label :password_confirmation, "Confirmation" %>
      <%= f.password_field :password_confirmation, class: 'form-control' %>

      <%= f.submit "Update password", class: "btn btn-primary" %>
    <% end %>
  </div>
</div>

# Listing 10.51: The edit action for password reset.
# app/controllers/password_resets_controller.rb
class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  .
  .
  .
  def edit
  end

  private

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
end

# Listing 10.52: The update action for password reset.
# app/controllers/password_resets_controller.rb
class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # Before filters

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end

# Listing 10.53: Adding password reset methods to the User model.
# app/models/user.rb
class User < ActiveRecord::Base
  .
  .
  .
  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private
    .
    .
    .
end

# Faire le test de reset, aller voir l'url dans le log au milieu du mail
# puis remplir le formulaire

### 10.2.5 Password reset test

## Générer un test d'intégration
$ rails generate integration_test password_resets
      invoke  test_unit
      create    test/integration/password_resets_test.rb

# Listing 10.54: An integration test for password resets.
# test/integration/password_resets_test.rb
require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid email
    post password_resets_path, password_reset: { email: "" }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path, password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid password & confirmation
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "foobaz",
                  password_confirmation: "barquux" }
    assert_select 'div#error_explanation'
    # Empty password
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "",
                  password_confirmation: "" }
    assert_select 'div#error_explanation'
    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "foobaz",
                  password_confirmation: "foobaz" }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end 

# Listing 10.55: green
$ bundle exec rake test

### 10.3 Email in production

# Installer l'addon Sendgrip sur l'hébergement Heroku
$ heroku addons:create sendgrid:starter

# Pour installer ce type d'addon, il faut enregistrer une carte bancaire sur Heroku

# Listing 10.56: Configuring Rails to use SendGrid in production.
# config/environments/production.rb
Rails.application.configure do
  .
  .
  .
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  host = '<your heroku app>.herokuapp.com'
  config.action_mailer.default_url_options = { host: host }
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
  }
  .
  .
  .
end

# ATTENTION : Mettre à jour votre nom de domaine dans le champ host

# Vous pouvez voir les infos avec
$ heroku config:get SENDGRID_USERNAME
$ heroku config:get SENDGRID_PASSWORD

# Valider les modifications
$ bundle exec rake test
$ git add -A
$ git commit -m "Add password resets & email configuration"
$ git checkout master
$ git merge account-activation-password-reset

# Déployer en production
$ bundle exec rake test
$ git push
$ git push heroku
$ heroku run rake db:migrate

### 10.4 Conclusion

# Pour accéder au dashboard de SendGrid
$ heroku addons:open sendgrid

#########################################################################################
#########################################################################################
### Chapter 11 User microposts
#########################################################################################
#########################################################################################

### 11.1 A Micropost model

# Créer une branche
$ git checkout master
$ git checkout -b user-microposts

# Générer un model
$ rails generate model Micropost content:text user:references

# Migrer la BD
$ bundle exec rake db:migrate

### 11.1.2 Micropost validations

# Listing 11.2: Tests for the validity of a new micropost. red
# test/models/micropost_test.rb
require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    # This code is not idiomatically correct.
    @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
end

# Listing 11.3: red
$ bundle exec rake test:models

# Listing 11.4: A validation for the micropost’s user_id. green
# app/models/micropost.rb
class Micropost < ActiveRecord::Base
   belongs_to :user
   validates :user_id, presence: true
end

# Listing 11.5: green
$ bundle exec rake test:models

# Listing 11.6: Tests for the Micropost model validations. red
# test/models/micropost_test.rb
require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
end

# Listing 11.7: The Micropost model validations. green
# app/models/micropost.rb
class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end

# Listing 11.8: green
$ bundle exec rake test

### 11.1.3 User/Micropost associations

# Listing 11.10: A user has_many microposts. green
# app/models/user.rb
class User < ActiveRecord::Base
  has_many :microposts
  .
  .
  .
end

# Listing 11.11: Using idiomatically correct code to build a micropost. green
# test/models/micropost_test.rb
require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  .
  .
  .
end

# Listing 11.12: green
$ bundle exec rake test

### 11.1.4 Micropost refinements

# Listing 11.13: Testing the micropost order. red
# test/models/micropost_test.rb
require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  .
  .
  .
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end

# Listing 11.14: Micropost fixtures.
# test/fixtures/microposts.yml
orange:
  content: "I just ate an orange!"
  created_at: <%= 10.minutes.ago %>

tau_manifesto:
  content: "Check out the @tauday site by @mhartl: http://tauday.com"
  created_at: <%= 3.years.ago %>

cat_video:
  content: "Sad cats are sad: http://youtu.be/PKffm2uI4dk"
  created_at: <%= 2.hours.ago %>

most_recent:
  content: "Writing a short test"
  created_at: <%= Time.zone.now %>

# Listing 11.15: red
$ bundle exec rake test TEST=test/models/micropost_test.rb \
>                       TESTOPTS="--name test_order_should_be_most_recent_first"

# Listing 11.16: Ordering the microposts with default_scope. green
# app/models/micropost.rb
class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end

# Listing 11.17: green
$ bundle exec rake test

# Listing 11.18: Ensuring that a user’s microposts are destroyed along with the user.
# app/models/user.rb
class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  .
  .
  .
end

# Listing 11.19: A test of dependent: :destroy. green
# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  .
  .
  .
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
end

# Listing 11.20: green
$ bundle exec rake test

### 11.2 Showing microposts

### 11.2.1 Rendering microposts

# Générer le controller microposts
$ rails generate controller Microposts

# Listing 11.21: A partial for showing a single micropost.
# app/views/microposts/_micropost.html.erb
<li id="micropost-<%= micropost.id %>">
  <%= link_to gravatar_for(micropost.user, size: 50), micropost.user %>
  <span class="user"><%= link_to micropost.user.name, micropost.user %></span>
  <span class="content"><%= micropost.content %></span>
  <span class="timestamp">
    Posted <%= time_ago_in_words(micropost.created_at) %> ago.
  </span>
</li>

# Listing 11.22: Adding an @microposts instance variable to the user show action.
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  .
  .
  .
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  .
  .
  .
end

# Listing 11.23: Adding microposts to the user show page.
# app/views/users/show.html.erb
<% provide(:title, @user.name) %>
<div class="row">
  <aside class="col-md-4">
    <section class="user_info">
      <h1>
        <%= gravatar_for @user %>
        <%= @user.name %>
      </h1>
    </section>
  </aside>
  <div class="col-md-8">
    <% if @user.microposts.any? %>
      <h3>Microposts (<%= @user.microposts.count %>)</h3>
      <ol class="microposts">
        <%= render @microposts %>
      </ol>
      <%= will_paginate @microposts %>
    <% end %>
  </div>
</div>

### 11.2.2 Sample microposts

# Listing 11.24: Adding microposts to the sample data.
# db/seeds.rb
.
.
.
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# Regénérer la BD en arrêtant le serveur
$ bundle exec rake db:migrate:reset
$ bundle exec rake db:seed

# Tester la page profile

# Listing 11.25: The CSS for microposts (including all the CSS for this chapter).
# app/assets/stylesheets/custom.css.scss
.
.
.
/* microposts */

.microposts {
  list-style: none;
  padding: 0;
  li {
    padding: 10px 0;
    border-top: 1px solid #e8e8e8;
  }
  .user {
    margin-top: 5em;
    padding-top: 0;
  }
  .content {
    display: block;
    margin-left: 60px;
    img {
      display: block;
      padding: 5px 0;
    }
  }
  .timestamp {
    color: $gray-light;
    display: block;
    margin-left: 60px;
  }
  .gravatar {
    float: left;
    margin-right: 10px;
    margin-top: 5px;
  }
}

aside {
  textarea {
    height: 100px;
    margin-bottom: 5px;
  }
}

span.picture {
  margin-top: 10px;
  input {
    border: 0;
  }
}

### 11.2.3 Profile micropost tests

# Générer un test d'intégration
$ rails generate integration_test users_profile
      invoke  test_unit
      create    test/integration/users_profile_test.rb

# Listing 11.26: Micropost fixtures with user associations.
# test/fixtures/microposts.yml
orange:
  content: "I just ate an orange!"
  created_at: <%= 10.minutes.ago %>
  user: michael

tau_manifesto:
  content: "Check out the @tauday site by @mhartl: http://tauday.com"
  created_at: <%= 3.years.ago %>
  user: michael

cat_video:
  content: "Sad cats are sad: http://youtu.be/PKffm2uI4dk"
  created_at: <%= 2.hours.ago %>
  user: michael

most_recent:
  content: "Writing a short test"
  created_at: <%= Time.zone.now %>
  user: michael

<% 30.times do |n| %>
micropost_<%= n %>:
  content: <%= Faker::Lorem.sentence(5) %>
  created_at: <%= 42.days.ago %>
  user: michael
<% end %>

# Listing 11.27: A test for the user profile. green
# test/integration/users_profile_test.rb
require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end

# Listing 11.28: green
$ bundle exec rake test

### 11.3 Manipulating microposts

# Listing 11.29: Routes for the Microposts resource.
# config/routes.rb
Rails.application.routes.draw do
  root                'static_pages#home'
  get    'help'    => 'static_pages#help'
  get    'about'   => 'static_pages#about'
  get    'contact' => 'static_pages#contact'
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
end

### 11.3.1 Micropost access control

# Listing 11.30: Authorization tests for the Microposts controller. red
# test/controllers/microposts_controller_test.rb
require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase

  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: { content: "Lorem ipsum" }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @micropost
    end
    assert_redirected_to login_url
  end
end

# Listing 11.31: Moving the logged_in_user method into the Application controller.
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end

# Listing 11.32: Adding authorization to the Microposts controller actions. green
# app/controllers/microposts_controller.rb
class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
  end

  def destroy
  end
end

# Listing 11.33: green
$ bundle exec rake test

### 11.3.2 Creating microposts

# Listing 11.34: The Microposts controller create action.
# app/controllers/microposts_controller.rb
class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end
end

# Listing 11.35: Adding microposts creation to the Home page (/).
# app/views/static_pages/home.html.erb
<% if logged_in? %>
  <div class="row">
    <aside class="col-md-4">
      <section class="user_info">
        <%= render 'shared/user_info' %>
      </section>
      <section class="micropost_form">
        <%= render 'shared/micropost_form' %>
      </section>
    </aside>
  </div>
<% else %>
  <div class="center jumbotron">
    <h1>Welcome to the Sample App</h1>

    <h2>
      This is the home page for the
      <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
      sample application.
    </h2>

    <%= link_to "Sign up now!", signup_path, class: "btn btn-lg btn-primary" %>
  </div>

  <%= link_to image_tag("rails.png", alt: "Rails logo"),
              'http://rubyonrails.org/' %>
<% end %>

# Listing 11.36: The partial for the user info sidebar.
# app/views/shared/_user_info.html.erb
<%= link_to gravatar_for(current_user, size: 50), current_user %>
<h1><%= current_user.name %></h1>
<span><%= link_to "view my profile", current_user %></span>
<span><%= pluralize(current_user.microposts.count, "micropost") %></span>

# Listing 11.37: The form partial for creating microposts.
# app/views/shared/_micropost_form.html.erb
<%= form_for(@micropost) do |f| %>
  <%= render 'shared/error_messages', object: f.object %>
  <div class="field">
    <%= f.text_area :content, placeholder: "Compose new micropost..." %>
  </div>
  <%= f.submit "Post", class: "btn btn-primary" %>
<% end %>

# Listing 11.38: Adding a micropost instance variable to the home action.
# app/controllers/static_pages_controller.rb
class StaticPagesController < ApplicationController

  def home
    @micropost = current_user.microposts.build if logged_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end

# Listing 11.39: Error messages that work with other objects. red
# app/views/shared/_error_messages.html.erb
<% if object.errors.any? %>
  <div id="error_explanation">
    <div class="alert alert-danger">
      The form contains <%= pluralize(object.errors.count, "error") %>.
    </div>
    <ul>
    <% object.errors.full_messages.each do |msg| %>
      <li><%= msg %></li>
    <% end %>
    </ul>
  </div>
<% end %>

# Listing 11.40: red
$ bundle exec rake test

# Listing 11.41: Updating the rendering of user signup errors.
# app/views/users/new.html.erb
<% provide(:title, 'Sign up') %>
<h1>Sign up</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(@user) do |f| %>
      <%= render 'shared/error_messages', object: f.object %>
      <%= f.label :name %>
      <%= f.text_field :name, class: 'form-control' %>

      <%= f.label :email %>
      <%= f.email_field :email, class: 'form-control' %>

      <%= f.label :password %>
      <%= f.password_field :password, class: 'form-control' %>

      <%= f.label :password_confirmation, "Confirmation" %>
      <%= f.password_field :password_confirmation, class: 'form-control' %>

      <%= f.submit "Create my account", class: "btn btn-primary" %>
    <% end %>
  </div>
</div>

# Listing 11.42: Updating the errors for editing users.
# app/views/users/edit.html.erb
<% provide(:title, "Edit user") %>
<h1>Update your profile</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(@user) do |f| %>
      <%= render 'shared/error_messages', object: f.object %>

      <%= f.label :name %>
      <%= f.text_field :name, class: 'form-control' %>

      <%= f.label :email %>
      <%= f.email_field :email, class: 'form-control' %>

      <%= f.label :password %>
      <%= f.password_field :password, class: 'form-control' %>

      <%= f.label :password_confirmation, "Confirmation" %>
      <%= f.password_field :password_confirmation, class: 'form-control' %>

      <%= f.submit "Save changes", class: "btn btn-primary" %>
    <% end %>

    <div class="gravatar_edit">
      <%= gravatar_for @user %>
      <a href="http://gravatar.com/emails">change</a>
    </div>
  </div>
</div>

# Listing 11.43: Updating the errors for password resets.
# app/views/password_resets/edit.html.erb
<% provide(:title, 'Reset password') %>
<h1>Password reset</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(@user, url: password_reset_path(params[:id])) do |f| %>
      <%= render 'shared/error_messages', object: f.object %>

      <%= hidden_field_tag :email, @user.email %>

      <%= f.label :password %>
      <%= f.password_field :password, class: 'form-control' %>

      <%= f.label :password_confirmation, "Confirmation" %>
      <%= f.password_field :password_confirmation, class: 'form-control' %>

      <%= f.submit "Update password", class: "btn btn-primary" %>
    <% end %>
  </div>
</div>

# Le test doit être GREEN
$ bundle exec rake test

### 11.3.3 A proto-feed

# Listing 11.44: A preliminary implementation for the micropost status feed.
# app/models/user.rb
class User < ActiveRecord::Base
  .
  .
  .
  # Defines a proto-feed.
  # See "Following users" for the full implementation.
  def feed
    Micropost.where("user_id = ?", id)
  end

    private
    .
    .
    .
end

# Listing 11.45: Adding a feed instance variable to the home action.
# app/controllers/static_pages_controller.rb
class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end

# Listing 11.46: The status feed partial.
# app/views/shared/_feed.html.erb
<% if @feed_items.any? %>
  <ol class="microposts">
    <%= render @feed_items %>
  </ol>
  <%= will_paginate @feed_items %>
<% end %>

# Listing 11.47: Adding a status feed to the Home page.
# app/views/static_pages/home.html.erb
<% if logged_in? %>
  <div class="row">
    <aside class="col-md-4">
      <section class="user_info">
        <%= render 'shared/user_info' %>
      </section>
      <section class="micropost_form">
        <%= render 'shared/micropost_form' %>
      </section>
    </aside>
    <div class="col-md-8">
      <h3>Micropost Feed</h3>
      <%= render 'shared/feed' %>
    </div>
  </div>
<% else %>
  .
  .
  .
<% end %>

# Listing 11.48: Adding an (empty) @feed_items instance variable to the create action.
# app/controllers/microposts_controller.rb
class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end
end

### 11.3.4 Destroying microposts

# Listing 11.49: Adding a delete link to the micropost partial.
# app/views/microposts/_micropost.html.erb
<li id="<%= micropost.id %>">
  <%= link_to gravatar_for(micropost.user, size: 50), micropost.user %>
  <span class="user"><%= link_to micropost.user.name, micropost.user %></span>
  <span class="content"><%= micropost.content %></span>
  <span class="timestamp">
    Posted <%= time_ago_in_words(micropost.created_at) %> ago.
    <% if current_user?(micropost.user) %>
      <%= link_to "delete", micropost, method: :delete,
                                       data: { confirm: "You sure?" } %>
    <% end %>
  </span>
</li>

# Listing 11.50: The Microposts controller destroy action.
# app/controllers/microposts_controller.rb
class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  .
  .
  .
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

     def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end

### 11.3.5 Micropost tests

# Listing 11.51: Adding a micropost with a different owner.
# test/fixtures/microposts.yml
.
.
.
ants:
  content: "Oh, is that what you want? Because that's how you get ants!"
  created_at: <%= 2.years.ago %>
  user: archer

zone:
  content: "Danger zone!"
  created_at: <%= 3.days.ago %>
  user: archer

tone:
  content: "I'm sorry. Your words made sense, but your sarcastic tone did not."
  created_at: <%= 10.minutes.ago %>
  user: lana

van:
  content: "Dude, this van's, like, rolling probable cause."
  created_at: <%= 4.hours.ago %>
  user: lana

# Listing 11.52: Testing micropost deletion with a user mismatch. green
# test/controllers/microposts_controller_test.rb
require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase

  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: { content: "Lorem ipsum" }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @micropost
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: micropost
    end
    assert_redirected_to root_url
  end
end

# Générer un test d'intégration
$ rails generate integration_test microposts_interface
      invoke  test_unit
      create    test/integration/microposts_interface_test.rb

# Listing 11.53: An integration test for the micropost interface. green
# test/integration/microposts_interface_test.rb
require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: "" }
    end
    assert_select 'div#error_explanation'
    # Valid submission
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete a post.
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit a different user.
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
end

# Listing 11.54: green
$ bundle exec rake test

### 11.4 Micropost images

### 11.4.1 Basic image upload

# Listing 11.55: Adding CarrierWave to the Gemfile.
source 'https://rubygems.org'

.
.
.
gem 'carrierwave',             '0.10.0'
gem 'mini_magick',             '3.8.0'
gem 'fog',                     '1.36.0'
.
.
.

# Installer
$bundle install  

# Générer un uploader grace à CarrierWave
$ rails generate uploader Picture

# Générer une migration pour ajouter une colonne picture dans le post
$ rails generate migration add_picture_to_microposts picture:string
$ bundle exec rake db:migrate

# Listing 11.56: Adding an image to the Micropost model.
# app/models/micropost.rb
class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end

# Listing 11.57: Adding image upload to the micropost create form.
# app/views/shared/_micropost_form.html.erb
<%= form_for(@micropost, html: { multipart: true }) do |f| %>
  <%= render 'shared/error_messages', object: f.object %>
  <div class="field">
    <%= f.text_area :content, placeholder: "Compose new micropost..." %>
  </div>
  <%= f.submit "Post", class: "btn btn-primary" %>
  <span class="picture">
    <%= f.file_field :picture %>
  </span>
<% end %>

# Listing 11.58: Adding picture to the list of permitted attributes.
# app/controllers/microposts_controller.rb
class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  .
  .
  .
  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

     def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end

# Listing 11.59: Adding image display to microposts.
# app/views/microposts/_micropost.html.erb
<li id="micropost-<%= micropost.id %>">
  <%= link_to gravatar_for(micropost.user, size: 50), micropost.user %>
  <span class="user"><%= link_to micropost.user.name, micropost.user %></span>
  <span class="content">
    <%= micropost.content %>
    <%= image_tag micropost.picture.url if micropost.picture? %>
  </span>
  <span class="timestamp">
    Posted <%= time_ago_in_words(micropost.created_at) %> ago.
    <% if current_user?(micropost.user) %>
      <%= link_to "delete", micropost, method: :delete,
                                       data: { confirm: "You sure?" } %>
    <% end %>
  </span>
</li>

# A ce stade, tester la publication d'image dans les tweets

### 11.4.2 Image validation

# Listing 11.60: The picture format validation.
# app/uploaders/picture_uploader.rb
class PictureUploader < CarrierWave::Uploader::Base
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end

# Listing 11.61: Adding validations to images.
# app/models/micropost.rb
class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end

# Listing 11.62: Checking the file size with jQuery.
# app/views/shared/_micropost_form.html.erb
<%= form_for(@micropost, html: { multipart: true }) do |f| %>
  <%= render 'shared/error_messages', object: f.object %>
  <div class="field">
    <%= f.text_area :content, placeholder: "Compose new micropost..." %>
  </div>
  <%= f.submit "Post", class: "btn btn-primary" %>
  <span class="picture">
    <%= f.file_field :picture, accept: 'image/jpeg,image/gif,image/png' %>
  </span>
<% end %>

<script type="text/javascript">
  $('#micropost_picture').bind('change', function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert('Maximum file size is 5MB. Please choose a smaller file.');
    }
  });
</script>

### 11.4.3 Image resizing

# Ici on utilise ImageMagick qui est préinstallé sur Heroku
# Mais en local il faudrait l'installer
# Sur Linux :
$ sudo apt-get update
$ sudo apt-get install imagemagick --fix-missing
# Mais sur Windows ce n'est pas précisé ...
# Il faut l'installer à partir de cette adresse :
# http://www.imagemagick.org/script/binary-releases.php
# Cocher les cases pour ajouter au PATH
# Et pour installer les librairies C et C++
# Relancer les consoles pour prendre en compte le pATH, vérifier quand même
# Ensuite les explications sont ici :
# http://www.rubydoc.info/gems/rmagick/2.15.4
# Modifier le Gemfile en ajoutant
gem 'rmagick'
# Puis installer
$ bundle install

# Listing 11.63: Configuring the image uploader for image resizing.
# app/uploaders/picture_uploader.rb
class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process resize_to_limit: [400, 400]

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end

# Tester, tout va bien, les images sont redimmensionnées

### 11.4.4 Image upload in production

###########################################
# Ces étapes nécessitent la création d'un cloud Amazon payant
# Je ne les fais pas pour l'instant
# Les images uploadées sur Heroku seront effacées à chaque mise en production
# Ajout : Même sans mise en prod, les images sont effacées, 
# on dirait quand le dyno s'arrête
###########################################

# Listing 11.64: Configuring the image uploader for production.
# app/uploaders/picture_uploader.rb
class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process resize_to_limit: [400, 400]

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end

# Création du compte

# Listing 11.65: Configuring CarrierWave to use S3.
config/initializers/carrier_wave.rb
 if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET_KEY']
    }
    config.fog_directory     =  ENV['S3_BUCKET']
  end
end

# Enregistrer les informations de connexion au cloud S3
$ heroku config:set S3_ACCESS_KEY=<access key>
$ heroku config:set S3_SECRET_KEY=<secret key>
$ heroku config:set S3_BUCKET=<bucket name>

###########################################
# Reprise des manipulations
###########################################

# Listing 11.66: Adding the uploads directory to the .gitignore file.
# See https://help.github.com/articles/ignoring-files for more about ignoring
# files.
#
# If you find yourself ignoring temporary files generated by your text editor
# or operating system, you probably want to add a global ignore instead:
#   git config --global core.excludesfile '~/.gitignore_global'

# Ignore bundler config.
/.bundle

# Ignore the default SQLite database.
/db/*.sqlite3
/db/*.sqlite3-journal

# Ignore all logfiles and tempfiles.
/log/*.log
/tmp

# Ignore Spring files.
/spring/*.pid

# Ignore uploaded test images.
/public/uploads

#### 11.5 Conclusion

# Valider les modifications
$ bundle exec rake test
$ git add -A
$ git commit -m "Add user microposts"
$ git checkout master
$ git merge user-microposts
$ git push

# Mettre en production
$ git push heroku
$ heroku pg:reset DATABASE
$ heroku run rake db:migrate
$ heroku run rake db:seed

# Le Gemfile final devrait être
# Listing 11.67: The final Gemfile for the sample application.
source 'https://rubygems.org'

gem 'rails',                   '4.2.2'
gem 'bcrypt',                  '3.1.7'
gem 'faker',                   '1.4.2'
gem 'carrierwave',             '0.10.0'
gem 'mini_magick',             '3.8.0'
gem 'fog',                     '1.36.0'
gem 'will_paginate',           '3.0.7'
gem 'bootstrap-will_paginate', '0.0.10'
gem 'bootstrap-sass',          '3.2.0.0'
gem 'sass-rails',              '5.0.2'
gem 'uglifier',                '2.5.3'
gem 'coffee-rails',            '4.1.0'
gem 'jquery-rails',            '4.0.3'
gem 'turbolinks',              '2.3.0'
gem 'jbuilder',                '2.2.3'
gem 'sdoc',                    '0.4.0', group: :doc

group :development, :test do
  gem 'sqlite3',     '1.3.9'
  gem 'byebug',      '3.4.0'
  gem 'web-console', '2.0.0.beta3'
  gem 'spring',      '1.1.3'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

group :production do
  gem 'pg',             '0.17.1'
  gem 'rails_12factor', '0.0.2'
  gem 'puma',           '3.1.0'
end

#########################################################################################
#########################################################################################
### Chapter 12 Following users
#########################################################################################
#########################################################################################

### 12.1 The Relationship model12.1 The Relationship model

# Créer une branche
$ git checkout master
$ git checkout -b following-users

### 12.1.1 A problem with the data model (and a solution)

# Générer un model Relationship
$ rails generate model Relationship follower_id:integer followed_id:integer

# Constater le script suivant :
# Listing 12.1: Adding indices for the relationships table.
# db/migrate/[timestamp]_create_relationships.rb
class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps null: false
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end

# Générer la migration
$ bundle exec rake db:migrate

### 12.1.2 User/relationship associations

# Listing 12.2: Implementing the active relationships has_many association.
# app/models/user.rb
class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  .
  .
  .
end

# Listing 12.3: Adding the follower belongs_to association to the Relationship model.
# app/models/relationship.rb
class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end

### 12.1.3 Relationship validations

# Listing 12.4: Testing the Relationship model validations.
# test/models/relationship_test.rb
require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(follower_id: 1, followed_id: 2)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end

# Listing 12.5: Adding the Relationship model validations.
# app/models/relationship.rb
class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end

# Listing 12.6: Removing the contents of the relationship fixture.
# test/fixtures/relationships.yml
 # empty

# Listing 12.7: green
$ bundle exec rake test

### 12.1.4 Followed users

# Listing 12.8: Adding the User model following association.
# app/models/user.rb
class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  .
  .
  .
end

# Listing 12.9: Tests for some “following” utility methods. red
# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  .
  .
  .
  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
end

# Listing 12.10: Utility methods for following. green
# app/models/user.rb
class User < ActiveRecord::Base
  .
  .
  .
  def feed
    .
    .
    .
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  private
  .
  .
  .
end

# Listing 12.11: green
$ bundle exec rake test

### 12.1.5 Followers

# Listing 12.12: Implementing user.followers using passive relationships.
# app/models/user.rb
class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  .
  .
  .
end

# Listing 12.13: A test for followers. green
# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  .
  .
  .
  test "should follow and unfollow a user" do
    michael  = users(:michael)
    archer   = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
end

# Doit être GREEN
$ bundle exec rake test

### 12.2 A web interface for following users

### 12.2.1 Sample following data

# Listing 12.14: Adding following/follower relationships to the sample data.
# db/seeds.rb
 # Users
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

# Microposts
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# Regénérer la BD
$ bundle exec rake db:migrate:reset
$ bundle exec rake db:seed

### 12.2.2 Stats and a follow form

# Listing 12.15: Adding following and followers actions to the Users controller.
# config/routes.rb
Rails.application.routes.draw do
  root                'static_pages#home'
  get    'help'    => 'static_pages#help'
  get    'about'   => 'static_pages#about'
  get    'contact' => 'static_pages#contact'
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
end

# Listing 12.16: A partial for displaying follower stats.
# app/views/shared/_stats.html.erb
<% @user ||= current_user %>
<div class="stats">
  <a href="<%= following_user_path(@user) %>">
    <strong id="following" class="stat">
      <%= @user.following.count %>
    </strong>
    following
  </a>
  <a href="<%= followers_user_path(@user) %>">
    <strong id="followers" class="stat">
      <%= @user.followers.count %>
    </strong>
    followers
  </a>
</div>

# Listing 12.17: Adding follower stats to the Home page.
# app/views/static_pages/home.html.erb
<% if logged_in? %>
  <div class="row">
    <aside class="col-md-4">
      <section class="user_info">
        <%= render 'shared/user_info' %>
      </section>
      <section class="stats">
        <%= render 'shared/stats' %>
      </section>
      <section class="micropost_form">
        <%= render 'shared/micropost_form' %>
      </section>
    </aside>
    <div class="col-md-8">
      <h3>Micropost Feed</h3>
      <%= render 'shared/feed' %>
    </div>
  </div>
<% else %>
  .
  .
  .
<% end %>

# Listing 12.18: SCSS for the Home page sidebar.
# app/assets/stylesheets/custom.css.scss
.
.
.
/* sidebar */
.
.
.
.gravatar {
  float: left;
  margin-right: 10px;
}

.gravatar_edit {
  margin-top: 15px;
}

.stats {
  overflow: auto;
  margin-top: 0;
  padding: 0;
  a {
    float: left;
    padding: 0 10px;
    border-left: 1px solid $gray-lighter;
    color: gray;
    &:first-child {
      padding-left: 0;
      border: 0;
    }
    &:hover {
      text-decoration: none;
      color: blue;
    }
  }
  strong {
    display: block;
  }
}

.user_avatars {
  overflow: auto;
  margin-top: 10px;
  .gravatar {
    margin: 1px 1px;
  }
  a {
    padding: 0;
  }
}

.users.follow {
  padding: 0;
}

/* forms */
.
.
.

# Tester la home pour voir les stats

# Listing 12.19: A partial for a follow/unfollow form.
# app/views/users/_follow_form.html.erb
<% unless current_user?(@user) %>
  <div id="follow_form">
  <% if current_user.following?(@user) %>
    <%= render 'unfollow' %>
  <% else %>
    <%= render 'follow' %>
  <% end %>
  </div>
<% end %>

# Listing 12.20: Adding the routes for user relationships.
# config/routes.rb
Rails.application.routes.draw do
  root                'static_pages#home'
  get    'help'    => 'static_pages#help'
  get    'about'   => 'static_pages#about'
  get    'contact' => 'static_pages#contact'
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end

# Listing 12.21: A form for following a user.
# app/views/users/_follow.html.erb
<%= form_for(current_user.active_relationships.build) do |f| %>
  <div><%= hidden_field_tag :followed_id, @user.id %></div>
  <%= f.submit "Follow", class: "btn btn-primary" %>
<% end %>

# Listing 12.22: A form for unfollowing a user.
# app/views/users/_unfollow.html.erb
<%= form_for(current_user.active_relationships.find_by(followed_id: @user.id),
             html: { method: :delete }) do |f| %>
  <%= f.submit "Unfollow", class: "btn" %>
<% end %>

# Listing 12.23: Adding the follow form and follower stats to the user profile page.
# app/views/users/show.html.erb
<% provide(:title, @user.name) %>
<div class="row">
  <aside class="col-md-4">
    <section>
      <h1>
        <%= gravatar_for @user %>
        <%= @user.name %>
      </h1>
    </section>
    <section class="stats">
      <%= render 'shared/stats' %>
    </section>
  </aside>
  <div class="col-md-8">
    <%= render 'follow_form' if logged_in? %>
    <% if @user.microposts.any? %>
      <h3>Microposts (<%= @user.microposts.count %>)</h3>
      <ol class="microposts">
        <%= render @microposts %>
      </ol>
      <%= will_paginate @microposts %>
    <% end %>
  </div>
</div>

# Tester le follow/unfollow sur d'autres users
# Sur le users/2 il y a le bouton follow
# Sur le users/5 il y a le bouton unfollow

### 12.2.3 Following and followers pages

# Listing 12.24: Tests for the authorization of the following and followers pages. red
# test/controllers/users_controller_test.rb
require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  .
  .
  .
  test "should redirect following when not logged in" do
    get :following, id: @user
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get :followers, id: @user
    assert_redirected_to login_url
  end
end

# Listing 12.25: The following and followers actions.
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  .
  .
  .
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
  .
  .
  .
end

# Listing 12.26: The show_follow view used to render following and followers.
# app/views/users/show_follow.html.erb
<% provide(:title, @title) %>
<div class="row">
  <aside class="col-md-4">
    <section class="user_info">
      <%= gravatar_for @user %>
      <h1><%= @user.name %></h1>
      <span><%= link_to "view my profile", @user %></span>
      <span><b>Microposts:</b> <%= @user.microposts.count %></span>
    </section>
    <section class="stats">
      <%= render 'shared/stats' %>
      <% if @users.any? %>
        <div class="user_avatars">
          <% @users.each do |user| %>
            <%= link_to gravatar_for(user, size: 30), user %>
          <% end %>
        </div>
      <% end %>
    </section>
  </aside>
  <div class="col-md-8">
    <h3><%= @title %></h3>
    <% if @users.any? %>
      <ul class="users follow">
        <%= render @users %>
      </ul>
      <%= will_paginate %>
    <% end %>
  </div>
</div>

# Tester les liens folowing et followers dans la home

# Générer un test d'intégration
$ rails generate integration_test following
      invoke  test_unit
      create    test/integration/following_test.rb

# Listing 12.27: Relationships fixtures for use in following/follower tests.
# test/fixtures/relationships.yml
one:
  follower: michael
  followed: lana

two:
  follower: michael
  followed: malory

three:
  follower: lana
  followed: michael

four:
  follower: archer
  followed: michael     

# Listing 12.28: Tests for following/follower pages. green
# test/integration/following_test.rb
require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
end

# Listing 12.29: green
$ bundle exec rake test

### 12.2.4 A working follow button the standard way

# Générer un controller
$ rails generate controller Relationships

# Listing 12.30: Basic access control tests for relationships. red
# test/controllers/relationships_controller_test.rb
require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase

  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post :create
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete :destroy, id: relationships(:one)
    end
    assert_redirected_to login_url
  end
end

# Listing 12.31: Access control for relationships. green
# app/controllers/relationships_controller.rb
class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
  end

  def destroy
  end
end

# Listing 12.32: The Relationships controller.
# app/controllers/relationships_controller.rb
class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_to user
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    redirect_to user
  end
end

# Tester le follow/unfollow

### 12.2.5 A working follow button with Ajax

# Listing 12.33: A form for following a user using Ajax.
# app/views/users/_follow.html.erb
<%= form_for(current_user.active_relationships.build, remote: true) do |f| %>
  <div><%= hidden_field_tag :followed_id, @user.id %></div>
  <%= f.submit "Follow", class: "btn btn-primary" %>
<% end %>

# Listing 12.34: A form for unfollowing a user using Ajax.
# app/views/users/_unfollow.html.erb
<%= form_for(current_user.active_relationships.find_by(followed_id: @user.id),
             html: { method: :delete },
             remote: true) do |f| %>
  <%= f.submit "Unfollow", class: "btn" %>
<% end %>

# Listing 12.35: Responding to Ajax requests in the Relationships controller.
# app/controllers/relationships_controller.rb
class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end

# Listing 12.36: Configuration needed for graceful degradation of form submission.
# config/application.rb
require File.expand_path('../boot', __FILE__)
.
.
.
module SampleApp
  class Application < Rails::Application
    .
    .
    .
    # Include the authenticity token in remote forms.
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end

# Listing 12.37: The JavaScript embedded Ruby to create a following relationship.
# app/views/relationships/create.js.erb
$("#follow_form").html("<%= escape_javascript(render('users/unfollow')) %>");
$("#followers").html('<%= @user.followers.count %>');

# Listing 12.38: The Ruby JavaScript (RJS) to destroy a following relationship.
# app/views/relationships/destroy.js.erb
$("#follow_form").html("<%= escape_javascript(render('users/follow')) %>");
$("#followers").html('<%= @user.followers.count %>');

### 12.2.6 Following tests

# Listing 12.39: Tests for the follow and unfollow buttons. green
#test/integration/following_test.rb
require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user  = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end
  .
  .
  .
  test "should follow a user the standard way" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, followed_id: @other.id
    end
  end

  test "should follow a user with Ajax" do
    assert_difference '@user.following.count', 1 do
      xhr :post, relationships_path, followed_id: @other.id
    end
  end

  test "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      xhr :delete, relationship_path(relationship)
    end
  end
end

# Listing 12.40: green
$ bundle exec rake test

### 12.3 The status feed

### 12.3.1 Motivation and strategy

# Listing 12.41: A test for the status feed. red
# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  .
  .
  .
  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end

# Listing 12.42: red
$ bundle exec rake test

### 12.3.2 A first feed implementation

# Listing 12.43: The initial working feed. green
# app/models/user.rb
class User < ActiveRecord::Base
  .
  .
  .
  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Returns a user's status feed.
  def feed
    Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  .
  .
  .
end

# Listing 12.44: green
$ bundle exec rake test

### 12.3.3 Subselects

# Listing 12.45: Using key-value pairs in the feed’s where method. green
# app/models/user.rb
class User < ActiveRecord::Base
  .
  .
  .
  .
  .
  .
end

# Listing 12.46: The final implementation of the feed. green
# app/models/user.rb
class User < ActiveRecord::Base
  .
  .
  .
  # Returns a user's status feed.
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  .
  .
  .
end

# Listing 12.47: green
$ bundle exec rake test

# Listing 12.48: The home action with a paginated feed.
# app/controllers/static_pages_controller.rb
class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
  .
  .
  .
end

# Tester la home, le flux complet doit s'afficher

# Valider les modifications
$ bundle exec rake test
$ git add -A
$ git commit -m "Add user following"
$ git checkout master
$ git merge following-users

# Mettre en production
$ git push
$ git push heroku
$ heroku pg:reset DATABASE
$ heroku run rake db:migrate
$ heroku run rake db:seed

# Tester le site complet en production

#########################################################################################
#########################################################################################
###
### THAT'S ALL FOLKS !!!!!!!!!!!!!!!!!!!!!!!!!!!!
###
#########################################################################################
#########################################################################################

