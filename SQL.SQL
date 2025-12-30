-- قاعدة بيانات SPHINX - أبو الهول للرحلات الأثرية

-- إنشاء قاعدة البيانات
CREATE DATABASE IF NOT EXISTS sphinx_tours_db;
USE sphinx_tours_db;

-- جدول المستخدمين
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    national_id VARCHAR(20),
    user_type ENUM('admin', 'staff', 'customer') DEFAULT 'customer',
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    profile_picture VARCHAR(255),
    wallet_balance DECIMAL(10, 2) DEFAULT 0.00
);

-- جدول المعالم الأثرية
CREATE TABLE archaeological_sites (
    site_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    era VARCHAR(50),
    description TEXT,
    foreign_price DECIMAL(10, 2) NOT NULL,
    egyptian_price DECIMAL(10, 2) NOT NULL,
    visiting_hours TEXT,
    image_url VARCHAR(255),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- جدول ملوك مصر
CREATE TABLE egyptian_kings (
    king_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    era VARCHAR(50) NOT NULL,
    reign_period VARCHAR(50),
    description TEXT,
    achievements TEXT,
    burial_place VARCHAR(100),
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول الحجوزات
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    site_id INT,
    booking_number VARCHAR(20) NOT NULL UNIQUE,
    booking_date DATE NOT NULL,
    visitors_count INT NOT NULL,
    visitor_type ENUM('egyptian', 'foreign') NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    booking_status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    payment_status ENUM('pending', 'paid', 'refunded') DEFAULT 'pending',
    payment_method VARCHAR(50),
    transaction_id VARCHAR(100),
    guide_service BOOLEAN DEFAULT FALSE,
    transport_service BOOLEAN DEFAULT FALSE,
    lunch_service BOOLEAN DEFAULT FALSE,
    photo_service BOOLEAN DEFAULT FALSE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (site_id) REFERENCES archaeological_sites(site_id)
);

-- جدول المعاملات المالية
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    transaction_type ENUM('deposit', 'withdrawal', 'payment', 'refund') NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    description VARCHAR(255),
    reference_id VARCHAR(100),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- جدول الاختبارات
CREATE TABLE quizzes (
    quiz_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    quiz_level INT NOT NULL,
    total_questions INT NOT NULL,
    correct_answers INT NOT NULL,
    total_score INT NOT NULL,
    percentage DECIMAL(5, 2) NOT NULL,
    time_taken INT, -- بالثواني
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- جدول الأسئلة
CREATE TABLE questions (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    question_text TEXT NOT NULL,
    option_a VARCHAR(255) NOT NULL,
    option_b VARCHAR(255) NOT NULL,
    option_c VARCHAR(255) NOT NULL,
    option_d VARCHAR(255) NOT NULL,
    correct_option CHAR(1) NOT NULL,
    question_level INT NOT NULL,
    points INT NOT NULL,
    category VARCHAR(50),
    explanation TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول إجابات المستخدمين
CREATE TABLE user_answers (
    answer_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    question_id INT,
    quiz_id INT,
    selected_option CHAR(1),
    is_correct BOOLEAN,
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (question_id) REFERENCES questions(question_id),
    FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id)
);

-- جدول اللوحة المتصدرين
CREATE TABLE leaderboard (
    leaderboard_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    total_score INT NOT NULL DEFAULT 0,
    quizzes_taken INT NOT NULL DEFAULT 0,
    average_percentage DECIMAL(5, 2) NOT NULL DEFAULT 0.00,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- جدول الإنجازات
CREATE TABLE achievements (
    achievement_id INT PRIMARY KEY AUTO_INCREMENT,
    achievement_name VARCHAR(100) NOT NULL,
    description TEXT,
    icon VARCHAR(50),
    points_required INT NOT NULL,
    badge_color VARCHAR(20)
);

-- جدول إنجازات المستخدمين
CREATE TABLE user_achievements (
    user_achievement_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    achievement_id INT,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (achievement_id) REFERENCES achievements(achievement_id)
);

-- جدول الرسائل من المساعد الذكي
CREATE TABLE ai_chat_messages (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    message_type ENUM('user', 'ai') NOT NULL,
    message_text TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- جدول التذاكر والدعم
CREATE TABLE support_tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    status ENUM('open', 'in_progress', 'resolved', 'closed') DEFAULT 'open',
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    assigned_to INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (assigned_to) REFERENCES users(user_id)
);

-- جدول المراجعات والتقييمات
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    site_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_approved BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (site_id) REFERENCES archaeological_sites(site_id)
);

-- جدول الإشعارات
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('info', 'success', 'warning', 'error') DEFAULT 'info',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- إدخال بيانات المعالم الأثرية
INSERT INTO archaeological_sites (name, location, era, description, foreign_price, egyptian_price, visiting_hours, image_url) VALUES
('المتحف المصري الكبير (GEM)', 'منطقة الأهرامات، الجيزة', 'العصر الحديث (متحف)', 'أحد أكبر وأهم المتاحف الأثرية في العالم. يقع على بعد أمتار من الأهرامات ويعرض أكثر من 50,000 قطعة أثرية، أهمها المجموعة الكاملة لمقبرة توت عنخ آمون.', 500.00, 100.00, 'مفتوح الآن (يوصى بالحجز المسبق عبر موقعه الرسمي). مواعيد العمل: 9 ص - 5 م (قد تتغير).', 'https://earthsguards.com/wp-content/uploads/2025/06/musume2.jpg'),
('أهرامات الجيزة', 'الجيزة', 'الدولة القديمة (أسرة 4)', 'أشهر معالم مصر، وتضم ثلاثة أهرامات: خوفو (الأكبر)، خفرع، ومنقرع. بُنيت كمقابر ملكية وتعتبر إحدى عجائب الدنيا السبع القديمة والوحيدة التي لا تزال قائمة.', 440.00, 40.00, 'يوميًا: 8 ص - 5 م (شتاءً)، 7 ص - 7 م (صيفاً)', 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/06/7e/7d/2c/pyramids-of-giza.jpg?w=1200&h=1200&s=1'),
('أبو الهول', 'الجيزة', 'الدولة القديمة (أسرة 4)', 'تمثال أسطوري بجسم أسد ورأس إنسان، يُعتقد أنه يمثل الملك خفرع. يحرس هضبة الجيزة وهو منحوت من كتلة صخرية واحدة.', 0.00, 0.00, 'نفس أوقات منطقة الأهرامات', 'https://www.independentarabia.com/sites/default/files/styles/1368x911/public/article/mainimage/2022/05/27/549211-1616005704.jpg');

-- إدخال بيانات ملوك مصر
INSERT INTO egyptian_kings (name, era, reign_period, description, achievements, burial_place, image_url) VALUES
('نارمر (مينا)', 'العصر العتيق (الأسرة الأولى)', 'حوالي 3100 ق.م', 'يعتبر أول ملك لمصر الموحدة ومؤسس الأسرة الأولى. قام بتوحيد مصر العليا والسفلى وأسس مدينة منف.', 'توحيد مصر العليا والسفلى, تأسيس الأسرة الأولى, تأسيس مدينة منف', 'أبيدوس', 'https://admin.almalnews.com/storage/uploads/2015/03/4af4354d-adb6-4ad2-bd4b-3776de74c3cc.jpg'),
('خوفو', 'الدولة القديمة (الأسرة الرابعة)', '2589–2566 ق.م', 'ثاني فراعنة الأسرة الرابعة، اشتهر ببناء الهرم الأكبر في الجيزة، أحد عجائب الدنيا السبع.', 'بناء الهرم الأكبر في الجيزة, تطوير نظام إداري مركزي, تعزيز التجارة الخارجية', 'الهرم الأكبر بالجيزة', 'https://upload.wikimedia.org/wikipedia/commons/5/59/Khufu.JPG'),
('رمسيس الثاني', 'الدولة الحديثة (الأسرة التاسعة عشر)', '1279–1213 ق.م', 'أعظم وأشهر فراعنة مصر، حكم لمدة 66 عاماً وبنى العديد من المعابد والتماثيل الضخمة.', 'معركة قادش, بناء معبد أبو سمبل, تشييد الرامسيوم, توسيع الإمبراطورية', 'وادي الملوك', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhHDffqGYostgOq_e-blVaQh6GVC3dePHDCHyT23UwFh-KDeypJ9adlArT8od8hTHfcjmzJLYpkD0iQxHvNSI2cz5xm-XXoIg2HBdtLOVBQeFOfwlbFZvhryUYXVeClQKIppv6VQ3tsL3k/s1600/10537448_1444175129202343_7652802320497538198_n.jpg');

-- إدخال بيانات الأسئلة
INSERT INTO questions (question_text, option_a, option_b, option_c, option_d, correct_option, question_level, points, category, explanation) VALUES
('ما هو أطول نهر في العالم؟', 'نهر النيل', 'نهر الأمازون', 'نهر المسيسيبي', 'نهر اليانغتسي', 'A', 1, 10, 'جغرافيا', 'نهر النيل هو أطول نهر في العالم بطول حوالي 6,650 كم.'),
('كم عدد الأهرامات الرئيسية في الجيزة؟', '2', '3', '4', '5', 'B', 1, 10, 'آثار', 'يوجد في الجيزة ثلاثة أهرامات رئيسية: خوفو، خفرع، ومنقرع.'),
('ما اسم الفرعون الذي بنى الهرم الأكبر؟', 'رمسيس الثاني', 'خفرع', 'خوفو', 'توت عنخ آمون', 'C', 1, 10, 'ملوك', 'الملك خوفو هو الذي بنى الهرم الأكبر في الجيزة.');

-- إدخال بيانات الإنجازات
INSERT INTO achievements (achievement_name, description, icon, points_required, badge_color) VALUES
('المبتدئ', 'أكمل أول اختبار', 'fas fa-graduation-cap', 100, '#4CAF50'),
('المتوسط', 'أكمل 5 اختبارات', 'fas fa-award', 500, '#FF9800'),
('المحترف', 'أكمل 10 اختبارات بدرجة 80% فأكثر', 'fas fa-crown', 1000, '#FFD700'),
('المعرفة الشاملة', 'أجب على 100 سؤال بشكل صحيح', 'fas fa-brain', 2000, '#2196F3');

-- إنشاء الفهارس لتحسين الأداء
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_bookings_user ON bookings(user_id);
CREATE INDEX idx_bookings_date ON bookings(booking_date);
CREATE INDEX idx_transactions_user ON transactions(user_id);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);
CREATE INDEX idx_quizzes_user ON quizzes(user_id);
CREATE INDEX idx_leaderboard_score ON leaderboard(total_score DESC);

-- إنشاء العرض (View) للحجوزات النشطة
CREATE VIEW active_bookings AS
SELECT b.booking_id, b.booking_number, u.username, s.name AS site_name, 
       b.booking_date, b.visitors_count, b.total_price, b.booking_status
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN archaeological_sites s ON b.site_id = s.site_id
WHERE b.booking_status IN ('pending', 'confirmed')
ORDER BY b.booking_date DESC;

-- إنشاء العرض (View) للمستخدمين النشطين
CREATE VIEW active_users AS
SELECT user_id, username, email, full_name, phone, wallet_balance, 
       registration_date, last_login
FROM users
WHERE status = 'active'
ORDER BY last_login DESC;

-- إنشاء الإجراءات المخزنة
DELIMITER //

-- إجراء لإضافة رصيد للمستخدم
CREATE PROCEDURE AddWalletBalance(
    IN p_user_id INT,
    IN p_amount DECIMAL(10, 2),
    IN p_description VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'خطأ في إضافة الرصيد';
    END;
    
    START TRANSACTION;
    
    -- تحديث رصيد المحفظة
    UPDATE users 
    SET wallet_balance = wallet_balance + p_amount 
    WHERE user_id = p_user_id;
    
    -- تسجيل المعاملة
    INSERT INTO transactions (user_id, transaction_type, amount, description)
    VALUES (p_user_id, 'deposit', p_amount, p_description);
    
    COMMIT;
END //

-- إجراء لإنشاء حجز جديد
CREATE PROCEDURE CreateBooking(
    IN p_user_id INT,
    IN p_site_id INT,
    IN p_booking_date DATE,
    IN p_visitors_count INT,
    IN p_visitor_type ENUM('egyptian', 'foreign'),
    IN p_total_price DECIMAL(10, 2),
    IN p_payment_method VARCHAR(50)
)
BEGIN
    DECLARE v_booking_number VARCHAR(20);
    DECLARE v_user_balance DECIMAL(10, 2);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'خطأ في إنشاء الحجز';
    END;
    
    START TRANSACTION;
    
    -- التحقق من رصيد المستخدم
    SELECT wallet_balance INTO v_user_balance 
    FROM users WHERE user_id = p_user_id;
    
    IF v_user_balance < p_total_price THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'رصيد غير كافي';
    END IF;
    
    -- توليد رقم الحجز
    SET v_booking_number = CONCAT('SPHX-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(FLOOR(RAND() * 10000), 4, '0'));
    
    -- خصم المبلغ من رصيد المستخدم
    UPDATE users 
    SET wallet_balance = wallet_balance - p_total_price 
    WHERE user_id = p_user_id;
    
    -- تسجيل المعاملة
    INSERT INTO transactions (user_id, transaction_type, amount, description)
    VALUES (p_user_id, 'payment', p_total_price, CONCAT('دفع مقابل الحجز ', v_booking_number));
    
    -- إنشاء الحجز
    INSERT INTO bookings (
        user_id, site_id, booking_number, booking_date, 
        visitors_count, visitor_type, total_price, 
        payment_status, payment_method
    ) VALUES (
        p_user_id, p_site_id, v_booking_number, p_booking_date,
        p_visitors_count, p_visitor_type, p_total_price,
        'paid', p_payment_method
    );
    
    COMMIT;
    
    -- إرجاع رقم الحجز
    SELECT v_booking_number AS booking_number;
END //

-- إجراء لتسجيل نتيجة اختبار
CREATE PROCEDURE SubmitQuizResult(
    IN p_user_id INT,
    IN p_quiz_level INT,
    IN p_total_questions INT,
    IN p_correct_answers INT,
    IN p_total_score INT,
    IN p_time_taken INT
)
BEGIN
    DECLARE v_percentage DECIMAL(5, 2);
    DECLARE v_quiz_id INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'خطأ في تسجيل نتيجة الاختبار';
    END;
    
    START TRANSACTION;
    
    -- حساب النسبة المئوية
    SET v_percentage = (p_correct_answers / p_total_questions) * 100;
    
    -- إدخال نتيجة الاختبار
    INSERT INTO quizzes (
        user_id, quiz_level, total_questions, 
        correct_answers, total_score, percentage, time_taken
    ) VALUES (
        p_user_id, p_quiz_level, p_total_questions,
        p_correct_answers, p_total_score, v_percentage, p_time_taken
    );
    
    SET v_quiz_id = LAST_INSERT_ID();
    
    -- تحديث اللوحة المتصدرين
    IF EXISTS (SELECT 1 FROM leaderboard WHERE user_id = p_user_id) THEN
        UPDATE leaderboard 
        SET total_score = total_score + p_total_score,
            quizzes_taken = quizzes_taken + 1,
            average_percentage = (
                SELECT AVG(percentage) 
                FROM quizzes 
                WHERE user_id = p_user_id
            )
        WHERE user_id = p_user_id;
    ELSE
        INSERT INTO leaderboard (user_id, total_score, quizzes_taken, average_percentage)
        VALUES (p_user_id, p_total_score, 1, v_percentage);
    END IF;
    
    -- التحقق من الإنجازات الجديدة
    CALL CheckUserAchievements(p_user_id);
    
    COMMIT;
    
    -- إرجاع معرف الاختبار
    SELECT v_quiz_id AS quiz_id;
END //

-- إجراء للتحقق من إنجازات المستخدم
CREATE PROCEDURE CheckUserAchievements(
    IN p_user_id INT
)
BEGIN
    DECLARE v_total_score INT;
    DECLARE v_quizzes_taken INT;
    DECLARE v_correct_answers INT;
    
    -- الحصول على إحصائيات المستخدم
    SELECT 
        COALESCE(SUM(total_score), 0),
        COUNT(quiz_id),
        COALESCE(SUM(correct_answers), 0)
    INTO v_total_score, v_quizzes_taken, v_correct_answers
    FROM quizzes 
    WHERE user_id = p_user_id;
    
    -- التحقق من إنجاز المبتدئ
    IF v_total_score >= 100 AND NOT EXISTS (
        SELECT 1 FROM user_achievements ua
        JOIN achievements a ON ua.achievement_id = a.achievement_id
        WHERE ua.user_id = p_user_id AND a.achievement_name = 'المبتدئ'
    ) THEN
        INSERT INTO user_achievements (user_id, achievement_id)
        SELECT p_user_id, achievement_id FROM achievements 
        WHERE achievement_name = 'المبتدئ';
    END IF;
    
    -- التحقق من إنجاز المتوسط
    IF v_quizzes_taken >= 5 AND NOT EXISTS (
        SELECT 1 FROM user_achievements ua
        JOIN achievements a ON ua.achievement_id = a.achievement_id
        WHERE ua.user_id = p_user_id AND a.achievement_name = 'المتوسط'
    ) THEN
        INSERT INTO user_achievements (user_id, achievement_id)
        SELECT p_user_id, achievement_id FROM achievements 
        WHERE achievement_name = 'المتوسط';
    END IF;
    
    -- التحقق من إنجاز المعرفة الشاملة
    IF v_correct_answers >= 100 AND NOT EXISTS (
        SELECT 1 FROM user_achievements ua
        JOIN achievements a ON ua.achievement_id = a.achievement_id
        WHERE ua.user_id = p_user_id AND a.achievement_name = 'المعرفة الشاملة'
    ) THEN
        INSERT INTO user_achievements (user_id, achievement_id)
        SELECT p_user_id, achievement_id FROM achievements 
        WHERE achievement_name = 'المعرفة الشاملة';
    END IF;
END //

DELIMITER ;

-- إنشاء المستخدم ومنح الصلاحيات
CREATE USER IF NOT EXISTS 'sphinx_app'@'localhost' IDENTIFIED BY 'SphinxSecurePassword123!';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON sphinx_tours_db.* TO 'sphinx_app'@'localhost';
FLUSH PRIVILEGES;