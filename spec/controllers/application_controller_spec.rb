# encoding : utf-8
require 'rails_helper'

describe ApplicationController do

  describe '#select2_fix' do
    context 'when it gets a full string of ids' do``
      it "returns array without '|' character" do
        expect(controller.select2_fix("|,2,3,4,5")).to eq ["2","3","4","5"]
      end
    end
    context 'when it gets an empty string' do
      it "returns array without '|' character" do
        expect(controller.select2_fix("|")).to eq []
      end
    end
  end

end
