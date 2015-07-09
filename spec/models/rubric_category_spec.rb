# == Schema Information
#
# Table name: rubric_categories
#
#  id          :integer          not null, primary key
#  rubric_id   :integer          not null
#  category_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe RubricCategory, type: :model do
  let( :rubric_category ) { create( :rubric_category ) }

  it "has a valid factory" do
    expect( rubric_category ).to be_valid
  end
  
  it "is invalid without a rubric" do
    rubric_category.rubric = nil
    rubric_category.valid?
    expect( rubric_category.errors[:rubric] ).to include( "can't be blank" )
  end

  it "is invalid without a category" do
    rubric_category.category = nil
    rubric_category.valid?
    expect( rubric_category.errors[:category] ).to include( "can't be blank" )
  end

  it "is invalid without a unique rubric category combination" do
    dup_rubric_category = build( :rubric_category, rubric: rubric_category.rubric, category: rubric_category.category )
    dup_rubric_category.valid?
    expect( dup_rubric_category.errors[:rubric] ).to include( "has already been taken" )
  end
end
