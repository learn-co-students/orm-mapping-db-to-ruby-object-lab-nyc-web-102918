class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2].to_i
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    all_students = []
    all_rows = DB[:conn].execute("SELECT * FROM students;")
    all_rows.each do |row|
      all_students << Student.new_from_db(row)
    end
    all_students
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
    SQL

    student_row = DB[:conn].execute(sql, name).flatten
    Student.new_from_db(student_row)
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

  def self.all_students_in_grade_9
    Student.all.select do |student|
      student.grade == 9
    end
  end

  def self.students_below_12th_grade
    Student.all.select do |student|
      student.grade < 12
    end
  end

  def self.first_student_in_grade_10
    Student.all.find do |student|
      student.grade == 10
    end
  end

  def self.all_students_in_grade_X(grade)
    Student.all.select do |student|
      student.grade == grade
    end
  end

  def self.first_X_students_in_grade_10(number_of_students)
    grade_10 = Student.all.select do |student|
      student.grade == 10
    end
    grade_10[0...number_of_students]
  end
end
