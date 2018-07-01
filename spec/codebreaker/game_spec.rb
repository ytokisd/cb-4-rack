require 'spec_helper'

module Codebreaker
  RSpec.describe Game do

    describe '#initialize' do

      it 'generates secret code' do
        expect(subject.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it 'generates 4 numbers secret code' do
        expect(subject.instance_variable_get(:@secret_code).size).to eq(4)
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(subject.instance_variable_get(:@secret_code)).to match(/^[1-6]+$/)
      end
    end

    describe '#check_attempt' do
      secret_code = '1234'

      context "When secret code equal #{secret_code}" do

        before do
          subject.instance_variable_set(:@secret_code, secret_code)
        end
        [
          [ '1234', '++++' ], [ '4321', '----' ], [ '1122', '+-' ], [ '6461', '--' ],
          [ '3312', '---' ], [ '5665', '' ], [ '6665', '' ], [ '5134', '++-' ],
        ].each do |node|
          it "answer is #{node[0]}, codebreaker returns \"#{node[1]}\"" do
            expect(subject.check_attempt(node[0])).to eq(node[1])
          end
        end
      end

      secret_code2 = '4233'
      context "When secret code equal #{secret_code2}" do

        before do
          subject.instance_variable_set(:@secret_code, secret_code2)
        end
        [
            [ '4233', '++++' ], [ '3324', '----' ], [ '1122', '-' ], [ '6461', '-' ],
            [ '3312', '---' ], [ '5665', '' ], [ '6665', '' ], [ '5134', '+-' ],
        ].each do |node|
          it "answer is #{node[0]}, codebreaker returns \"#{node[1]}\"" do
            expect(subject.check_attempt(node[0])).to eq(node[1])
          end
        end
      end
    end

    describe '#take_hint' do
      secret_code = '4635'
      context "when secret code equal #{secret_code}" do
        before do
          subject.instance_variable_set(:@secret_code, secret_code)
        end
        it { expect(secret_code[0]).to eq(subject.take_hint) }
      end
    end

  end
end
