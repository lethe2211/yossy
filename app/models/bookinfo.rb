# -*- coding: utf-8 -*-
# Bookinfo model
class Bookinfo < ActiveRecord::Base
  # One-to-many relationship between booklist and bookinfo
  has_many :bookinfo

  attr_accessible :isbn, :itemCaption, :largeImageUrl, :listPrice, :publisherName, :salesDate, :seriesName, :seriesNameKana, :subTitle, :subTitleKana, :title, :titleKana

  # Validation (You must add or update record where the length of "isbn" is 10 or 13)
  validates_format_of :isbn, with: /^[0-9]{10}$|^[0-9]{13}$/, :message => "は10桁か13桁の数字です．"
end
