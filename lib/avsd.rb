require "avsd/version"
require "rubygems"
require "sqlite3"
require "matrix"

module Avsd
	def self.hello
		puts 'hello'
	end
end

class Matrix
	def []=(i, j, x)
	@rows[i][j] = x
	end

	def fold
		for col in 0..self.column_size - 1
			for row in col..self.row_size - 1
				sum = self[row, col] + self[col, row]
				self[row, col] = sum
				self[col, row] = sum
			end
		end
	end
end

# class Avsd
# 	include Avsd
# 	cooccurance_matrix = all_record.unique_words.g_matrix.band
# 	dist_matrix = cooccurance_matrix.dik_matrix
# 	sample dist_matrix, 3
# end

class Labeled_matrix
	def initialize(labels)
		@labels = labels
		@mat = Matrix.unit(labels.length)
	end

	def band label1, label2
		@mat[@labels.index(label1), @labels.index(label2)] += 1
	end

	attr_accessor :mat, :labels
end

def all_record
	# db = SQLite3::Database.new("database.db")
	[[2,4,6],[2,2,4],[2,1,3,4,5],[2,3,4],[3]]
end

def unique_labels
	all_record.flatten.uniq
end

def g_matrix
	Labeled_matrix.new unique_labels
end


def band_matrix labeled_mat, all_record
	labeled_mat.labels.each do |label|
		all_record.each do |record|
			if record.include? label
				record.each do |tar_label|
					labeled_mat.band(label, tar_label)
				end
			end
		end
	end
	labeled_mat.fold
end


mat = Matrix.unit(5)
for row in 0..mat.row_size-1
	for col in 0..mat.row_size-1
		mat[row, col] = 1
	end
end
mat.fold
puts mat

