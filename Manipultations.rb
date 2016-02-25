# Manipulations du livre Railstutorials
# A partir du chapitre 3

# 3.1

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

# Si vous ne voulez pas être obligé dinstaller une clé SSH faites ceci
# Le système vous demandera un login et password
$ git remote add origin https://bitbucket.org:<username>/sample_app.git
$ git push -u origin --all # pushes up the repo and its refs for the first time

