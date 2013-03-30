require 'spec_helper'

describe SoftDelete::Archivable do
  describe "when the model object matches the condition for soft delete" do
    subject(:soft_deletable_object) { User.create(:name => 'Foo') }

    describe "when the object is not destroyed" do
      it "should be able to find the user" do
        User.find(soft_deletable_object.id).should_not be_nil
      end
    end

    describe "when the object is destroyed" do
      it "should not be able to find the object" do
        soft_deletable_object.destroy
        expect { User.find(soft_deletable_object.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end

      it "should still keep the record in the database" do
        soft_deletable_object.destroy
        User.unscoped.where(:id => soft_deletable_object.id).first.should_not be_nil
      end

      it "should return true" do
        soft_deletable_object.destroy.should be_true
      end
    end
  end

  describe "when the model object does not match the condition for soft delete" do
    subject(:hard_deletable_object) { User.create(:name => 'Bar') }

    describe "when the object is destroyed" do
      it "should not be able to find the object" do
        hard_deletable_object.destroy
        expect { User.find(hard_deletable_object.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end

      it "should permanently remove the object from the database" do
        hard_deletable_object.destroy
        User.unscoped.where(:id => hard_deletable_object.id).first.should be_nil
      end

      it "should return true" do
        hard_deletable_object.destroy.should be_true
      end
    end
  end
end
