class DepartmentCourse {
  final String code;
  final String name;
  final double credits;
  final int semester;

  const DepartmentCourse({
    required this.code,
    required this.name,
    required this.credits,
    required this.semester,
  });
}

class Department {
  final String id;
  final String name;
  final String nameEn;
  final String faculty;
  final String facultyEn;
  final List<DepartmentCourse> courses;

  const Department({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.faculty,
    required this.facultyEn,
    required this.courses,
  });
}

class DepartmentData {
  static const List<Department> departments = [
    // ══════════════════════════════════════════════════════
    // MÜHENDİSLİK FAKÜLTESİ
    // ══════════════════════════════════════════════════════

    // ── Bilgisayar Mühendisliği (CNG) ──
    Department(
      id: 'cng',
      name: 'Bilgisayar Mühendisliği',
      nameEn: 'Computer Engineering',
      faculty: 'Mühendislik Fakültesi',
      facultyEn: 'Faculty of Engineering',
      courses: [
        // 1. Dönem
        DepartmentCourse(code: 'MAT 119', name: 'Calculus with Analytic Geometry', credits: 5, semester: 1),
        DepartmentCourse(code: 'PHY 105', name: 'General Physics I', credits: 4, semester: 1),
        DepartmentCourse(code: 'CNG 111', name: 'Introduction to Comp. Engineering Concepts', credits: 4, semester: 1),
        DepartmentCourse(code: 'CHM 107', name: 'General Chemistry', credits: 4, semester: 1),
        DepartmentCourse(code: 'ENGL 101', name: 'Development of Reading and Writing Skills I', credits: 4, semester: 1),
        // 2. Dönem
        DepartmentCourse(code: 'MAT 120', name: 'Calculus for Functions of Several Variables', credits: 5, semester: 2),
        DepartmentCourse(code: 'PHY 106', name: 'General Physics II', credits: 4, semester: 2),
        DepartmentCourse(code: 'CNG 140', name: 'C Programming', credits: 4, semester: 2),
        DepartmentCourse(code: 'MAT 260', name: 'Basic Linear Algebra', credits: 3, semester: 2),
        DepartmentCourse(code: 'ENGL 102', name: 'Development of Reading and Writing Skills II', credits: 4, semester: 2),
        // 3. Dönem
        DepartmentCourse(code: 'MAT 219', name: 'Differential Equations', credits: 4, semester: 3),
        DepartmentCourse(code: 'EEE 281', name: 'Electrical Circuits', credits: 4, semester: 3),
        DepartmentCourse(code: 'CNG 213', name: 'Data Structures', credits: 4, semester: 3),
        DepartmentCourse(code: 'CNG 223', name: 'Discrete Computational Structures', credits: 3, semester: 3),
        DepartmentCourse(code: 'ENGL 211', name: 'Academic Oral Presentation Skills', credits: 3, semester: 3),
        // 4. Dönem
        DepartmentCourse(code: 'STAS 221', name: 'Statistics for Engineers I', credits: 3, semester: 4),
        DepartmentCourse(code: 'CNG 242', name: 'Programming Language Concepts', credits: 4, semester: 4),
        DepartmentCourse(code: 'CNG 280', name: 'Formal Languages and Abstract Machines', credits: 3, semester: 4),
        DepartmentCourse(code: 'CNG 232', name: 'Logic Design', credits: 4, semester: 4),
        // 5. Dönem
        DepartmentCourse(code: 'CNG 315', name: 'Algorithms', credits: 3, semester: 5),
        DepartmentCourse(code: 'CNG 331', name: 'Computer Organization', credits: 3, semester: 5),
        DepartmentCourse(code: 'CNG 351', name: 'Data Management and File Structures', credits: 3, semester: 5),
        DepartmentCourse(code: 'ENGL 311', name: 'Advanced Communication Skills', credits: 3, semester: 5),
        // 6. Dönem
        DepartmentCourse(code: 'CNG 336', name: 'Introduction to Embedded Systems Development', credits: 4, semester: 6),
        DepartmentCourse(code: 'CNG 334', name: 'Introduction to Operating Systems', credits: 3, semester: 6),
        DepartmentCourse(code: 'CNG 384', name: 'Signals and Systems for Computer Engineers', credits: 3, semester: 6),
        DepartmentCourse(code: 'CNG 350', name: 'Software Engineering', credits: 3, semester: 6),
        // 7. Dönem
        DepartmentCourse(code: 'CNG 491', name: 'Senior Project and Seminar: Design', credits: 3, semester: 7),
        DepartmentCourse(code: 'CNG 435', name: 'Data Communications and Networking', credits: 3, semester: 7),
        // 8. Dönem
        DepartmentCourse(code: 'CNG 492', name: 'Senior Project and Seminar: Implementation', credits: 3, semester: 8),
      ],
    ),

    // ── Elektrik-Elektronik Mühendisliği (EEE) ──
    Department(
      id: 'eee',
      name: 'Elektrik-Elektronik Mühendisliği',
      nameEn: 'Electrical & Electronics Engineering',
      faculty: 'Mühendislik Fakültesi',
      facultyEn: 'Faculty of Engineering',
      courses: [
        // 1. Dönem
        DepartmentCourse(code: 'MAT 119', name: 'Calculus with Analytic Geometry', credits: 5, semester: 1),
        DepartmentCourse(code: 'PHY 105', name: 'General Physics I', credits: 4, semester: 1),
        DepartmentCourse(code: 'CHM 107', name: 'General Chemistry', credits: 4, semester: 1),
        DepartmentCourse(code: 'ENGL 101', name: 'Development of Reading and Writing Skills I', credits: 4, semester: 1),
        // 2. Dönem
        DepartmentCourse(code: 'MAT 120', name: 'Calculus for Functions of Several Variables', credits: 5, semester: 2),
        DepartmentCourse(code: 'PHY 106', name: 'General Physics II', credits: 4, semester: 2),
        DepartmentCourse(code: 'CNG 230', name: 'Introduction to C Programming', credits: 3, semester: 2),
        DepartmentCourse(code: 'MAT 260', name: 'Basic Linear Algebra', credits: 3, semester: 2),
        DepartmentCourse(code: 'ENGL 102', name: 'Development of Reading and Writing Skills II', credits: 4, semester: 2),
        // 3. Dönem
        DepartmentCourse(code: 'MAT 219', name: 'Differential Equations', credits: 4, semester: 3),
        DepartmentCourse(code: 'EEE 201', name: 'Circuits Theory I', credits: 5, semester: 3),
        DepartmentCourse(code: 'CNG 301', name: 'Algorithms and Data Structures', credits: 3, semester: 3),
        DepartmentCourse(code: 'ENGL 211', name: 'Academic Oral Presentation Skills', credits: 3, semester: 3),
        // 4. Dönem
        DepartmentCourse(code: 'EEE 224', name: 'Electromagnetic Theory', credits: 4, semester: 4),
        DepartmentCourse(code: 'EEE 202', name: 'Circuits Theory II', credits: 5, semester: 4),
        DepartmentCourse(code: 'EEE 212', name: 'Semiconductor Devices and Modeling', credits: 3, semester: 4),
        DepartmentCourse(code: 'EEE 248', name: 'Logic Design', credits: 4, semester: 4),
        // 5. Dönem
        DepartmentCourse(code: 'EEE 361', name: 'Electromechanical Energy Conversion', credits: 4, semester: 5),
        DepartmentCourse(code: 'EEE 303', name: 'Electromagnetic Waves', credits: 3, semester: 5),
        DepartmentCourse(code: 'EEE 301', name: 'Signals and Systems I', credits: 3, semester: 5),
        DepartmentCourse(code: 'EEE 311', name: 'Electronics I', credits: 4, semester: 5),
        DepartmentCourse(code: 'ENGL 311', name: 'Advanced Communication Skills', credits: 3, semester: 5),
        // 6. Dönem
        DepartmentCourse(code: 'EEE 347', name: 'Introduction to Microprocessors', credits: 4, semester: 6),
        DepartmentCourse(code: 'EEE 302', name: 'Feedback Systems', credits: 3, semester: 6),
        DepartmentCourse(code: 'EEE 312', name: 'Electronics II', credits: 4, semester: 6),
        DepartmentCourse(code: 'EEE 330', name: 'Probability and Random Variables', credits: 3, semester: 6),
        // 7. Dönem
        DepartmentCourse(code: 'EEE 493', name: 'Engineering Design I', credits: 2, semester: 7),
        // 8. Dönem
        DepartmentCourse(code: 'EEE 494', name: 'Engineering Design II', credits: 2, semester: 8),
      ],
    ),

    // ── Makina Mühendisliği (MECH) ──
    Department(
      id: 'mech',
      name: 'Makina Mühendisliği',
      nameEn: 'Mechanical Engineering',
      faculty: 'Mühendislik Fakültesi',
      facultyEn: 'Faculty of Engineering',
      courses: [
        // 1. Dönem
        DepartmentCourse(code: 'MAT 119', name: 'Calculus with Analytic Geometry', credits: 5, semester: 1),
        DepartmentCourse(code: 'PHY 105', name: 'General Physics I', credits: 4, semester: 1),
        DepartmentCourse(code: 'CNG 230', name: 'Introduction to C Programming', credits: 3, semester: 1),
        DepartmentCourse(code: 'MECH 100', name: 'Introduction to Mechanical Engineering', credits: 1, semester: 1),
        DepartmentCourse(code: 'MECH 113', name: 'Computer Aided Engineering Drawing I', credits: 3, semester: 1),
        DepartmentCourse(code: 'ENGL 101', name: 'Development of Reading and Writing Skills I', credits: 4, semester: 1),
        // 2. Dönem
        DepartmentCourse(code: 'MAT 120', name: 'Calculus for Functions of Several Variables', credits: 5, semester: 2),
        DepartmentCourse(code: 'PHY 106', name: 'General Physics II', credits: 4, semester: 2),
        DepartmentCourse(code: 'CHM 107', name: 'General Chemistry', credits: 4, semester: 2),
        DepartmentCourse(code: 'MECH 114', name: 'Computer Aided Engineering Drawing II', credits: 3, semester: 2),
        DepartmentCourse(code: 'ENGL 102', name: 'Development of Reading and Writing Skills II', credits: 4, semester: 2),
        // 3. Dönem
        DepartmentCourse(code: 'MAT 219', name: 'Differential Equations', credits: 4, semester: 3),
        DepartmentCourse(code: 'MECH 202', name: 'Manufacturing Technologies', credits: 4, semester: 3),
        DepartmentCourse(code: 'MECH 203', name: 'Thermodynamics', credits: 4, semester: 3),
        DepartmentCourse(code: 'MECH 205', name: 'Statics', credits: 3, semester: 3),
        DepartmentCourse(code: 'MECH 227', name: 'Engineering Materials', credits: 3, semester: 3),
        // 4. Dönem
        DepartmentCourse(code: 'MAT 210', name: 'Applied Mathematics for Engineers', credits: 4, semester: 4),
        DepartmentCourse(code: 'MECH 206', name: 'Strength of Materials', credits: 3, semester: 4),
        DepartmentCourse(code: 'MECH 208', name: 'Dynamics', credits: 3, semester: 4),
        DepartmentCourse(code: 'MECH 220', name: 'Mechanical Engineering Laboratory I', credits: 3, semester: 4),
        DepartmentCourse(code: 'EEE 209', name: 'Fundamentals of Electrical and Electronics Eng.', credits: 3, semester: 4),
        DepartmentCourse(code: 'ENGL 211', name: 'Academic Oral Presentation Skills', credits: 3, semester: 4),
        // 5. Dönem
        DepartmentCourse(code: 'MECH 301', name: 'Theory of Machines', credits: 4, semester: 5),
        DepartmentCourse(code: 'MECH 305', name: 'Fluid Mechanics', credits: 4, semester: 5),
        DepartmentCourse(code: 'MECH 307', name: 'Mechanical Engineering Design', credits: 3, semester: 5),
        DepartmentCourse(code: 'MECH 310', name: 'Numerical Methods', credits: 3, semester: 5),
        DepartmentCourse(code: 'ESC 280', name: 'Engineering Economy', credits: 3, semester: 5),
        // 6. Dönem
        DepartmentCourse(code: 'MECH 303', name: 'Manufacturing Engineering', credits: 3, semester: 6),
        DepartmentCourse(code: 'MECH 304', name: 'Control Systems', credits: 3, semester: 6),
        DepartmentCourse(code: 'MECH 308', name: 'Design of Machine Elements', credits: 3, semester: 6),
        DepartmentCourse(code: 'MECH 311', name: 'Heat Transfer', credits: 4, semester: 6),
        DepartmentCourse(code: 'MECH 320', name: 'Mechanical Engineering Laboratory II', credits: 1, semester: 6),
        // 7. Dönem
        DepartmentCourse(code: 'MECH 420', name: 'Mechanical Engineering Laboratory III', credits: 2, semester: 7),
        // 8. Dönem
        DepartmentCourse(code: 'MECH 458', name: 'Graduation Design Project', credits: 3, semester: 8),
      ],
    ),

    // ── İnşaat Mühendisliği (CVE) ──
    Department(
      id: 'cve',
      name: 'İnşaat Mühendisliği',
      nameEn: 'Civil Engineering',
      faculty: 'Mühendislik Fakültesi',
      facultyEn: 'Faculty of Engineering',
      courses: [
        // 1. Dönem
        DepartmentCourse(code: 'MAT 119', name: 'Calculus with Analytic Geometry', credits: 5, semester: 1),
        DepartmentCourse(code: 'PHY 105', name: 'General Physics I', credits: 4, semester: 1),
        DepartmentCourse(code: 'CNG 230', name: 'Introduction to C Programming', credits: 3, semester: 1),
        DepartmentCourse(code: 'ENGL 101', name: 'Development of Reading and Writing Skills I', credits: 4, semester: 1),
        // 2. Dönem
        DepartmentCourse(code: 'MAT 120', name: 'Calculus for Functions of Several Variables', credits: 5, semester: 2),
        DepartmentCourse(code: 'PHY 106', name: 'General Physics II', credits: 4, semester: 2),
        DepartmentCourse(code: 'CHM 107', name: 'General Chemistry', credits: 4, semester: 2),
        DepartmentCourse(code: 'CVE 101', name: 'Computer Aided Engineering Drawing I', credits: 3, semester: 2),
        DepartmentCourse(code: 'ENGL 102', name: 'Development of Reading and Writing Skills II', credits: 4, semester: 2),
        // 3. Dönem
        DepartmentCourse(code: 'MAT 219', name: 'Differential Equations', credits: 4, semester: 3),
        DepartmentCourse(code: 'CVE 202', name: 'Surveying', credits: 3, semester: 3),
        DepartmentCourse(code: 'CVE 221', name: 'Statics', credits: 3, semester: 3),
        DepartmentCourse(code: 'CVE 241', name: 'Materials of Construction', credits: 4, semester: 3),
        // 4. Dönem
        DepartmentCourse(code: 'MAT 210', name: 'Applied Mathematics for Engineers', credits: 4, semester: 4),
        DepartmentCourse(code: 'CVE 222', name: 'Engineering Mechanics II', credits: 3, semester: 4),
        DepartmentCourse(code: 'CVE 224', name: 'Mechanics of Materials', credits: 3, semester: 4),
        DepartmentCourse(code: 'ECO 280', name: 'Engineering Economy', credits: 3, semester: 4),
        DepartmentCourse(code: 'ENGL 211', name: 'Academic Oral Presentation Skills', credits: 3, semester: 4),
        // 5. Dönem
        DepartmentCourse(code: 'CVE 303', name: 'Probability and Statistics for Civil Engineers', credits: 3, semester: 5),
        DepartmentCourse(code: 'CVE 323', name: 'Introduction to Structural Mechanics', credits: 3, semester: 5),
        DepartmentCourse(code: 'CVE 353', name: 'Transportation and Traffic Engineering', credits: 3, semester: 5),
        DepartmentCourse(code: 'CVE 363', name: 'Soil Mechanics', credits: 4, semester: 5),
        DepartmentCourse(code: 'CVE 371', name: 'Introduction to Fluid Mechanics', credits: 3, semester: 5),
        // 6. Dönem
        DepartmentCourse(code: 'CVE 332', name: 'Construction Engineering and Management', credits: 3, semester: 6),
        DepartmentCourse(code: 'CVE 366', name: 'Foundation Engineering', credits: 3, semester: 6),
        DepartmentCourse(code: 'CVE 372', name: 'Hydromechanics', credits: 4, semester: 6),
        DepartmentCourse(code: 'CVE 376', name: 'Engineering Hydrology', credits: 3, semester: 6),
        DepartmentCourse(code: 'CVE 382', name: 'Reinforced Concrete Fundamentals', credits: 3, semester: 6),
        DepartmentCourse(code: 'CVE 384', name: 'Structural Analysis', credits: 3, semester: 6),
        // 7. Dönem
        DepartmentCourse(code: 'CVE 471', name: 'Water Resources Engineering', credits: 3, semester: 7),
        DepartmentCourse(code: 'CVE 485', name: 'Design of Steel Structures', credits: 3, semester: 7),
        DepartmentCourse(code: 'ENGL 311', name: 'Advanced Communication Skills', credits: 3, semester: 7),
        // 8. Dönem
        DepartmentCourse(code: 'CVE 410', name: 'Civil Engineering Design', credits: 3, semester: 8),
      ],
    ),

    // ── Havacılık ve Uzay Mühendisliği (ASE) ──
    Department(
      id: 'ase',
      name: 'Havacılık ve Uzay Mühendisliği',
      nameEn: 'Aerospace Engineering',
      faculty: 'Mühendislik Fakültesi',
      facultyEn: 'Faculty of Engineering',
      courses: [
        // 1. Dönem
        DepartmentCourse(code: 'MAT 119', name: 'Calculus with Analytic Geometry', credits: 5, semester: 1),
        DepartmentCourse(code: 'PHY 105', name: 'General Physics I', credits: 4, semester: 1),
        DepartmentCourse(code: 'CHM 107', name: 'General Chemistry', credits: 4, semester: 1),
        DepartmentCourse(code: 'MECH 113', name: 'Computer Aided Engineering Drawing I', credits: 3, semester: 1),
        DepartmentCourse(code: 'ENGL 101', name: 'Development of Reading and Writing Skills I', credits: 4, semester: 1),
        // 2. Dönem
        DepartmentCourse(code: 'MAT 120', name: 'Calculus for Functions of Several Variables', credits: 5, semester: 2),
        DepartmentCourse(code: 'PHY 106', name: 'General Physics II', credits: 4, semester: 2),
        DepartmentCourse(code: 'CNG 230', name: 'Introduction to C Programming', credits: 3, semester: 2),
        DepartmentCourse(code: 'ASE 172', name: 'Introduction to Aircraft Performance', credits: 3, semester: 2),
        DepartmentCourse(code: 'ENGL 102', name: 'Development of Reading and Writing Skills II', credits: 4, semester: 2),
        // 3. Dönem
        DepartmentCourse(code: 'ASE 231', name: 'Thermodynamics', credits: 4, semester: 3),
        DepartmentCourse(code: 'ASE 261', name: 'Statics', credits: 3, semester: 3),
        DepartmentCourse(code: 'MECH 202', name: 'Manufacturing Technologies', credits: 4, semester: 3),
        DepartmentCourse(code: 'MECH 227', name: 'Engineering Materials', credits: 3, semester: 3),
        DepartmentCourse(code: 'MAT 219', name: 'Differential Equations', credits: 4, semester: 3),
        // 4. Dönem
        DepartmentCourse(code: 'ASE 244', name: 'Fluid Mechanics', credits: 4, semester: 4),
        DepartmentCourse(code: 'ASE 262', name: 'Dynamics', credits: 3, semester: 4),
        DepartmentCourse(code: 'ASE 264', name: 'Mechanics of Materials', credits: 4, semester: 4),
        DepartmentCourse(code: 'MAT 210', name: 'Applied Mathematics for Engineers', credits: 4, semester: 4),
        DepartmentCourse(code: 'EEE 209', name: 'Fundamentals of Electrical and Electronics Eng.', credits: 3, semester: 4),
        DepartmentCourse(code: 'ENGL 211', name: 'Academic Oral Presentation Skills', credits: 3, semester: 4),
        // 5. Dönem
        DepartmentCourse(code: 'ASE 331', name: 'Heat Transfer', credits: 3, semester: 5),
        DepartmentCourse(code: 'ASE 341', name: 'Aerodynamics I', credits: 4, semester: 5),
        DepartmentCourse(code: 'ASE 361', name: 'Applied Elasticity', credits: 3, semester: 5),
        DepartmentCourse(code: 'ASE 383', name: 'System Dynamics', credits: 3, semester: 5),
        DepartmentCourse(code: 'MECH 310', name: 'Numerical Methods', credits: 3, semester: 5),
        // 6. Dönem
        DepartmentCourse(code: 'ASE 301', name: 'Numerical Methods for Aerospace Engineering', credits: 3, semester: 6),
        DepartmentCourse(code: 'ASE 334', name: 'Propulsion Systems I', credits: 4, semester: 6),
        DepartmentCourse(code: 'ASE 342', name: 'Aerodynamics II', credits: 4, semester: 6),
        DepartmentCourse(code: 'ASE 362', name: 'Aerospace Structures', credits: 4, semester: 6),
        DepartmentCourse(code: 'ASE 372', name: 'Flight Mechanics', credits: 3, semester: 6),
        // 7. Dönem
        DepartmentCourse(code: 'ASE 435', name: 'Propulsion Systems II', credits: 3, semester: 7),
        DepartmentCourse(code: 'ASE 451', name: 'Aeronautical Engineering Design', credits: 3, semester: 7),
        DepartmentCourse(code: 'ASE 463', name: 'Mechanical Vibrations', credits: 3, semester: 7),
      ],
    ),

    // ── Kimya Mühendisliği (CHME) ──
    Department(
      id: 'chme',
      name: 'Kimya Mühendisliği',
      nameEn: 'Chemical Engineering',
      faculty: 'Mühendislik Fakültesi',
      facultyEn: 'Faculty of Engineering',
      courses: [
        // 1. Dönem
        DepartmentCourse(code: 'MAT 119', name: 'Calculus with Analytic Geometry', credits: 5, semester: 1),
        DepartmentCourse(code: 'PHY 105', name: 'General Physics I', credits: 4, semester: 1),
        DepartmentCourse(code: 'CHM 111', name: 'General Chemistry I', credits: 4, semester: 1),
        DepartmentCourse(code: 'MECH 113', name: 'Computer Aided Engineering Drawing I', credits: 3, semester: 1),
        DepartmentCourse(code: 'ENGL 101', name: 'Development of Reading and Writing Skills I', credits: 4, semester: 1),
        // 2. Dönem
        DepartmentCourse(code: 'MAT 120', name: 'Calculus for Functions of Several Variables', credits: 5, semester: 2),
        DepartmentCourse(code: 'PHY 106', name: 'General Physics II', credits: 4, semester: 2),
        DepartmentCourse(code: 'CHM 112', name: 'General Chemistry II', credits: 4, semester: 2),
        DepartmentCourse(code: 'CNG 230', name: 'Introduction to C Programming', credits: 3, semester: 2),
        DepartmentCourse(code: 'ENGL 102', name: 'Development of Reading and Writing Skills II', credits: 4, semester: 2),
        DepartmentCourse(code: 'CHME 102', name: 'Introduction to Chemical Engineering', credits: 1, semester: 2),
        // 3. Dönem
        DepartmentCourse(code: 'CHME 203', name: 'Chemical Process Calculations', credits: 4, semester: 3),
        DepartmentCourse(code: 'MAT 219', name: 'Differential Equations', credits: 4, semester: 3),
        DepartmentCourse(code: 'CHM 237', name: 'Organic Chemistry I', credits: 4, semester: 3),
        DepartmentCourse(code: 'ENGL 211', name: 'Academic Oral Presentation Skills', credits: 3, semester: 3),
        // 4. Dönem
        DepartmentCourse(code: 'CHME 204', name: 'Thermodynamics I', credits: 4, semester: 4),
        DepartmentCourse(code: 'MAT 210', name: 'Applied Mathematics for Engineers', credits: 4, semester: 4),
        DepartmentCourse(code: 'CHM 230', name: 'Analytical Chemistry for Engineers', credits: 4, semester: 4),
        DepartmentCourse(code: 'CHM 238', name: 'Organic Chemistry II', credits: 3, semester: 4),
        DepartmentCourse(code: 'CHME 323', name: 'Fluid Mechanics', credits: 3, semester: 4),
        // 5. Dönem
        DepartmentCourse(code: 'CHME 305', name: 'Thermodynamics II', credits: 4, semester: 5),
        DepartmentCourse(code: 'CHME 325', name: 'Heat Transfer', credits: 3, semester: 5),
        DepartmentCourse(code: 'CHM 351', name: 'Physical Chemistry', credits: 4, semester: 5),
        DepartmentCourse(code: 'ENGL 311', name: 'Advanced Communication Skills', credits: 3, semester: 5),
        // 6. Dönem
        DepartmentCourse(code: 'CHME 302', name: 'Chemical Engineering Laboratory I', credits: 2, semester: 6),
        DepartmentCourse(code: 'CHME 312', name: 'Chemical Reaction Engineering', credits: 4, semester: 6),
        DepartmentCourse(code: 'CHME 326', name: 'Mass Transfer and Separation Processes', credits: 4, semester: 6),
        DepartmentCourse(code: 'ECO 210', name: 'Principles of Economics', credits: 3, semester: 6),
        // 7. Dönem
        DepartmentCourse(code: 'CHME 401', name: 'Chemical Engineering Laboratory II', credits: 2, semester: 7),
        DepartmentCourse(code: 'CHME 417', name: 'Chemical Engineering Design I', credits: 4, semester: 7),
        // 8. Dönem
        DepartmentCourse(code: 'CHME 418', name: 'Chemical Engineering Design II', credits: 4, semester: 8),
      ],
    ),

    // ── Petrol ve Doğal Gaz Mühendisliği (PNGE) ──
    Department(
      id: 'pnge',
      name: 'Petrol ve Doğal Gaz Mühendisliği',
      nameEn: 'Petroleum & Natural Gas Engineering',
      faculty: 'Mühendislik Fakültesi',
      facultyEn: 'Faculty of Engineering',
      courses: [
        // 1. Dönem
        DepartmentCourse(code: 'MAT 119', name: 'Calculus with Analytic Geometry', credits: 5, semester: 1),
        DepartmentCourse(code: 'PHY 105', name: 'General Physics I', credits: 4, semester: 1),
        DepartmentCourse(code: 'CHM 111', name: 'General Chemistry I', credits: 4, semester: 1),
        DepartmentCourse(code: 'ENGL 101', name: 'Development of Reading and Writing Skills I', credits: 4, semester: 1),
        DepartmentCourse(code: 'MECH 113', name: 'Computer Aided Engineering Drawing', credits: 3, semester: 1),
        // 2. Dönem
        DepartmentCourse(code: 'MAT 120', name: 'Calculus for Functions of Several Variables', credits: 5, semester: 2),
        DepartmentCourse(code: 'PHY 106', name: 'General Physics II', credits: 4, semester: 2),
        DepartmentCourse(code: 'CHM 112', name: 'General Chemistry II', credits: 4, semester: 2),
        DepartmentCourse(code: 'PNGE 110', name: 'Introduction to Petroleum Engineering', credits: 2, semester: 2),
        DepartmentCourse(code: 'ENGL 102', name: 'Development of Reading and Writing Skills II', credits: 4, semester: 2),
        DepartmentCourse(code: 'CNG 240', name: 'Programming with Python for Engineers', credits: 3, semester: 2),
        // 3. Dönem
        DepartmentCourse(code: 'MAT 219', name: 'Differential Equations', credits: 4, semester: 3),
        DepartmentCourse(code: 'PNGE 201', name: 'General Geology', credits: 4, semester: 3),
        DepartmentCourse(code: 'CHME 204', name: 'Thermodynamics I', credits: 3, semester: 3),
        DepartmentCourse(code: 'PNGE 220', name: 'Rock Properties', credits: 3, semester: 3),
        DepartmentCourse(code: 'CVE 221', name: 'Statics', credits: 3, semester: 3),
        // 4. Dönem
        DepartmentCourse(code: 'MAT 210', name: 'Applied Mathematics for Engineers', credits: 4, semester: 4),
        DepartmentCourse(code: 'PNGE 218', name: 'Fluid Properties', credits: 3, semester: 4),
        DepartmentCourse(code: 'PNGE 211', name: 'Introduction to Fluid Mechanics', credits: 4, semester: 4),
        DepartmentCourse(code: 'PNGE 202', name: 'Petroleum Geology', credits: 3, semester: 4),
        DepartmentCourse(code: 'MECH 206', name: 'Mechanics of Materials', credits: 3, semester: 4),
        // 5. Dönem
        DepartmentCourse(code: 'ENGL 211', name: 'Academic Oral Presentation Skills', credits: 3, semester: 5),
        DepartmentCourse(code: 'PNGE 321', name: 'Drilling Engineering I', credits: 4, semester: 5),
        DepartmentCourse(code: 'PNGE 331', name: 'Petroleum Production Engineering I', credits: 3, semester: 5),
        DepartmentCourse(code: 'PNGE 343', name: 'Petroleum Reservoir Engineering I', credits: 3, semester: 5),
        // 6. Dönem
        DepartmentCourse(code: 'PNGE 322', name: 'Drilling Engineering II', credits: 3, semester: 6),
        DepartmentCourse(code: 'PNGE 344', name: 'Petroleum Reservoir Engineering II', credits: 3, semester: 6),
        DepartmentCourse(code: 'PNGE 352', name: 'Well Logging', credits: 3, semester: 6),
        DepartmentCourse(code: 'PNGE 332', name: 'Petroleum Production Engineering II', credits: 3, semester: 6),
        DepartmentCourse(code: 'ECO 210', name: 'Principles of Economics', credits: 3, semester: 6),
        DepartmentCourse(code: 'CVE 303', name: 'Probability and Statistics', credits: 3, semester: 6),
        // 7. Dönem
        DepartmentCourse(code: 'PNGE 417', name: 'Petroleum Engineering Design I', credits: 2, semester: 7),
        DepartmentCourse(code: 'PNGE 461', name: 'Natural Gas Engineering', credits: 3, semester: 7),
        DepartmentCourse(code: 'PNGE 411', name: 'Petroleum Property Valuation', credits: 3, semester: 7),
        // 8. Dönem
        DepartmentCourse(code: 'PNGE 418', name: 'Petroleum Engineering Design II', credits: 3, semester: 8),
        DepartmentCourse(code: 'ENGL 311', name: 'Advanced Communication Skills', credits: 3, semester: 8),
      ],
    ),

    // ── Siber Güvenlik Mühendisliği (CYG) ──
    Department(
      id: 'cyg',
      name: 'Siber Güvenlik Mühendisliği',
      nameEn: 'Cybersecurity Engineering',
      faculty: 'Mühendislik Fakültesi',
      facultyEn: 'Faculty of Engineering',
      courses: [
        // 1. Dönem
        DepartmentCourse(code: 'MAT 119', name: 'Calculus with Analytic Geometry', credits: 5, semester: 1),
        DepartmentCourse(code: 'PHY 105', name: 'General Physics I', credits: 4, semester: 1),
        DepartmentCourse(code: 'CYG 101', name: 'Cybersecurity Engineering Orientation', credits: 0, semester: 1),
        DepartmentCourse(code: 'CNG 111', name: 'Introduction to Computer Science and Programming', credits: 4, semester: 1),
        DepartmentCourse(code: 'CHM 107', name: 'General Chemistry', credits: 4, semester: 1),
        DepartmentCourse(code: 'ENGL 101', name: 'Development of Reading and Writing Skills I', credits: 4, semester: 1),
        // 2. Dönem
        DepartmentCourse(code: 'MAT 120', name: 'Calculus for Functions of Several Variables', credits: 5, semester: 2),
        DepartmentCourse(code: 'PHY 106', name: 'General Physics II', credits: 4, semester: 2),
        DepartmentCourse(code: 'CNG 140', name: 'C Programming', credits: 4, semester: 2),
        DepartmentCourse(code: 'MAT 260', name: 'Basic Linear Algebra', credits: 3, semester: 2),
        DepartmentCourse(code: 'ENGL 102', name: 'Development of Reading and Writing Skills II', credits: 4, semester: 2),
        // 3. Dönem
        DepartmentCourse(code: 'MAT 219', name: 'Introduction to Differential Equations', credits: 4, semester: 3),
        DepartmentCourse(code: 'EEE 281', name: 'Electrical Circuits', credits: 4, semester: 3),
        DepartmentCourse(code: 'CNG 213', name: 'Data Structures', credits: 4, semester: 3),
        DepartmentCourse(code: 'CNG 223', name: 'Discrete Computational Structures', credits: 3, semester: 3),
        DepartmentCourse(code: 'ENGL 211', name: 'Academic Oral Presentation Skills', credits: 3, semester: 3),
        // 4. Dönem
        DepartmentCourse(code: 'STAS 221', name: 'Statistics for Engineers I', credits: 3, semester: 4),
        DepartmentCourse(code: 'CYG 242', name: 'Object Oriented Software Development', credits: 4, semester: 4),
        DepartmentCourse(code: 'CNG 280', name: 'Formal Languages and Abstract Machines', credits: 3, semester: 4),
        DepartmentCourse(code: 'CNG 232', name: 'Logic Design', credits: 4, semester: 4),
        DepartmentCourse(code: 'CYG 202', name: 'Introduction to Cyber Security', credits: 3, semester: 4),
        // 5. Dönem
        DepartmentCourse(code: 'CNG 315', name: 'Algorithms', credits: 3, semester: 5),
        DepartmentCourse(code: 'CNG 331', name: 'Computer Organization', credits: 3, semester: 5),
        DepartmentCourse(code: 'CNG 351', name: 'Data Management and File Structures', credits: 3, semester: 5),
        DepartmentCourse(code: 'CYG 302', name: 'Fundamentals of Cryptography', credits: 3, semester: 5),
        // 6. Dönem
        DepartmentCourse(code: 'CNG 336', name: 'Introduction to Embedded Systems Development', credits: 4, semester: 6),
        DepartmentCourse(code: 'CNG 334', name: 'Introduction to Operating Systems', credits: 3, semester: 6),
        DepartmentCourse(code: 'CNG 384', name: 'Signals and Systems for Computer Engineers', credits: 3, semester: 6),
        DepartmentCourse(code: 'CYG 303', name: 'Legal, Professional and Ethical Issues in Cyber Systems', credits: 3, semester: 6),
        // 7. Dönem
        DepartmentCourse(code: 'CYG 491', name: 'Senior Project and Seminar: Design', credits: 3, semester: 7),
        DepartmentCourse(code: 'CNG 435', name: 'Data Communications and Networking', credits: 3, semester: 7),
        DepartmentCourse(code: 'CYG 460', name: 'Software Security', credits: 3, semester: 7),
        // 8. Dönem
        DepartmentCourse(code: 'CYG 492', name: 'Senior Project and Seminar II: Implementation', credits: 3, semester: 8),
        DepartmentCourse(code: 'CYG 468', name: 'Secure Programming', credits: 3, semester: 8),
      ],
    ),

    // ── Yazılım Mühendisliği (SNG) ──
    Department(
      id: 'sng',
      name: 'Yazılım Mühendisliği',
      nameEn: 'Software Engineering',
      faculty: 'Mühendislik Fakültesi',
      facultyEn: 'Faculty of Engineering',
      courses: [
        // 1. Dönem
        DepartmentCourse(code: 'MAT 119', name: 'Calculus with Analytic Geometry', credits: 5, semester: 1),
        DepartmentCourse(code: 'PHY 105', name: 'General Physics I', credits: 4, semester: 1),
        DepartmentCourse(code: 'CHM 107', name: 'General Chemistry', credits: 4, semester: 1),
        DepartmentCourse(code: 'ENGL 101', name: 'Development of Reading and Writing Skills I', credits: 4, semester: 1),
        DepartmentCourse(code: 'SNG 111', name: 'Introduction to Computer Science and Programming', credits: 4, semester: 1),
        // 2. Dönem
        DepartmentCourse(code: 'MAT 120', name: 'Calculus for Functions of Several Variables', credits: 5, semester: 2),
        DepartmentCourse(code: 'PHY 106', name: 'General Physics II', credits: 4, semester: 2),
        DepartmentCourse(code: 'MAT 260', name: 'Basic Linear Algebra', credits: 3, semester: 2),
        DepartmentCourse(code: 'ENGL 102', name: 'Development of Reading and Writing Skills II', credits: 4, semester: 2),
        DepartmentCourse(code: 'SNG 140', name: 'C Programming', credits: 4, semester: 2),
        // 3. Dönem
        DepartmentCourse(code: 'MAT 219', name: 'Differential Equations', credits: 4, semester: 3),
        DepartmentCourse(code: 'ENGL 211', name: 'Academic Oral Presentation Skills', credits: 3, semester: 3),
        DepartmentCourse(code: 'CNG 213', name: 'Data Structures', credits: 4, semester: 3),
        DepartmentCourse(code: 'CNG 223', name: 'Discrete Computational Structures', credits: 3, semester: 3),
        DepartmentCourse(code: 'SNG 201', name: 'Introduction to Software Engineering', credits: 3, semester: 3),
        // 4. Dönem
        DepartmentCourse(code: 'STAS 221', name: 'Statistics for Engineers I', credits: 3, semester: 4),
        DepartmentCourse(code: 'CNG 232', name: 'Logic Design', credits: 4, semester: 4),
        DepartmentCourse(code: 'CNG 280', name: 'Formal Languages and Abstract Machines', credits: 3, semester: 4),
        DepartmentCourse(code: 'SNG 221', name: 'Software Requirements Engineering', credits: 3, semester: 4),
        DepartmentCourse(code: 'SNG 242', name: 'Object Oriented Software Development', credits: 4, semester: 4),
        // 5. Dönem
        DepartmentCourse(code: 'ENGL 311', name: 'Advanced Communication Skills', credits: 3, semester: 5),
        DepartmentCourse(code: 'CNG 315', name: 'Algorithms', credits: 3, semester: 5),
        DepartmentCourse(code: 'CNG 331', name: 'Computer Organization', credits: 3, semester: 5),
        DepartmentCourse(code: 'CNG 351', name: 'Data Management and File Structures', credits: 3, semester: 5),
        DepartmentCourse(code: 'SNG 303', name: 'Software Project Management', credits: 3, semester: 5),
        DepartmentCourse(code: 'SNG 330', name: 'Software Design', credits: 3, semester: 5),
        // 6. Dönem
        DepartmentCourse(code: 'CNG 334', name: 'Introduction to Operating Systems', credits: 3, semester: 6),
        DepartmentCourse(code: 'SNG 341', name: 'Software Development and Evolution', credits: 4, semester: 6),
        DepartmentCourse(code: 'SNG 346', name: 'Web Application Development', credits: 3, semester: 6),
        DepartmentCourse(code: 'SNG 352', name: 'Software Quality Assurance and Testing', credits: 3, semester: 6),
        // 7. Dönem
        DepartmentCourse(code: 'CNG 435', name: 'Data Communications and Networking', credits: 3, semester: 7),
        DepartmentCourse(code: 'SNG 460', name: 'Software Security', credits: 3, semester: 7),
        DepartmentCourse(code: 'SNG 491', name: 'Software Engineering Senior Project I', credits: 4, semester: 7),
        // 8. Dönem
        DepartmentCourse(code: 'SNG 492', name: 'Software Engineering Senior Project II', credits: 3, semester: 8),
      ],
    ),

    // ── Endüstri Mühendisliği (INE) ──
    Department(
      id: 'ine',
      name: 'Endüstri Mühendisliği',
      nameEn: 'Industrial Engineering',
      faculty: 'Mühendislik Fakültesi',
      facultyEn: 'Faculty of Engineering',
      courses: [
        DepartmentCourse(code: 'INE 102', name: 'Introduction to Industrial Engineering', credits: 3, semester: 1),
        DepartmentCourse(code: 'MAT 119', name: 'Calculus with Analytic Geometry', credits: 5, semester: 1),
        DepartmentCourse(code: 'PHY 105', name: 'General Physics I', credits: 4, semester: 1),
        DepartmentCourse(code: 'ENGL 101', name: 'Development of Reading and Writing Skills I', credits: 4, semester: 1),
        DepartmentCourse(code: 'MAT 120', name: 'Calculus for Functions of Several Variables', credits: 5, semester: 2),
        DepartmentCourse(code: 'PHY 106', name: 'General Physics II', credits: 4, semester: 2),
        DepartmentCourse(code: 'ENGL 102', name: 'Development of Reading and Writing Skills II', credits: 4, semester: 2),
        DepartmentCourse(code: 'INE 241', name: 'Finance and Managerial Accounting for Engineers', credits: 3, semester: 3),
        DepartmentCourse(code: 'INE 251', name: 'Linear Programming', credits: 3, semester: 3),
        DepartmentCourse(code: 'INE 265', name: 'Introduction to Probability', credits: 3, semester: 3),
        DepartmentCourse(code: 'INE 252', name: 'Network Flows and Integer Programming', credits: 3, semester: 4),
        DepartmentCourse(code: 'INE 266', name: 'Engineering Statistics', credits: 3, semester: 4),
        DepartmentCourse(code: 'INE 323', name: 'Production and Service Operations Planning I', credits: 3, semester: 5),
        DepartmentCourse(code: 'INE 333', name: 'Work Systems Analysis and Design', credits: 3, semester: 5),
        DepartmentCourse(code: 'INE 347', name: 'Engineering Economy', credits: 3, semester: 5),
        DepartmentCourse(code: 'INE 361', name: 'Stochastic Models in Operations Research', credits: 3, semester: 5),
        DepartmentCourse(code: 'INE 324', name: 'Production and Service Operations Planning II', credits: 3, semester: 6),
        DepartmentCourse(code: 'INE 368', name: 'Quality Planning and Control', credits: 3, semester: 6),
        DepartmentCourse(code: 'INE 372', name: 'Simulation', credits: 3, semester: 6),
        DepartmentCourse(code: 'INE 404', name: 'Business Management for Engineers', credits: 3, semester: 7),
        DepartmentCourse(code: 'INE 422', name: 'Industrial Engineering Applications Seminar', credits: 3, semester: 7),
        DepartmentCourse(code: 'INE 489', name: 'Systems Thinking', credits: 3, semester: 7),
        DepartmentCourse(code: 'INE 497', name: 'Systems Design I', credits: 3, semester: 7),
        DepartmentCourse(code: 'INE 498', name: 'Systems Design II', credits: 3, semester: 8),
      ],
    ),

    // ══════════════════════════════════════════════════════
    // İKTİSADİ VE İDARİ BİLİMLER FAKÜLTESİ
    // ══════════════════════════════════════════════════════

    // ── İşletme (BUS) ──
    Department(
      id: 'bus',
      name: 'İşletme',
      nameEn: 'Business Administration',
      faculty: 'İktisadi ve İdari Bilimler Fakültesi',
      facultyEn: 'Faculty of Economics and Administrative Sciences',
      courses: [
        // 1. Dönem
        DepartmentCourse(code: 'MAT 101', name: 'Mathematics for Social Sciences', credits: 5, semester: 1),
        DepartmentCourse(code: 'ENGL 101', name: 'Development of Reading and Writing Skills I', credits: 4, semester: 1),
        DepartmentCourse(code: 'BUS 111', name: 'Fundamentals of Business', credits: 3, semester: 1),
        DepartmentCourse(code: 'ECO 101', name: 'Microeconomics', credits: 4, semester: 1),
        DepartmentCourse(code: 'PSIR 101', name: 'Introduction to Sociology and Politics', credits: 3, semester: 1),
        // 2. Dönem
        DepartmentCourse(code: 'ENGL 102', name: 'Development of Reading and Writing Skills II', credits: 4, semester: 2),
        DepartmentCourse(code: 'BUS 142', name: 'Financial Accounting', credits: 3, semester: 2),
        DepartmentCourse(code: 'BUS 152', name: 'Statistics for Social Sciences', credits: 3, semester: 2),
        DepartmentCourse(code: 'ECO 102', name: 'Macroeconomics', credits: 4, semester: 2),
        DepartmentCourse(code: 'PSIR 108', name: 'Issues in Global Politics', credits: 3, semester: 2),
        // 3. Dönem
        DepartmentCourse(code: 'BUS 221', name: 'Organizational Behavior and Social Psychology', credits: 3, semester: 3),
        DepartmentCourse(code: 'BUS 271', name: 'Principles of Marketing', credits: 3, semester: 3),
        DepartmentCourse(code: 'BUS 281', name: 'Principles of Finance', credits: 3, semester: 3),
        DepartmentCourse(code: 'PSIR 237', name: 'Principles of Law', credits: 3, semester: 3),
        // 4. Dönem
        DepartmentCourse(code: 'BUS 222', name: 'Organization Theory', credits: 3, semester: 4),
        DepartmentCourse(code: 'BUS 232', name: 'Information Systems and Programming', credits: 3, semester: 4),
        DepartmentCourse(code: 'BUS 242', name: 'Managerial Accounting', credits: 3, semester: 4),
        DepartmentCourse(code: 'ENGL 211', name: 'Academic Oral Presentation Skills', credits: 3, semester: 4),
        // 5. Dönem
        DepartmentCourse(code: 'ENGL 311', name: 'Advanced Communication Skills', credits: 3, semester: 5),
        DepartmentCourse(code: 'BUS 321', name: 'Human Resource Management', credits: 3, semester: 5),
        DepartmentCourse(code: 'BUS 361', name: 'Operations Management', credits: 3, semester: 5),
        // 6. Dönem
        DepartmentCourse(code: 'BUS 312', name: 'Business Law', credits: 3, semester: 6),
        DepartmentCourse(code: 'BUS 352', name: 'Management Science', credits: 3, semester: 6),
        // 7. Dönem
        DepartmentCourse(code: 'BUS 431', name: 'Information Systems', credits: 3, semester: 7),
        // 8. Dönem
        DepartmentCourse(code: 'BUS 400', name: 'Graduation Project', credits: 3, semester: 8),
        DepartmentCourse(code: 'BUS 412', name: 'Strategic Processes and Management', credits: 3, semester: 8),
      ],
    ),

    // ── İktisat (ECO) ──
    Department(
      id: 'eco',
      name: 'İktisat',
      nameEn: 'Economics',
      faculty: 'İktisadi ve İdari Bilimler Fakültesi',
      facultyEn: 'Faculty of Economics and Administrative Sciences',
      courses: [
        // 1. Dönem
        DepartmentCourse(code: 'ECO 101', name: 'Microeconomics', credits: 4, semester: 1),
        DepartmentCourse(code: 'MAT 119', name: 'Calculus with Analytic Geometry', credits: 5, semester: 1),
        DepartmentCourse(code: 'PSIR 101', name: 'Introduction to Sociology and Politics', credits: 3, semester: 1),
        DepartmentCourse(code: 'ENGL 101', name: 'Development of Reading and Writing Skills I', credits: 4, semester: 1),
        // 2. Dönem
        DepartmentCourse(code: 'ECO 102', name: 'Macroeconomics', credits: 4, semester: 2),
        DepartmentCourse(code: 'MAT 120', name: 'Calculus for Functions of Several Variables', credits: 5, semester: 2),
        DepartmentCourse(code: 'BUS 152', name: 'Statistics for Social Sciences', credits: 3, semester: 2),
        DepartmentCourse(code: 'ENGL 102', name: 'Development of Reading and Writing Skills II', credits: 4, semester: 2),
        // 3. Dönem
        DepartmentCourse(code: 'ECO 201', name: 'Intermediate Microeconomics', credits: 4, semester: 3),
        DepartmentCourse(code: 'ECO 211', name: 'Economic History', credits: 3, semester: 3),
        DepartmentCourse(code: 'ECO 275', name: 'Mathematics for Economists', credits: 3, semester: 3),
        DepartmentCourse(code: 'ENGL 211', name: 'Academic Oral Presentation Skills', credits: 3, semester: 3),
        // 4. Dönem
        DepartmentCourse(code: 'ECO 202', name: 'Intermediate Macroeconomics', credits: 4, semester: 4),
        DepartmentCourse(code: 'ECO 205', name: 'Statistics for Economists', credits: 4, semester: 4),
        DepartmentCourse(code: 'ECO 212', name: 'History of Economic Thought', credits: 3, semester: 4),
        DepartmentCourse(code: 'BUS 232', name: 'Information Systems and Programming', credits: 3, semester: 4),
        // 5. Dönem
        DepartmentCourse(code: 'ECO 311', name: 'Principles of Econometrics I', credits: 4, semester: 5),
        DepartmentCourse(code: 'ECO 303', name: 'International Trade Theory and Policy', credits: 3, semester: 5),
        // 6. Dönem
        DepartmentCourse(code: 'ECO 312', name: 'Principles of Econometrics II', credits: 4, semester: 6),
        DepartmentCourse(code: 'ECO 304', name: 'International Macroeconomics', credits: 3, semester: 6),
        DepartmentCourse(code: 'ECO 306', name: 'Monetary Theory and Policy', credits: 3, semester: 6),
        DepartmentCourse(code: 'ENGL 311', name: 'Advanced Communication Skills', credits: 3, semester: 6),
        // 7. Dönem
        DepartmentCourse(code: 'ECO 480', name: 'World Economy', credits: 3, semester: 7),
        // 8. Dönem
        DepartmentCourse(code: 'ECO 400', name: 'Graduation Project', credits: 3, semester: 8),
      ],
    ),

    // ── Siyaset Bilimi ve Uluslararası İlişkiler (PSIR) ──
    Department(
      id: 'psir',
      name: 'Siyaset Bilimi ve Uluslararası İlişkiler',
      nameEn: 'Political Science and International Relations',
      faculty: 'İktisadi ve İdari Bilimler Fakültesi',
      facultyEn: 'Faculty of Economics and Administrative Sciences',
      courses: [
        // 1. Dönem
        DepartmentCourse(code: 'PSIR 101', name: 'Introduction to Sociology and Politics', credits: 3, semester: 1),
        DepartmentCourse(code: 'PSIR 105', name: 'Modern World History', credits: 3, semester: 1),
        DepartmentCourse(code: 'PSIR 111', name: 'Study Skills in Social and Political Sciences', credits: 3, semester: 1),
        DepartmentCourse(code: 'ECO 101', name: 'Microeconomics', credits: 4, semester: 1),
        DepartmentCourse(code: 'ENGL 101', name: 'Development of Reading and Writing Skills I', credits: 4, semester: 1),
        // 2. Dönem
        DepartmentCourse(code: 'PSIR 108', name: 'Issues in Global Politics', credits: 3, semester: 2),
        DepartmentCourse(code: 'PSIR 110', name: 'International History, 1914-1989', credits: 3, semester: 2),
        DepartmentCourse(code: 'PSIR 112', name: 'Statistics for Political Scientists', credits: 3, semester: 2),
        DepartmentCourse(code: 'ECO 102', name: 'Macroeconomics', credits: 4, semester: 2),
        DepartmentCourse(code: 'ENGL 102', name: 'Development of Reading and Writing Skills II', credits: 4, semester: 2),
        // 3. Dönem
        DepartmentCourse(code: 'PSIR 203', name: 'History of Political Thought I', credits: 3, semester: 3),
        DepartmentCourse(code: 'PSIR 212', name: 'Comparative Politics', credits: 3, semester: 3),
        DepartmentCourse(code: 'PSIR 218', name: 'Political Sociology', credits: 3, semester: 3),
        DepartmentCourse(code: 'PSIR 237', name: 'Principles of Law', credits: 3, semester: 3),
        DepartmentCourse(code: 'ENGL 211', name: 'Academic Oral Presentation Skills', credits: 3, semester: 3),
        // 4. Dönem
        DepartmentCourse(code: 'PSIR 202', name: 'Constitutional Law', credits: 3, semester: 4),
        DepartmentCourse(code: 'PSIR 206', name: 'History of Political Thought II', credits: 3, semester: 4),
        DepartmentCourse(code: 'PSIR 210', name: 'Theories of International Relations', credits: 3, semester: 4),
        DepartmentCourse(code: 'PSIR 211', name: 'Comparative Government', credits: 3, semester: 4),
        DepartmentCourse(code: 'PSIR 214', name: 'War and Peace Studies', credits: 3, semester: 4),
        // 5. Dönem
        DepartmentCourse(code: 'PSIR 303', name: 'Public International Law', credits: 3, semester: 5),
        // 6. Dönem
        DepartmentCourse(code: 'PSIR 304', name: 'International Organizations', credits: 3, semester: 6),
        DepartmentCourse(code: 'PSIR 309', name: 'Research Methods for Political Science', credits: 3, semester: 6),
      ],
    ),

    // ══════════════════════════════════════════════════════
    // EĞİTİM FAKÜLTESİ
    // ══════════════════════════════════════════════════════

    // ── Rehberlik ve Psikolojik Danışmanlık (GPC) ──
    Department(
      id: 'gpc',
      name: 'Rehberlik ve Psikolojik Danışmanlık',
      nameEn: 'Guidance and Psychological Counseling',
      faculty: 'Eğitim Fakültesi',
      facultyEn: 'Faculty of Education',
      courses: [
        // 1. Dönem
        DepartmentCourse(code: 'PSYC 100', name: 'General Psychology', credits: 3, semester: 1),
        DepartmentCourse(code: 'GPC 124', name: 'Introduction to Guidance and Counseling', credits: 3, semester: 1),
        DepartmentCourse(code: 'GPC 136', name: 'Human Relations in Education', credits: 3, semester: 1),
        DepartmentCourse(code: 'EDUS 200', name: 'Introduction to Education', credits: 3, semester: 1),
        DepartmentCourse(code: 'ENGL 101', name: 'Development of Reading and Writing Skills I', credits: 4, semester: 1),
        DepartmentCourse(code: 'TUR 103', name: 'Turkish I: Written Expression', credits: 2, semester: 1),
        // 2. Dönem
        DepartmentCourse(code: 'GPC 126', name: 'Physiological Psychology', credits: 3, semester: 2),
        DepartmentCourse(code: 'GPC 254', name: 'Social Psychology', credits: 3, semester: 2),
        DepartmentCourse(code: 'SOCL 109', name: 'Introduction to Sociology', credits: 3, semester: 2),
        DepartmentCourse(code: 'GPC 150', name: 'Psychology of Learning', credits: 3, semester: 2),
        DepartmentCourse(code: 'ENGL 102', name: 'Development of Reading and Writing Skills II', credits: 4, semester: 2),
        DepartmentCourse(code: 'TUR 104', name: 'Turkish II: Oral Communication', credits: 2, semester: 2),
        // 3. Dönem
        DepartmentCourse(code: 'EDUS 209', name: 'Introduction to Educational Statistics I', credits: 4, semester: 3),
        DepartmentCourse(code: 'GPC 122', name: 'Developmental Psychology I', credits: 3, semester: 3),
        DepartmentCourse(code: 'EDUS 230', name: 'Introduction to Curriculum and Instruction', credits: 3, semester: 3),
        DepartmentCourse(code: 'ENGL 211', name: 'Academic Oral Presentation Skills', credits: 3, semester: 3),
        // 4. Dönem
        DepartmentCourse(code: 'EDUS 210', name: 'Introduction to Educational Statistics II', credits: 4, semester: 4),
        DepartmentCourse(code: 'GPC 200', name: 'Observation in Schools', credits: 3, semester: 4),
        DepartmentCourse(code: 'GPC 253', name: 'Developmental Psychology II', credits: 3, semester: 4),
        DepartmentCourse(code: 'EDUS 302', name: 'Research Methods in Education', credits: 4, semester: 4),
        // 5. Dönem
        DepartmentCourse(code: 'PSYC 340', name: 'Theories of Personality', credits: 4, semester: 5),
        DepartmentCourse(code: 'GPC 300', name: 'Career Counseling', credits: 3, semester: 5),
        DepartmentCourse(code: 'GPC 313', name: 'Theories of Counseling', credits: 3, semester: 5),
        DepartmentCourse(code: 'GPC 363', name: 'Measurement and Evaluation in Counseling', credits: 3, semester: 5),
        DepartmentCourse(code: 'ENGL 311', name: 'Advanced Communication Skills', credits: 3, semester: 5),
        // 6. Dönem
        DepartmentCourse(code: 'GPC 355', name: 'Special Education', credits: 3, semester: 6),
        DepartmentCourse(code: 'GPC 301', name: 'Practicum in Career Counseling', credits: 3, semester: 6),
        DepartmentCourse(code: 'GPC 314', name: 'Methods and Techniques of Counseling', credits: 3, semester: 6),
        DepartmentCourse(code: 'GPC 364', name: 'Appraisal of Students', credits: 3, semester: 6),
        // 7. Dönem
        DepartmentCourse(code: 'GPC 410', name: 'Field Practice in Individual Counseling', credits: 3, semester: 7),
        DepartmentCourse(code: 'GPC 411', name: 'Community Work', credits: 2, semester: 7),
        DepartmentCourse(code: 'GPC 415', name: 'Behavior Disorders', credits: 3, semester: 7),
        DepartmentCourse(code: 'GPC 437', name: 'Group Counseling', credits: 3, semester: 7),
        // 8. Dönem
        DepartmentCourse(code: 'GPC 400', name: 'Field Practice in Individual Counseling Services', credits: 3, semester: 8),
        DepartmentCourse(code: 'GPC 438', name: 'Practicum in Group Counseling', credits: 4, semester: 8),
        DepartmentCourse(code: 'GPC 490', name: 'Professional Standards in Guidance and Counseling', credits: 3, semester: 8),
        DepartmentCourse(code: 'GPC 495', name: 'Seminar in Guidance and Counseling', credits: 3, semester: 8),
      ],
    ),

    // ── İngilizce Öğretmenliği (EFL) ──
    Department(
      id: 'efl',
      name: 'İngilizce Öğretmenliği',
      nameEn: 'English Language Teaching',
      faculty: 'Eğitim Fakültesi',
      facultyEn: 'Faculty of Education',
      courses: [
        // 1. Dönem
        DepartmentCourse(code: 'EFL 123', name: 'Listening & Pronunciation', credits: 3, semester: 1),
        DepartmentCourse(code: 'EFL 125', name: 'Advanced Reading & Writing I', credits: 3, semester: 1),
        DepartmentCourse(code: 'EFL 130', name: 'Introduction to Literature', credits: 3, semester: 1),
        DepartmentCourse(code: 'EDUS 200', name: 'Introduction to Education', credits: 3, semester: 1),
        DepartmentCourse(code: 'TUR 103', name: 'Turkish I: Written Communication', credits: 2, semester: 1),
        // 2. Dönem
        DepartmentCourse(code: 'EFL 122', name: 'Contextual Grammar & Composition II', credits: 3, semester: 2),
        DepartmentCourse(code: 'EFL 124', name: 'Oral Communication Skills', credits: 3, semester: 2),
        DepartmentCourse(code: 'EFL 126', name: 'Advanced Reading & Writing II', credits: 3, semester: 2),
        DepartmentCourse(code: 'TUR 104', name: 'Turkish II: Oral Communication', credits: 2, semester: 2),
        // 3. Dönem
        DepartmentCourse(code: 'EFL 211', name: 'English Literature I', credits: 3, semester: 3),
        DepartmentCourse(code: 'EFL 245', name: 'Linguistics I', credits: 3, semester: 3),
        DepartmentCourse(code: 'EFL 249', name: 'ELT Methodology I', credits: 3, semester: 3),
        DepartmentCourse(code: 'EDUS 220', name: 'Educational Psychology', credits: 3, semester: 3),
        DepartmentCourse(code: 'ENGL 211', name: 'Academic Oral Presentation Skills', credits: 3, semester: 3),
        // 4. Dönem
        DepartmentCourse(code: 'EFL 212', name: 'English Literature II', credits: 3, semester: 4),
        DepartmentCourse(code: 'EFL 244', name: 'Translation Studies', credits: 3, semester: 4),
        DepartmentCourse(code: 'EFL 246', name: 'Linguistics II', credits: 3, semester: 4),
        DepartmentCourse(code: 'EFL 254', name: 'ELT Methodology II', credits: 3, semester: 4),
        // 5. Dönem
        DepartmentCourse(code: 'EFL 311', name: 'Advanced Writing and Research Skills', credits: 3, semester: 5),
        DepartmentCourse(code: 'EFL 313', name: 'Language Acquisition', credits: 3, semester: 5),
        DepartmentCourse(code: 'EFL 319', name: 'Drama Analysis', credits: 3, semester: 5),
        DepartmentCourse(code: 'EFL 321', name: 'Teaching Language Skills: Speaking & Listening', credits: 3, semester: 5),
        DepartmentCourse(code: 'CTE 319', name: 'Instructional Tech. & Materials Development', credits: 3, semester: 5),
        // 6. Dönem
        DepartmentCourse(code: 'EFL 318', name: 'Novel Analysis', credits: 3, semester: 6),
        DepartmentCourse(code: 'EFL 320', name: 'Teaching English to Young Learners', credits: 3, semester: 6),
        DepartmentCourse(code: 'EFL 322', name: 'Teaching Language Skills: Reading & Writing', credits: 3, semester: 6),
        DepartmentCourse(code: 'EDUS 304', name: 'Classroom Management', credits: 3, semester: 6),
        DepartmentCourse(code: 'EDUS 416', name: 'Turkish Ed. System & School Management', credits: 3, semester: 6),
        // 7. Dönem
        DepartmentCourse(code: 'EFL 409', name: 'Current Issues in Linguistics', credits: 3, semester: 7),
        DepartmentCourse(code: 'EFL 413', name: 'English Language Testing & Evaluation', credits: 3, semester: 7),
        DepartmentCourse(code: 'EFL 415', name: 'Materials Adaptation & Development', credits: 3, semester: 7),
        DepartmentCourse(code: 'EFL 417', name: 'School Experience II', credits: 4, semester: 7),
        DepartmentCourse(code: 'ENGL 311', name: 'Advanced Communication Skills', credits: 3, semester: 7),
        // 8. Dönem
        DepartmentCourse(code: 'EFL 414', name: 'Schools of Modern Thought', credits: 3, semester: 8),
        DepartmentCourse(code: 'EFL 324', name: 'Community Service', credits: 2, semester: 8),
        DepartmentCourse(code: 'EFL 418', name: 'Practice Teaching', credits: 4, semester: 8),
        DepartmentCourse(code: 'EDUS 424', name: 'Guidance', credits: 3, semester: 8),
      ],
    ),

    // ══════════════════════════════════════════════════════
    // FEN-EDEBİYAT FAKÜLTESİ
    // ══════════════════════════════════════════════════════

    // ── Psikoloji (PSYC) ──
    Department(
      id: 'psyc',
      name: 'Psikoloji',
      nameEn: 'Psychology',
      faculty: 'Fen-Edebiyat Fakültesi',
      facultyEn: 'Faculty of Arts and Sciences',
      courses: [
        // 1. Dönem
        DepartmentCourse(code: 'PSYC 101', name: 'Introduction to Psychology I', credits: 3, semester: 1),
        DepartmentCourse(code: 'BIO 106', name: 'General Biology', credits: 3, semester: 1),
        DepartmentCourse(code: 'ENGL 101', name: 'Development of Reading and Writing Skills I', credits: 4, semester: 1),
        // 2. Dönem
        DepartmentCourse(code: 'PSYC 102', name: 'Introduction to Psychology II', credits: 3, semester: 2),
        DepartmentCourse(code: 'SOCL 109', name: 'Introduction to Sociology', credits: 3, semester: 2),
        DepartmentCourse(code: 'ENGL 102', name: 'Development of Reading and Writing Skills II', credits: 4, semester: 2),
        // 3. Dönem
        DepartmentCourse(code: 'PSYC 221', name: 'Developmental Psychology I', credits: 4, semester: 3),
        DepartmentCourse(code: 'PSYC 251', name: 'Social Psychology I', credits: 3, semester: 3),
        DepartmentCourse(code: 'PSYC 281', name: 'Experimental Psychology I: Learning', credits: 3, semester: 3),
        DepartmentCourse(code: 'ENGL 211', name: 'Academic Oral Presentation Skills', credits: 3, semester: 3),
        // 4. Dönem
        DepartmentCourse(code: 'PSYC 222', name: 'Developmental Psychology II', credits: 4, semester: 4),
        DepartmentCourse(code: 'PSYC 252', name: 'Social Psychology II', credits: 3, semester: 4),
        DepartmentCourse(code: 'PSYC 284', name: 'Experimental Psychology II: Cognition', credits: 3, semester: 4),
        DepartmentCourse(code: 'PSYC 200', name: 'Ethics in Research & Practice of Psychology', credits: 3, semester: 4),
        // 5. Dönem
        DepartmentCourse(code: 'PSYC 331', name: 'Testing & Measurement in Psychology', credits: 4, semester: 5),
        DepartmentCourse(code: 'PSYC 340', name: 'Theories of Personality', credits: 4, semester: 5),
        // 6. Dönem
        DepartmentCourse(code: 'PSYC 342', name: 'Psychopathology', credits: 4, semester: 6),
        DepartmentCourse(code: 'PSYC 374', name: 'Biological Psychology', credits: 4, semester: 6),
        DepartmentCourse(code: 'ENGL 311', name: 'Advanced Communication Skills', credits: 3, semester: 6),
      ],
    ),
  ];

  static List<String> get departmentNames =>
      departments.map((d) => d.name).toList();

  static List<String> departmentNamesLocalized(bool isTr) =>
      departments.map((d) => isTr ? d.name : d.nameEn).toList();

  static Department? findById(String id) {
    try {
      return departments.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  static Department? findByName(String name) {
    try {
      return departments.firstWhere((d) => d.name == name || d.nameEn == name);
    } catch (_) {
      return null;
    }
  }
}
