# -*- coding: utf-8 -*-
require 'open-uri'
require 'json'

# Booklist Controller
class BooklistController < ApplicationController
  # Before filter
  before_filter :authenticate

  # /booklist/
  def index
    @booklists = Booklist.all
    @updated = Booklist.find(:all, :order => "updated_at DESC", :limit => 10) # Last updated books
  end
  
  # /booklist/:id
  def show
    @booklist = Booklist.find(params[:id])
    # Get bookinfo corresponding the book in library
    @bookinfo = Bookinfo.find(:first, :conditions => {:isbn => @booklist.isbn})
  end

  # /booklist/new
  def new
    @booklist = Booklist.new
  end

  # /booklist/edit/:id
  def edit
    @booklist = Booklist.find(params[:id])
  end

  # /booklist/create
  def create  
    Rails.logger.debug('booklist:')
    Rails.logger.debug(params[:booklist])
    @booklist = Booklist.new(params[:booklist])
    
    # Get information of books and add it into Bookinfo model
    begin
      @item = getBookInfo(@booklist.isbn)

      @bookinfo = Bookinfo.new({"isbn" => @item["isbn"], "title" => @item["title"], "titleKana" => @item["titleKana"], "subTitle" => @item["subTitle"], "subTitleKana" => @item["subTitleKana"], "seriesName" => @item["seriesName"], "seriesNameKana" => @item["seriesNameKana"], "publisherName" => @item["publisherName"], "listPrice" => @item["listPrice"], "salesDate" => @item["salesDate"], "itemCaption" => @item["itemCaption"], "largeImageUrl" => @item["largeImageUrl"]})
      @bookinfo.save
      
      if @item["title"]
        @booklist.name = @item["title"] # The name of booklist is the same as the title of book
      end
    rescue

    end

    # Add the library information
    if @booklist.save  
      redirect_to :controller => "booklist", :action => "new", :notice => '蔵書の新規登録を行いました．'
    else
      render :controller => "booklist", :action =>"new"
    end  
  end  

  def confirm
    @booklist = Booklist.new(params[:booklist])
    
    @item = getBookInfo(@booklist.isbn)

    @bookinfo = Bookinfo.new({"isbn" => @item["isbn"], "title" => @item["title"], "titleKana" => @item["titleKana"], "subTitle" => @item["subTitle"], "subTitleKana" => @item["subTitleKana"], "seriesName" => @item["seriesName"], "seriesNameKana" => @item["seriesNameKana"], "publisherName" => @item["publisherName"], "listPrice" => @item["listPrice"], "salesDate" => @item["salesDate"], "itemCaption" => @item["itemCaption"], "largeImageUrl" => @item["largeImageUrl"]}) if @item

  end

  # /booklist/update
  def update
    @booklist = Booklist.find(params[:id])

    # Get information of books and add it into Bookinfo model
    begin
      @item = getBookInfo(@booklist.isbn)

      @bookinfo = Bookinfo.new({"isbn" => @item["isbn"], "title" => @item["title"], "titleKana" => @item["titleKana"], "subTitle" => @item["subTitle"], "subTitleKana" => @item["subTitleKana"], "seriesName" => @item["seriesName"], "seriesNameKana" => @item["seriesNameKana"], "publisherName" => @item["publisherName"], "listPrice" => @item["listPrice"], "salesDate" => @item["salesDate"], "itemCaption" => @item["itemCaption"], "largeImageUrl" => @item["largeImageUrl"]})
      @bookinfo.save
    rescue

    end

    # Update the library information
    if @booklist.update_attributes(params[:booklist])
      redirect_to :controller => "booklist", :action => "edit", :notice => '蔵書の情報変更を行いました．'
    else
      render :controller => "booklist", :action => "edit"
    end
  end

  # /booklist/destroy
  def destroy
    @booklist = Booklist.find(params[:id])
    @booklist.destroy
  end

  # /booklist/search
  def search

  end

  # /booklist/result
  def result
    # Queries
    @isbn = params[:isbn]
    @name = params[:name]
    @place = params[:place]
    @room = params[:room]
    @shelf = params[:shelf]
    @acquired_at = params[:acquired_at]
    @borrowed_by = params[:borrowed_by]
    
    # Search (If each parameter is '', system regards it as wild card)
    @result = Booklist.find_by_sql(["select * from booklists where (isbn = :isbn or :isbn = '') and (name like :name or :name like '') and (place like :place or :place like '') and (room like :room or :room like '') and (shelf like :shelf or :shelf like '') and (acquired_at = :acquired_at or :acquired_at = '') and (borrowed_by = :borrowed_by or :borrowed_by = '')", :isbn => @isbn, :name => '%' + @name + '%', :place => '%' + @place + '%', :room => '%' + @room + '%', :shelf => '%' + @shelf + '%', :acquired_at => @acquired_at, :borrowed_by => @borrowed_by])  
  end

  private
  # If you do not login, it redirects to the login page
  def authenticate
    @session = session[:user_id]

    if @session == nil
      redirect_to :controller => "sessions", :action => "index"
      return
    end
  end

  # Call "楽天ブックス書籍検索API2" and get information of books as JSON
  def getBookInfo(isbn) 
    url = 'https://app.rakuten.co.jp/services/api/BooksBook/Search/20130522?format=json&applicationId=1075347747100807178&isbn=' + isbn
    
    logger.debug(url)
    json = JSON.load(open(url, proxy: "http://proxy.kuins.net:8080/"))
    logger.debug(json.inspect)
    if json['Items'].empty?
      return nil
    else
      logger.debug(json["Items"][0]["Item"])
      return json["Items"][0]["Item"]
    end
  end

end
