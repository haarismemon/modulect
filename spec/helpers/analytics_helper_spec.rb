require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the AnalyticsHelper. For example:
#
# describe AnalyticsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe AnalyticsHelper, type: :helper do
  # fixtures :uni_modules

  describe '#is_number?' do
    context 'when passed an integer' do
      it 'evaluates to true' do
        expect(helper.is_number?(10)).to eq true
      end
      context 'when passed a float' do
        it 'evaluates to true' do
          expect(helper.is_number?(5.5)).to eq true
        end
      end
      context 'when not passed a number' do
        it 'evaluates to false' do
          expect(helper.is_number?('string')).to eq false
        end
      end
    end
  end

  describe '#get_review_modules_analytics' do
    context "when parsing visited modules data" do
      # let! (:prp) { uni_modules(:prp) }
      # let! (:uni_module_log) { UniModuleLog.create(counter: 2, uni_module: prp)}
      # let! (:pra) { uni_modules(:pra)}
      # let! (:uni_module_log2) { UniModuleLog.create(counter: 1, uni_module: pra)}

      it "orders the modules in descending order of visits" do
        all_data = helper.get_all_data(UniModule.all, User.all, Tag.all, "any", "all_time")
        visited_modules_data = all_data['visited_modules']

        first_module_to_visits = visited_modules_data.first
        first_module = first_module_to_visits.first
        first_module_visits = first_module_to_visits.second

        expect(first_module).to eq prp
        expect(first_module_visits).to eq 2

        second_module_to_visits = visited_modules_data.second
        second_module = second_module_to_visits.first
        second_module_visits = second_module_to_visits.second

        expect(second_module).to eq pra
        expect(second_module_visits).to eq 1
      end
    end

  end
end
