###############################################
#
# Manipulations du livre Railstutorials
#
# A partir du chapitre 3
#
###############################################

### 3.1 Sample app setup

# Après s'être positionné dans la zone de travail
# Il fautcréer une nouvelle application
$ rails new railstutorials
$ cd railstutorials

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

### 3.2.2 Custom static pages

# Editer la vue home dans le dossier static_pages
<h1>Sample App</h1>
<p>
  This is the home page for the
  <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
  sample application.
</p>

# Ainsi que la vue help
<h1>Help</h1>
<p>
  Get help on the Ruby on Rails Tutorial at the
  <a href="http://www.railstutorial.org/#help">Rails Tutorial help section</a>.
  To get help on this sample app, see the
  <a href="http://www.railstutorial.org/book"><em>Ruby on Rails Tutorial</em>
  book</a>.
</p>

### 3.3.1 Our first test

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

# Ajouter un test qui ne  fonctionnera pas
  test "should get about" do
    get :about
    assert_response :success
  end

# Relancer le test
# Il doit y avoir une erreur qui décèle une erreur de route

### 3.3.3 Green

# Ajouter la route manquante
  get 'static_pages/about'

# Relancer le test
# Il y a toujours une erreur qui décèle une action non trouvée
# Ajouter l'action about dans StaticPagesController
  def about
  end

# Relancer le test
# Il y a toujours une erreur qui décèle une vue non trouvée
# Créer la vue about.html.erb
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
# Il n'y a plus d'erreur
# Cette façon de faire s'appelle : Test Driven Development
# Vérifier l'adresse http://localhost:3000/static_pages/about

### 3.4 Slightly dynamic pages

# Renommer la layout par defaut
application.html..erb  -->>  layout_file

# Mofifier le test comme ceci
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

### 3.4.2 Adding page titles

# Modifier la vue home
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

### 3.4.3 Layout and embedded Ruby

# Modifier la vue home
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

# Modifier la vue help
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
<% provide(:title, "Home") %>
<h1>Sample App</h1>
<p>
  This is the home page for the
  <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
  sample application.
</p>

# Nettoyer la vue help
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

### 3.4.4 Setting the root route

# Dans le fichier des routes, modifier ainsi
Rails.application.routes.draw do
  root 'static_pages#home'
  get  'static_pages/help'
  get  'static_pages/about'
end
