require "rubygems"
require "sqlite3"
require "matrix"
require "priority_queue"


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
		self
	end

	def show
		puts [self.column_size, self.row_size].inspect
		for col in 0..self.column_size - 1
			for row in 0..self.row_size - 1
				print self[row, col] == nil ? "n" : self[row, col]
				print "  "
			end
			puts
		end
		self
	end

	def mirror_diagonal
		self.fold
		for col in 0..self.column_size - 1
			for row in 0..self.row_size - 1
				self[col, row] /= 2.0
			end
		end
		self
	end

	def zero_diagonal
		for col in 0..self.column_size - 1
			self[col, col] = 0
		end
		self
	end

	def flip
		m = self.flatten.max + 1
		for col in 0..self.column_size - 1
			for row in 0..self.row_size - 1
				next if self[col, row] == 0
				self[col, row] -= m
				self[col, row] *= -1
			end
		end
		self
	end

	def flatten
		arr = []
		for col in 0..self.column_size - 1
			for row in 0..self.row_size - 1
				arr << self[col, row]
			end
		end
		arr
	end
end

class Array
    def sum
      self.reduce(0) { |accum, i| accum + i }
    end

    def mean
      self.sum / self.length.to_f
    end

    def sample_variance
      m = self.mean
      sum = self.reduce(0) { |accum, i| accum + (i - m) ** 2 }
      sum / self.length.to_f
    end

    def sd
      Math.sqrt(self.sample_variance)
    end
end

module Avsd
	class Avsd
		def initialize(records)
			@labels = records.flatten.uniq
			@co_mat = Matrix.unit(labels.length)
			self.band_matrix records
			self.g_short_mat
		end

		def band label1, label2
			@co_mat[@labels.index(label1), @labels.index(label2)] += 1
		end

		def band_matrix records
			@labels.each do |label_a|
				records.each do |record|
					if record.include? label_a
						record.each do |label_b|
							band(label_a, label_b)
						end
					end
				end
			end
			@co_mat.mirror_diagonal.zero_diagonal
		end

		def g_short_mat
			@short_mat = Matrix.zero(@co_mat.column_size)
			@short_mat = @short_mat.collect { |x| x = nil }
			for s_id in 0..@co_mat.column_size - 1
				q = PriorityQueue.new
				q[s_id] = 0
				while not q.empty?
					f = q.delete_min
					@short_mat[s_id, f[0]] = f[1]
					@short_mat.inspect
					@co_mat.row(f[0]).each_with_index do |val, i|
						next if i == f[0] or val == 0 or @short_mat[s_id, i] != nil
						if q[i] == nil or q[i] < f[1] + val
							q[i] = f[1] + val
						end
					end
				end
			end
		end

		def sample num
			arr = Array.new(@short_mat.column_size) { |idx| idx }
			set = arr.sample num
			arr = []
			set.length.times do |i|
				for k in i + 1..set.length - 1
					arr << [set[i], set[k]]
				end
			end
			sampled_labels = Hash.new
			set.each do |id|
				sampled_labels[@labels[id]] = id
			end
			vals = []
			arr.each do |id_set|
				vals << @short_mat[id_set[0], id_set[1]]
			end
			[sampled_labels, vals, vals.mean, vals.sd].inspect
		end

		attr_accessor :short_mat, :co_mat, :labels
	end

end


# avsd = Avsd::Avsd.new [['carotte','potate','beaf','curry paste'],['beaf','potates','oregano'],['oregano', 'tomato', 'garlic']]
# puts avsd.sample 3
