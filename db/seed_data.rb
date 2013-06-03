require_relative 'bootstrap_ar'
connect_to 'development'

Project.create( name: 'abc')
Project.create( name: 'def')
