# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Booklist.create(isbn: "9784844324782", name: "基礎Ruby on Rails", place: "先端棟", room: "1研", shelf: "正元席", acquired_at: "2013-04-01", checked_at: "2013-07-04")
require "csv"

CSV.foreach('db/booklist_sample.csv') do |row|
   Booklist.create(:isbn => row[0], :name => row[1], :place => row[2], :room => row[3], :shelf => row[4], :acquired_at => row[5], :checked_at => row[6], :borrowed_by => row[7])
end
