class Student

  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    DB[:conn].execute("SELECT * FROM students").map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    results = DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end
    results[0]
  end

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(num)
    sql = "SELECT * FROM students WHERE grade = 10"
    results = DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
    results[0...num]
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10"
    results = DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
    results[0]
  end

  def self.all_students_in_grade_X(grade)
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql, grade).map do |row|
      self.new_from_db(row)
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
