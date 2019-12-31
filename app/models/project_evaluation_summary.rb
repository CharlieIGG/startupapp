# frozen_string_literal: true

# == Schema Information
#
# Table name: project_evaluation_summaries
#
#  id                    :bigint           not null, primary key
#  average               :float
#  evaluation_program_id :bigint           not null
#  project_id            :bigint           not null
#  program_start         :date
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  timestamp             :datetime
#  scores                :jsonb
#


#
# This class depicts the track record for a Project in any given EvaluationProgram
#
class ProjectEvaluationSummary < ApplicationRecord
  belongs_to :evaluation_program
  belongs_to :project
  has_many :evaluation_scores

  validates_numericality_of :average, less_than_or_equal_to: 100,
                                      greater_than_or_equal_to: 0

  def calculate_average
    return if evaluation_scores.empty?

    score = evaluation_scores.reload.sum(:total) / evaluation_scores.count
    self.average = score
    score
  end

  def calculate_average!
    update(average: calculate_average)
  end
end