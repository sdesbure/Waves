require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'jsonify/tilt'

# Registering jsonify engine with Tilt.
# This should be done before controllers loaded
# otherwise will have to use `engine_ext` to explicitly define templates extension
Tilt::JsonifyTemplate = Jsonify::Template

require 'yaml'
require File.expand_path('../config', __FILE__)

Cfg = AppConfig.new

Bundler.require(Cfg.env)

require Cfg.base_path('database.rb')

App = EspressoApp.new(:automount) do
    assets_url '/assets'
    assets.append_path 'public/assets/vendor'
    %w{javascripts stylesheets images}.each do |type|
      assets.append_path "public/assets/#{type}"
    end
#    assets.js_compressor = :uglifier
    #assets.css_compressor = :sqwish
end

App.controllers_setup do
  view_path 'base/views'
  engine(Cfg[:engine]) if Cfg[:engine]
  format(Cfg[:format]) if Cfg[:format]
end

#App.assets_url 'assets'
#App.assets.prepend_path Cfg.assets_path

[Cfg.helpers_path, Cfg.models_path].each do |path|
  Dir[path + '**/*.rb'].each {|f| require f}
end

%w[**/*_controller.rb **/*_action.rb].each do |matcher|
  Dir[Cfg.controllers_path + matcher].each {|f| require f}
end

DataMapper.finalize if Cfg[:orm] == :DataMapper

EspressoConstants::VIEW__ENGINE_BY_EXT['.jsonify'] = Jsonify::Template
EspressoConstants::VIEW__ENGINE_BY_SYM[:Jsonify]  = Jsonify::Template
EspressoConstants::VIEW__EXT_BY_ENGINE[Jsonify::Template] = '.jsonify'.freeze
