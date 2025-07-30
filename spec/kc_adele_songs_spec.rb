# frozen_string_literal: true

RSpec.describe GoogleSerp do
  describe 'Knowledge Card Adele Songs' do
    before :all do
      @data = GoogleSerp.parse('files/extra_results/adele_songs.html').images
      @expected_data = JSON.parse(File.read('files/extra_results/adele_songs_expected_array.json'))
    end

    it 'output matches' do
      @expected_data.zip(@data).each do |p1, p2|
        expect(p2.name).to eq(p1['name'])
        expect(p2.extensions).to eq(p1['extensions'])
        expect(p2.link).to eq(p1['link'])
        expect(p2.image).to eq(p1['image'])
      end
    end

    it 'name' do
      expect(@data[0].name).to be_a(String)
      expect(@data[0].name).to_not be_empty
    end

    it 'extensions' do
      expect(@data[0].extensions).to be_a(Array)
      expect(@data[0].extensions).to_not be_empty
    end

    it 'link' do
      expect(@data[0].link).to be_a(String)
      expect(@data[0].link).to_not be_empty
    end

    it 'image' do
      expect(@data[0].image).to be_a(String)
      expect(@data[0].image).to_not be_empty
    end
  end
end
