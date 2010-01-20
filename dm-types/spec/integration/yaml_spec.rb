require 'spec_helper'

try_spec do

  require './spec/fixtures/person'
  require './spec/fixtures/invention'

  describe DataMapper::Types::Fixtures::Person do
    before :all do
      @resource = DataMapper::Types::Fixtures::Person.new(:name => '')
    end

    describe 'with no inventions information' do
      before :all do
        @resource.inventions = nil
      end

      describe 'when dumped and loaded again' do
        before :all do
          @resource.save.should be_true
          @resource.reload
        end

        it 'has nil inventions list' do
          @resource.inventions.should be_nil
        end
      end
    end

    describe 'with a few items on the inventions list' do
      before :all do
        @input = [ 'carbon telephone transmitter', 'light bulb', 'electric grid' ].map do |name|
          DataMapper::Types::Fixtures::Invention.new(name)
        end
        @resource.inventions = @input
      end

      describe 'when dumped and loaded again' do
        before :all do
          @resource.save.should be_true
          @resource.reload
        end

        it 'loads inventions list to the state when it was dumped/persisted with keys being strings' do
          @resource.inventions.should == @input
        end
      end

      pending 'when the list is changed after load' do
        before :all do
          @resource.save.should be_true
          @resource.reload
          @starting_list = @resource.inventions.dup
          @tesla_coil = DataMapper::Types::Fixtures::Invention.new('tesla coil')
          @resource.inventions.push @tesla_coil
        end

        it 'detects changes and saves them' do
          @resource.save.should be_true
          @resource.reload
          @resource.inventions.should == @starting_list + [@tesla_coil]
        end
      end
    end

    describe 'with inventions information given as empty list' do
      before :all do
        @resource.inventions = []
      end

      describe 'when dumped and loaded again' do
        before :all do
          @resource.save.should be_true
          @resource.reload
        end

        it 'has empty inventions list' do
          @resource.inventions.should == []
        end
      end
    end
  end
end
