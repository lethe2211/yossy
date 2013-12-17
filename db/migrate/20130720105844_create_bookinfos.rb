class CreateBookinfos < ActiveRecord::Migration
  def change
    create_table :bookinfos do |t|
      t.string :isbn
      t.string :title
      t.string :titleKana
      t.string :subTitle
      t.string :subTitleKana
      t.string :seriesName
      t.string :seriesNameKana
      t.string :publisherName
      t.string :listPrice
      t.string :salesDate
      t.string :itemCaption
      t.string :largeImageUrl

      t.timestamps
    end
  end
end
